// Copyright 2020 The Chromium Authors. All rights reserved.
// Source: https://github.com/firebase/flutterfire/blob/master/packages/firebase_auth/firebase_auth/test/mock.dart
// Use of this source code is governed by a BSD-style license that can be found in the following LICENSE file https://github.com/firebase/flutterfire/blob/master/LICENSE.

// ignore: depend_on_referenced_packages
import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

typedef Callback = void Function(MethodCall call);

void setupFirebaseAuthMocks([Callback? customHandlers]) {
  TestWidgetsFlutterBinding.ensureInitialized();

  TestFirebaseCoreHostApi.setup(MockFirebaseApp());
}

Future<T> neverEndingFuture<T>() async {
  // ignore: literal_only_boolean_expressions
  while (true) {
    await Future<dynamic>.delayed(const Duration(minutes: 5));
  }
}
