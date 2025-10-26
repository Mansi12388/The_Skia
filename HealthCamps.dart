import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'Firebase_Initializer.dart';

class AppColors {
  static const Color primaryOrange = Color(0xFFF97316);
  static const Color navyBlue = Color(0xFF1E3A8A);
  static const Color lightBlue = Color(0xFF1976D2);
  static const Color darkGrey = Color(0xFF6B7280);
  static const Color lightGrey = Color(0xFFF3F4F6);
  static const Color white = Color(0xFFFFFFFF);
  static const Color success = Color(0xFF10B981);
  static const Color error = Color(0xFFEF4444);
}

// ============================================================================
// FIREBASE CONFIGURATION (Updated to parivartan-c3238)
// ============================================================================
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
//         appId: '1:776412307701:android:fe13f2c79d8260293d25bc',
//         messagingSenderId: '776412307701',
//         projectId: 'parivartan-c3238',
//         storageBucket: 'parivartan-c3238.firebasestorage.app',
//       );
//     }
//   }
// }

// MODEL CLASSES
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

  factory FamilyMember.fromMap(Map<String, dynamic> map) {
    return FamilyMember(
      name: map['name'] ?? '',
      mobile: map['mobile'] ?? '',
      age: map['age'] ?? '',
      gender: map['gender'] ?? '',
    );
  }
}

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

  factory CampRegistration.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
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

class UpcomingCamp {
  final String? id;
  final String type;
  final String date;
  final String time;
  final String venue;
  final List<String> services;
  final String imagePath;

  UpcomingCamp({
    this.id,
    required this.type,
    required this.date,
    required this.time,
    required this.venue,
    required this.services,
    required this.imagePath,
  });

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'date': date,
      'time': time,
      'venue': venue,
      'services': services,
      'imagePath': imagePath,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }

  factory UpcomingCamp.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UpcomingCamp(
      id: doc.id,
      type: data['type'] ?? '',
      date: data['date'] ?? '',
      time: data['time'] ?? '',
      venue: data['venue'] ?? '',
      services: List<String>.from(data['services'] ?? []),
      imagePath: data['imagePath'] ?? '',
    );
  }
}

// MAIN ENTRY POINT
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
//   runApp(const HealthCampAddPage());
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const HealthCampAddPage());
}

// MAIN APP
class HealthCampAddPage extends StatelessWidget {
  const HealthCampAddPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NSS Admin Dashboard',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppColors.navyBlue,
        scaffoldBackgroundColor: AppColors.white,
        textTheme: GoogleFonts.poppinsTextTheme(),
        useMaterial3: true,
      ),
      home: const AdminDashboard(),
    );
  }
}

