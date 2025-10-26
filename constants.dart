import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryOrange = Color(0xFFFF6F00);
  static const Color navyBlue = Color(0xFF0D47A1);
  static const Color successGreen = Color(0xFF4CAF50);
  static const Color white = Color(0xFFFFFFFF);
  static const Color lightGrey = Color(0xFFF5F5F5);
  static const Color darkGrey = Color(0xFF757575);
}

class AppTheme {
  static ThemeData get theme => ThemeData(
        primaryColor: AppColors.primaryOrange,
        scaffoldBackgroundColor: AppColors.white,
        fontFamily: 'Inter',
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            fontFamily: 'Poppins', 
            fontWeight: FontWeight.bold, 
            fontSize: 36,
            letterSpacing: 1.2,
          ),
          headlineLarge: TextStyle(
            fontFamily: 'Poppins', 
            fontWeight: FontWeight.bold, 
            fontSize: 28,
            letterSpacing: 0.5,
          ),
          headlineMedium: TextStyle(
            fontFamily: 'Inter', 
            fontWeight: FontWeight.w600, 
            fontSize: 24,
            letterSpacing: 0.3,
          ),
          titleLarge: TextStyle(
            fontFamily: 'Inter', 
            fontWeight: FontWeight.w600, 
            fontSize: 20,
            letterSpacing: 0.2,
          ),
          bodyLarge: TextStyle(
            fontFamily: 'Inter', 
            fontSize: 16,
            height: 1.5,
            letterSpacing: 0.1,
          ),
          bodyMedium: TextStyle(
            fontFamily: 'Inter', 
            fontSize: 14,
            height: 1.4,
            letterSpacing: 0.1,
          ),
          labelLarge: TextStyle(
            fontFamily: 'Inter', 
            fontWeight: FontWeight.w600, 
            fontSize: 16,
            letterSpacing: 0.5,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.lightGrey,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.withValues(alpha: 0.2)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.primaryOrange, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red, width: 1),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          labelStyle: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryOrange,
            foregroundColor: AppColors.white,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 3,
            shadowColor: AppColors.primaryOrange.withValues(alpha: 0.3),
            textStyle: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.white,
          elevation: 0,
          titleTextStyle: TextStyle(
            fontFamily: 'Inter',
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.navyBlue,
          ),
        ),
      );
}

class AppStrings {
  static const String appName = 'Parivartan';
  static const String welcomeBack = 'Welcome Back!';
  static const String createAccount = 'Create Account';
  static const String selectRole = 'Select your role and login';
  static const String chooseRole = 'Choose your role and register';
}
