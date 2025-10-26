import 'package:flutter/material.dart';
import '../../utils/constants.dart' hide AppColors;
import '../../controllers/auth_controller.dart';
import '../../models/user_model.dart';
import '../home/home_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  // Role-specific controllers
  final _courseController = TextEditingController();
  final _batchController = TextEditingController();
  final _admissionYearController = TextEditingController();
  final _orgNameController = TextEditingController();
  final _coordIdController = TextEditingController();
  final _skillTagsController = TextEditingController();
  final _availabilityController = TextEditingController();
  final _authCodeController = TextEditingController();

  UserRole selectedRole = UserRole.volunteerStudent;
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;
  final _confirmPasswordController = TextEditingController();

  final List<Map<String, dynamic>> roles = [
    {'role': UserRole.commonMan, 'name': 'Common Man', 'icon': Icons.person},
    {'role': UserRole.university, 'name': 'University', 'icon': Icons.business},
    {
      'role': UserRole.volunteerStudent,
      'name': 'Volunteer/Student',
      'icon': Icons.school,
    },
    {
      'role': UserRole.adminCoordinator,
      'name': 'Admin/Coordinator',
      'icon': Icons.admin_panel_settings,
    },
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _courseController.dispose();
    _batchController.dispose();
    _admissionYearController.dispose();
    _orgNameController.dispose();
    _coordIdController.dispose();
    _skillTagsController.dispose();
    _availabilityController.dispose();
    _authCodeController.dispose();
    super.dispose();
  }

  Future<void> _signup() async {
    // Enable real-time validation after first submit attempt
    setState(() => _autovalidateMode = AutovalidateMode.onUserInteraction);

    if (_formKey.currentState!.validate()) {
      // Hide keyboard
      FocusScope.of(context).unfocus();

      setState(() => _isLoading = true);

      try {
        // Collect role-specific data
        Map<String, dynamic> roleSpecificData = {};

        switch (selectedRole) {
          case UserRole.commonMan:
            roleSpecificData = {
              'skills': _skillTagsController.text.trim(),
              'availability': _availabilityController.text.trim(),
            };
            break;
          case UserRole.university:
            roleSpecificData = {
              'orgName': _orgNameController.text.trim(),
              'coordId': _coordIdController.text.trim(),
            };
            break;
          case UserRole.volunteerStudent:
            roleSpecificData = {
              'course': _courseController.text.trim(),
              'batch': _batchController.text.trim(),
              'admissionYear': _admissionYearController.text.trim(),
            };
            break;
          case UserRole.adminCoordinator:
            roleSpecificData = {'authCode': _authCodeController.text.trim()};
            break;
        }

        // Create user model (temporary ID will be replaced by Firebase UID)
        final user = UserModel(
          id: 'temp',
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          phone: _phoneController.text.trim(),
          role: selectedRole,
          createdAt: DateTime.now(),
          roleSpecificData: roleSpecificData,
        );

        final newUser = await AuthController.signup(
          user,
          _passwordController.text,
        );

        if (mounted) {
          // Show success message
          _showSuccessMessage(
            'Account created successfully! Welcome, ${newUser.name}!',
          );

          // Small delay to show success message
          await Future.delayed(const Duration(milliseconds: 800));

          if (mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HomePage(userRole: newUser.role),
              ),
            );
          }
        }
      } catch (e) {
        if (mounted) {
          String errorMessage = e.toString().replaceAll('Exception: ', '');

          // Make error messages more user-friendly
          if (errorMessage.contains('email-already-in-use')) {
            errorMessage =
                'This email is already registered. Please login instead.';
          } else if (errorMessage.contains('weak-password')) {
            errorMessage =
                'Password is too weak. Please use a stronger password.';
          } else if (errorMessage.contains('invalid-email')) {
            errorMessage = 'Invalid email address. Please check and try again.';
          } else if (errorMessage.contains('network')) {
            errorMessage =
                'Network error. Please check your internet connection.';
          }

          _showErrorMessage(errorMessage);
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    } else {
      _showErrorMessage('Please fill in all required fields correctly.');
    }
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 4),
        action: SnackBarAction(
          label: 'Dismiss',
          textColor: Colors.white,
          onPressed: () {},
        ),
      ),
    );
  }

  Widget _buildRoleSpecificFields() {
    switch (selectedRole) {
      case UserRole.commonMan:
        return Column(
          children: [
            TextFormField(
              controller: _skillTagsController,
              textInputAction: TextInputAction.next,
              enabled: !_isLoading,
              decoration: const InputDecoration(
                labelText: 'Skills',
                prefixIcon: Icon(Icons.star),
                hintText: 'e.g., Teaching, Healthcare, Driving, Logistics',
              ),
              validator: AuthController.validateSkills,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _availabilityController,
              textInputAction: TextInputAction.done,
              enabled: !_isLoading,
              decoration: const InputDecoration(
                labelText: 'Availability',
                prefixIcon: Icon(Icons.schedule),
                hintText: 'e.g., Weekends, Evening hours, Flexible',
              ),
              validator: AuthController.validateAvailability,
            ),
          ],
        );
      case UserRole.university:
        return Column(
          children: [
            TextFormField(
              controller: _orgNameController,
              textInputAction: TextInputAction.next,
              enabled: !_isLoading,
              decoration: const InputDecoration(
                labelText: 'Organization / College Name',
                prefixIcon: Icon(Icons.business),
                hintText: 'Enter your institution name',
              ),
              validator: AuthController.validateOrgName,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _coordIdController,
              textInputAction: TextInputAction.done,
              enabled: !_isLoading,
              decoration: const InputDecoration(
                labelText: 'Coordinator ID (optional)',
                prefixIcon: Icon(Icons.badge),
                hintText: 'Your NSS coordinator ID',
              ),
            ),
          ],
        );
      case UserRole.volunteerStudent:
        return Column(
          children: [
            TextFormField(
              controller: _courseController,
              textInputAction: TextInputAction.next,
              enabled: !_isLoading,
              decoration: const InputDecoration(
                labelText: 'Course / Branch',
                prefixIcon: Icon(Icons.school),
                hintText: 'e.g., Computer Science, Mechanical Engineering',
              ),
              validator: AuthController.validateCourse,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _batchController,
              textInputAction: TextInputAction.next,
              enabled: !_isLoading,
              decoration: const InputDecoration(
                labelText: 'NSS Batch',
                prefixIcon: Icon(Icons.group),
                hintText: '2024-25',
              ),
              validator: AuthController.validateBatch,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _admissionYearController,
              textInputAction: TextInputAction.done,
              enabled: !_isLoading,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Admission Year',
                prefixIcon: Icon(Icons.calendar_today),
                hintText: '2024',
              ),
              validator: AuthController.validateAdmissionYear,
            ),
          ],
        );
      case UserRole.adminCoordinator:
        return Column(
          children: [
            TextFormField(
              controller: _authCodeController,
              textInputAction: TextInputAction.done,
              enabled: !_isLoading,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Authorization Code',
                prefixIcon: Icon(Icons.security),
                hintText: 'Enter your admin authorization code',
              ),
              validator: AuthController.validateAuthCode,
            ),
          ],
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // Header
              Text(
                AppStrings.createAccount,
                style: Theme.of(
                  context,
                ).textTheme.displayLarge?.copyWith(color: AppColors.navyBlue),
              ),
              const SizedBox(height: 8),
              Text(
                AppStrings.chooseRole,
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(color: AppColors.darkGrey),
              ),
              const SizedBox(height: 24),

              // Role Selection
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppColors.lightGrey,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<UserRole>(
                    value: selectedRole,
                    isExpanded: true,
                    items: roles.map((role) {
                      return DropdownMenuItem<UserRole>(
                        value: role['role'],
                        child: Row(
                          children: [
                            Icon(role['icon'], color: AppColors.navyBlue),
                            const SizedBox(width: 12),
                            Text(role['name']),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (UserRole? newValue) {
                      setState(() => selectedRole = newValue!);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Signup Form
              Form(
                key: _formKey,
                autovalidateMode: _autovalidateMode,
                child: Column(
                  children: [
                    // Common fields
                    TextFormField(
                      controller: _nameController,
                      textInputAction: TextInputAction.next,
                      enabled: !_isLoading,
                      decoration: const InputDecoration(
                        labelText: 'Full Name',
                        prefixIcon: Icon(Icons.person_outline),
                        hintText: 'Enter your full name',
                      ),
                      validator: AuthController.validateName,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      enabled: !_isLoading,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.email_outlined),
                        hintText: 'Enter your email address',
                      ),
                      validator: AuthController.validateEmail,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.next,
                      enabled: !_isLoading,
                      decoration: const InputDecoration(
                        labelText: 'Phone Number',
                        prefixIcon: Icon(Icons.phone_outlined),
                        hintText: 'Enter 10-digit mobile number',
                      ),
                      validator: AuthController.validatePhone,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      textInputAction: TextInputAction.next,
                      enabled: !_isLoading,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: const Icon(Icons.lock_outline),
                        hintText: 'Create a strong password',
                        helperText:
                            'Must have 8+ chars, uppercase, lowercase, number & special char',
                        helperMaxLines: 2,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                      ),
                      validator: AuthController.validatePassword,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: _obscureConfirmPassword,
                      textInputAction: TextInputAction.next,
                      enabled: !_isLoading,
                      decoration: InputDecoration(
                        labelText: 'Confirm Password',
                        prefixIcon: const Icon(Icons.lock_outline),
                        hintText: 'Re-enter your password',
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureConfirmPassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureConfirmPassword =
                                  !_obscureConfirmPassword;
                            });
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please confirm your password';
                        }
                        if (value != _passwordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    // Role-specific fields
                    _buildRoleSpecificFields(),
                    const SizedBox(height: 24),

                    // Signup Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _signup,
                        child: _isLoading
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
                            : const Text('Register'),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Login Link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Already have an account? '),
                  TextButton(
                    onPressed: () =>
                        Navigator.pushReplacementNamed(context, '/login'),
                    child: const Text(
                      'Login',
                      style: TextStyle(color: AppColors.primaryOrange),
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
}
