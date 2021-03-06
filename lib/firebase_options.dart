// File generated by FlutterFire CLI.
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    // ignore: missing_enum_constant_in_switch
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
    }

    throw UnsupportedError(
      'DefaultFirebaseOptions are not supported for this platform.',
    );
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA4AUUqJQEuXMXn5Kv6kb8FqWryd3Ur0y0',
    appId: '1:55232180944:android:bed57925bd8793fe1664d5',
    messagingSenderId: '55232180944',
    projectId: 'silgam-app',
    storageBucket: 'silgam-app.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC55jTfB_rJb3RbhRxMWauTgHttoMYN6qo',
    appId: '1:55232180944:ios:6389f09fade70a521664d5',
    messagingSenderId: '55232180944',
    projectId: 'silgam-app',
    storageBucket: 'silgam-app.appspot.com',
    iosClientId: '55232180944-jm8sqs01dn3uu7ntj2hj8r84cl8or3us.apps.googleusercontent.com',
    iosBundleId: 'com.seunghyun.silgam',
  );
}
