import 'package:flutter/material.dart';

// Color Constants (matching AdminPanelPage)
class AppColors {
  static const Color navyBlue = Color(0xFF1A3A52);
  static const Color primaryOrange = Color(0xFFF97316);
  static const Color successGreen = Color(0xFF10B981);
  static const Color darkGrey = Color(0xFF6B7280);
  static const Color lightGrey = Color(0xFFF3F4F6);
  static const Color white = Color(0xFFFFFFFF);
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NSS Hiring Process',
      theme: ThemeData(
        primaryColor: AppColors.primaryOrange,
        scaffoldBackgroundColor: AppColors.white,
        useMaterial3: true,
        colorScheme: ColorScheme.light(
          primary: AppColors.primaryOrange,
          secondary: AppColors.primaryOrange,
          surface: AppColors.white,
        ),
      ),
      home: const HiringProcessPage(),
    );
  }
}

class HiringProcessPage extends StatelessWidget {
  const HiringProcessPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.navyBlue, Color(0xFF1976D2)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              // leading: IconButton(
              //   icon: const Icon(Icons.arrow_back, color: AppColors.white),
              //   onPressed: () => Navigator.of(context).pop(),
              // ),
              titleSpacing: 0,
              toolbarHeight: 80,
              title: Row(
                children: [
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
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'NSS Hiring Process',
                          style: Theme.of(context).textTheme.headlineMedium
                              ?.copyWith(
                                color: AppColors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Your Journey to Join NSS',
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
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.lightGrey,
              AppColors.white,
              // AppColors.primaryOrange.withOpacity(0.05),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),

                  // Header Card
                  Container(
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryOrange.withOpacity(0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                AppColors.primaryOrange,
                                Color(0xFFEA580C),
                              ],
                            ),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primaryOrange.withOpacity(0.3),
                                blurRadius: 15,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.people,
                            size: 50,
                            color: AppColors.white,
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'NSS Hiring Process',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: AppColors.navyBlue,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Your Journey to Join NSS',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.darkGrey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Process Steps
                  _buildProcessStep(
                    context,
                    step: '1',
                    title: 'Interview',
                    description: 'Initial screening to know you better',
                    icon: Icons.chat_bubble_outline,
                    color: AppColors.primaryOrange,
                  ),
                  _buildConnector(),
                  _buildProcessStep(
                    context,
                    step: '2',
                    title: 'Selection Activity 1',
                    description: 'First evaluation activity',
                    icon: Icons.assignment_outlined,
                    color: AppColors.primaryOrange,
                  ),
                  _buildConnector(),
                  _buildProcessStep(
                    context,
                    step: '3',
                    title: 'Selection Activity 2',
                    description: 'Second evaluation activity',
                    icon: Icons.task_alt,
                    color: AppColors.primaryOrange,
                  ),
                  _buildConnector(),
                  _buildProcessStep(
                    context,
                    step: '4',
                    title: 'Selection Activity 3',
                    description: 'Final evaluation activity',
                    icon: Icons.emoji_events_outlined,
                    color: AppColors.primaryOrange,
                  ),
                  const SizedBox(height: 40),

                  // Important Note
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.primaryOrange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppColors.primaryOrange.withOpacity(0.3),
                        width: 2,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.warning_amber_rounded,
                          color: AppColors.primaryOrange,
                          size: 32,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Attendance is compulsory for ALL activities',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: AppColors.navyBlue,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Success Card
                  // Container(
                  //   width: double.infinity,
                  //   padding: const EdgeInsets.all(28),
                  //   decoration: BoxDecoration(
                  //     gradient: const LinearGradient(
                  //       colors: [AppColors.successGreen, Color(0xFF059669)],
                  //     ),
                  //     borderRadius: BorderRadius.circular(20),
                  //     boxShadow: [
                  //       BoxShadow(
                  //         color: AppColors.successGreen.withOpacity(0.3),
                  //         blurRadius: 20,
                  //         offset: const Offset(0, 10),
                  //       ),
                  //     ],
                  //   ),
                  //   child: Column(
                  //     children: [
                  //       Container(
                  //         padding: const EdgeInsets.all(16),
                  //         decoration: const BoxDecoration(
                  //           color: AppColors.white,
                  //           shape: BoxShape.circle,
                  //         ),
                  //         child: const Icon(
                  //           Icons.check_circle,
                  //           size: 40,
                  //           color: AppColors.successGreen,
                  //         ),
                  //       ),
                  //       const SizedBox(height: 16),
                  //       const Text(
                  //         'Pass All Activities',
                  //         style: TextStyle(
                  //           fontSize: 22,
                  //           fontWeight: FontWeight.bold,
                  //           color: AppColors.white,
                  //         ),
                  //       ),
                  //       const SizedBox(height: 8),
                  //       const Text(
                  //         'Be a Part of NSS',
                  //         style: TextStyle(
                  //           fontSize: 18,
                  //           color: AppColors.white,
                  //           fontWeight: FontWeight.w500,
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProcessStep(
    BuildContext context, {
    required String step,
    required String title,
    required String description,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [color, color.withOpacity(0.7)]),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(child: Icon(icon, color: AppColors.white, size: 30)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Step $step',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.navyBlue,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(fontSize: 14, color: AppColors.darkGrey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConnector() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              Container(
                width: 3,
                height: 15,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.primaryOrange.withOpacity(0.3),
                      AppColors.primaryOrange,
                    ],
                  ),
                ),
              ),
              Icon(
                Icons.arrow_downward,
                color: AppColors.primaryOrange,
                size: 24,
              ),
              Container(
                width: 3,
                height: 15,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.primaryOrange,
                      AppColors.primaryOrange.withOpacity(0.3),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
