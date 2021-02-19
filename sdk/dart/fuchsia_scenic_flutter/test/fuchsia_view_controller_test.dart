// Copyright 2020 The Fuchsia Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fuchsia_scenic_flutter/fuchsia_view.dart';
import 'package:mockito/mockito.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('FuchsiaViewController', () async {
    bool? connectedCalled;
    bool? disconnectedCalled;
    bool? stateChangedCalled;
    final controller = TestFuchsiaViewController(
      viewId: 42,
      onViewConnected: (_) => connectedCalled = true,
      onViewDisconnected: (_) => disconnectedCalled = true,
      onViewStateChanged: (_, __) => stateChangedCalled = true,
    );

    await controller.connect();
    verify(controller.platformViewChannel.invokeMethod('View.create', {
      'viewId': 42,
      'hitTestable': true,
      'focusable': true,
    }));

    final methodCallback =
        verify(controller.platformViewChannel.setMethodCallHandler(captureAny))
            .captured
            .single;
    expect(methodCallback, isNotNull);

    methodCallback(MethodCall('View.viewConnected'));
    methodCallback(MethodCall('View.viewDisconnected'));
    methodCallback(MethodCall('View.viewStateChanged', {'state': true}));

    expect(connectedCalled, isTrue);
    expect(stateChangedCalled, isTrue);
    expect(disconnectedCalled, isTrue);

    disconnectedCalled = false;
    await controller.disconnect();
    verify(controller.platformViewChannel.invokeMethod('View.dispose', {
      'viewId': 42,
    }));
    expect(disconnectedCalled, isTrue);
  });

  test('FuchsiaViewController requestFocus', () async {
    final controller = TestFuchsiaViewController(viewId: 42);
    when(controller.platformViewChannel.invokeMethod('View.requestFocus', any))
        .thenAnswer((_) => Future.value(0));
    await controller.requestFocus(42);
    verify(controller.platformViewChannel.invokeMethod('View.requestFocus', {
      'viewRef': 42,
    }));

    // test requestFocus fails to set focus.
    when(controller.platformViewChannel.invokeMethod('View.requestFocus', any))
        .thenAnswer((_) => Future.value(-1));
    expect(controller.requestFocus(42), throwsA(isException));
  });

  test('FuchsiaViewController dispatchPointerEvent', () async {
    PointerEvent? event;
    final controller = TestFuchsiaViewController(
      viewId: 42,
      onPointerEvent: (_, e) async => event = e,
    );

    final addedEvent = PointerAddedEvent();
    await controller.dispatchPointerEvent(addedEvent);
    expect(event, equals(addedEvent));
  });
}

class TestFuchsiaViewController extends FuchsiaViewController {
  final _platformMethodChannel = MockMethodChannel();

  TestFuchsiaViewController({
    required int viewId,
    FuchsiaViewConnectionCallback? onViewConnected,
    FuchsiaViewConnectionCallback? onViewDisconnected,
    FuchsiaViewConnectionStateCallback? onViewStateChanged,
    FuchsiaPointerEventsCallback? onPointerEvent,
  }) : super(
          viewId: viewId,
          onViewConnected: onViewConnected,
          onViewDisconnected: onViewDisconnected,
          onViewStateChanged: onViewStateChanged,
          onPointerEvent: onPointerEvent,
        );

  @override
  MethodChannel get platformViewChannel => _platformMethodChannel;
}

class MockMethodChannel extends Mock implements MethodChannel {}
