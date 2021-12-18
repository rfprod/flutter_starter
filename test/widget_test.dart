// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_starter/root/root.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('AppHomePage widgets smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(AppRoot(key: Key('root')));

    expect(find.text('Logged in'), findsOneWidget);
    expect(find.byIcon(Icons.refresh), 1);
  });
}
