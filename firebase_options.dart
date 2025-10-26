// File generated manually based on google-services.json
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
    apiKey: 'AIzaSyDWK--JSc9Sq8lkKh1YmmWinsO_NafH-uA',
    appId: '1:776412307701:web:YOUR_WEB_APP_ID',
    messagingSenderId: '776412307701',
    projectId: 'parivartan-c3238',
    authDomain: 'parivartan-c3238.firebaseapp.com',
    storageBucket: 'parivartan-c3238.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDkmtgkymdThtASpBdxmWOGd6l2oyIgK_E',
    appId: '1:776412307701:android:fe13f2c79d8260293d25bc',
    messagingSenderId: '776412307701',
    projectId: 'parivartan-c3238',
    storageBucket: 'parivartan-c3238.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'YOUR_IOS_API_KEY',
    appId: '1:776412307701:ios:YOUR_IOS_APP_ID',
    messagingSenderId: '776412307701',
    projectId: 'parivartan-c3238',
    storageBucket: 'parivartan-c3238.firebasestorage.app',
    iosBundleId: 'com.example.parivartan',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'YOUR_MACOS_API_KEY',
    appId: '1:776412307701:macos:YOUR_MACOS_APP_ID',
    messagingSenderId: '776412307701',
    projectId: 'parivartan-c3238',
    storageBucket: 'parivartan-c3238.firebasestorage.app',
    iosBundleId: 'com.example.parivartan',
  );
}

