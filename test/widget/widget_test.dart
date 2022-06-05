// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_starter/root/root.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;

import '../mocks/firebase.mock.dart';
import 'widget_test.mocks.dart';

// Generate a MockClient using the Mockito package.
// Create new instances of this class in each test.
@GenerateMocks(<Type>[http.Client])
void main() {
  final http.Client client = MockClient();

  setUp(() async {
    setupFirebaseAuthMocks();

    await Firebase.initializeApp();
  });

  testWidgets('AppRoot widget smoke test', (WidgetTester tester) async {
    String mockResponse =
        '{"ARS": { "15m": 6026327.02, "last": 6026327.02, "buy": 6026327.02, "sell": 6026327.02, "symbol": "ARS" }}';
    when(client.get(Uri.parse('https://blockchain.info/ticker')))
        .thenAnswer((_) async => http.Response(mockResponse, 200));

    // Build our app and trigger a frame.
    await tester.pumpWidget(AppRoot(key: Key('root')));

    final Finder keyFinder = find.byKey(Key('home'));
    expect(keyFinder, findsOneWidget);

    final Finder titleFinder = find.text('Home');
    expect(titleFinder, findsOneWidget);

    final Finder infoIconFinder = find.byIcon(Icons.info);
    expect(infoIconFinder, findsOneWidget);
  });
}
