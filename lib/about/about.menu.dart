import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:webview_cookie_manager/webview_cookie_manager.dart';
import 'package:webview_flutter/webview_flutter.dart';

enum _MenuOptions {
  navigationDelegate,
  userAgent,
  javascriptChannel,
  listCookies,
  clearCookies,
  addCookie,
  setCookie,
  removeCookie
}

class AppAboutMenu extends StatefulWidget {
  const AppAboutMenu({required this.controller, required Key key})
      : super(key: key);

  final Completer<WebViewController> controller;

  @override
  State<AppAboutMenu> createState() => _AppAboutMenuState();
}

class _AppAboutMenuState extends State<AppAboutMenu> {
  final WebviewCookieManager cookieManager = WebviewCookieManager();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<WebViewController>(
      future: widget.controller.future,
      builder:
          (BuildContext context, AsyncSnapshot<WebViewController> controller) {
        return PopupMenuButton<_MenuOptions>(
          onSelected: (_MenuOptions value) async {
            switch (value) {
              case _MenuOptions.navigationDelegate:
                Uri uri = Uri.parse('https://g.dev/rfprod');
                controller.data!.loadRequest(uri);
                break;
              case _MenuOptions.userAgent:
                final Object userAgent = await controller.data!
                    .runJavaScriptReturningResult('navigator.userAgent');
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(userAgent.toString()),
                ));
                break;
              case _MenuOptions.javascriptChannel:
                await controller.data!.runJavaScript('''
var req = new XMLHttpRequest();
req.open('GET', "https://api.ipify.org/?format=json");
req.onload = function() {
  if (req.status == 200) {
    let response = JSON.parse(req.responseText);
    SnackBar.postMessage("IP Address: " + response.ip);
  } else {
    SnackBar.postMessage("Error: " + req.status);
  }
}
req.send();''');
                break;
              case _MenuOptions.clearCookies:
                _onClearCookies();
                break;
              case _MenuOptions.listCookies:
                _onListCookies(controller.data!);
                break;
              case _MenuOptions.addCookie:
                _onAddCookie(controller.data!);
                break;
              case _MenuOptions.setCookie:
                _onSetCookie(controller.data!);
                break;
              case _MenuOptions.removeCookie:
                _onRemoveCookie(controller.data!);
                break;
            }
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<_MenuOptions>>[
            const PopupMenuItem<_MenuOptions>(
              value: _MenuOptions.navigationDelegate,
              child: Text('Show gDev profile'),
            ),
            const PopupMenuItem<_MenuOptions>(
              value: _MenuOptions.userAgent,
              child: Text('Show user-agent'),
            ),
            const PopupMenuItem<_MenuOptions>(
              value: _MenuOptions.javascriptChannel,
              child: Text('Lookup IP Address'),
            ),
            const PopupMenuItem<_MenuOptions>(
              value: _MenuOptions.clearCookies,
              child: Text('Clear cookies'),
            ),
            const PopupMenuItem<_MenuOptions>(
              value: _MenuOptions.listCookies,
              child: Text('List cookies'),
            ),
            const PopupMenuItem<_MenuOptions>(
              value: _MenuOptions.addCookie,
              child: Text('Add cookie'),
            ),
            const PopupMenuItem<_MenuOptions>(
              value: _MenuOptions.setCookie,
              child: Text('Set cookie'),
            ),
            const PopupMenuItem<_MenuOptions>(
              value: _MenuOptions.removeCookie,
              child: Text('Remove cookie'),
            ),
          ],
        );
      },
    );
  }

  // list cookies
  Future<void> _onListCookies(WebViewController controller) async {
    final Object cookies =
        await controller.runJavaScriptReturningResult('document.cookie');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(cookies.toString().isNotEmpty
            ? cookies.toString()
            : 'There are no cookies.'),
      ),
    );
  }

  // clear cookies
  Future<void> _onClearCookies() async {
    final bool hadCookies = await cookieManager.hasCookies();
    String message = 'There were cookies. Now, they are gone!';
    if (!hadCookies) {
      message = 'There were no cookies to clear.';
    } else {
      await cookieManager.clearCookies();
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  // add a cookie
  Future<void> _onAddCookie(WebViewController controller) async {
    await controller.runJavaScript('''var date = new Date();
  date.setTime(date.getTime()+(30*24*60*60*1000));
  document.cookie = "FirstName=John; expires=" + date.toGMTString();''');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Custom cookie added.'),
      ),
    );
  }

  // set a cookie
  Future<void> _onSetCookie(WebViewController controller) async {
    await cookieManager.setCookies(<Cookie>[
      Cookie('foo', 'bar')
        ..domain = 'flutter.dev'
        ..expires = DateTime.now().add(Duration(days: 10))
        ..httpOnly = false,
    ]);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Custom cookie is set.'),
      ),
    );
  }

  // remove a cookie
  Future<void> _onRemoveCookie(WebViewController controller) async {
    await controller.runJavaScript(
        'document.cookie="FirstName=John; expires=Thu, 01 Jan 1970 00:00:00 UTC" ');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Custom cookie removed.'),
      ),
    );
  }
}
