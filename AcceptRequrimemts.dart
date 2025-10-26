import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:parivartan/CommonMan_Module/FirebaseInitializers.dart';

// Main entry point of the application
// Initializes Firebase and runs the app
// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(options: _getFirebaseOptions());
//   runApp(const CommonPeople());
// }

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseConfig.initialize(); // One line initialization
  runApp(const CommonPeople());
}

// Firebase options configuration
// FirebaseOptions _getFirebaseOptions() {
//   if (kIsWeb) {
//     return const FirebaseOptions(
//       apiKey: "AIzaSyDkEGryfJouqLI3PYOI3PGEJtslJZ5kcNY",
//       appId: "1:994090021321:web:37937c4ad50ea891edf818",
//       messagingSenderId: "994090021321",
//       projectId: "project1-219ef",
//       authDomain: "project1-219ef.firebaseapp.com",
//       storageBucket: "project1-219ef.appspot.com",
//     );
//   } else {
//     return const FirebaseOptions(
//       apiKey: "AIzaSyDkEGryfJouqLI3PYOI3PGEJtslJZ5kcNY",
//       appId: "1:994090021321:android:37937c4ad50ea891edf818",
//       messagingSenderId: "994090021321",
//       projectId: "project1-219ef",
//     );
//   }
// }

// App color constants matching SignUpPage design
class AppColors {
  static const Color navyBlue = Color(0xFF1E3A8A);
  static const Color primaryOrange = Color(0xFFF97316);
  static const Color white = Colors.white;
  static const Color lightGrey = Color(0xFFF3F4F6);
  static const Color darkGrey = Color(0xFF6B7280);
}

// Localization class
// Manages translations for multiple languages (English, Marathi, Hindi)
// Provides translate() method to get localized strings based on keys
class AppLocalizations {
  final String languageCode;

