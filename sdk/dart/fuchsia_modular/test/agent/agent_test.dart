// Copyright 2018 The Fuchsia Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:test/test.dart';

import 'package:fuchsia_modular/agent.dart';
import 'package:fuchsia_modular/lifecycle.dart';
import 'package:fuchsia_services/services.dart';

void main() {
  setUpAll(() {
    final context = ComponentContext.createAndServe();
    Lifecycle.enableLifecycleEvents(context.outgoing);
  });

  test('factory should return same instance', () {
    expect(Agent(), Agent());
  });
}
