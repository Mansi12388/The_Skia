import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'Firebase_Initializer.dart';

// Main function to initialize Firebase
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const FetchRequirements());
}

// Firebase options configuration
// FirebaseOptions _getFirebaseOptions() {
//   if (kIsWeb) {
//     return const FirebaseOptions(
//       apiKey: 'AIzaSyDkmtgkymdThtASpBdxmWOGd6l2oyIgK_E',
//       appId: '1:776412307701:android:fe13f2c79d8260293d25bc',
//       messagingSenderId: '776412307701',
//       projectId: 'parivartan-c3238',
//       storageBucket: 'parivartan-c3238.firebasestorage.app',
//     );
//   } else {
//     return const FirebaseOptions(
//       apiKey: 'AIzaSyDkmtgkymdThtASpBdxmWOGd6l2oyIgK_E',
//       appId: '1:776412307701:ios:xxxxxxxxxxxxx',
//       messagingSenderId: '776412307701',
//       projectId: 'parivartan-c3238',
//       storageBucket: 'parivartan-c3238.firebasestorage.app',
//       iosClientId: 'your-ios-client-id',
//       iosBundleId: 'com.example.parivartan',
//     );
//   }
// }

// Main App Widget
class FetchRequirements extends StatelessWidget {
  const FetchRequirements({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NSS Requirements',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const AllRequirementsPage(languageCode: 'en'),
    );
  }
}

// AppColors class
class AppColors {
  static const Color navyBlue = Color(0xFF1E3A8A);
  static const Color primaryOrange = Color(0xFFF97316);
  static const Color white = Colors.white;
  static const Color lightGrey = Color(0xFFF3F4F6);
  static const Color darkGrey = Color(0xFF6B7280);
}

// All Requirements Page
class AllRequirementsPage extends StatefulWidget {
  final String languageCode;

  const AllRequirementsPage({Key? key, required this.languageCode})
    : super(key: key);

  @override
  State<AllRequirementsPage> createState() => _AllRequirementsPageState();
}

