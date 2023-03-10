import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_starter/about/about.menu.dart';
import 'package:flutter_starter/about/about.stack.dart';
import 'package:flutter_starter/webview/webview.navigation.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AppAboutPage extends StatefulWidget {
  const AppAboutPage({required Key key, required this.title}) : super(key: key);

  final String title;

  @override
  State<AppAboutPage> createState() => _AppAboutPageState();
}

class _AppAboutPageState extends State<AppAboutPage> {
  final Completer<WebViewController> controller =
      Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          AppWebViewNavigationControls(
              controller: controller, key: Key('aboutStackNavigation')),
          AppAboutMenu(controller: controller, key: Key('aboutMenu')),
        ],
      ),
      body: AppAboutStack(controller: controller, key: Key('aboutStack')),
    );
  }
}
