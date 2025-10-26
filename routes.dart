import 'package:flutter/material.dart';
import 'views/splash/splash_wrapper.dart';
import 'views/auth/login_page.dart';
import 'views/auth/signup_page.dart';
import 'views/home/home_page.dart';
import 'models/user_model.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String home = '/home';

  static Map<String, WidgetBuilder> get routes => {
        splash: (context) => const SplashWrapper(),
        login: (context) => const LoginPage(),
        signup: (context) => const SignUpPage(),
        home: (context) => const HomePage(userRole: UserRole.volunteerStudent),
      };
}