class _AllRequirementsPageState extends State<AllRequirementsPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<RequirementModel> requirementsList = [];
  bool isLoading = false;
  String searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadRequirementsFromFirebase();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Fetch all requirements from Firebase
  Future<void> _loadRequirementsFromFirebase() async {
    setState(() {
      isLoading = true;
    });

    try {
      QuerySnapshot snapshot = await _firestore
          .collection("requirements")
          .orderBy('timestamp', descending: true)
          .get();

      requirementsList.clear();
      for (var doc in snapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        requirementsList.add(
          RequirementModel(
            id: doc.id,
            name: data['name'] ?? '',
            phone: data['phone'] ?? '',
            email: data['email'] ?? '',
            village: data['village'] ?? '',
            address: data['address'] ?? '',
            category: data['category'] ?? '',
            description: data['description'] ?? '',
            urgency: data['urgency'] ?? 'medium',
            status: data['status'] ?? 'pending',
            timestamp: (data['timestamp'] as Timestamp).toDate(),
          ),
        );
      }
    } catch (e) {
      _showSnackBar('Error loading data: $e', isError: true);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Accept/Update status of requirement
  Future<void> _acceptRequirement(
    String requirementId,
    String currentStatus,
  ) async {
    String newStatus;
    if (currentStatus == 'pending') {
      newStatus = 'in-progress';
    } else if (currentStatus == 'in-progress') {
      newStatus = 'resolved';
    } else {
      _showSnackBar('Requirement already resolved', isError: false);
      return;
    }

    try {
      await _firestore.collection('requirements').doc(requirementId).update({
        'status': newStatus,
      });
      _showSnackBar(
        'Status updated to ${_getStatusText(newStatus)}',
        isError: false,
      );
      _loadRequirementsFromFirebase();
    } catch (e) {
      _showSnackBar('Error updating status: $e', isError: true);
    }
  }

  void _showSnackBar(String message, {required bool isError}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isError ? Icons.error_outline : Icons.check_circle_outline,
              color: Colors.white,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(message, style: const TextStyle(fontSize: 15)),
            ),
          ],
        ),
        backgroundColor: isError ? Colors.red[600] : Colors.green[600],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  List<RequirementModel> get filteredRequirements {
    if (searchQuery.isEmpty) {
      return requirementsList;
    }
    return requirementsList.where((req) {
      return req.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
          req.village.toLowerCase().contains(searchQuery.toLowerCase()) ||
          req.category.toLowerCase().contains(searchQuery.toLowerCase()) ||
          req.description.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryOrange,
      body: Column(
        children: [
          _buildHeader(),
          _buildSearchBar(),
          Expanded(child: _buildRequirementsList()),
        ],
      ),
    );
  }

  // Header with NSS logo and gradient background
  Widget _buildHeader() {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.navyBlue, Color(0xFF1976D2)],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.navyBlue.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
          child: Row(
            children: [
              // Back button
              // IconButton(
              //   icon: const Icon(
              //     Icons.arrow_back,
              //     color: Colors.white,
              //     size: 24,
              //   ),
              //   //onPressed: () =>
              //   Navigator.of(context).pop(),
              //   tooltip: 'Back',
              // ),
              const SizedBox(width: 8),
              // NSS Logo
              ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: Container(
                  width: 50,
                  height: 50,
                  color: Colors.white,
                  child: Image.asset(
                    "assets/Nss_Logo.jpg",
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.image_not_supported,
                        color: AppColors.navyBlue,
                        size: 30,
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Title
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'All Requirements',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 0.3,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'SPPU University',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white70,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ],
                ),
              ),
              // Refresh button
              IconButton(
                icon: const Icon(Icons.refresh, color: Colors.white, size: 24),
                onPressed: _loadRequirementsFromFirebase,
                tooltip: 'Refresh',
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Search bar
  Widget _buildSearchBar() {
    return Container(
      color: AppColors.lightGrey,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: TextField(
        controller: _searchController,
        onChanged: (value) {
          setState(() {
            searchQuery = value;
          });
        },
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: 'Search by name, village, category...',
          hintStyle: TextStyle(color: AppColors.navyBlue),
          prefixIcon: const Icon(Icons.search, color: AppColors.navyBlue),
          suffixIcon: searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, color: AppColors.navyBlue),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      searchQuery = '';
                    });
                  },
                )
              : null,
          filled: true,
          fillColor: Colors.white.withOpacity(0.2),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
        ),
      ),
    );
  }

  // Build requirements list
  Widget _buildRequirementsList() {
    final filtered = filteredRequirements;

    return Container(
      decoration: const BoxDecoration(color: AppColors.lightGrey),
      child: RefreshIndicator(
        onRefresh: _loadRequirementsFromFirebase,
        color: AppColors.navyBlue,
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: AppColors.white,
                  strokeWidth: 3,
                ),
              )
            : filtered.isEmpty
            ? _buildEmptyState()
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: filtered.length,
                itemBuilder: (context, index) {
                  return _buildRequirementCard(filtered[index]);
                },
              ),
      ),
    );
  }

  // Empty state widget
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            searchQuery.isEmpty ? Icons.inbox_outlined : Icons.search_off,
            size: 80,
            color: Colors.white.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            searchQuery.isEmpty ? 'No requirements yet' : 'No results found',
            style: TextStyle(
              fontSize: 18,
              color: Colors.white.withOpacity(0.8),
              fontWeight: FontWeight.w500,
            ),
          ),
          if (searchQuery.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              'Try different search terms',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withOpacity(0.6),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // Build individual requirement card
  Widget _buildRequirementCard(RequirementModel requirement) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category and Status Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.primaryOrange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        _getCategoryIcon(requirement.category),
                        color: AppColors.primaryOrange,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      requirement.category,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: AppColors.navyBlue,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(
                      requirement.status,
                    ).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: _getStatusColor(requirement.status),
                      width: 1.5,
                    ),
                  ),
                  child: Text(
                    _getStatusText(requirement.status),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: _getStatusColor(requirement.status),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Description
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.lightGrey,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                requirement.description,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[800],
                  height: 1.5,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 12),

            // Name and Phone
            Row(
              children: [
                Icon(
                  Icons.person_outline,
                  size: 16,
                  color: AppColors.primaryOrange,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    requirement.name,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Icon(
                  Icons.phone_outlined,
                  size: 16,
                  color: AppColors.primaryOrange,
                ),
                const SizedBox(width: 4),
                Text(
                  requirement.phone,
                  style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Village and Date
            Row(
              children: [
                Icon(
                  Icons.location_on_outlined,
                  size: 16,
                  color: AppColors.primaryOrange,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    requirement.village,
                    style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                  ),
                ),
                const SizedBox(width: 12),
                Icon(
                  Icons.calendar_today_outlined,
                  size: 16,
                  color: AppColors.primaryOrange,
                ),
                const SizedBox(width: 4),
                Text(
                  DateFormat('dd MMM yyyy').format(requirement.timestamp),
                  style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Address
            if (requirement.address.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.home_outlined,
                      size: 16,
                      color: AppColors.darkGrey,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        requirement.address,
                        style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),

            if (requirement.address.isNotEmpty) const SizedBox(height: 12),

            // Urgency Badge and Accept Button Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Urgency Badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _getUrgencyColor(
                      requirement.urgency,
                    ).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: _getUrgencyColor(requirement.urgency),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.priority_high,
                        size: 16,
                        color: _getUrgencyColor(requirement.urgency),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${requirement.urgency.toUpperCase()} Priority',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: _getUrgencyColor(requirement.urgency),
                        ),
                      ),
                    ],
                  ),
                ),

                // Accept Button
                ElevatedButton.icon(
                  onPressed: requirement.status == 'resolved'
                      ? null
                      : () => _acceptRequirement(
                          requirement.id,
                          requirement.status,
                        ),
                  icon: Icon(
                    requirement.status == 'resolved'
                        ? Icons.check_circle
                        : requirement.status == 'in-progress'
                        ? Icons.done_all
                        : Icons.check,
                    size: 18,
                  ),
                  label: Text(
                    requirement.status == 'resolved'
                        ? 'Completed'
                        : requirement.status == 'in-progress'
                        ? 'Complete'
                        : 'Accept',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: requirement.status == 'resolved'
                        ? Colors.grey[400]
                        : requirement.status == 'in-progress'
                        ? Colors.green[600]
                        : AppColors.navyBlue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 2,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Helper methods
  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'water':
        return Icons.water_drop;
      case 'health':
        return Icons.local_hospital;
      case 'education':
        return Icons.school;
      case 'environment':
        return Icons.eco;
      case 'sanitation':
        return Icons.cleaning_services;
      case 'infrastructure':
        return Icons.construction;
      case 'other':
        return Icons.more_horiz;
      default:
        return Icons.help_outline;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'pending':
        return 'Pending';
      case 'in-progress':
        return 'In Progress';
      case 'resolved':
        return 'Resolved';
      default:
        return status;
    }
  }

  Color _getUrgencyColor(String urgency) {
    switch (urgency) {
      case 'high':
        return Colors.red[600]!;
      case 'medium':
        return Colors.orange[600]!;
      case 'low':
        return Colors.green[600]!;
      default:
        return Colors.grey[600]!;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.orange[700]!;
      case 'in-progress':
        return const Color(0xFF1976D2);
      case 'resolved':
        return Colors.green[700]!;
      default:
        return Colors.grey[700]!;
    }
  }
}

// Model class for Requirement
class RequirementModel {
  final String id;
  final String name;
  final String phone;
  final String email;
  final String village;
  final String address;
  final String category;
  final String description;
  final String urgency;
  final String status;
  final DateTime timestamp;

  RequirementModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.village,
    required this.address,
    required this.category,
    required this.description,
    required this.urgency,
    required this.status,
    required this.timestamp,
  });
}
