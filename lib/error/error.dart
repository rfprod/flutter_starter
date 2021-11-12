import 'package:flutter/material.dart';
import 'package:flutter_starter/error/error.page.dart';

class AppError extends StatelessWidget {
  const AppError({required Key key}) : super(key: key);

  // This widget is diaplayed while the app has errored while during bootstrap.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Error',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: AppErrorPage(key: Key('error'), title: 'Error'),
    );
  }
}
