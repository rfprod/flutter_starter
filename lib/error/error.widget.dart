import 'package:flutter/material.dart';

class AppErrorWidget extends StatefulWidget {
  const AppErrorWidget({required Key key}) : super(key: key);

  @override
  _AppErrorWidgetState createState() => _AppErrorWidgetState();
}

class _AppErrorWidgetState extends State<AppErrorWidget> {
  @override
  Widget build(BuildContext context) {
    return Center(
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
    );
  }
}
