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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBlo7bDABnamLYwfH_8cYmTpAokhze_Csg',
    appId: '1:14131773963:android:750115019603008fcbfd0e',
    messagingSenderId: '14131773963',
    projectId: 'intec-app-e897e',
    storageBucket: 'intec-app-e897e.firebasestorage.app',
  );

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBhXn66cFBFLoqKQwxPaQfXrqDW7YzQeg4',
    appId: '1:14131773963:web:52e843aeb851ea28cbfd0e',
    messagingSenderId: '14131773963',
    projectId: 'intec-app-e897e',
    authDomain: 'intec-app-e897e.firebaseapp.com',
    storageBucket: 'intec-app-e897e.firebasestorage.app',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAclCMExT14slWRir1bXEznVr6HkPS-mg0',
    appId: '1:14131773963:ios:b1f3874d1ab32676cbfd0e',
    messagingSenderId: '14131773963',
    projectId: 'intec-app-e897e',
    storageBucket: 'intec-app-e897e.firebasestorage.app',
    iosBundleId: 'com.example.intecSocialApp',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAclCMExT14slWRir1bXEznVr6HkPS-mg0',
    appId: '1:14131773963:ios:b1f3874d1ab32676cbfd0e',
    messagingSenderId: '14131773963',
    projectId: 'intec-app-e897e',
    storageBucket: 'intec-app-e897e.firebasestorage.app',
    iosBundleId: 'com.example.intecSocialApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBhXn66cFBFLoqKQwxPaQfXrqDW7YzQeg4',
    appId: '1:14131773963:web:5ac47599531f4fafcbfd0e',
    messagingSenderId: '14131773963',
    projectId: 'intec-app-e897e',
    authDomain: 'intec-app-e897e.firebaseapp.com',
    storageBucket: 'intec-app-e897e.firebasestorage.app',
  );

}