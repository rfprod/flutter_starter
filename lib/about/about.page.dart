import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AppAboutPage extends StatefulWidget {
  const AppAboutPage({required Key key, required this.title}) : super(key: key);

  final String title;

  @override
  State<AppAboutPage> createState() => _AppAboutPageState();
}

class _AppAboutPageState extends State<AppAboutPage> {
  final Stream<User?> _authChange = FirebaseAuth.instance.authStateChanges();

  StreamSubscription<User?>? _userSub;

  User? _user;

  void _showSnackbar(String message) {
    Text text = Text(message);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: text),
    );
  }

  @override
  initState() {
    super.initState();
    _userSub = _authChange.listen((User? user) {
      if (user == null) {
        _showSnackbar('User is currently signed out!');
        Navigator.pushNamed(context, '/login');
        setState(() {
          _user = null;
        });
      } else {
        _showSnackbar('User is signed in!');
        setState(() {
          _user = user;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _userSub?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.info),
              onPressed: () => Navigator.pushNamed(context, '/about')),
          if (_user == null)
            IconButton(
                icon: Icon(Icons.login),
                onPressed: () => Navigator.pushNamed(context, '/login')),
          if (_user != null)
            IconButton(
                icon: Icon(Icons.bar_chart),
                onPressed: () => Navigator.pushNamed(context, '/charts')),
          if (_user != null)
            IconButton(
                icon: Icon(Icons.logout),
                onPressed: () => FirebaseAuth.instance.signOut()),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Flutter starter',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            if (_user != null)
              Text(
                'Logged in user: ${_user?.email}',
              ),
          ],
        ),
      ),
    );
  }
}
