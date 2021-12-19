import 'package:flutter/material.dart';
import 'package:flutter_starter/error/error.widget.dart';

class AppErrorPage extends StatefulWidget {
  const AppErrorPage({required Key key, required this.title}) : super(key: key);

  final String title;

  @override
  _AppErrorPageState createState() => _AppErrorPageState();
}

class _AppErrorPageState extends State<AppErrorPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: AppErrorWidget(key: Key('error')),
    );
  }
}
