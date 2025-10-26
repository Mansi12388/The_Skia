import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Firebase_Initializer.dart';

// ============ APP COLORS ============
class AppColors {
  static const Color primaryOrange = Color(0xFFF97316);
  static const Color navyBlue = Color(0xFF1E3A8A);
  static const Color darkGrey = Color(0xFF6B7280);
  static const Color lightGrey = Color(0xFFF3F4F6);
  static const Color white = Color(0xFFFFFFFF);
}

// ============ FIREBASE CONFIGURATION ============
// class DefaultFirebaseOptions {
//   static FirebaseOptions get currentPlatform {
//     if (kIsWeb) {
//       return const FirebaseOptions(
//         apiKey: 'AIzaSyDkmtgkymdThtASpBdxmWOGd6l2oyIgK_E',
//         appId: '1:776412307701:android:fe13f2c79d8260293d25bc',
//         messagingSenderId: '776412307701',
//         projectId: 'parivartan-c3238',
//         storageBucket: 'parivartan-c3238.firebasestorage.app',
//       );
//     } else {
//       return const FirebaseOptions(
//         apiKey: 'AIzaSyDkmtgkymdThtASpBdxmWOGd6l2oyIgK_E',
//         appId: '1:776412307701:ios:xxxxxxxxxxxxx',
//         messagingSenderId: '776412307701',
//         projectId: 'parivartan-c3238',
//         storageBucket: 'parivartan-c3238.firebasestorage.app',
//         iosClientId: 'your-ios-client-id',
//         iosBundleId: 'com.example.parivartan',
//       );
//     }
//   }
// }

// ============ DONATION MODEL ============
class DonationModel {
  final String id;
  final String type;
  final String details;
  final double? amount;
  final DateTime date;
  final String name;
  final String email;
  final String phone;
  final String? transactionId;
  final String paymentStatus;
  final String approvalStatus;

  DonationModel({
    required this.id,
    required this.type,
    required this.details,
    this.amount,
    required this.date,
    required this.name,
    required this.email,
    required this.phone,
    this.transactionId,
    this.paymentStatus = 'Completed',
    this.approvalStatus = 'Pending',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'details': details,
      'amount': amount,
      'date': Timestamp.fromDate(date),
      'name': name,
      'email': email,
      'phone': phone,
      'transactionId': transactionId,
      'paymentStatus': paymentStatus,
      'approvalStatus': approvalStatus,
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  factory DonationModel.fromMap(Map<String, dynamic> map) {
    return DonationModel(
      id: map['id'] as String,
      type: map['type'] as String,
      details: map['details'] as String,
      amount: map['amount'] != null ? (map['amount'] as num).toDouble() : null,
      date: (map['date'] as Timestamp).toDate(),
      name: map['name'] as String,
      email: map['email'] as String,
      phone: map['phone'] as String,
      transactionId: map['transactionId'] as String?,
      paymentStatus: (map['paymentStatus'] as String?) ?? 'Completed',
      approvalStatus: (map['approvalStatus'] as String?) ?? 'Pending',
    );
  }

  DonationModel copyWith({
    String? id,
    String? type,
    String? details,
    double? amount,
    DateTime? date,
    String? name,
    String? email,
    String? phone,
    String? transactionId,
    String? paymentStatus,
    String? approvalStatus,
  }) {
    return DonationModel(
      id: id ?? this.id,
      type: type ?? this.type,
      details: details ?? this.details,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      transactionId: transactionId ?? this.transactionId,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      approvalStatus: approvalStatus ?? this.approvalStatus,
    );
  }
}

// ============ FIREBASE CONTROLLER ============
class AdminFirebaseController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference get _donationsCollection =>
      _firestore.collection('Donation');

  Stream<List<DonationModel>> getDonationsStream() {
    debugPrint('👂 Setting up Admin Firestore listener...');
    return _donationsCollection
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) {
          debugPrint(
            '📥 Admin Stream update: ${snapshot.docs.length} documents',
          );

          if (snapshot.docs.isEmpty) {
            debugPrint('⚠️ No documents found in Donation collection');
          }

          return snapshot.docs.map((doc) {
            try {
              final data = doc.data() as Map<String, dynamic>;
              debugPrint('📄 Document ${doc.id}: ${data.keys.toList()}');
              return DonationModel.fromMap(data);
            } catch (e) {
              debugPrint('❌ Error parsing document ${doc.id}: $e');
              rethrow;
            }
          }).toList();
        });
  }

  Future<void> updateDonationStatus(
    String donationId,
    String approvalStatus,
  ) async {
    try {
      debugPrint('🔄 Updating donation $donationId to $approvalStatus');
      await _donationsCollection.doc(donationId).update({
        'approvalStatus': approvalStatus,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      debugPrint('✅ Donation status updated successfully');
    } catch (e) {
      debugPrint('❌ Error updating donation status: $e');
      rethrow;
    }
  }
}

// ============ MAIN APP ============
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    debugPrint('\n🚀🚀🚀 ADMIN APP STARTING 🚀🚀🚀\n');
    debugPrint('========================================');
    debugPrint('FIREBASE INITIALIZATION');
    debugPrint('========================================');
    debugPrint('📦 Platform: ${kIsWeb ? "Web" : "Mobile (Android/iOS)"}');
    debugPrint('📍 Project: parivartan-c3238');

    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    debugPrint('✅ Firebase initialized successfully');

    if (kIsWeb) {
      debugPrint('🌐 Running on Web - default settings applied');
    } else {
      try {
        FirebaseFirestore.instance.settings = const Settings(
          persistenceEnabled: true,
        );
        debugPrint('📱 Mobile persistence enabled');
      } catch (e) {
        debugPrint('⚠️ Could not enable persistence: $e');
      }
    }

    debugPrint('========================================\n');
  } catch (e, stackTrace) {
    debugPrint('\n❌❌❌ FIREBASE INITIALIZATION ERROR ❌❌❌');
    debugPrint('Error: $e');
    debugPrint('Stack trace: $stackTrace');
    debugPrint('========================================\n');
  }

  runApp(const AdminDonationApp());
}

