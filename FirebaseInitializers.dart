import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb, debugPrint;

/// Firebase Configuration Class
/// Provides Firebase options for different platforms (Web, iOS, Android)
/// Centralizes Firebase initialization logic for the entire app
class FirebaseConfig {
  /// Private constructor to prevent instantiation
  FirebaseConfig._();

  /// Returns platform-specific Firebase options
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    } else {
      // For mobile (Android/iOS)
      return mobile;
    }
  }

  /// Firebase options for Web platform
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDkmtgkymdThtASpBdxmWOGd6l2oyIgK_E',
    appId: '1:776412307701:android:fe13f2c79d8260293d25bc',
    messagingSenderId: '776412307701',
    projectId: 'parivartan-c3238',
    storageBucket: 'parivartan-c3238.firebasestorage.app',
  );

  /// Firebase options for Mobile platforms (Android/iOS)
  static const FirebaseOptions mobile = FirebaseOptions(
    apiKey: 'AIzaSyDkmtgkymdThtASpBdxmWOGd6l2oyIgK_E',
    appId: '1:776412307701:ios:xxxxxxxxxxxxx',
    messagingSenderId: '776412307701',
    projectId: 'parivartan-c3238',
    storageBucket: 'parivartan-c3238.firebasestorage.app',
    iosClientId: 'your-ios-client-id',
    iosBundleId: 'com.example.parivartan',
  );

  /// Initialize Firebase with proper error handling
  /// Call this in main() before runApp()
  static Future<void> initialize() async {
    try {
      await Firebase.initializeApp(options: currentPlatform);
      debugPrint('✅ Firebase initialized successfully');
    } catch (e) {
      debugPrint('❌ Firebase initialization failed: $e');
      rethrow;
    }
  }
}

/// Helper function for backward compatibility
/// Can be used directly in main() or other files
FirebaseOptions getFirebaseOptions() {
  return FirebaseConfig.currentPlatform;
}
