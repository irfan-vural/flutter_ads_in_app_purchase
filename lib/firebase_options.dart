// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
        return macos;
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
    apiKey: 'AIzaSyDf1m7z0Zay2Ft4loQEHYzBwlj-RauFGzI',
    appId: '1:524295796154:web:53aae9263f737901539983',
    messagingSenderId: '524295796154',
    projectId: 'decider-82556',
    authDomain: 'decider-82556.firebaseapp.com',
    storageBucket: 'decider-82556.appspot.com',
    measurementId: 'G-45G3PBV1F4',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA5TAwPNmoGAGt59ftUSaxEyXKebfUCGxk',
    appId: '1:524295796154:android:b943a6a33eacbf35539983',
    messagingSenderId: '524295796154',
    projectId: 'decider-82556',
    storageBucket: 'decider-82556.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyANMuaKzc1kxN0ryTxvlNZWaYeRU1wz0Oo',
    appId: '1:524295796154:ios:a1edc988344637a8539983',
    messagingSenderId: '524295796154',
    projectId: 'decider-82556',
    storageBucket: 'decider-82556.appspot.com',
    iosBundleId: 'com.example.flutterAdsPurchaseBestcase',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyANMuaKzc1kxN0ryTxvlNZWaYeRU1wz0Oo',
    appId: '1:524295796154:ios:f797b8375d131b87539983',
    messagingSenderId: '524295796154',
    projectId: 'decider-82556',
    storageBucket: 'decider-82556.appspot.com',
    iosBundleId: 'com.example.flutterAdsPurchaseBestcase.RunnerTests',
  );
}