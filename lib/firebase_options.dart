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
    apiKey: 'AIzaSyAaS25sOWbMamSpdrhumzoim8z15ctoJsM',
    appId: '1:258167260360:web:59fef311d6cc809c8391fd',
    messagingSenderId: '258167260360',
    projectId: 'x-eats-15a80',
    authDomain: 'x-eats-15a80.firebaseapp.com',
    storageBucket: 'x-eats-15a80.appspot.com',
    measurementId: 'G-6FLQ8JHVN8',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCpC7dYcusRpLibTAoGa0bI8VCMglX-zfY',
    appId: '1:258167260360:android:dc77f1a2e465e3628391fd',
    messagingSenderId: '258167260360',
    projectId: 'x-eats-15a80',
    storageBucket: 'x-eats-15a80.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDwVIGt3dd8IFzcipTwCUrxM3-N-1u10xA',
    appId: '1:258167260360:ios:41994255a4044c608391fd',
    messagingSenderId: '258167260360',
    projectId: 'x-eats-15a80',
    storageBucket: 'x-eats-15a80.appspot.com',
    iosClientId:
        '258167260360-166hulbtp6adhmccdp05vc0aiah5tnld.apps.googleusercontent.com',
    iosBundleId: 'com.example.xeats',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDwVIGt3dd8IFzcipTwCUrxM3-N-1u10xA',
    appId: '1:258167260360:ios:41994255a4044c608391fd',
    messagingSenderId: '258167260360',
    projectId: 'x-eats-15a80',
    storageBucket: 'x-eats-15a80.appspot.com',
    iosClientId:
        '258167260360-166hulbtp6adhmccdp05vc0aiah5tnld.apps.googleusercontent.com',
    iosBundleId: 'com.example.xeats',
  );
}
