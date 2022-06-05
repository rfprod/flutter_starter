import 'package:flutter/material.dart';
import 'package:flutter_starter/error/error.widget.dart';

class AppErrorPage extends StatefulWidget {
  const AppErrorPage(
      {required Key key, required this.snapshot, required this.title})
      : super(key: key);

  final AsyncSnapshot<Object?> snapshot;

  final String title;

  @override
  State<AppErrorPage> createState() => _AppErrorPageState();
}

class _AppErrorPageState extends State<AppErrorPage> {
  // This widget is displayed when the app errors during bootstrap.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: AppErrorWidget(key: Key('error.widget'), snapshot: widget.snapshot),
    );
  }
}
