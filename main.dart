// main.dart - NSS HEALTH CAMP APP ENTRY POINT
//
// Add to pubspec.yaml:
// dependencies:
//   firebase_core: ^2.24.2
//   cloud_firestore: ^4.13.6
//   flutter:
//     sdk: flutter
//
// assets:
//   - assets/Nss_Logo.jpg
//   - assets/andh.jpg
//   - assets/dental.jpg
//   - assets/dental1.jpg
//   - assets/health.jpg
//   - assets/health2.jpeg
//   - assets/new.jpeg

import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

//import 'app_colors.dart';
//import 'main_navigation.dart';
// app_colors.dart - Color constants for the app

import 'package:flutter/material.dart';
import 'package:parivartan/CommonMan_Module/FirebaseInitializers.dart';
import 'package:parivartan/CommonMan_Module/Health_Dental_Camp/Main_Navigation.dart';

class AppColors {
  static const Color primary = Color(0xFF6366F1);
  static const Color primaryDark = Color(0xFF4F46E5);
  static const Color secondary = Color(0xFF8B5CF6);
  static const Color accent = Color(0xFF06B6D4);
  static const Color background = Color(0xFFF8FAFC);
  static const Color cardBg = Color(0xFFFFFFFF);
  static const Color textDark = Color(0xFF1E293B);
  static const Color textLight = Color(0xFF64748B);
  static const Color success = Color(0xFF10B981);
  static const Color error = Color(0xFFEF4444);
  static const Color navyBlue = Color(0xFF1E3A8A);
  static const Color lightBlue = Color(0xFF1976D2);
  static const Color primaryOrange = Color(0xFFF97316);
}

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   // Set system UI overlay style
//   SystemChrome.setSystemUIOverlayStyle(
//     const SystemUiOverlayStyle(
//       statusBarColor: Colors.transparent,
//       statusBarIconBrightness: Brightness.light,
//     ),
//   );

//   try {
//     await Firebase.initializeApp(
//       options: const FirebaseOptions(
//         apiKey: 'AIzaSyDkmtgkymdThtASpBdxmWOGd6l2oyIgK_E',
//         appId: '1:776412307701:android:fe13f2c79d8260293d25bc',
//         messagingSenderId: '776412307701',
//         projectId: 'parivartan-c3238',
//         storageBucket: 'parivartan-c3238.firebasestorage.app',
//       ),
//     );
//   } catch (e) {
//     debugPrint('Firebase initialization error: $e');
//   }
//   runApp(const NSSCampApp());
// }
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseConfig.initialize(); // One line initialization
  runApp(const NSSCampApp());
}

class NSSCampApp extends StatelessWidget {
  const NSSCampApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NSS Health Camp',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppColors.navyBlue,
        scaffoldBackgroundColor: AppColors.background,
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.navyBlue,
          primary: AppColors.navyBlue,
        ),
      ),
      home: const MainNavigation(),
    );
  }
}
// models.dart - Data models for the app

/// Model class representing a family member's information
class FamilyMember {
  final String name;
  final String mobile;
  final String age;
  final String gender;

  FamilyMember({
    required this.name,
    required this.mobile,
    required this.age,
    required this.gender,
  });

  Map<String, dynamic> toMap() {
    return {'name': name, 'mobile': mobile, 'age': age, 'gender': gender};
  }

  factory FamilyMember.fromMap(Map<String, dynamic> map) {
    return FamilyMember(
      name: map['name'] ?? '',
      mobile: map['mobile'] ?? '',
      age: map['age'] ?? '',
      gender: map['gender'] ?? '',
    );
  }
}

/// Model class representing a camp registration
class CampRegistration {
  final String? id;
  final String campType;
  final int memberCount;
  final DateTime? registrationDate;
  final String status;
  final List<FamilyMember> members;

  CampRegistration({
    this.id,
    required this.campType,
    required this.memberCount,
    this.registrationDate,
    required this.status,
    required this.members,
  });

  Map<String, dynamic> toMap() {
    return {
      'campType': campType,
      'memberCount': memberCount,
      'registrationDate': FieldValue.serverTimestamp(),
      'status': status,
      'members': members.map((m) => m.toMap()).toList(),
    };
  }

  factory CampRegistration.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?;
    if (data == null) {
      return CampRegistration(
        id: doc.id,
        campType: '',
        memberCount: 0,
        status: 'Pending',
        members: [],
      );
    }
    return CampRegistration(
      id: doc.id,
      campType: data['campType'] ?? '',
      memberCount: data['memberCount'] ?? 0,
      registrationDate: (data['registrationDate'] as Timestamp?)?.toDate(),
      status: data['status'] ?? 'Pending',
      members:
          (data['members'] as List<dynamic>?)
              ?.map((m) => FamilyMember.fromMap(m as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

/// Model class representing a health camp
class HealthCamp {
  final String type;
  final String date;
  final String time;
  final String venue;
  final List<String> services;
  final IconData icon;
  final String imagePath;

  HealthCamp({
    required this.type,
    required this.date,
    required this.time,
    required this.venue,
    required this.services,
    required this.icon,
    required this.imagePath,
  });
}
