import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_starter/error/error.dart';
import 'package:flutter_starter/loading/loading.dart';
import 'package:flutter_starter/root/root.dart';
import 'package:sentry/sentry.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");

  await Sentry.init(
    (SentryOptions options) {
      options.dsn = dotenv.get('SENTRY_DSN',
          fallback: 'https://xxx@xxx.ingest.sentry.io/xxx');
      options.tracesSampleRate = 1.0;
    },
    appRunner: () {
      WidgetsFlutterBinding.ensureInitialized();

      return runApp(App(
        key: Key('app'),
      ));
    },
  );
}

// We are using a StatefulWidget such that we only create the [Future] once,
// no matter how many times our widget rebuild.
// If we used a [StatelessWidget], in the event where [App] is rebuilt, that
// would re-initialize FlutterFire and make our application re-enter loading state,
// which is undesired.
class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  // The future is part of the state of our widget. We should not call `initializeApp`
  // directly inside [build].
  final Future<FirebaseApp> _initialization = Firebase.initializeApp(
    name: 'flutter-starter',
    options: FirebaseOptions(
      apiKey: dotenv.get('FIRE_API_KEY', fallback: 'FIRE_API_KEY'),
      appId: dotenv.get('FIRE_APP_ID', fallback: 'FIRE_APP_ID'),
      messagingSenderId: dotenv.get('FIRE_MESSAGING_SENDER_ID',
          fallback: 'FIRE_MESSAGING_SENDER_ID'),
      projectId: dotenv.get('FIRE_PROJECT_ID', fallback: 'FIRE_PROJECT_ID'),
    ),
  ).catchError((Object error) {
    if (error is FirebaseException && error.code == 'duplicate-app') {
      return Firebase.app('flutter-starter');
    } else {
      throw error;
    }
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FutureBuilder<FirebaseApp>(
        // Initialize FlutterFire.
        future: _initialization,
        builder: (BuildContext context, AsyncSnapshot<Object?> snapshot) {
          if (snapshot.hasError) {
            return AppError(key: Key('error'), snapshot: snapshot);
          }

          // Once complete, show your application.
          if (snapshot.connectionState == ConnectionState.done) {
            return AppRoot(key: Key('root'));
          }

          // Otherwise, show something whilst waiting for initialization to complete.
          return AppLoading(key: Key('loading'));
        },
      ),
    );
  }
}
