import 'dart:core';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sentry/sentry.dart';

class AppLoginPage extends StatefulWidget {
  const AppLoginPage({required Key key, required this.title}) : super(key: key);

  final String title;

  @override
  State<AppLoginPage> createState() => _AppLoginPageState();
}

class _AppLoginPageState extends State<AppLoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final ISentrySpan transaction = Sentry.startTransaction('logIn()', 'task');

  String _email = '';
  String _password = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _sentryError(Exception exception) {
    transaction.throwable = exception;
    transaction.setTag('level', 'error');
    transaction.status = SpanStatus.internalError();
    transaction.finish();
  }

  void _setEmail(String? value) async {
    _email = value!;
  }

  void _setPassword(String? value) async {
    _password = value!;
  }

  bool _validate() {
    return _formKey.currentState!.validate();
  }

  void _showSnackbar(String message) {
    Text text = Text(message);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: text),
    );
  }

  Future<UserCredential> _signIn(BuildContext context) async {
    return await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: _email, password: _password)
        .then((UserCredential value) {
      Navigator.pop(context);
      return value;
    }).catchError((Object error) {
      if (error is FirebaseAuthException) {
        switch (error.code) {
          case 'user-not-found':
            {
              _showSnackbar(
                  'No user found for that email. Trying to register you automatically with the provided credentials.');
              _signUp(context);
            }
            break;
          case 'wrong-password':
            {
              _showSnackbar('Wrong password provided for that user.');
            }
            break;
        }
      }
    });
  }

  Future<UserCredential> _signUp(BuildContext context) async {
    return await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: _email, password: _password)
        .then((UserCredential value) {
      Navigator.pop(context);
      return value;
    }).catchError((Object error) {
      if (error is FirebaseAuthException) {
        switch (error.code) {
          case 'weak-password':
            {
              _showSnackbar('The password provided is too weak.');
            }
            break;
          case 'email-already-in-use':
            {
              _showSnackbar('The account already exists for that email.');
            }
            break;
        }
      }
    });
  }

  void _submitForm(BuildContext context) async {
    try {
      await _signIn(context);
    } on Exception catch (e) {
      _sentryError(e);
    }
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
          ],
        ),
        body: Form(
          key: _formKey,
          onChanged: _validate,
          child: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: TextFormField(
                  key: Key('email'),
                  autofocus: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter your email',
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an email address';
                    }
                    if (!RegExp(
                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                        .hasMatch(value)) {
                      return 'Please use a valid email address';
                    }
                    return null;
                  },
                  onSaved: _setEmail,
                  onChanged: _setEmail,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: _setEmail,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: TextFormField(
                  key: Key('password'),
                  autofocus: false,
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter your password',
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a password';
                    }
                    return null;
                  },
                  onSaved: _setPassword,
                  onChanged: _setPassword,
                  onFieldSubmitted: (String value) => _submitForm(context),
                ),
              ),
              TextButton(
                  onPressed: () => _submitForm(context), child: Text('Log in'))
            ],
          )),
        ));
  }
}
