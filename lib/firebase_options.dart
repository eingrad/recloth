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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCFBNJ2IH56FWP73QhyoMtbbGVeRutrwgY',
    appId: '1:267817647639:web:2b53028445fd58d8672652',
    messagingSenderId: '267817647639',
    projectId: 'recloth-22d97',
    authDomain: 'recloth-22d97.firebaseapp.com',
    storageBucket: 'recloth-22d97.firebasestorage.app',
    measurementId: 'G-5SPG5D392V',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAw21A0p2dTJ0vTtQFI8_BQJnW4zA8lmBI',
    appId: '1:267817647639:android:cfef55db25ba9b4d672652',
    messagingSenderId: '267817647639',
    projectId: 'recloth-22d97',
    storageBucket: 'recloth-22d97.firebasestorage.app',
  );

}