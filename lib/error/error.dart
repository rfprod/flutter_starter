import 'package:flutter/material.dart';
import 'package:flutter_starter/error/error.page.dart';

class AppError extends StatelessWidget {
  const AppError({required Key key, required this.snapshot}) : super(key: key);

  final AsyncSnapshot<Object?> snapshot;

  // This widget is displayed when the app errors during bootstrap.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Error',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: AppErrorPage(
          key: Key('error.page'), snapshot: snapshot, title: 'Error'),
    );
  }
}
