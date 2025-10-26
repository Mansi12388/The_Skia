// register_page.dart - Camp registration page

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:parivartan/CommonMan_Module/Health_Dental_Camp/main.dart';
//import 'app_colors.dart';
//import 'models.dart';

class RegisterPage extends StatefulWidget {
  final String? campType;

  const RegisterPage({super.key, this.campType});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String? selectedCamp;
  int familyMemberCount = 1;
  final List<Map<String, dynamic>> familyMembers = [];
  final _formKey = GlobalKey<FormState>();
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    selectedCamp = widget.campType ?? 'Health Camp';
    _initializeFamilyMembers();
  }

  void _initializeFamilyMembers() {
    familyMembers.clear();
    for (int i = 0; i < familyMemberCount; i++) {
      familyMembers.add({
        'name': TextEditingController(),
        'mobile': TextEditingController(),
        'age': TextEditingController(),
        'gender': null,
      });
    }
  }

  Future<void> _submitRegistration() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      final registration = CampRegistration(
        campType: selectedCamp!,
        memberCount: familyMemberCount,
        status: 'Confirmed',
        members: familyMembers.map((member) {
          return FamilyMember(
            name: member['name'].text,
            mobile: member['mobile'].text,
            age: member['age'].text,
            gender: member['gender'] ?? '',
          );
        }).toList(),
      );

      await FirebaseFirestore.instance
          .collection('registrations')
          .add(registration.toMap());

      if (mounted) {
        setState(() => _isSubmitting = false);
        _showSuccessDialog();
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSubmitting = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppBar(
          automaticallyImplyLeading: false,

          // leading: IconButton(
          //   icon: const Icon(Icons.arrow_back, color: Colors.white),
          //   onPressed: () => Navigator.pop(context),
          // ),
          title: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  // color: Colors.white,
                  borderRadius: BorderRadius.circular(23),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(23),
                  child: Image.asset(
                    "assets/Nss_Logo.jpg",
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 50,
                        height: 50,
                        // color: Colors.white,
                        child: const Icon(
                          Icons.favorite_rounded,
                          color: AppColors.navyBlue,
                          size: 30,
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Text(
                  'Camp Registration',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 22,
                  ),
                ),
              ),
            ],
          ),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.navyBlue, Color(0xFF1976D2)],
              ),
            ),
          ),
          elevation: 0,
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 500),
              builder: (context, value, child) {
                return Transform.translate(
                  offset: Offset(0, 30 * (1 - value)),
                  child: Opacity(
                    opacity: value,
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        // gradient: const LinearGradient(
                        //   colors: [AppColors.navyBlue, Color(0xFF1976D2)],
                        // ),
                        color: const Color.fromARGB(255, 251, 246, 246),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppColors.primaryOrange.withOpacity(0.8),
                          width: 1.5,
                        ),
                        // border: AppColors.primaryOrange,
                        boxShadow: [
                          // BoxShadow(
                          //   color: AppColors.primaryOrange,
                          //   blurRadius: 20,
                          //   offset: const Offset(0, 10),
                          // ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(
                                Icons.medical_services_rounded,
                                color: AppColors.navyBlue,
                                size: 24,
                              ),
                              SizedBox(width: 12),
                              Text(
                                'Select Camp Type',
                                style: TextStyle(
                                  color: AppColors.navyBlue,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          DropdownButtonFormField<String>(
                            value: selectedCamp,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide.none,
                              ),
                              // prefixIcon: const Icon(
                              //   Icons.local_hospital_rounded,
                              //   color: AppColors.navyBlue,
                              // ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 16,
                              ),
                            ),
                            dropdownColor: Colors.white,
                            items:
                                ['Health Camp', 'Dental Camp', 'Eye Care Camp']
                                    .map(
                                      (camp) => DropdownMenuItem(
                                        value: camp,
                                        child: Text(
                                          camp,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.navyBlue,
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                            onChanged: (value) =>
                                setState(() => selectedCamp = value),
                            validator: (value) =>
                                value == null ? 'Please select a camp' : null,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 600),
              builder: (context, value, child) {
                return Transform.scale(
                  scale: 0.8 + (0.2 * value),
                  child: Opacity(
                    opacity: value,
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.people_rounded,
                                color: AppColors.navyBlue,
                                size: 24,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Family Members',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.navyBlue,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildCounterButton(Icons.remove_rounded, () {
                                if (familyMemberCount > 1) {
                                  setState(() {
                                    familyMemberCount--;
                                    _initializeFamilyMembers();
                                  });
                                }
                              }),
                              AnimatedSwitcher(
                                duration: const Duration(milliseconds: 300),
                                transitionBuilder: (child, animation) {
                                  return ScaleTransition(
                                    scale: animation,
                                    child: child,
                                  );
                                },
                                child: Container(
                                  key: ValueKey<int>(familyMemberCount),
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 32,
                                    vertical: 16,
                                  ),

                                  decoration: BoxDecoration(
                                    color: AppColors.background,
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(
                                      color: AppColors.primaryOrange
                                          .withOpacity(0.2),
                                      width: 1,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.primaryOrange
                                            .withOpacity(0.1),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Text(
                                    '$familyMemberCount',
                                    style: const TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.primaryOrange,
                                    ),
                                  ),
                                ),
                              ),
                              _buildCounterButton(Icons.add_rounded, () {
                                if (familyMemberCount < 10) {
                                  setState(() {
                                    familyMemberCount++;
                                    _initializeFamilyMembers();
                                  });
                                }
                              }),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            ...List.generate(
              familyMemberCount,
              (index) => TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: Duration(milliseconds: 400 + (index * 150)),
                builder: (context, value, child) {
                  return Transform.translate(
                    offset: Offset(0, 30 * (1 - value)),
                    child: Opacity(
                      opacity: value,
                      child: _buildMemberCard(index),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 700),
              builder: (context, value, child) {
                return Transform.scale(
                  scale: value,
                  child: Opacity(
                    opacity: value,
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isSubmitting ? null : _submitRegistration,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _isSubmitting
                              ? Colors.grey
                              : AppColors.primaryOrange,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        child: _isSubmitting
                            ? const SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.check_circle_rounded,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                  SizedBox(width: 12),
                                  Text(
                                    'Submit Registration',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
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
          ],
        ),
      ),
    );
  }

  Widget _buildCounterButton(IconData icon, VoidCallback onPressed) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: AppColors.primaryOrange.withOpacity(0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryOrange.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, color: AppColors.primaryOrange, size: 28),
        padding: const EdgeInsets.all(12),
      ),
    );
  }

  Widget _buildMemberCard(int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.navyBlue.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Container(
              //   padding: const EdgeInsets.all(12),
              //   // decoration: BoxDecoration(
              //   //   // gradient: const LinearGradient(
              //   //   //   colors: [AppColors.navyBlue, Color(0xFF1976D2)],
              //   //   // ),
              //   //   borderRadius: BorderRadius.circular(12),
              //   //   boxShadow: [
              //   //     BoxShadow(
              //   //       // color: AppColors.navyBlue.withOpacity(0.3),
              //   //       blurRadius: 8,
              //   //       offset: const Offset(0, 4),
              //   //     ),
              //   //   ],
              //   // ),
              //   child: Text(
              //     '${index + 1}',
              //     style: const TextStyle(
              //       color: Colors.white,
              //       fontWeight: FontWeight.w700,
              //       fontSize: 16,
              //     ),
              //   ),
              // ),
              // const SizedBox(width: 12),
              Text(
                'Member ${index + 1}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.navyBlue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: familyMembers[index]['name'],
            decoration: InputDecoration(
              labelText: 'Full Name',
              labelStyle: const TextStyle(color: AppColors.textLight),
              prefixIcon: const Icon(
                Icons.person_rounded,
                color: AppColors.primaryOrange,
              ),
              filled: true,
              fillColor: AppColors.primaryOrange.withOpacity(0.05),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(
                  color: AppColors.primaryOrange.withOpacity(0.2),
                  width: 1,
                ),
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
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: familyMembers[index]['mobile'],
            decoration: InputDecoration(
              labelText: 'Mobile Number',
              labelStyle: const TextStyle(color: AppColors.textLight),
              prefixIcon: const Icon(
                Icons.phone_rounded,
                color: AppColors.primaryOrange,
              ),
              filled: true,
              fillColor: AppColors.primaryOrange.withOpacity(0.05),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(
                  color: AppColors.primaryOrange.withOpacity(0.2),
                  width: 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(
                  color: AppColors.primaryOrange,
                  width: 2,
                ),
              ),
              counterText: '',
            ),
            keyboardType: TextInputType.phone,
            maxLength: 10,
            validator: (value) {
              if (value?.isEmpty ?? true) return 'Required';
              if (value!.length != 10) return 'Enter valid 10-digit number';
              return null;
            },
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: familyMembers[index]['age'],
                  decoration: InputDecoration(
                    labelText: 'Age',
                    labelStyle: const TextStyle(color: AppColors.textLight),
                    prefixIcon: const Icon(
                      Icons.cake_rounded,
                      color: AppColors.primaryOrange,
                    ),
                    filled: true,
                    fillColor: AppColors.primaryOrange.withOpacity(0.05),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(
                        color: AppColors.primaryOrange.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(
                        color: AppColors.primaryOrange,
                        width: 2,
                      ),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Required' : null,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: familyMembers[index]['gender'],
                  decoration: InputDecoration(
                    labelText: 'Gender',
                    labelStyle: const TextStyle(color: AppColors.textLight),
                    prefixIcon: const Icon(
                      Icons.people_rounded,
                      color: AppColors.primaryOrange,
                    ),
                    filled: true,
                    fillColor: AppColors.primaryOrange.withOpacity(0.05),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(
                        color: AppColors.primaryOrange.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(
                        color: AppColors.primaryOrange,
                        width: 2,
                      ),
                    ),
                  ),
                  dropdownColor: Colors.white,
                  items: ['Male', 'Female', 'Other']
                      .map(
                        (g) => DropdownMenuItem(
                          value: g,
                          child: Text(
                            g,
                            style: const TextStyle(color: AppColors.textDark),
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (value) =>
                      setState(() => familyMembers[index]['gender'] = value),
                  validator: (value) => value == null ? 'Required' : null,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 600),
              builder: (context, value, child) {
                return Transform.scale(
                  scale: value,
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.success, Color(0xFF059669)],
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.success.withOpacity(0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.check_rounded,
                      color: Colors.white,
                      size: 50,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            const Text(
              'Registration Successful!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: AppColors.textDark,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.people_rounded,
                        color: AppColors.navyBlue,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '$familyMemberCount Member(s)',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.navyBlue,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.medical_services_rounded,
                        color: AppColors.primaryOrange,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        selectedCamp!,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryOrange,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryOrange,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: const Text(
                'Done',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    for (var member in familyMembers) {
      (member['name'] as TextEditingController).dispose();
      (member['mobile'] as TextEditingController).dispose();
      (member['age'] as TextEditingController).dispose();
    }
    super.dispose();
  }
}
