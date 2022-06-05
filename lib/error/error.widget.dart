import 'package:flutter/material.dart';

class AppErrorWidget extends StatefulWidget {
  const AppErrorWidget({required Key key, required this.snapshot})
      : super(key: key);

  final AsyncSnapshot<Object?> snapshot;

  @override
  State<AppErrorWidget> createState() => _AppErrorWidgetState();
}

class _AppErrorWidgetState extends State<AppErrorWidget> {
  // This widget is displayed when the app errors in general.
  // It can and should be reused.
  // The widget has access to error state which should be eventually used to display errors explanation.
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
