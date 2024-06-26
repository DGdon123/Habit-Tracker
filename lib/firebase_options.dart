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
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
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
    apiKey: 'AIzaSyAr8DTYoxTJ1LA4XM8AhGXHIzhl9TNp0E0',
    appId: '1:491013391004:android:9b79b3e1f661ad6e7aa359',
    messagingSenderId: '491013391004',
    projectId: 'habittracker-51e7f',
    storageBucket: 'habittracker-51e7f.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBzxrZmKPnGJTrS18WPjCeDol-bycG6HnE',
    appId: '1:491013391004:ios:94c77d0712467db97aa359',
    messagingSenderId: '491013391004',
    projectId: 'habittracker-51e7f',
    storageBucket: 'habittracker-51e7f.appspot.com',
    androidClientId: '491013391004-4d5u21qb2eeoc5nrhtnqp8k7v165fg68.apps.googleusercontent.com',
    iosClientId: '491013391004-aqrjsqdpadnb3l577nid6ulfkgfkikvc.apps.googleusercontent.com',
    iosBundleId: 'com.example.habitTracker',
  );
}
