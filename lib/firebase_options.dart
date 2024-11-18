// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDE41nhR53RLRuxk40_mHs43DIAw32dPh4',
    appId: '1:1025254909622:android:fde80a65a779e6cd52e817',
    messagingSenderId: '1025254909622',
    projectId: 'hulapi',
    databaseURL: 'https://hulapi-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'hulapi.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyArpPDQoTp8JuucpA5xf-lJ-6TEn7JOmpg',
    appId: '1:1025254909622:ios:318701ced0b30a1c52e817',
    messagingSenderId: '1025254909622',
    projectId: 'hulapi',
    databaseURL: 'https://hulapi-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'hulapi.appspot.com',
    iosBundleId: 'com.example.basic',
  );

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDY84EhPRolZV7IKkaEXMwWMWEpw-drOiE',
    appId: '1:1025254909622:web:80250866652977d152e817',
    messagingSenderId: '1025254909622',
    projectId: 'hulapi',
    authDomain: 'hulapi.firebaseapp.com',
    databaseURL: 'https://hulapi-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'hulapi.appspot.com',
    measurementId: 'G-XMDLYFZVD8',
  );

}