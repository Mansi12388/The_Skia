import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

// Color Constants (matching SignUpPage)
class AppColors {
  static const Color navyBlue = Color(0xFF1A3A52);
  static const Color primaryOrange = Color(0xFFF97316);
  static const Color successGreen = Color(0xFF10B981);
  static const Color darkGrey = Color(0xFF6B7280);
  static const Color lightGrey = Color(0xFFF3F4F6);
  static const Color white = Color(0xFFFFFFFF);

  static Color? error;

  static get lightBlue => null;

  static Color? get textDark => null;
}

// Web detection constant
const bool kIsWeb = bool.fromEnvironment('dart.library.html');

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    if (kIsWeb) {
      await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: "AIzaSyDkEGryfJouqLI3PYOI3PGEJtslJZ5kcNY",
          appId: "1:994090021321:web:37937c4ad50ea891edf818",
          messagingSenderId: "994090021321",
          projectId: "project1-219ef",
          authDomain: "project1-219ef.firebaseapp.com",
          storageBucket: "project1-219ef.appspot.com",
        ),
      );
    } else {
      await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: "AIzaSyDkEGryfJouqLI3PYOI3PGEJtslJZ5kcNY",
          appId: "1:994090021321:android:37937c4ad50ea891edf818",
          messagingSenderId: "994090021321",
          projectId: "project1-219ef",
        ),
      );
    }

    FirebaseFirestore.instance.settings = const Settings(
      persistenceEnabled: true,
      cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
    );
  } catch (e) {
    print("Firebase initialization error: $e");
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NSS Management',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppColors.primaryOrange,
        scaffoldBackgroundColor: AppColors.white,
        useMaterial3: true,
        colorScheme: ColorScheme.light(
          primary: AppColors.primaryOrange,
          secondary: AppColors.primaryOrange,
          surface: AppColors.white,
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
            borderSide: BorderSide(color: AppColors.lightGrey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.primaryOrange, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.red.shade300),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.red.shade400, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryOrange,
            foregroundColor: AppColors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 0,
          ),
        ),
      ),
      home: const AdminPanelPage(),
    );
  }
}

// ===== ADMIN PANEL PAGE FOR GOVERNMENT SCHEMES =====
class AdminPanelPage extends StatefulWidget {
  const AdminPanelPage({Key? key}) : super(key: key);

  @override
  State<AdminPanelPage> createState() => _AdminPanelPageState();
}

class _AdminPanelPageState extends State<AdminPanelPage> {
  final _formKey = GlobalKey<FormState>();
  late FirebaseFirestore _firestore;

  final _schemeIdController = TextEditingController();
  final _nameController = TextEditingController();
  final _applicationLinkController = TextEditingController();
  final _benefitsController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _eligibilityController = TextEditingController();
  final _countryController = TextEditingController(text: 'India');
  final _stateController = TextEditingController(text: 'All');
  final _districtController = TextEditingController(text: 'All');
  final _ministryController = TextEditingController();

  DateTime? _startDate;
  DateTime? _endDate;
  String _status = 'active';
  bool _isSubmitting = false;
  int _currentView = 0;
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;

  @override
  void initState() {
    super.initState();
    _firestore = FirebaseFirestore.instance;
  }

