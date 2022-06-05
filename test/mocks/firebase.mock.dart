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

  MethodChannelFirebase.channel
      .setMockMethodCallHandler((MethodCall call) async {
    if (call.method == 'Firebase#initializeCore') {
      return <Map<String, dynamic>>[
        <String, dynamic>{
          'name': defaultFirebaseAppName,
          'options': <String, String>{
            'apiKey': '123',
            'appId': '123',
            'messagingSenderId': '123',
            'projectId': '123',
          },
          'pluginConstants': <String, dynamic>{},
        }
      ];
    }

    if (call.method == 'Firebase#initializeApp') {
      return <String, dynamic>{
        'name': call.arguments['appName'],
        'options': call.arguments['options'],
        'pluginConstants': <String, dynamic>{},
      };
    }

    if (customHandlers != null) {
      customHandlers(call);
    }

    return null;
  });
}

Future<T> neverEndingFuture<T>() async {
  // ignore: literal_only_boolean_expressions
  while (true) {
    await Future<dynamic>.delayed(const Duration(minutes: 5));
  }
}
