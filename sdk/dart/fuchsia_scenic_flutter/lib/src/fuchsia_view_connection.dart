// Copyright 2020 The Fuchsia Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:fidl_fuchsia_ui_views/fidl_async.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';
import 'package:fuchsia_services/services.dart';
import 'package:zircon/zircon.dart';

import 'fuchsia_view_controller.dart';
import 'pointer_injector.dart';

/// Defines a thin wrapper around [FuchsiaViewController].
///
/// Its primary purpose is to hold on to [ViewHolderToken] for the lifetime of
/// the view controller, since [FuchsiaViewController] is agnostic to all
/// Fuchsia data types. (Eventually, [FuchsiaView] and [FuchsiaViewController]
/// will be moved to Flutter framework, which cannot have Fuchsia data types.)
class FuchsiaViewConnection extends FuchsiaViewController {
  /// The scenic view tree token when the view is attached.
  final ViewHolderToken viewHolderToken;

  /// The handle to the view used for [requestFocus] calls.
  final ViewRef? viewRef;

  PointerInjector? _pointerInjector;

  /// Returns the [PointerInjector] instance used by this connection.
  @visibleForTesting
  PointerInjector get pointerInjector =>
      _pointerInjector ??= PointerInjector.fromStartupContext(startupContext);

  /// Callback when the connection to child's view is connected to view tree.
  final FuchsiaViewConnectionCallback? _onViewConnected;

  /// Callback when the child's view is disconnected from view tree.
  final FuchsiaViewConnectionCallback? _onViewDisconnected;

  StartupContext? _startupContext;

  /// Returns the [StartupContext] used to connect to required services.
  @visibleForTesting
  StartupContext get startupContext =>
      _startupContext ??= StartupContext.fromStartupInfo();

  /// Set to true if pointer injection into child views should be enabled.
  /// This requires the view's [ViewRef] to be set during construction.
  final bool usePointerInjection;

  /// Constructor.
  FuchsiaViewConnection(
    this.viewHolderToken, {
    this.viewRef,
    FuchsiaViewConnectionCallback? onViewConnected,
    FuchsiaViewConnectionCallback? onViewDisconnected,
    FuchsiaViewConnectionStateCallback? onViewStateChanged,
    this.usePointerInjection = false,
  })  : assert(viewHolderToken?.value != null && viewHolderToken.value.isValid),
        assert(
            viewRef?.reference == null || viewRef!.reference.handle!.isValid),
        assert(!usePointerInjection || viewRef?.reference != null),
        _onViewConnected = onViewConnected,
        _onViewDisconnected = onViewDisconnected,
        super(
          viewId: viewHolderToken.value.handle!.handle,
          onViewConnected: _handleViewConnected,
          onViewDisconnected: _handleViewDisconnected,
          onViewStateChanged: onViewStateChanged,
          onPointerEvent: _handlePointerEvent,
        );

  /// Requests that focus be transferred to the remote Scene represented by
  /// this connection.
  @override
  Future<void> requestFocus([_]) async {
    assert(viewRef?.reference != null && _ == null);
    return super.requestFocus(viewRef!.reference.handle!.handle);
  }

  static void _handleViewConnected(FuchsiaViewController controller) async {
    FuchsiaViewConnection connection = controller as FuchsiaViewConnection;
    connection._onViewConnected?.call(controller);

    if (connection.usePointerInjection) {
      final hostViewRef = ViewRef(
        reference: EventPair(
            connection.startupContext.viewRef!.duplicate(ZX.RIGHT_SAME_RIGHTS)),
      );
      final viewRefDup = ViewRef(
          reference:
              connection.viewRef!.reference.duplicate(ZX.RIGHT_SAME_RIGHTS));

      await connection.pointerInjector.register(
        hostViewRef: hostViewRef,
        viewRef: viewRefDup,
        viewport: controller.viewport!,
      );
    }
  }

  static void _handleViewDisconnected(FuchsiaViewController controller) {
    FuchsiaViewConnection connection = controller as FuchsiaViewConnection;
    connection._onViewDisconnected?.call(controller);
    if (connection.usePointerInjection) {
      connection.pointerInjector.dispose();
    }
  }

  static Future<void> _handlePointerEvent(
      FuchsiaViewController controller, PointerEvent pointer) async {
    FuchsiaViewConnection connection = controller as FuchsiaViewConnection;
    return connection.pointerInjector.dispatchEvent(
      pointer: pointer,
      viewport: connection.viewport,
    );
  }
}
