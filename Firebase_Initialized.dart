import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:parivartan/src/views/home/home_page.dart';

// Global Firebase Options - Single source of truth
class GlobalFirebaseOptions {
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDkmtgkymdThtASpBdxmWOGd6l2oyIgK_E',
    appId: '1:776412307701:android:fe13f2c79d8260293d25bc',
    messagingSenderId: '776412307701',
    projectId: 'parivartan-c3238',
    storageBucket: 'parivartan-c3238.firebasestorage.app',
  );

  // You can add iOS options here if needed
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDkmtgkymdThtASpBdxmWOGd6l2oyIgK_E',
    appId: '1:776412307701:ios:xxxxxxxxxxxxx',
    messagingSenderId: '776412307701',
    projectId: 'parivartan-c3238',
    storageBucket: 'parivartan-c3238.firebasestorage.app',
    iosClientId: 'your-ios-client-id',
    iosBundleId: 'com.example.parivartan',
  );
}

// Main entry point - Firebase is initialized ONLY here
void main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Initialize Firebase once for the entire app
    await Firebase.initializeApp(options: GlobalFirebaseOptions.android);
    print('✅ Firebase initialized successfully');
  } catch (e) {
    print('❌ Firebase initialization error: $e');
  }

  // Run the app
  runApp(const ParivartanApp());
}

// Main App Widget
class ParivartanApp extends StatelessWidget {
  const ParivartanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Parivartan NSS',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFFF97316),
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
        useMaterial3: true,
        colorScheme: const ColorScheme.light(
          primary: Color(0xFFF97316),
          secondary: Color(0xFFF97316),
        ),
      ),
      // Start with StudentHomePage
      home: const HomePage(),
    );
  }
}