  AppLocalizations(this.languageCode);

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'app_title': 'NSS Community Connect',
      'university': 'SPPU University',
      'tab_raise': 'Our Requirements',
      'tab_my': 'My Requirements',
      'select_category': 'Select Category',
      'water': 'Water',
      'health': 'Health',
      'education': 'Education',
      'environment': 'Environment',
      'sanitation': 'Sanitation',
      'infrastructure': 'Infrastructure',
      'other': 'Other',
      'your_info': 'Your Information',
      'full_name': 'Full Name',
      'mobile_number': 'Mobile Number',
      'email': 'Email (Optional)',
      'village_city': 'Village/City',
      'full_address': 'Full Address',
      'urgency': 'Urgency',
      'low': 'Low',
      'medium': 'Medium',
      'high': 'High',
      'requirement_details': 'Requirement Details',
      'description_hint': 'Describe your requirement here...',
      'submit_button': 'Submit Requirement',
      'required_field': 'Required',
      'select_category_error': 'Please select a category',
      'submit_success': 'Requirement submitted successfully!',
      'error': 'Error',
      'no_requirements': 'No requirements yet',
      'pending': 'Pending',
      'in_progress': 'In Progress',
      'resolved': 'Resolved',
      'language': 'Language',
      'select_language': 'Select Language',
      'cancel_requirement': 'Cancel Requirement',
      'cancel_confirm_title': 'Cancel Requirement?',
      'cancel_confirm_message':
          'Are you sure you want to cancel this requirement? This action cannot be undone.',
      'yes': 'Yes',
      'no': 'No',
      'cancel_success': 'Requirement cancelled successfully!',
      'cancel_error': 'Failed to cancel requirement',
    },
    'mr': {
      'app_title': 'NSS सामुदायिक संपर्क',
      'university': 'SPPU विद्यापीठ',
      'tab_raise': 'आमच्या गरजा',
      'tab_my': 'माझ्या गरजा',
      'select_category': 'श्रेणी निवडा',
      'water': 'पाणी',
      'health': 'आरोग्य',
      'education': 'शिक्षण',
      'environment': 'पर्यावरण',
      'sanitation': 'स्वच्छता',
      'infrastructure': 'पायाभूत सुविधा',
      'other': 'इतर',
      'your_info': 'तुमची माहिती',
      'full_name': 'पूर्ण नाव',
      'mobile_number': 'मोबाईल नंबर',
      'email': 'ईमेल (पर्यायी)',
      'village_city': 'गाव/शहर',
      'full_address': 'संपूर्ण पत्ता',
      'urgency': 'तात्काळता',
      'low': 'कमी',
      'medium': 'मध्यम',
      'high': 'उच्च',
      'requirement_details': 'गरजेचा तपशील',
      'description_hint': 'तुमची गरज येथे लिहा...',
      'submit_button': 'गरज सबमिट करा',
      'required_field': 'आवश्यक आहे',
      'select_category_error': 'कृपया श्रेणी निवडा',
      'submit_success': 'गरज यशस्वीरित्या सबमिट केली!',
      'error': 'त्रुटी',
      'no_requirements': 'अजून गरजा नाहीत',
      'pending': 'प्रलंबित',
      'in_progress': 'प्रगतीपथावर',
      'resolved': 'सोडवले',
      'language': 'भाषा',
      'select_language': 'भाषा निवडा',
      'cancel_requirement': 'गरज रद्द करा',
      'cancel_confirm_title': 'गरज रद्द करायची?',
      'cancel_confirm_message':
          'तुम्हाला खात्री आहे की तुम्ही ही गरज रद्द करू इच्छिता? ही क्रिया पूर्ववत केली जाऊ शकत नाही.',
      'yes': 'होय',
      'no': 'नाही',
      'cancel_success': 'गरज यशस्वीरित्या रद्द केली!',
      'cancel_error': 'गरज रद्द करण्यात अयशस्वी',
    },
    'hi': {
      'app_title': 'NSS सामुदायिक संपर्क',
      'university': 'SPPU विश्वविद्यालय',
      'tab_raise': 'हमारी आवश्यकताएं',
      'tab_my': 'मेरी आवश्यकताएं',
      'select_category': 'श्रेणी चुनें',
      'water': 'पानी',
      'health': 'स्वास्थ्य',
      'education': 'शिक्षा',
      'environment': 'पर्यावरण',
      'sanitation': 'स्वच्छता',
      'infrastructure': 'बुनियादी ढांचा',
      'other': 'अन्य',
      'your_info': 'आपकी जानकारी',
      'full_name': 'पूरा नाम',
      'mobile_number': 'मोबाइल नंबर',
      'email': 'ईमेल (वैकल्पिक)',
      'village_city': 'गाँव/शहर',
      'full_address': 'पूरा पता',
      'urgency': 'तात्कालिकता',
      'low': 'कम',
      'medium': 'मध्यम',
      'high': 'उच्च',
      'requirement_details': 'आवश्यकता विवरण',
      'description_hint': 'अपनी आवश्यकता यहाँ लिखें...',
      'submit_button': 'आवश्यकता सबमिट करें',
      'required_field': 'आवश्यक है',
      'select_category_error': 'कृपया श्रेणी चुनें',
      'submit_success': 'आवश्यकता सफलतापूर्वक सबमिट की गई!',
      'error': 'त्रुटि',
      'no_requirements': 'अभी कोई आवश्यकताएं नहीं',
      'pending': 'लंबित',
      'in_progress': 'प्रगति में',
      'resolved': 'हल हो गया',
      'language': 'भाषा',
      'select_language': 'भाषा चुनें',
      'cancel_requirement': 'आवश्यकता रद्द करें',
      'cancel_confirm_title': 'आवश्यकता रद्द करें?',
      'cancel_confirm_message':
          'क्या आप वाकई इस आवश्यकता को रद्द करना चाहते हैं? इस क्रिया को पूर्ववत नहीं किया जा सकता.',
      'yes': 'हाँ',
      'no': 'नहीं',
      'cancel_success': 'आवश्यकता सफलतापूर्वक रद्द की गई!',
      'cancel_error': 'आवश्यकता रद्द करने में विफल',
    },
  };

  // Returns translated string for given key
  String translate(String key) {
    return _localizedValues[languageCode]?[key] ?? key;
  }
}

// Root widget of the application
// StatefulWidget to manage language changes across the app
class CommonPeople extends StatefulWidget {
  const CommonPeople({Key? key}) : super(key: key);

  @override
  State<CommonPeople> createState() => _NSSAppState();
}