// ADMIN DASHBOARD
class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
              colors: [AppColors.navyBlue, AppColors.lightBlue],
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
                //color: Colors.white,
                borderRadius: BorderRadius.circular(23),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(23),
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
                    'Admin Dashboard',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'NSS Health Camp Management',
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
          // _buildStatsCards(),
          _buildTabBar(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [ManageCampsTab(), ViewRegistrationsTab()],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.lightGrey,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: const LinearGradient(
            colors: [AppColors.navyBlue, AppColors.lightBlue],
          ),
        ),
        labelColor: Colors.white,
        unselectedLabelColor: AppColors.darkGrey,
        labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        tabs: const [
          Tab(text: 'Manage Camps'),
          Tab(text: 'Registrations'),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color, color.withOpacity(0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.w900,
            ),
          ),
          Text(
            title,
            style: GoogleFonts.poppins(
              color: Colors.white.withOpacity(0.9),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// MANAGE CAMPS TAB
// ============================================================================
class ManageCampsTab extends StatelessWidget {
  const ManageCampsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Upcoming Health Camps',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: AppColors.navyBlue,
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () => _showAddCampDialog(context),
                  icon: const Icon(Icons.add_rounded, size: 20),
                  label: Text(
                    'Add Camp',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w700),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryOrange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('upcoming_camps')
                  .orderBy('createdAt', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primaryOrange,
                    ),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64,
                          color: AppColors.error.withOpacity(0.5),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Error loading camps',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: AppColors.darkGrey,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(32),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppColors.primaryOrange.withOpacity(0.1),
                                AppColors.navyBlue.withOpacity(0.1),
                              ],
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.event_busy_rounded,
                            size: 80,
                            color: AppColors.primaryOrange,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'No Camps Added Yet',
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            color: AppColors.navyBlue,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Add your first health camp',
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
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final doc = snapshot.data!.docs[index];
                    final camp = UpcomingCamp.fromFirestore(doc);
                    return CampManagementCard(camp: camp);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showAddCampDialog(BuildContext context) {
    final typeController = TextEditingController();
    final dateController = TextEditingController();
    final timeController = TextEditingController();
    final venueController = TextEditingController();
    final imagePathController = TextEditingController(
      text: 'lib/assets/health.jpg',
    );
    final servicesController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          bool isSubmitting = false;

          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(28),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              // gradient: const LinearGradient(
                              //   colors: [
                              //     AppColors.primaryOrange,
                              //     AppColors.navyBlue,
                              //   ],
                              // ),
                              color: AppColors.navyBlue,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: const Icon(
                              Icons.add_circle_rounded,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              'Add New Camp',
                              style: GoogleFonts.poppins(
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                                color: AppColors.navyBlue,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.close_rounded),
                            color: AppColors.darkGrey,
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      _buildTextField(
                        typeController,
                        'Camp Type',
                        Icons.medical_services_rounded,
                        'e.g., Health Camp, Dental Camp',
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        dateController,
                        'Date',
                        Icons.calendar_today_rounded,
                        'e.g., 15th November 2024',
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        timeController,
                        'Time',
                        Icons.access_time_rounded,
                        'e.g., 9:00 AM - 4:00 PM',
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        venueController,
                        'Venue',
                        Icons.location_on_rounded,
                        'e.g., Village Community Hall',
                      ),
                      // const SizedBox(height: 16),
                      // _buildTextField(
                      //   imagePathController,
                      //   'Image Path',
                      //   Icons.image_rounded,
                      //   'lib/assets/health.jpg',
                      // ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        servicesController,
                        'Services (comma separated)',
                        Icons.medical_information_rounded,
                        'e.g., General Check-up, BP',
                        maxLines: 3,
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: isSubmitting
                              ? null
                              : () async {
                                  if (formKey.currentState!.validate()) {
                                    setState(() => isSubmitting = true);

                                    final services = servicesController.text
                                        .split(',')
                                        .map((s) => s.trim())
                                        .where((s) => s.isNotEmpty)
                                        .toList();

                                    final campData = {
                                      'type': typeController.text,
                                      'date': dateController.text,
                                      'time': timeController.text,
                                      'venue': venueController.text,
                                      'imagePath': imagePathController.text,
                                      'services': services,
                                      'createdAt': FieldValue.serverTimestamp(),
                                    };

                                    try {
                                      await FirebaseFirestore.instance
                                          .collection('upcoming_camps')
                                          .add(campData);

                                      if (context.mounted) {
                                        Navigator.pop(context);
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Row(
                                              children: [
                                                const Icon(
                                                  Icons.check_circle_rounded,
                                                  color: Colors.white,
                                                ),
                                                const SizedBox(width: 12),
                                                Text(
                                                  'Camp added successfully!',
                                                  style: GoogleFonts.poppins(),
                                                ),
                                              ],
                                            ),
                                            backgroundColor: AppColors.success,
                                            behavior: SnackBarBehavior.floating,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                          ),
                                        );
                                      }
                                    } catch (e) {
                                      setState(() => isSubmitting = false);
                                      if (context.mounted) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              'Error: ${e.toString()}',
                                              style: GoogleFonts.poppins(),
                                            ),
                                            backgroundColor: AppColors.error,
                                          ),
                                        );
                                      }
                                    }
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isSubmitting
                                ? Colors.grey
                                : AppColors.primaryOrange,
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                          child: isSubmitting
                              ? const SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(
                                  'Add Camp',
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon,
    String hint, {
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      style: GoogleFonts.poppins(),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: GoogleFonts.poppins(color: AppColors.darkGrey),
        prefixIcon: Icon(icon, color: AppColors.primaryOrange),
        filled: true,
        fillColor: AppColors.lightGrey,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            color: AppColors.primaryOrange,
            width: 2,
          ),
        ),
      ),
      validator: (value) =>
          value?.isEmpty ?? true ? 'This field is required' : null,
    );
  }
}

