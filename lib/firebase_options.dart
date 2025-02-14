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
    apiKey: 'AIzaSyDRX3XrOMoYofJjMdErzZQxi4yIFIu4epM',
    appId: '1:53939535264:web:24e80fdf6727e7c7da78c5',
    messagingSenderId: '53939535264',
    projectId: 'fintech-apiv1',
    authDomain: 'fintech-apiv1.firebaseapp.com',
    storageBucket: 'fintech-apiv1.firebasestorage.app',
    measurementId: 'G-WY0Q2QSJ59',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAwBlAb6rlelsmR1v_7DN4UNquhBTbv3HM',
    appId: '1:53939535264:android:a6d4558748f6e9a0da78c5',
    messagingSenderId: '53939535264',
    projectId: 'fintech-apiv1',
    storageBucket: 'fintech-apiv1.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyByzjVdvYB1QkRTCdXiYEcASUTUNFh404k',
    appId: '1:53939535264:ios:1dc26e74e53d850fda78c5',
    messagingSenderId: '53939535264',
    projectId: 'fintech-apiv1',
    storageBucket: 'fintech-apiv1.firebasestorage.app',
    iosBundleId: 'com.example.fintechApi',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyByzjVdvYB1QkRTCdXiYEcASUTUNFh404k',
    appId: '1:53939535264:ios:1dc26e74e53d850fda78c5',
    messagingSenderId: '53939535264',
    projectId: 'fintech-apiv1',
    storageBucket: 'fintech-apiv1.firebasestorage.app',
    iosBundleId: 'com.example.fintechApi',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDRX3XrOMoYofJjMdErzZQxi4yIFIu4epM',
    appId: '1:53939535264:web:6720dfb641243527da78c5',
    messagingSenderId: '53939535264',
    projectId: 'fintech-apiv1',
    authDomain: 'fintech-apiv1.firebaseapp.com',
    storageBucket: 'fintech-apiv1.firebasestorage.app',
    measurementId: 'G-6FS9TKHTE0',
  );
}
