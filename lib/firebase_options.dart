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
    apiKey: 'AIzaSyDE2_TigFEdBuJbeL3gecgtzbllVK8YMUg',
    appId: '1:174497811264:web:6564d0e753aee066fd08a5',
    messagingSenderId: '174497811264',
    projectId: 'zipgameday-6ef28',
    authDomain: 'zipgameday-6ef28.firebaseapp.com',
    databaseURL: 'https://zipgameday-6ef28.firebaseio.com',
    storageBucket: 'zipgameday-6ef28.appspot.com',
    measurementId: 'G-2KLVLNW4F5',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCjOhdcrJRdwLDiu7Qf0A9yxIE5bKrOxPk',
    appId: '1:174497811264:android:dec84c8e26a0b24dfd08a5',
    messagingSenderId: '174497811264',
    projectId: 'zipgameday-6ef28',
    databaseURL: 'https://zipgameday-6ef28.firebaseio.com',
    storageBucket: 'zipgameday-6ef28.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD9DKNhJbRu_uX3QeBcwj9DS0jxUkbSIUY',
    appId: '1:174497811264:ios:8241fd6026229f1afd08a5',
    messagingSenderId: '174497811264',
    projectId: 'zipgameday-6ef28',
    databaseURL: 'https://zipgameday-6ef28.firebaseio.com',
    storageBucket: 'zipgameday-6ef28.appspot.com',
    androidClientId: '174497811264-kie6152gc4vvs3lphjk9m0970ku3cp4m.apps.googleusercontent.com',
    iosClientId: '174497811264-3tu3dvmfhvn2tnjrrhd9mudevu9fbjdo.apps.googleusercontent.com',
    iosBundleId: 'com.example.zipapp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyD9DKNhJbRu_uX3QeBcwj9DS0jxUkbSIUY',
    appId: '1:174497811264:ios:5f4a262398ce6e32fd08a5',
    messagingSenderId: '174497811264',
    projectId: 'zipgameday-6ef28',
    databaseURL: 'https://zipgameday-6ef28.firebaseio.com',
    storageBucket: 'zipgameday-6ef28.appspot.com',
    androidClientId: '174497811264-kie6152gc4vvs3lphjk9m0970ku3cp4m.apps.googleusercontent.com',
    iosClientId: '174497811264-7q3mjjvh23vn85g43a7dhk6kgf34fnqc.apps.googleusercontent.com',
    iosBundleId: 'com.example.zipapp.RunnerTests',
  );
}
