import 'package:flutter/material.dart';

class AppLoadingPage extends StatefulWidget {
  const AppLoadingPage({required Key key, required this.title})
      : super(key: key);

  final String title;

  @override
  _AppLoadingPageState createState() => _AppLoadingPageState();
}

class _AppLoadingPageState extends State<AppLoadingPage> {
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
              'Loading...',
            ),
            Text(
              'Please wait',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
    );
  }
}