class AdminDonationApp extends StatelessWidget {
  const AdminDonationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NSS Admin Portal',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: AppColors.white,
        textTheme: GoogleFonts.poppinsTextTheme(),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.lightGrey,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: AppColors.primaryOrange,
              width: 2,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
      ),
      home: const AdminDonationPage(),
    );
  }
}

// ============ ADMIN DONATION PAGE ============
class AdminDonationPage extends StatefulWidget {
  const AdminDonationPage({super.key});

  @override
  State<AdminDonationPage> createState() => _AdminDonationPageState();
}

class _AdminDonationPageState extends State<AdminDonationPage> {
  final AdminFirebaseController _firebaseController = AdminFirebaseController();
  final List<DonationModel> _donations = [];
  bool _isLoading = true;
  String _filterStatus = 'All';

  final List<Map<String, dynamic>> _categories = [
    {
      'name': 'Clothes',
      'icon': Icons.checkroom,
      'color': const Color(0xFFF97316),
    },
    {'name': 'Food', 'icon': Icons.fastfood, 'color': const Color(0xFF1E3A8A)},
    {
      'name': 'Money',
      'icon': Icons.attach_money,
      'color': const Color(0xFF10B981),
    },
    {
      'name': 'Electronics',
      'icon': Icons.devices,
      'color': const Color(0xFF8B5CF6),
    },
    {
      'name': 'Stationery',
      'icon': Icons.edit,
      'color': const Color(0xFF06B6D4),
    },
    {
      'name': 'Books',
      'icon': Icons.menu_book,
      'color': const Color(0xFFEC4899),
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadDonations();
  }

  Future<void> _loadDonations() async {
    setState(() => _isLoading = true);

    _firebaseController.getDonationsStream().listen(
      (loadedDonations) {
        if (mounted) {
          setState(() {
            _donations.clear();
            _donations.addAll(loadedDonations);
            _isLoading = false;
          });
          debugPrint('✅ UI updated with ${loadedDonations.length} donations');
        }
      },
      onError: (error) {
        debugPrint('❌ Stream error: $error');
        if (mounted) {
          setState(() => _isLoading = false);
          _showErrorDialog('Error loading donations: $error');
        }
      },
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Row(
          children: [
            Icon(Icons.error_outline, color: Colors.red[400]),
            const SizedBox(width: 12),
            const Text('Error'),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primaryOrange,
            ),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _updateDonationStatus(
    DonationModel donation,
    String status,
  ) async {
    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(color: AppColors.primaryOrange),
        ),
      );

      await _firebaseController.updateDonationStatus(donation.id, status);

      if (mounted) {
        Navigator.pop(context); // Close loading dialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(
                  status == 'Approved' ? Icons.check_circle : Icons.cancel,
                  color: Colors.white,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text('Donation ${status.toLowerCase()} successfully!'),
                ),
              ],
            ),
            backgroundColor: status == 'Approved' ? Colors.green : Colors.red,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 3),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    } catch (e) {
      debugPrint('❌ Error updating status: $e');
      if (mounted) {
        Navigator.of(context, rootNavigator: true).pop();
        _showErrorDialog('Failed to update donation status: $e');
      }
    }
  }

  void _showDonationDetails(DonationModel donation) {
    final category = _categories.firstWhere(
      (c) => c['name'] == donation.type,
      orElse: () => _categories[0],
    );

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: AppColors.white,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: (category['color'] as Color).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    category['icon'] as IconData,
                    color: category['color'] as Color,
                    size: 40,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Donation Details',
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.navyBlue,
                  ),
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.lightGrey,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    children: [
                      _detailRow('ID:', donation.id),
                      const Divider(height: 24),
                      _detailRow('Name:', donation.name),
                      const Divider(height: 24),
                      _detailRow('Email:', donation.email),
                      const Divider(height: 24),
                      _detailRow('Phone:', donation.phone),
                      const Divider(height: 24),
                      _detailRow('Category:', donation.type),
                      const Divider(height: 24),
                      _detailRow('Details:', donation.details),
                      if (donation.amount != null) ...[
                        const Divider(height: 24),
                        _detailRow(
                          'Amount:',
                          '₹${donation.amount!.toStringAsFixed(2)}',
                        ),
                      ],
                      if (donation.transactionId != null) ...[
                        const Divider(height: 24),
                        _detailRow('Transaction ID:', donation.transactionId!),
                      ],
                      const Divider(height: 24),
                      _detailRow('Payment Status:', donation.paymentStatus),
                      const Divider(height: 24),
                      _detailRow('Approval Status:', donation.approvalStatus),
                      const Divider(height: 24),
                      _detailRow(
                        'Date:',
                        DateFormat(
                          'dd MMM yyyy, hh:mm a',
                        ).format(donation.date),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                if (donation.approvalStatus == 'Pending') ...[
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            _updateDonationStatus(donation, 'Rejected');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text('Reject'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            _updateDonationStatus(donation, 'Approved');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text('Accept'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                ] else ...[
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryOrange,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Close'),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              color: AppColors.darkGrey,
              fontSize: 13,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            value,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w500,
              color: AppColors.navyBlue,
              fontSize: 13,
            ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }

  List<DonationModel> get _filteredDonations {
    if (_filterStatus == 'All') {
      return _donations;
    }
    return _donations
        .where((donation) => donation.approvalStatus == _filterStatus)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,

        elevation: 0,
        backgroundColor: AppColors.white,
        // leading: IconButton(
        //   icon: const Icon(Icons.arrow_back, color: Colors.white),
        //   onPressed: () => Navigator.of(context).pop(),
        // ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.navyBlue, Color(0xFF1976D2)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Image.asset(
                  "assets/Nss_Logo.jpg",
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Admin Portal',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Manage Donations',
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      color: Colors.white.withOpacity(0.9),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          _buildFilterChips(),
          Expanded(child: _buildDonationsList()),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.lightGrey,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildFilterChip('All'),
            const SizedBox(width: 8),
            _buildFilterChip('Pending'),
            const SizedBox(width: 8),
            _buildFilterChip('Approved'),
            const SizedBox(width: 8),
            _buildFilterChip('Rejected'),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String status) {
    final isSelected = _filterStatus == status;
    Color chipColor;
    if (status == 'Approved') {
      chipColor = Colors.green;
    } else if (status == 'Rejected') {
      chipColor = Colors.red;
    } else if (status == 'Pending') {
      chipColor = Colors.orange;
    } else {
      chipColor = AppColors.navyBlue;
    }

    return FilterChip(
      label: Text(status),
      selected: isSelected,
      onSelected: (selected) {
        setState(() => _filterStatus = status);
      },
      backgroundColor: AppColors.white,
      selectedColor: chipColor.withOpacity(0.2),
      labelStyle: GoogleFonts.poppins(
        color: isSelected ? chipColor : AppColors.darkGrey,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
      ),
      side: BorderSide(
        color: isSelected ? chipColor : AppColors.lightGrey,
        width: isSelected ? 2 : 1,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    );
  }

  Widget _buildDonationsList() {
    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(color: AppColors.primaryOrange),
      );
    }

    final filteredDonations = _filteredDonations;

    if (filteredDonations.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox, size: 80, color: AppColors.lightGrey),
            const SizedBox(height: 16),
            Text(
              'No donations found',
              style: GoogleFonts.poppins(
                fontSize: 18,
                color: AppColors.darkGrey,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _filterStatus == 'All'
                  ? 'No donations have been submitted yet'
                  : 'No $_filterStatus donations',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: AppColors.darkGrey,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredDonations.length,
      itemBuilder: (context, index) {
        final donation = filteredDonations[index];
        final category = _categories.firstWhere(
          (c) => c['name'] == donation.type,
          orElse: () => _categories[0],
        );

        Color statusColor;
        IconData statusIcon;
        if (donation.approvalStatus == 'Approved') {
          statusColor = Colors.green;
          statusIcon = Icons.check_circle;
        } else if (donation.approvalStatus == 'Rejected') {
          statusColor = Colors.red;
          statusIcon = Icons.cancel;
        } else {
          statusColor = Colors.orange;
          statusIcon = Icons.pending;
        }

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: statusColor.withOpacity(0.3), width: 2),
            boxShadow: [
              BoxShadow(
                color: statusColor.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(15),
              onTap: () => _showDonationDetails(donation),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: (category['color'] as Color).withOpacity(
                              0.1,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            category['icon'] as IconData,
                            color: category['color'] as Color,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                donation.name,
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.navyBlue,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                donation.type,
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  color: AppColors.darkGrey,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(
                                    Icons.calendar_today,
                                    size: 12,
                                    color: AppColors.darkGrey,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    DateFormat(
                                      'dd MMM yyyy',
                                    ).format(donation.date),
                                    style: GoogleFonts.poppins(
                                      fontSize: 11,
                                      color: AppColors.darkGrey,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            if (donation.amount != null)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.green[50],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  '₹${donation.amount!.toStringAsFixed(0)}',
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green[700],
                                  ),
                                ),
                              ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: statusColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    statusIcon,
                                    size: 14,
                                    color: statusColor,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    donation.approvalStatus,
                                    style: GoogleFonts.poppins(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: statusColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.lightGrey,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.email_outlined,
                                      size: 14,
                                      color: AppColors.darkGrey,
                                    ),
                                    const SizedBox(width: 6),
                                    Expanded(
                                      child: Text(
                                        donation.email,
                                        style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          color: AppColors.darkGrey,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.phone_outlined,
                                      size: 14,
                                      color: AppColors.darkGrey,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      donation.phone,
                                      style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        color: AppColors.darkGrey,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (donation.approvalStatus == 'Pending') ...[
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () =>
                                  _updateDonationStatus(donation, 'Rejected'),
                              icon: const Icon(Icons.close, size: 18),
                              label: const Text('Reject'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.red,
                                side: const BorderSide(color: Colors.red),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () =>
                                  _updateDonationStatus(donation, 'Approved'),
                              icon: const Icon(Icons.check, size: 18),
                              label: const Text('Accept'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                elevation: 0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
