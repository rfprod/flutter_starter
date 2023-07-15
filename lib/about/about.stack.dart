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
  Uri uri = Uri.parse('https://rfprod.github.io/flutter_starter/');

  Uri? loadedUri;

  int loadingPercentage = 0;

  @override
  Widget build(BuildContext context) {
    WebViewController controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel('SnackBar',
          onMessageReceived: (JavaScriptMessage message) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(message.message)));
      })
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        // TODO: debug navigation delegate
        // The view falls into infinite cycle of reloads if onProgress is enabled
        // and the loadedUri variable is not used to determine whether the view has been loaded.
        NavigationDelegate(
          // onProgress: (int progress) {
          //   if (loadedUri == null) {
          //     setState(() {
          //       loadingPercentage = progress;
          //     });
          //   }
          // },
          onPageStarted: (String url) {
            if (loadedUri == null) {
              setState(() {
                loadingPercentage = 0;
              });
            }
          },
          onPageFinished: (String url) {
            if (loadingPercentage < 100) {
              setState(() {
                loadingPercentage = 100;
                loadedUri = Uri.parse(url);
              });
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text("Loaded $url")));
            }
          },
          onWebResourceError: (WebResourceError error) {
            if (error.isForMainFrame ?? false == true) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(error.description)));
            }
          },
          onNavigationRequest: (NavigationRequest request) {
            final String host = Uri.parse(request.url).host;
            loadedUri = null;
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
        ),
      )
      ..loadRequest(uri);

    return Stack(
      children: <Widget>[
        WebViewWidget(controller: controller),
        if (loadingPercentage < 100)
          LinearProgressIndicator(
            value: loadingPercentage / 100,
          ),
      ],
    );
  }
}