class CampManagementCard extends StatelessWidget {
  final UpcomingCamp camp;

  const CampManagementCard({super.key, required this.camp});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: AppColors.primaryOrange.withOpacity(0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryOrange.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primaryOrange.withOpacity(0.1),
                  AppColors.navyBlue.withOpacity(0.1),
                ],
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(23),
                topRight: Radius.circular(23),
              ),
            ),
            child: Row(
              children: [
                // Container(
                //   padding: const EdgeInsets.all(14),
                //   decoration: BoxDecoration(
                //     gradient: const LinearGradient(
                //       colors: [AppColors.primaryOrange, AppColors.navyBlue],
                //     ),
                //     borderRadius: BorderRadius.circular(15),
                //   ),
                //   child: const Icon(
                //     Icons.medical_services_rounded,
                //     color: Colors.white,
                //     size: 28,
                //   ),
                // ),
                // const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        camp.type,
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: AppColors.navyBlue,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_today_rounded,
                            size: 14,
                            color: AppColors.darkGrey,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            camp.date,
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: AppColors.darkGrey,
                              fontWeight: FontWeight.w600,
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
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.access_time_rounded,
                      size: 18,
                      color: AppColors.primaryOrange,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      camp.time,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.navyBlue,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_rounded,
                      size: 18,
                      color: AppColors.navyBlue,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        camp.venue,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.navyBlue,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'Services',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.navyBlue,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: camp.services.map((service) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryOrange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: AppColors.primaryOrange.withOpacity(0.3),
                        ),
                      ),
                      child: Text(
                        service,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryOrange,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _showEditDialog(context, camp),
                        icon: const Icon(Icons.edit_rounded, size: 18),
                        label: Text('Edit', style: GoogleFonts.poppins()),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.primaryOrange,
                          side: const BorderSide(
                            color: AppColors.primaryOrange,
                            width: 2,
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _showDeleteDialog(context, camp.id!),
                        icon: const Icon(Icons.delete_rounded, size: 18),
                        label: Text('Delete', style: GoogleFonts.poppins()),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.error,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context, UpcomingCamp camp) {
    final typeController = TextEditingController(text: camp.type);
    final dateController = TextEditingController(text: camp.date);
    final timeController = TextEditingController(text: camp.time);
    final venueController = TextEditingController(text: camp.venue);
    final imagePathController = TextEditingController(text: camp.imagePath);
    final servicesController = TextEditingController(
      text: camp.services.join(', '),
    );
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(28),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          // gradient: const LinearGradient(
                          //   // colors: [
                          //   //   AppColors.primaryOrange,
                          //   //   AppColors.navyBlue,
                          //   // ],
                          // ),
                          color: AppColors.navyBlue,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: const Icon(
                          Icons.edit_rounded,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          'Edit Camp',
                          style: GoogleFonts.poppins(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            color: AppColors.navyBlue,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close_rounded),
                        color: AppColors.darkGrey,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _buildEditTextField(
                    typeController,
                    'Camp Type',
                    Icons.medical_services_rounded,
                  ),
                  const SizedBox(height: 16),
                  _buildEditTextField(
                    dateController,
                    'Date',
                    Icons.calendar_today_rounded,
                  ),
                  const SizedBox(height: 16),
                  _buildEditTextField(
                    timeController,
                    'Time',
                    Icons.access_time_rounded,
                  ),
                  const SizedBox(height: 16),
                  _buildEditTextField(
                    venueController,
                    'Venue',
                    Icons.location_on_rounded,
                  ),
                  const SizedBox(height: 16),
                  _buildEditTextField(
                    imagePathController,
                    'Image Path',
                    Icons.image_rounded,
                  ),
                  const SizedBox(height: 16),
                  _buildEditTextField(
                    servicesController,
                    'Services (comma separated)',
                    Icons.medical_information_rounded,
                    maxLines: 3,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          final services = servicesController.text
                              .split(',')
                              .map((s) => s.trim())
                              .where((s) => s.isNotEmpty)
                              .toList();
                          try {
                            await FirebaseFirestore.instance
                                .collection('upcoming_camps')
                                .doc(camp.id)
                                .update({
                                  'type': typeController.text,
                                  'date': dateController.text,
                                  'time': timeController.text,
                                  'venue': venueController.text,
                                  'imagePath': imagePathController.text,
                                  'services': services,
                                });
                            if (context.mounted) {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Row(
                                    children: [
                                      const Icon(
                                        Icons.check_circle_rounded,
                                        color: Colors.white,
                                      ),
                                      const SizedBox(width: 12),
                                      Text(
                                        'Camp updated successfully!',
                                        style: GoogleFonts.poppins(),
                                      ),
                                    ],
                                  ),
                                  backgroundColor: AppColors.success,
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              );
                            }
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Error: ${e.toString()}',
                                    style: GoogleFonts.poppins(),
                                  ),
                                  backgroundColor: AppColors.error,
                                ),
                              );
                            }
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryOrange,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      child: Text(
                        'Update Camp',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEditTextField(
    TextEditingController controller,
    String label,
    IconData icon, {
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      style: GoogleFonts.poppins(),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.poppins(color: AppColors.darkGrey),
        prefixIcon: Icon(icon, color: AppColors.primaryOrange),
        filled: true,
        fillColor: AppColors.lightGrey,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            color: AppColors.primaryOrange,
            width: 2,
          ),
        ),
      ),
      validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
    );
  }

  void _showDeleteDialog(BuildContext context, String campId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        title: Row(
          children: [
            const Icon(Icons.warning_rounded, color: AppColors.error, size: 28),
            const SizedBox(width: 12),
            Text(
              'Delete Camp',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w700,
                fontSize: 20,
              ),
            ),
          ],
        ),
        content: Text(
          'Are you sure you want to delete this camp? This action cannot be undone.',
          style: GoogleFonts.poppins(fontSize: 15, height: 1.5),
        ),
        actions: [
          OutlinedButton(
            onPressed: () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.darkGrey,
              side: BorderSide(color: AppColors.darkGrey.withOpacity(0.3)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: Text('Cancel', style: GoogleFonts.poppins()),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                await FirebaseFirestore.instance
                    .collection('upcoming_camps')
                    .doc(campId)
                    .delete();
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        children: [
                          const Icon(
                            Icons.check_circle_rounded,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Camp deleted successfully!',
                            style: GoogleFonts.poppins(),
                          ),
                        ],
                      ),
                      backgroundColor: AppColors.success,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Error: ${e.toString()}',
                        style: GoogleFonts.poppins(),
                      ),
                      backgroundColor: AppColors.error,
                    ),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: Text(
              'Delete',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// VIEW REGISTRATIONS TAB
// ============================================================================
class ViewRegistrationsTab extends StatelessWidget {
  const ViewRegistrationsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'All Registrations',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: AppColors.navyBlue,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.primaryOrange, AppColors.navyBlue],
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('registrations')
                        .snapshots(),
                    builder: (context, snapshot) {
                      int count = snapshot.data?.docs.length ?? 0;
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.list_alt_rounded,
                            color: Colors.white,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '$count Total',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('registrations')
                  .orderBy('registrationDate', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primaryOrange,
                    ),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64,
                          color: AppColors.error.withOpacity(0.5),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Error loading registrations',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: AppColors.darkGrey,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(32),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppColors.primaryOrange.withOpacity(0.1),
                                AppColors.navyBlue.withOpacity(0.1),
                              ],
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.assignment_outlined,
                            size: 80,
                            color: AppColors.primaryOrange,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'No Registrations Yet',
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            color: AppColors.navyBlue,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Registrations will appear here',
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
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final doc = snapshot.data!.docs[index];
                    final registration = CampRegistration.fromFirestore(doc);
                    return AdminRegistrationCard(registration: registration);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class AdminRegistrationCard extends StatefulWidget {
  final CampRegistration registration;

  const AdminRegistrationCard({super.key, required this.registration});

  @override
  State<AdminRegistrationCard> createState() => _AdminRegistrationCardState();
}

class _AdminRegistrationCardState extends State<AdminRegistrationCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final dateStr = widget.registration.registrationDate != null
        ? DateFormat(
            'MMM dd, yyyy • hh:mm a',
          ).format(widget.registration.registrationDate!)
        : 'Unknown date';

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: AppColors.primaryOrange.withOpacity(0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryOrange.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primaryOrange.withOpacity(0.1),
                  AppColors.navyBlue.withOpacity(0.1),
                ],
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(23),
                topRight: Radius.circular(23),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.primaryOrange, AppColors.navyBlue],
                    ),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryOrange.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.medical_services_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.registration.campType,
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: AppColors.navyBlue,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            Icons.people_rounded,
                            size: 14,
                            color: AppColors.darkGrey,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '${widget.registration.memberCount} Member(s)',
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: AppColors.darkGrey,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: widget.registration.status == 'Confirmed'
                        ? AppColors.success
                        : AppColors.primaryOrange,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        widget.registration.status == 'Confirmed'
                            ? Icons.check_circle_rounded
                            : Icons.schedule_rounded,
                        color: Colors.white,
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        widget.registration.status,
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.lightGrey,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: AppColors.primaryOrange.withOpacity(0.2),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.access_time_rounded,
                        size: 20,
                        color: AppColors.primaryOrange,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          dateStr,
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.navyBlue,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Registered Members',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.navyBlue,
                      ),
                    ),
                    IconButton(
                      onPressed: () =>
                          setState(() => _isExpanded = !_isExpanded),
                      style: IconButton.styleFrom(
                        backgroundColor: AppColors.primaryOrange.withOpacity(
                          0.1,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: AnimatedRotation(
                        turns: _isExpanded ? 0.5 : 0,
                        duration: const Duration(milliseconds: 300),
                        child: const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: AppColors.primaryOrange,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                AnimatedSize(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  child: Column(
                    children: _isExpanded
                        ? _buildExpandedMembersList()
                        : _buildCollapsedMembersList(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildExpandedMembersList() {
    return widget.registration.members.asMap().entries.map((entry) {
      final idx = entry.key;
      final member = entry.value;
      return Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.primaryOrange.withOpacity(0.05),
              AppColors.navyBlue.withOpacity(0.05),
            ],
          ),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: AppColors.primaryOrange.withOpacity(0.2),
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primaryOrange, AppColors.navyBlue],
                ),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '${idx + 1}',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    member.name,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                      color: AppColors.navyBlue,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primaryOrange.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${member.age} yrs',
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryOrange,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.navyBlue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          member.gender,
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppColors.navyBlue,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(
                        Icons.phone_rounded,
                        size: 14,
                        color: AppColors.primaryOrange,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        member.mobile,
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: AppColors.darkGrey,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  List<Widget> _buildCollapsedMembersList() {
    if (widget.registration.members.isEmpty) {
      return [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.primaryOrange.withOpacity(0.05),
                AppColors.navyBlue.withOpacity(0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: AppColors.primaryOrange.withOpacity(0.2),
              width: 1.5,
            ),
          ),
          child: Text(
            'No members',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w700,
              fontSize: 15,
              color: AppColors.navyBlue,
            ),
          ),
        ),
      ];
    }

    return [
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.primaryOrange.withOpacity(0.05),
              AppColors.navyBlue.withOpacity(0.05),
            ],
          ),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: AppColors.primaryOrange.withOpacity(0.2),
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primaryOrange, AppColors.navyBlue],
                ),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '1',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                widget.registration.members[0].name,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                  color: AppColors.navyBlue,
                ),
              ),
            ),
            if (widget.registration.memberCount > 1)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primaryOrange, AppColors.navyBlue],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryOrange.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Text(
                  '+${widget.registration.memberCount - 1} more',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
          ],
        ),
      ),
    ];
  }
}
