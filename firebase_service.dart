import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';

class FirebaseService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Collection names
  static const String _usersCollection = 'users';
  static const String _commonMenCollection = 'common_men';
  static const String _universitiesCollection = 'universities';
  static const String _volunteerStudentsCollection = 'volunteer_students';
  static const String _adminCoordinatorsCollection = 'admin_coordinators';

  // Get current user
  static User? get currentUser => _auth.currentUser;

  // Sign up with email and password
  static Future<UserCredential> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Sign in with email and password
  static Future<UserCredential> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Sign out
  static Future<void> signOut() async {
    await _auth.signOut();
  }

  // Save user data to Firestore
  static Future<void> saveUserData(UserModel user) async {
    try {
      // Save base user data
      await _firestore.collection(_usersCollection).doc(user.id).set({
        'id': user.id,
        'name': user.name,
        'email': user.email,
        'phone': user.phone,
        'role': user.role.toString().split('.').last,
        'profileImage': user.profileImage,
        'createdAt': user.createdAt.toIso8601String(),
      });

      // Save role-specific data to appropriate collection
      await _saveRoleSpecificData(user.id, user.role, user.roleSpecificData);
    } catch (e) {
      throw Exception('Failed to save user data: $e');
    }
  }

  // Save role-specific data to appropriate collection
  static Future<void> _saveRoleSpecificData(
    String userId,
    UserRole role,
    Map<String, dynamic> roleData,
  ) async {
    String collection;
    
    switch (role) {
      case UserRole.commonMan:
        collection = _commonMenCollection;
        break;
      case UserRole.university:
        collection = _universitiesCollection;
        break;
      case UserRole.volunteerStudent:
        collection = _volunteerStudentsCollection;
        break;
      case UserRole.adminCoordinator:
        collection = _adminCoordinatorsCollection;
        break;
    }

    await _firestore.collection(collection).doc(userId).set({
      'userId': userId,
      ...roleData,
      'updatedAt': DateTime.now().toIso8601String(),
    });
  }

  // Get user data from Firestore
  static Future<UserModel?> getUserData(String userId) async {
    try {
      // Get base user data
      final userDoc = await _firestore.collection(_usersCollection).doc(userId).get();
      
      if (!userDoc.exists) {
        return null;
      }

      final userData = userDoc.data()!;
      final roleString = userData['role'] as String;
      final role = _parseUserRole(roleString);

      // Get role-specific data
      final roleSpecificData = await _getRoleSpecificData(userId, role);

      return UserModel(
        id: userData['id'],
        name: userData['name'],
        email: userData['email'],
        phone: userData['phone'],
        role: role,
        profileImage: userData['profileImage'],
        createdAt: DateTime.parse(userData['createdAt']),
        roleSpecificData: roleSpecificData,
      );
    } catch (e) {
      throw Exception('Failed to get user data: $e');
    }
  }

  // Get role-specific data from appropriate collection
  static Future<Map<String, dynamic>> _getRoleSpecificData(
    String userId,
    UserRole role,
  ) async {
    String collection;
    
    switch (role) {
      case UserRole.commonMan:
        collection = _commonMenCollection;
        break;
      case UserRole.university:
        collection = _universitiesCollection;
        break;
      case UserRole.volunteerStudent:
        collection = _volunteerStudentsCollection;
        break;
      case UserRole.adminCoordinator:
        collection = _adminCoordinatorsCollection;
        break;
    }

    final doc = await _firestore.collection(collection).doc(userId).get();
    
    if (!doc.exists) {
      return {};
    }

    final data = Map<String, dynamic>.from(doc.data()!);
    data.remove('userId');
    data.remove('updatedAt');
    return data;
  }

  // Update user data
  static Future<void> updateUserData(UserModel user) async {
    try {
      // Update base user data
      await _firestore.collection(_usersCollection).doc(user.id).update({
        'name': user.name,
        'phone': user.phone,
        'profileImage': user.profileImage,
      });

      // Update role-specific data
      await _saveRoleSpecificData(user.id, user.role, user.roleSpecificData);
    } catch (e) {
      throw Exception('Failed to update user data: $e');
    }
  }

  // Check if user exists in Firestore
  static Future<bool> userExists(String userId) async {
    final doc = await _firestore.collection(_usersCollection).doc(userId).get();
    return doc.exists;
  }

  // Parse UserRole from string
  static UserRole _parseUserRole(String roleString) {
    switch (roleString) {
      case 'commonMan':
        return UserRole.commonMan;
      case 'university':
        return UserRole.university;
      case 'volunteerStudent':
        return UserRole.volunteerStudent;
      case 'adminCoordinator':
        return UserRole.adminCoordinator;
      default:
        return UserRole.volunteerStudent;
    }
  }

  // Handle Firebase Auth exceptions
  static String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'weak-password':
        return 'The password provided is too weak.';
      case 'email-already-in-use':
        return 'An account already exists for this email.';
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'user-disabled':
        return 'This user account has been disabled.';
      case 'user-not-found':
        return 'No user found with this email.';
      case 'wrong-password':
        return 'Incorrect password.';
      case 'invalid-credential':
        return 'Invalid email or password.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      case 'network-request-failed':
        return 'Network error. Please check your connection.';
      default:
        return 'Authentication failed: ${e.message}';
    }
  }
}

