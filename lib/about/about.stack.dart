import 'dart:async';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AppAboutStack extends StatefulWidget {
  const AppAboutStack({required this.controller, required Key key})
      : super(key: key);

  final Completer<WebViewController> controller;

  @override
  State<AppAboutStack> createState() => _AppAboutStackState();
}

class _AppAboutStackState extends State<AppAboutStack> {
  int loadingPercentage = 0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        WebView(
          initialUrl: 'https://rfprod.github.io/flutter_starter/',
          onWebViewCreated: (WebViewController controller) {
            widget.controller.complete(controller);
          },
          onPageStarted: (String url) {
            setState(() {
              loadingPercentage = 0;
            });
          },
          onProgress: (int progress) {
            setState(() {
              loadingPercentage = progress;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              loadingPercentage = 100;
            });
          },
          navigationDelegate: (NavigationRequest navigation) {
            final String host = Uri.parse(navigation.url).host;
            if (host.contains('github.com') ||
                host.contains('wikipedia.org') ||
                (host.contains('google.com') &&
                    !host.contains('developers.google.com'))) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Blocking navigation to $host',
                  ),
                ),
              );
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
          javascriptMode: JavascriptMode.unrestricted,
          javascriptChannels: _createJavascriptChannels(context),
        ),
        if (loadingPercentage < 100)
          LinearProgressIndicator(
            value: loadingPercentage / 100.0,
          ),
      ],
    );
  }

  Set<JavascriptChannel> _createJavascriptChannels(BuildContext context) {
    return <JavascriptChannel>{
      JavascriptChannel(
        name: 'SnackBar',
        onMessageReceived: (JavascriptMessage message) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(message.message)));
        },
      ),
    };
  }
}
