import '../models/user_model.dart';
import '../services/firebase_service.dart';

class AuthController {
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) return 'Email is required';
    final emailRegex = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$');
    return emailRegex.hasMatch(value) ? null : 'Enter a valid email address';
  }

  static String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) return 'Phone number is required';
    final phoneRegex = RegExp(r'^[6-9]\d{9}$');
    return phoneRegex.hasMatch(value) ? null : 'Enter a valid 10-digit phone number';
  }

  static String? validateRequired(String? value, {String? fieldName}) {
    if (value == null || value.trim().isEmpty) {
      return fieldName != null ? '$fieldName is required' : 'This field is required';
    }
    return null;
  }

  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) return 'Name is required';
    if (value.trim().length < 2) return 'Name must be at least 2 characters';
    if (value.trim().length > 50) return 'Name must be less than 50 characters';
    final nameRegex = RegExp(r'^[a-zA-Z\s]+$');
    return nameRegex.hasMatch(value.trim()) ? null : 'Name can only contain letters and spaces';
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Password is required';
    if (value.length < 8) return 'Password must be at least 8 characters';
    if (value.length > 50) return 'Password must be less than 50 characters';
    
    // Check for at least one uppercase letter
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Password must contain at least one uppercase letter';
    }
    
    // Check for at least one lowercase letter
    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return 'Password must contain at least one lowercase letter';
    }
    
    // Check for at least one digit
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Password must contain at least one number';
    }
    
    // Check for at least one special character
    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
      return 'Password must contain at least one special character';
    }
    
    return null;
  }

  static String? validateCourse(String? value) {
    if (value == null || value.trim().isEmpty) return 'Course/Branch is required';
    if (value.trim().length < 2) return 'Course name must be at least 2 characters';
    return null;
  }

  static String? validateBatch(String? value) {
    if (value == null || value.trim().isEmpty) return 'NSS Batch is required';
    final batchRegex = RegExp(r'^\d{4}-\d{2}$');
    return batchRegex.hasMatch(value.trim()) ? null : 'Enter batch in format: 2024-25';
  }

  static String? validateAdmissionYear(String? value) {
    if (value == null || value.trim().isEmpty) return 'Admission year is required';
    final year = int.tryParse(value.trim());
    final currentYear = DateTime.now().year;
    if (year == null || year < 2000 || year > currentYear) {
      return 'Enter a valid admission year';
    }
    return null;
  }

  static String? validateOrgName(String? value) {
    if (value == null || value.trim().isEmpty) return 'Organization name is required';
    if (value.trim().length < 3) return 'Organization name must be at least 3 characters';
    return null;
  }

  static String? validateSkills(String? value) {
    if (value == null || value.trim().isEmpty) return 'Skills are required';
    if (value.trim().length < 3) return 'Please enter at least one skill';
    return null;
  }

  static String? validateAvailability(String? value) {
    if (value == null || value.trim().isEmpty) return 'Availability is required';
    if (value.trim().length < 3) return 'Please specify your availability';
    return null;
  }

  static String? validateAuthCode(String? value) {
    if (value == null || value.trim().isEmpty) return 'Authorization code is required';
    if (value.trim().length < 6) return 'Authorization code must be at least 6 characters';
    return null;
  }

  // Firebase Authentication - Login
  static Future<UserModel?> login(String email, String password, UserRole role) async {
    try {
      // Sign in with Firebase Auth
      final userCredential = await FirebaseService.signInWithEmail(
        email: email,
        password: password,
      );

      if (userCredential.user == null) {
        throw Exception('Login failed');
      }

      // Get user data from Firestore
      final userData = await FirebaseService.getUserData(userCredential.user!.uid);
      
      if (userData == null) {
        throw Exception('User data not found');
      }

      // Verify the role matches
      if (userData.role != role) {
        await FirebaseService.signOut();
        throw Exception('Invalid role. Please select the correct role for your account.');
      }

      return userData;
    } catch (e) {
      rethrow;
    }
  }

  // Firebase Authentication - Signup
  static Future<UserModel> signup(UserModel user, String password) async {
    try {
      // Create user with Firebase Auth
      final userCredential = await FirebaseService.signUpWithEmail(
        email: user.email,
        password: password,
      );

      if (userCredential.user == null) {
        throw Exception('Signup failed');
      }

      // Create UserModel with Firebase UID
      final newUser = UserModel(
        id: userCredential.user!.uid,
        name: user.name,
        email: user.email,
        phone: user.phone,
        role: user.role,
        profileImage: user.profileImage,
        createdAt: user.createdAt,
        roleSpecificData: user.roleSpecificData,
      );

      // Save user data to Firestore
      await FirebaseService.saveUserData(newUser);

      return newUser;
    } catch (e) {
      rethrow;
    }
  }

  // Sign out
  static Future<void> signOut() async {
    await FirebaseService.signOut();
  }

  // Get current user data
  static Future<UserModel?> getCurrentUserData() async {
    final currentUser = FirebaseService.currentUser;
    if (currentUser == null) return null;
    
    return await FirebaseService.getUserData(currentUser.uid);
  }
}
