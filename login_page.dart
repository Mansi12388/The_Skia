import 'package:flutter/material.dart';
import '../../utils/constants.dart' hide AppColors;
import '../../controllers/auth_controller.dart';
import '../../models/user_model.dart';
import '../widgets/social_login_button.dart';
import '../home/home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  UserRole selectedRole = UserRole.volunteerStudent;
  bool _isLoading = false;
  bool _obscurePassword = true;
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;

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
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    // Enable real-time validation after first submit attempt
    setState(() => _autovalidateMode = AutovalidateMode.onUserInteraction);

    if (_formKey.currentState!.validate()) {
      // Hide keyboard
      FocusScope.of(context).unfocus();

      setState(() => _isLoading = true);

      try {
        final userData = await AuthController.login(
          _emailController.text.trim(),
          _passwordController.text,
          selectedRole,
        );

        if (mounted) {
          if (userData != null) {
            // Show success message
            _showSuccessMessage('Welcome back, ${userData.name}!');

            // Small delay to show success message
            await Future.delayed(const Duration(milliseconds: 500));

            // Navigate to role-specific home page
            if (mounted) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => HomePage(userRole: userData.role),
                ),
              );
            }
          } else {
            _showErrorMessage(
              'Login failed. Please check your credentials and try again.',
            );
          }
        }
      } catch (e) {
        if (mounted) {
          String errorMessage = e.toString().replaceAll('Exception: ', '');

          // Make error messages more user-friendly
          if (errorMessage.contains('network')) {
            errorMessage =
                'Network error. Please check your internet connection.';
          } else if (errorMessage.contains('Invalid email or password')) {
            errorMessage = 'Invalid email or password. Please try again.';
          } else if (errorMessage.contains('role')) {
            errorMessage =
                'You selected the wrong role. Please select the role you registered with.';
          } else if (errorMessage.contains('User data not found')) {
            errorMessage = 'Account not found. Please sign up first.';
          }

          _showErrorMessage(errorMessage);
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    } else {
      // Show error if validation fails
      _showErrorMessage('Please fill in all fields correctly.');
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

  Future<void> _googleLogin() async {
    setState(() => _isLoading = true);
    try {
      // TODO: Implement Google Sign-In
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(userRole: selectedRole),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        _showErrorMessage('Google login failed. Please try again.');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _facebookLogin() async {
    setState(() => _isLoading = true);
    try {
      // TODO: Implement Facebook Sign-In
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(userRole: selectedRole),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        _showErrorMessage('Facebook login failed. Please try again.');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
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
                AppStrings.welcomeBack,
                style: Theme.of(
                  context,
                ).textTheme.displayLarge?.copyWith(color: AppColors.navyBlue),
              ),
              const SizedBox(height: 8),
              Text(
                AppStrings.selectRole,
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(color: AppColors.darkGrey),
              ),
              const SizedBox(height: 32),

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

              // Login Form
              Form(
                key: _formKey,
                autovalidateMode: _autovalidateMode,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      enabled: !_isLoading,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        hintText: 'Enter your email',
                        prefixIcon: const Icon(Icons.email_outlined),
                        suffixIcon: _emailController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear, size: 20),
                                onPressed: () {
                                  setState(() {
                                    _emailController.clear();
                                  });
                                },
                              )
                            : null,
                      ),
                      onChanged: (value) {
                        setState(() {}); // Rebuild to show/hide clear button
                      },
                      validator: AuthController.validateEmail,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      textInputAction: TextInputAction.done,
                      enabled: !_isLoading,
                      onFieldSubmitted: (_) => _login(),
                      decoration: InputDecoration(
                        labelText: 'Password',
                        hintText: 'Enter your password',
                        prefixIcon: const Icon(Icons.lock_outline),
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
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 8),

                    // Forgot Password Link
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: _isLoading
                            ? null
                            : () {
                                // TODO: Implement forgot password
                                _showErrorMessage(
                                  'Password reset feature coming soon!',
                                );
                              },
                        child: Text(
                          'Forgot Password?',
                          style: TextStyle(
                            color: _isLoading
                                ? AppColors.darkGrey
                                : AppColors.primaryOrange,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Login Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _login,
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
                            : const Text('Login'),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Divider
              Row(
                children: [
                  const Expanded(child: Divider()),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'OR',
                      style: TextStyle(
                        color: AppColors.darkGrey,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const Expanded(child: Divider()),
                ],
              ),

              const SizedBox(height: 24),

              // Social Login Buttons
              SocialLoginButton(
                text: 'Continue with Google',
                icon: Icons.g_mobiledata,
                color: const Color(0xFF4285F4),
                backgroundColor: Colors.white,
                onPressed: _isLoading ? null : () => _googleLogin(),
              ),

              const SizedBox(height: 12),

              SocialLoginButton(
                text: 'Continue with Facebook',
                icon: Icons.facebook,
                color: const Color(0xFF1877F2),
                backgroundColor: Colors.white,
                onPressed: _isLoading ? null : () => _facebookLogin(),
              ),

              const SizedBox(height: 24),

              // Sign Up Link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account? "),
                  TextButton(
                    onPressed: () =>
                        Navigator.pushReplacementNamed(context, '/signup'),
                    child: const Text(
                      'Sign Up',
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
