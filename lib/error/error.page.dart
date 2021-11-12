import 'package:flutter/material.dart';

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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Something went wrong',
            ),
            Text(
              'Please try again a bit later.',
              style: Theme.of(context).textTheme.headline5,
            ),
          ],
        ),
      ),
    );
  }
}
