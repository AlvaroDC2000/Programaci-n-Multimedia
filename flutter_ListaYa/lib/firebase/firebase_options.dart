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
        return macos;
      case TargetPlatform.windows:
        return windows;
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
    apiKey: 'AIzaSyDC38U3cSD50vOClRLXppdYN22STbeK1pU',
    appId: '1:474601209451:web:98c171bd5488eeeb183b2e',
    messagingSenderId: '474601209451',
    projectId: 'flutter-listaya',
    authDomain: 'flutter-listaya.firebaseapp.com',
    storageBucket: 'flutter-listaya.firebasestorage.app',
    measurementId: 'G-EPYH2T0BCR',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDQ9AY-gK4GaE9IQHGhPDZXP5hL9VOJZ_o',
    appId: '1:474601209451:android:bd74f999c6f28130183b2e',
    messagingSenderId: '474601209451',
    projectId: 'flutter-listaya',
    storageBucket: 'flutter-listaya.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDtWjlJ9TN7iBElHrwyXfhbsCoGxm5tWcY',
    appId: '1:474601209451:ios:006daae9de95bdef183b2e',
    messagingSenderId: '474601209451',
    projectId: 'flutter-listaya',
    storageBucket: 'flutter-listaya.firebasestorage.app',
    iosBundleId: 'com.example.flutterApplication1',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDtWjlJ9TN7iBElHrwyXfhbsCoGxm5tWcY',
    appId: '1:474601209451:ios:006daae9de95bdef183b2e',
    messagingSenderId: '474601209451',
    projectId: 'flutter-listaya',
    storageBucket: 'flutter-listaya.firebasestorage.app',
    iosBundleId: 'com.example.flutterApplication1',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDC38U3cSD50vOClRLXppdYN22STbeK1pU',
    appId: '1:474601209451:web:4deb01f00cc5009c183b2e',
    messagingSenderId: '474601209451',
    projectId: 'flutter-listaya',
    authDomain: 'flutter-listaya.firebaseapp.com',
    storageBucket: 'flutter-listaya.firebasestorage.app',
    measurementId: 'G-SBF8DEEFBQ',
  );
}
