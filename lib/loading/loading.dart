import 'package:flutter/material.dart';
import 'package:flutter_starter/loading/loading.page.dart';

class AppLoading extends StatelessWidget {
  const AppLoading({required Key key}) : super(key: key);

  // This widget is diaplayed while the app is loading.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Loading...',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: AppLoadingPage(key: Key('loading'), title: 'Loading...'),
    );
  }
}
