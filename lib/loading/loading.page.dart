import 'package:flutter/material.dart';
import 'package:flutter_starter/loading/loading.widget.dart';

class AppLoadingPage extends StatefulWidget {
  const AppLoadingPage({required Key key, required this.title})
      : super(key: key);

  final String title;

  @override
  State<AppLoadingPage> createState() => _AppLoadingPageState();
}

class _AppLoadingPageState extends State<AppLoadingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: AppLoadingWidget(key: Key('loading')),
    );
  }
}