// State class for NSSApp
// Manages current language selection and provides language change callback
class _NSSAppState extends State<CommonPeople> {
  String _currentLanguage = 'en'; // Default language is English

  // Method to change app language
  void _changeLanguage(String languageCode) {
    setState(() {
      _currentLanguage = languageCode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NSS Community Connect',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppColors.navyBlue,
        scaffoldBackgroundColor: AppColors.white,
        fontFamily: 'Roboto',
        useMaterial3: true,
        colorScheme: ColorScheme.light(
          primary: AppColors.navyBlue,
          secondary: AppColors.primaryOrange,
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
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: AppColors.primaryOrange,
              width: 2,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red, width: 1.5),
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
            elevation: 0,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
      home: NSSHomePage(
        languageCode: _currentLanguage,
        onLanguageChanged: _changeLanguage,
      ),
    );
  }
}

// Main home page widget
// Contains tabs for submitting requirements and viewing user's requirements
// Manages form state, Firebase operations, and language changes
class NSSHomePage extends StatefulWidget {
  final String languageCode;
  final Function(String) onLanguageChanged;

  const NSSHomePage({
    super.key,
    required this.languageCode,
    required this.onLanguageChanged,
  });

  @override
  State<NSSHomePage> createState() => _NSSHomePageState();
}

// State class for NSSHomePage
// Handles all business logic including:
// - Form validation and submission
// - Firebase CRUD operations (Create, Read, Delete)
// - Category selection
// - Language switching
// - UI state management
class _NSSHomePageState extends State<NSSHomePage>
    with SingleTickerProviderStateMixin {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<QueryModel> queryList = [];
  bool isLoading = false;

  late TabController _tabController;
  final _formKey = GlobalKey<FormState>();

  // Form Controllers for text input fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _villageController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  // Selected values
  String _selectedCategory = '';
  String _selectedUrgency = 'medium';

  late AppLocalizations _localizations;

  // List of all available categories with their properties
  // Each category has a translation key, English name, icon, and color
  List<CategoryItem> get categories => [
    CategoryItem(
      nameKey: 'water',
      nameEn: 'Water',
      icon: Icons.water_drop,
      color: const Color(0xFF2196F3),
    ),
    CategoryItem(
      nameKey: 'health',
      nameEn: 'Health',
      icon: Icons.local_hospital,
      color: const Color(0xFFE91E63),
    ),
    CategoryItem(
      nameKey: 'education',
      nameEn: 'Education',
      icon: Icons.school,
      color: const Color(0xFF9C27B0),
    ),
    CategoryItem(
      nameKey: 'environment',
      nameEn: 'Environment',
      icon: Icons.eco,
      color: const Color(0xFF4CAF50),
    ),
    CategoryItem(
      nameKey: 'sanitation',
      nameEn: 'Sanitation',
      icon: Icons.cleaning_services,
      color: const Color(0xFFFF9800),
    ),
    CategoryItem(
      nameKey: 'infrastructure',
      nameEn: 'Infrastructure',
      icon: Icons.construction,
      color: const Color(0xFF795548),
    ),
    CategoryItem(
      nameKey: 'other',
      nameEn: 'Other',
      icon: Icons.more_horiz,
      color: const Color(0xFF607D8B),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _localizations = AppLocalizations(widget.languageCode);
    _tabController = TabController(length: 2, vsync: this);
    // Load requirements when switching to "My Requirements" tab
    _tabController.addListener(() {
      if (_tabController.index == 1) {
        _loadQueriesFromFirebase();
      }
    });
  }

  @override
  void didUpdateWidget(NSSHomePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update localizations when language changes
    if (oldWidget.languageCode != widget.languageCode) {
      setState(() {
        _localizations = AppLocalizations(widget.languageCode);
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _villageController.dispose();
    _addressController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  // Loads all requirements from Firebase Firestore
  // Orders by timestamp (newest first) and populates queryList
  Future<void> _loadQueriesFromFirebase() async {
    setState(() {
      isLoading = true;
    });

    try {
      QuerySnapshot snapshot = await _firestore
          .collection("requirements")
          .orderBy('timestamp', descending: true)
          .get();

      queryList.clear();
      for (var doc in snapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        queryList.add(
          QueryModel(
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
      _showSnackBar('${_localizations.translate('error')}: $e', isError: true);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Submits a new requirement to Firebase
  // Validates form, checks category selection, and saves to Firestore
  Future<void> _submitQuery() async {
    if (_formKey.currentState!.validate() && _selectedCategory.isNotEmpty) {
      setState(() {
        isLoading = true;
      });

      try {
        await _firestore.collection("requirements").add({
          'name': _nameController.text.trim(),
          'phone': _phoneController.text.trim(),
          'email': _emailController.text.trim(),
          'village': _villageController.text.trim(),
          'address': _addressController.text.trim(),
          'category': _selectedCategory,
          'description': _descriptionController.text.trim(),
          'urgency': _selectedUrgency,
          'status': 'pending',
          'timestamp': FieldValue.serverTimestamp(),
        });

        _showSnackBar(
          _localizations.translate('submit_success'),
          isError: false,
        );
        _clearForm();
      } catch (e) {
        _showSnackBar(
          '${_localizations.translate('error')}: $e',
          isError: true,
        );
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    } else if (_selectedCategory.isEmpty) {
      _showSnackBar(
        _localizations.translate('select_category_error'),
        isError: true,
      );
    }
  }

  // Deletes a requirement from Firebase
  // Shows confirmation dialog before deletion
  Future<void> _cancelRequirement(String requirementId) async {
    // Show confirmation dialog
    bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            _localizations.translate('cancel_confirm_title'),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.navyBlue,
            ),
          ),
          content: Text(_localizations.translate('cancel_confirm_message')),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                _localizations.translate('no'),
                style: const TextStyle(color: AppColors.darkGrey),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: Text(_localizations.translate('yes')),
            ),
          ],
        );
      },
    );

    // If user confirmed, delete from Firebase
    if (confirmed == true) {
      setState(() {
        isLoading = true;
      });

      try {
        await _firestore.collection("requirements").doc(requirementId).delete();
        _showSnackBar(
          _localizations.translate('cancel_success'),
          isError: false,
        );
        await _loadQueriesFromFirebase(); // Reload the list
      } catch (e) {
        _showSnackBar(
          '${_localizations.translate('cancel_error')}: $e',
          isError: true,
        );
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  // Clears all form fields and resets selections
  void _clearForm() {
    _nameController.clear();
    _phoneController.clear();
    _emailController.clear();
    _villageController.clear();
    _addressController.clear();
    _descriptionController.clear();
    setState(() {
      _selectedCategory = '';
      _selectedUrgency = 'medium';
    });
  }

  // Shows a snackbar message at the bottom of the screen
  // Can show success (green) or error (red) messages
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

  // Shows language selection dialog
  // Allows user to choose between English, Marathi, and Hindi
  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            _localizations.translate('select_language'),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.navyBlue,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildLanguageOption('English', 'en'),
              _buildLanguageOption('मराठी', 'mr'),
              _buildLanguageOption('हिंदी', 'hi'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Cancel',
                style: TextStyle(color: AppColors.darkGrey),
              ),
            ),
          ],
        );
      },
    );
  }

  // Builds a single language option in the language selection dialog
  Widget _buildLanguageOption(String label, String code) {
    final isSelected = widget.languageCode == code;
    return ListTile(
      title: Text(label),
      leading: Radio<String>(
        value: code,
        groupValue: widget.languageCode,
        activeColor: AppColors.primaryOrange,
        onChanged: (String? value) {
          if (value != null) {
            widget.onLanguageChanged(value);
            Navigator.pop(context);
          }
        },
      ),
      selected: isSelected,
      onTap: () {
        widget.onLanguageChanged(code);
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [_buildRaiseQueryTab(), _buildMyQueriesTab()],
            ),
          ),
        ],
      ),
    );
  }

  // Builds the header section with NSS logo, title, and language selector
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
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
              child: Row(
                children: [
                  // NSS Logo
                  const SizedBox(width: 16),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: Image.asset(
                      "assets/Nss_Logo.jpg",
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                  ),

                  const SizedBox(width: 16),
                  // Title and subtitle
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _localizations.translate('app_title'),
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 0.3,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _localizations.translate('university'),
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.white70,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Language selector button
                  IconButton(
                    icon: const Icon(
                      Icons.language,
                      color: Colors.white,
                      size: 26,
                    ),
                    onPressed: _showLanguageDialog,
                    tooltip: _localizations.translate('language'),
                  ),
                ],
              ),
            ),
            // Tab bar for switching between "Our Requirements" and "My Requirements"
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              // decoration: BoxDecoration(
              //   color: Colors.white.withOpacity(0.2),
              //   borderRadius: BorderRadius.circular(30),
              // ),
              child: TabBar(
                controller: _tabController,
                // indicator: BoxDecoration(
                //   //color: Colors.white,
                //   borderRadius: BorderRadius.circular(30),
                // ),
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white,
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                dividerColor: Colors.transparent,
                tabs: [
                  Tab(
                    icon: const Icon(Icons.add_box_outlined, size: 20),
                    text: _localizations.translate('tab_raise'),
                  ),
                  Tab(
                    icon: const Icon(Icons.list_alt_outlined, size: 20),
                    text: _localizations.translate('tab_my'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Builds the "Our Requirements" tab with form to submit new requirements
  Widget _buildRaiseQueryTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category Selection Section
            Text(
              _localizations.translate('select_category'),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.navyBlue,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _localizations.translate('required_field'),
              style: TextStyle(fontSize: 14, color: AppColors.darkGrey),
            ),
            const SizedBox(height: 16),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.0,
              ),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                return _buildCategoryCard(categories[index]);
              },
            ),
            const SizedBox(height: 24),

            // User Information Card
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _localizations.translate('your_info'),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.navyBlue,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Full Name Field
                  _buildTextField(
                    controller: _nameController,
                    label: _localizations.translate('full_name'),
                    icon: Icons.person_outline,
                    validator: (v) => v?.isEmpty ?? true
                        ? _localizations.translate('required_field')
                        : null,
                  ),
                  const SizedBox(height: 16),

                  // Phone Number Field
                  _buildTextField(
                    controller: _phoneController,
                    label: _localizations.translate('mobile_number'),
                    icon: Icons.phone_outlined,
                    keyboardType: TextInputType.phone,
                    validator: (v) => v?.isEmpty ?? true
                        ? _localizations.translate('required_field')
                        : null,
                  ),
                  const SizedBox(height: 16),

                  // Email Field
                  _buildTextField(
                    controller: _emailController,
                    label: _localizations.translate('email'),
                    icon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),

                  // Village/City Field
                  _buildTextField(
                    controller: _villageController,
                    label: _localizations.translate('village_city'),
                    icon: Icons.location_city_outlined,
                    validator: (v) => v?.isEmpty ?? true
                        ? _localizations.translate('required_field')
                        : null,
                  ),
                  const SizedBox(height: 16),

                  // Full Address Field
                  _buildTextField(
                    controller: _addressController,
                    label: _localizations.translate('full_address'),
                    icon: Icons.home_outlined,
                    maxLines: 2,
                    validator: (v) => v?.isEmpty ?? true
                        ? _localizations.translate('required_field')
                        : null,
                  ),
                  const SizedBox(height: 20),

                  // Urgency Selection
                  Text(
                    _localizations.translate('urgency'),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.navyBlue,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _buildUrgencyButton(
                        'low',
                        _localizations.translate('low'),
                        Colors.green,
                      ),
                      const SizedBox(width: 10),
                      _buildUrgencyButton(
                        'medium',
                        _localizations.translate('medium'),
                        Colors.orange,
                      ),
                      const SizedBox(width: 10),
                      _buildUrgencyButton(
                        'high',
                        _localizations.translate('high'),
                        Colors.red,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Requirement Details
                  Text(
                    _localizations.translate('requirement_details'),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.navyBlue,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _descriptionController,
                    maxLines: 5,
                    style: const TextStyle(fontSize: 15),
                    decoration: InputDecoration(
                      hintText: _localizations.translate('description_hint'),
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      prefixIcon: const Padding(
                        padding: EdgeInsets.only(bottom: 60),
                        child: Icon(
                          Icons.description_outlined,
                          color: AppColors.primaryOrange,
                        ),
                      ),
                    ),
                    validator: (v) => v?.isEmpty ?? true
                        ? _localizations.translate('required_field')
                        : null,
                  ),
                  const SizedBox(height: 24),

                  // Submit Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : _submitQuery,
                      child: isLoading
                          ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2.5,
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.send_outlined, size: 20),
                                const SizedBox(width: 8),
                                Text(_localizations.translate('submit_button')),
                              ],
                            ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Builds the "My Requirements" tab showing list of submitted requirements
  Widget _buildMyQueriesTab() {
    return RefreshIndicator(
      onRefresh: _loadQueriesFromFirebase,
      color: AppColors.primaryOrange,
      child: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primaryOrange),
            )
          : queryList.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inbox_outlined, size: 80, color: Colors.grey[300]),
                  const SizedBox(height: 16),
                  Text(
                    _localizations.translate('no_requirements'),
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: queryList.length,
              itemBuilder: (context, index) {
                return _buildQueryCard(queryList[index]);
              },
            ),
    );
  }

  // Builds a single category card for category selection grid
  Widget _buildCategoryCard(CategoryItem category) {
    final isSelected = _selectedCategory == category.nameEn;
    return GestureDetector(
      onTap: () {
        setState(() => _selectedCategory = category.nameEn);
        HapticFeedback.lightImpact();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryOrange : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primaryOrange : Colors.grey[300]!,
            width: isSelected ? 2.5 : 1,
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: AppColors.primaryOrange.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.white.withOpacity(0.2)
                    : AppColors.lightGrey,
                shape: BoxShape.circle,
              ),
              child: Icon(
                category.icon,
                size: 28,
                color: isSelected ? Colors.white : category.color,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _localizations.translate(category.nameKey),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Builds a text input field with consistent styling
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      style: const TextStyle(fontSize: 15),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: AppColors.darkGrey),
        prefixIcon: Icon(icon, color: AppColors.primaryOrange, size: 22),
      ),
    );
  }

  // Builds an urgency button (Low/Medium/High)
  Widget _buildUrgencyButton(String urgency, String label, Color color) {
    final isSelected = _selectedUrgency == urgency;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() => _selectedUrgency = urgency);
          HapticFeedback.lightImpact();
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? color : AppColors.lightGrey,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected ? color : Colors.grey[300]!,
              width: isSelected ? 2 : 1,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: color.withOpacity(0.3),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: isSelected ? Colors.white : Colors.black87,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Builds a single requirement card in the "My Requirements" list
  Widget _buildQueryCard(QueryModel query) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
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
                        _getCategoryIcon(query.category),
                        color: AppColors.primaryOrange,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      query.category,
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
                    color: _getStatusColor(query.status).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: _getStatusColor(query.status),
                      width: 1.5,
                    ),
                  ),
                  child: Text(
                    _getStatusText(query.status),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: _getStatusColor(query.status),
                    ),
                  ),
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
              child: Text(
                query.description,
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
                    query.village,
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
                  DateFormat('dd MMM yyyy').format(query.timestamp),
                  style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Urgency Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: _getUrgencyColor(query.urgency).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: _getUrgencyColor(query.urgency),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.priority_high,
                    size: 16,
                    color: _getUrgencyColor(query.urgency),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${query.urgency.toUpperCase()} Priority',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: _getUrgencyColor(query.urgency),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            // Cancel requirement button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _cancelRequirement(query.id),
                icon: const Icon(Icons.cancel_outlined, size: 18),
                label: Text(_localizations.translate('cancel_requirement')),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  side: const BorderSide(color: Colors.red, width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Returns appropriate icon for each category
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

  // Returns translated status text based on current language
  String _getStatusText(String status) {
    switch (status) {
      case 'pending':
        return _localizations.translate('pending');
      case 'in-progress':
        return _localizations.translate('in_progress');
      case 'resolved':
        return _localizations.translate('resolved');
      default:
        return status;
    }
  }

  // Returns color based on urgency level
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

  // Returns color based on status
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

// Model class for Category
class CategoryItem {
  final String nameKey;
  final String nameEn;
  final IconData icon;
  final Color color;

  CategoryItem({
    required this.nameKey,
    required this.nameEn,
    required this.icon,
    required this.color,
  });
}

// Model class for Requirement/Query
class QueryModel {
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

  QueryModel({
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