  @override
  void dispose() {
    _schemeIdController.dispose();
    _nameController.dispose();
    _applicationLinkController.dispose();
    _benefitsController.dispose();
    _descriptionController.dispose();
    _eligibilityController.dispose();
    _countryController.dispose();
    _stateController.dispose();
    _districtController.dispose();
    _ministryController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primaryOrange,
              onPrimary: AppColors.white,
              surface: AppColors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  Future<void> _submitScheme() async {
    // Enable real-time validation after first submit attempt
    setState(() => _autovalidateMode = AutovalidateMode.onUserInteraction);

    if (!_formKey.currentState!.validate()) {
      _showSnackBar(
        'Please fill all required fields',
        Colors.orange,
        Icons.warning,
      );
      return;
    }

    if (_startDate == null || _endDate == null) {
      _showSnackBar(
        'Please select both start and end dates',
        Colors.orange,
        Icons.calendar_today,
      );
      return;
    }

    // Hide keyboard
    FocusScope.of(context).unfocus();

    setState(() => _isSubmitting = true);

    try {
      final schemeData = {
        'scheme_id': _schemeIdController.text.trim(),
        'name': _nameController.text.trim(),
        'application_link': _applicationLinkController.text.trim(),
        'benefits': _benefitsController.text.trim(),
        'description': _descriptionController.text.trim(),
        'eligibility': _eligibilityController.text.trim(),
        'geography': {
          'country': _countryController.text.trim(),
          'state': _stateController.text.trim(),
          'district': _districtController.text.trim(),
        },
        'ministry': _ministryController.text.trim(),
        'start_date': DateFormat('yyyy-MM-dd').format(_startDate!),
        'end_date': DateFormat('yyyy-MM-dd').format(_endDate!),
        'status': _status,
        'created_at': FieldValue.serverTimestamp(),
        'updated_at': FieldValue.serverTimestamp(),
      };

      await _firestore
          .collection('government_schemes')
          .add(schemeData)
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () {
              throw Exception('Request timeout. Please check your connection.');
            },
          );

      if (mounted) {
        _showSnackBar(
          'Scheme added successfully!',
          AppColors.successGreen,
          Icons.check_circle,
        );
        _clearForm();
        // Small delay to show success message
        await Future.delayed(const Duration(milliseconds: 800));
        if (mounted) {
          setState(() => _currentView = 1);
        }
      }
    } on FirebaseException catch (e) {
      String errorMessage;
      if (e.code == 'permission-denied') {
        errorMessage =
            'Permission denied. Please update Firestore security rules.';
      } else if (e.code == 'unavailable') {
        errorMessage = 'Network error. Please check your internet connection.';
      } else {
        errorMessage = 'Firebase Error: ${e.code}';
      }

      if (mounted) {
        _showSnackBar(errorMessage, Colors.red, Icons.error);
      }
    } catch (e) {
      if (mounted) {
        _showSnackBar('Error: ${e.toString()}', Colors.red, Icons.error);
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  void _showSnackBar(String message, Color color, IconData icon) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: AppColors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(color: AppColors.white),
              ),
            ),
          ],
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: Duration(seconds: message.length > 100 ? 10 : 4),
        action: color == Colors.red
            ? SnackBarAction(
                label: 'Dismiss',
                textColor: Colors.white,
                onPressed: () {},
              )
            : null,
      ),
    );
  }

  void _clearForm() {
    _schemeIdController.clear();
    _nameController.clear();
    _applicationLinkController.clear();
    _benefitsController.clear();
    _descriptionController.clear();
    _eligibilityController.clear();
    _countryController.text = 'India';
    _stateController.text = 'All';
    _districtController.text = 'All';
    _ministryController.clear();
    setState(() {
      _startDate = null;
      _endDate = null;
      _status = 'active';
      _autovalidateMode = AutovalidateMode.disabled;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: PreferredSize(
      //   preferredSize: const Size.fromHeight(80),
      //   child: Container(
      //     decoration: const BoxDecoration(
      //       gradient: LinearGradient(
      //         colors: [AppColors.navyBlue, Color(0xFF1976D2)],
      //         begin: Alignment.topLeft,
      //         end: Alignment.bottomRight,
      //       ),
      //     ),
      //     child: AppBar(
      //       backgroundColor: Colors.transparent,
      //       elevation: 0,
      //       automaticallyImplyLeading: false,
      //       titleSpacing: 0,
      //       toolbarHeight: 80,
      //       title: Row(
      //         children: [
      //           const SizedBox(width: 16),
      //           ClipRRect(
      //             borderRadius: BorderRadius.circular(25),
      //             child: Image.asset(
      //               "assets/Nss_Logo.jpg",
      //               width: 50,
      //               height: 50,
      //               fit: BoxFit.cover,
      //             ),
      //           ),
      //           const SizedBox(width: 16),
      //           Expanded(
      //             child: Column(
      //               crossAxisAlignment: CrossAxisAlignment.start,
      //               mainAxisAlignment: MainAxisAlignment.center,
      //               children: [
      //                 Text(
      //                   'Government Schemes',
      //                   style: Theme.of(context).textTheme.headlineMedium
      //                       ?.copyWith(
      //                         color: AppColors.white,
      //                         fontWeight: FontWeight.bold,
      //                         fontSize: 22,
      //                       ),
      //                 ),
      //                 const SizedBox(height: 4),
      //                 Text(
      //                   'Add and manage government schemes',
      //                   style: Theme.of(context).textTheme.bodyLarge?.copyWith(
      //                     color: AppColors.white.withOpacity(0.9),
      //                     fontSize: 14,
      //                   ),
      //                 ),
      //               ],
      //             ),
      //           ),
      //           const SizedBox(width: 16),
      //         ],
      //       ),
      //     ),
      //   ),
      // ),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.navyBlue, Color(0xFF1976D2)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Color(0x401A3A52),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.transparent,
              elevation: 0,
              titleSpacing: 0,
              toolbarHeight: 80,
              title: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: Image.asset(
                        "assets/Nss_Logo.jpg",
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Government Schemes',
                          style: Theme.of(context).textTheme.headlineMedium
                              ?.copyWith(
                                color: AppColors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                                letterSpacing: 0.5,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Add and manage government schemes',
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(
                                color: AppColors.white.withOpacity(0.9),
                                fontSize: 14,
                              ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                ],
              ),
            ),
          ),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Removed the duplicate header row (it's already in AppBar)
              const SizedBox(height: 24),

              // Tab Selection
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppColors.lightGrey,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildTabButton(
                        'Add Scheme',
                        0,
                        Icons.add_circle_outline,
                      ),
                    ),
                    Expanded(
                      child: _buildTabButton('History', 1, Icons.history),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              if (_currentView == 0) _buildFormView() else _buildHistoryView(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabButton(String label, int index, IconData icon) {
    final isActive = _currentView == index;
    return GestureDetector(
      onTap: () => setState(() => _currentView = index),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isActive ? AppColors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: AppColors.primaryOrange.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 18,
              color: isActive ? AppColors.primaryOrange : AppColors.darkGrey,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isActive ? AppColors.navyBlue : AppColors.darkGrey,
                fontSize: 14,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormView() {
    return Form(
      key: _formKey,
      autovalidateMode: _autovalidateMode,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Basic Information
          _buildTextField(
            controller: _schemeIdController,
            label: 'Scheme ID',
            hint: 'e.g., SCH004',
            icon: Icons.tag,
            enabled: !_isSubmitting,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _nameController,
            label: 'Scheme Name',
            hint: 'e.g., PM-KISAN',
            icon: Icons.title,
            enabled: !_isSubmitting,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _applicationLinkController,
            label: 'Application Link',
            hint: 'https://...',
            icon: Icons.link,
            enabled: !_isSubmitting,
          ),
          const SizedBox(height: 16),

          // Scheme Details
          _buildTextField(
            controller: _benefitsController,
            label: 'Benefits',
            hint: '₹6000 per year in 3 installments',
            icon: Icons.money,
            maxLines: 2,
            enabled: !_isSubmitting,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _descriptionController,
            label: 'Description',
            hint: 'Income support to all farmer families...',
            icon: Icons.article,
            maxLines: 3,
            enabled: !_isSubmitting,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _eligibilityController,
            label: 'Eligibility',
            hint: 'Small and marginal farmers owning land',
            icon: Icons.check_circle_outline,
            maxLines: 2,
            enabled: !_isSubmitting,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _ministryController,
            label: 'Ministry',
            hint: 'Ministry of Agriculture and Farmers Welfare',
            icon: Icons.account_balance,
            enabled: !_isSubmitting,
          ),
          const SizedBox(height: 16),

          // Geography
          _buildTextField(
            controller: _countryController,
            label: 'Country',
            hint: 'India',
            icon: Icons.flag,
            enabled: !_isSubmitting,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _stateController,
            label: 'State',
            hint: 'All',
            icon: Icons.map,
            enabled: !_isSubmitting,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _districtController,
            label: 'District',
            hint: 'All',
            icon: Icons.location_city,
            enabled: !_isSubmitting,
          ),
          const SizedBox(height: 16),

          // Timeline
          _buildDateField('Start Date', _startDate, true),
          const SizedBox(height: 16),
          _buildDateField('End Date', _endDate, false),
          const SizedBox(height: 16),

          // Status Dropdown
          _buildStatusDropdown(),
          const SizedBox(height: 32),

          // Submit Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isSubmitting ? null : _submitScheme,
              child: _isSubmitting
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.white,
                        ),
                      ),
                    )
                  : const Text(
                      'Submit Scheme',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    int maxLines = 1,
    bool enabled = true,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      enabled: enabled,
      textInputAction: maxLines > 1
          ? TextInputAction.newline
          : TextInputAction.next,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: AppColors.primaryOrange),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter $label';
        }
        return null;
      },
    );
  }

  Widget _buildDateField(String label, DateTime? date, bool isStartDate) {
    return GestureDetector(
      onTap: _isSubmitting ? null : () => _selectDate(context, isStartDate),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.lightGrey,
          border: Border.all(
            color:
                date == null &&
                    _autovalidateMode == AutovalidateMode.onUserInteraction
                ? Colors.red.shade300
                : AppColors.lightGrey,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              Icons.calendar_today,
              color: AppColors.primaryOrange,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.darkGrey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    date != null
                        ? DateFormat('dd MMM yyyy').format(date)
                        : 'Select Date',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: date != null
                          ? AppColors.navyBlue
                          : AppColors.darkGrey,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_drop_down, color: AppColors.primaryOrange),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.lightGrey,
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _status,
          isExpanded: true,
          icon: Icon(Icons.arrow_drop_down, color: AppColors.primaryOrange),
          items: ['active', 'inactive', 'pending'].map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Row(
                children: [
                  Icon(
                    Icons.circle,
                    size: 10,
                    color: value == 'active'
                        ? AppColors.successGreen
                        : value == 'inactive'
                        ? Colors.red
                        : Colors.orange,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    value.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.navyBlue,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          onChanged: _isSubmitting
              ? null
              : (String? newValue) {
                  if (newValue != null) {
                    setState(() => _status = newValue);
                  }
                },
        ),
      ),
    );
  }

  Widget _buildHistoryView() {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('government_schemes')
          .orderBy('created_at', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.lightGrey,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red.shade300,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading schemes',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.navyBlue,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Check Firestore security rules',
                    style: TextStyle(color: AppColors.darkGrey, fontSize: 12),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => setState(() {}),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: AppColors.primaryOrange),
                const SizedBox(height: 16),
                Text(
                  'Loading schemes...',
                  style: TextStyle(color: AppColors.darkGrey),
                ),
              ],
            ),
          );
        }

        final schemes = snapshot.data?.docs ?? [];

        if (schemes.isEmpty) {
          return Center(
            child: Container(
              padding: const EdgeInsets.all(40),
              decoration: BoxDecoration(
                color: AppColors.lightGrey,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.inbox,
                    size: 64,
                    color: AppColors.darkGrey.withOpacity(0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No schemes added yet',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.darkGrey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Add your first scheme to get started',
                    style: TextStyle(fontSize: 14, color: AppColors.darkGrey),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () => setState(() => _currentView = 0),
                    icon: const Icon(Icons.add),
                    label: const Text('Add First Scheme'),
                  ),
                ],
              ),
            ),
          );
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: schemes.length,
          itemBuilder: (context, index) {
            final scheme = schemes[index].data() as Map<String, dynamic>;
            return _buildHistorySchemeCard(scheme, schemes[index].id);
          },
        );
      },
    );
  }

  Widget _buildHistorySchemeCard(Map<String, dynamic> scheme, String docId) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () => _showSchemeDetails(scheme),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.lightGrey,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.primaryOrange.withOpacity(0.2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // NSS Logo Image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      "assets/Nss_Logo.jpg",
                      width: 48,
                      height: 48,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          scheme['name'] ?? 'Unnamed Scheme',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.navyBlue,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: scheme['status'] == 'active'
                                ? AppColors.successGreen.withOpacity(0.2)
                                : AppColors.primaryOrange.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            scheme['status']?.toString().toUpperCase() ?? 'N/A',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: scheme['status'] == 'active'
                                  ? AppColors.successGreen
                                  : AppColors.primaryOrange,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.delete_outline,
                      color: Colors.red.shade400,
                      size: 22,
                    ),
                    onPressed: () => _deleteScheme(docId),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                scheme['description'] ?? 'No description',
                style: const TextStyle(
                  color: AppColors.darkGrey,
                  fontSize: 13,
                  height: 1.5,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    size: 16,
                    color: AppColors.primaryOrange,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      '${scheme['geography']?['state'] ?? 'N/A'}, ${scheme['geography']?['country'] ?? 'N/A'}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.darkGrey,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSchemeDetails(Map<String, dynamic> scheme) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 12),
              height: 4,
              width: 40,
              decoration: BoxDecoration(
                color: AppColors.lightGrey,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            scheme['name'] ?? 'Unnamed Scheme',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppColors.navyBlue,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: scheme['status'] == 'active'
                                ? AppColors.successGreen.withOpacity(0.2)
                                : AppColors.primaryOrange.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            scheme['status']?.toString().toUpperCase() ?? 'N/A',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: scheme['status'] == 'active'
                                  ? AppColors.successGreen
                                  : AppColors.primaryOrange,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _buildDetailRow(
                      'Scheme ID',
                      scheme['scheme_id'],
                      Icons.tag,
                    ),
                    _buildDetailRow(
                      'Benefits',
                      scheme['benefits'],
                      Icons.money,
                    ),
                    _buildDetailRow(
                      'Description',
                      scheme['description'],
                      Icons.article,
                    ),
                    _buildDetailRow(
                      'Eligibility',
                      scheme['eligibility'],
                      Icons.check_circle,
                    ),
                    _buildDetailRow(
                      'Ministry',
                      scheme['ministry'],
                      Icons.account_balance,
                    ),
                    _buildDetailRow(
                      'Country',
                      scheme['geography']?['country'],
                      Icons.flag,
                    ),
                    _buildDetailRow(
                      'State',
                      scheme['geography']?['state'],
                      Icons.map,
                    ),
                    _buildDetailRow(
                      'District',
                      scheme['geography']?['district'],
                      Icons.location_city,
                    ),
                    _buildDetailRow(
                      'Start Date',
                      scheme['start_date'],
                      Icons.calendar_today,
                    ),
                    _buildDetailRow(
                      'End Date',
                      scheme['end_date'],
                      Icons.event,
                    ),
                    _buildDetailRow(
                      'Application Link',
                      scheme['application_link'],
                      Icons.link,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, dynamic value, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.lightGrey,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: AppColors.primaryOrange),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.darkGrey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value?.toString() ?? 'N/A',
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.navyBlue,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteScheme(String docId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Delete Scheme',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.navyBlue,
          ),
        ),
        content: const Text(
          'Are you sure you want to delete this scheme? This action cannot be undone.',
          style: TextStyle(color: AppColors.darkGrey),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppColors.darkGrey),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade500,
              foregroundColor: AppColors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await _firestore.collection('government_schemes').doc(docId).delete();
        if (mounted) {
          _showSnackBar(
            'Scheme deleted successfully',
            AppColors.successGreen,
            Icons.check_circle,
          );
        }
      } catch (e) {
        if (mounted) {
          _showSnackBar('Error deleting scheme: $e', Colors.red, Icons.error);
        }
      }
    }
  }
}
