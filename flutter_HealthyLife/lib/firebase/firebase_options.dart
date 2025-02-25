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
/// Clase generada por FlutterFire CLI para el correcto funcionamiento de firebase.
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
    apiKey: 'AIzaSyCR5rM-z8aymeIy4Iy-JSO7kEvK8esVRCM',
    appId: '1:791269411879:web:26e1ff6c0f8ffefe8d1202',
    messagingSenderId: '791269411879',
    projectId: 'flutter-healthy-life',
    authDomain: 'flutter-healthy-life.firebaseapp.com',
    storageBucket: 'flutter-healthy-life.firebasestorage.app',
    measurementId: 'G-BR9081DWJR',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBbwyLmvCF6jXZfjBYclrnmejIml4WeYko',
    appId: '1:791269411879:android:243f5fe7e85850fe8d1202',
    messagingSenderId: '791269411879',
    projectId: 'flutter-healthy-life',
    storageBucket: 'flutter-healthy-life.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDWRRF1OqMK3tVyfc7EvGiudFEwHXatQWw',
    appId: '1:791269411879:ios:5cf2ef52febd457b8d1202',
    messagingSenderId: '791269411879',
    projectId: 'flutter-healthy-life',
    storageBucket: 'flutter-healthy-life.firebasestorage.app',
    iosBundleId: 'com.example.flutterApplication1',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDWRRF1OqMK3tVyfc7EvGiudFEwHXatQWw',
    appId: '1:791269411879:ios:5cf2ef52febd457b8d1202',
    messagingSenderId: '791269411879',
    projectId: 'flutter-healthy-life',
    storageBucket: 'flutter-healthy-life.firebasestorage.app',
    iosBundleId: 'com.example.flutterApplication1',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCR5rM-z8aymeIy4Iy-JSO7kEvK8esVRCM',
    appId: '1:791269411879:web:f11d7b6a678edde68d1202',
    messagingSenderId: '791269411879',
    projectId: 'flutter-healthy-life',
    authDomain: 'flutter-healthy-life.firebaseapp.com',
    storageBucket: 'flutter-healthy-life.firebasestorage.app',
    measurementId: 'G-FV2B6552QD',
  );
}
