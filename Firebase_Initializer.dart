import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return const FirebaseOptions(
        apiKey: 'AIzaSyDkmtgkymdThtASpBdxmWOGd6l2oyIgK_E',
        appId: '1:776412307701:android:fe13f2c79d8260293d25bc',
        messagingSenderId: '776412307701',
        projectId: 'parivartan-c3238',
        storageBucket: 'parivartan-c3238.firebasestorage.app',
      );
    } else {
      return const FirebaseOptions(
        apiKey: 'AIzaSyDkmtgkymdThtASpBdxmWOGd6l2oyIgK_E',
        appId: '1:776412307701:ios:xxxxxxxxxxxxx',
        messagingSenderId: '776412307701',
        projectId: 'parivartan-c3238',
        storageBucket: 'parivartan-c3238.firebasestorage.app',
        iosClientId: 'your-ios-client-id',
        iosBundleId: 'com.example.parivartan',
      );
    }
  }
}
