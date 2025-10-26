import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// AppColor.dart
class AppColors {
  static const Color navyBlue = Color(0xFF1A3A52);
  static const Color primaryOrange = Color(0xFFF97316);
  static const Color successGreen = Color(0xFF10B981);
  static const Color darkGrey = Color(0xFF6B7280);
  static const Color lightGrey = Color(0xFFF3F4F6);
  static const Color white = Color(0xFFFFFFFF);
  static const Color background = Color(0xFFF5F5F5);
  static const Color accent = Color(0xFFF97316);
  static const Color secondary = Color(0xFF10B981);
  static const Color textDark = Color(0xFF2C3E50);
  static const Color lightBlue = Color(0xFF1976D2);

  static Color? textLight;

  static Color? error;

  static var success;
}

// Firebase Options
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

// Camp Model
class HealthCamp {
  final String type;
  final String date;
  final String time;
  final String venue;
  final List<String> services;
  final IconData icon;
  final String imagePath;

  HealthCamp({
    required this.type,
    required this.date,
    required this.time,
    required this.venue,
    required this.services,
    required this.icon,
    required this.imagePath,
  });
}

// Main Method
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
//   runApp(const MyApp());
// }

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NSS Health Camps',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: AppColors.background,
      ),
      home: const HomePage(),
    );
  }
}

// Home Page
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppBar(
          automaticallyImplyLeading: true,
          // leading: IconButton(
          //   icon: const Icon(Icons.arrow_back, color: Colors.white),
          //   onPressed: () => Navigator.of(context).pop(),
          // ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  //color: Colors.white,
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
                        color: Colors.white,
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
                  'Upcoming Camps',
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
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          elevation: 0,
          actions: [
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 500),
              builder: (context, value, child) {
                return Transform.scale(
                  scale: value,
                  child: Container(
                    margin: const EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.notifications_rounded),
                      color: Colors.white,
                      onPressed: () {},
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('upcoming_camps')
            .orderBy('date')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.navyBlue),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  'Error loading camps: ${snapshot.error}',
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                'No upcoming camps available',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          final camps = snapshot.data!.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>? ?? {};
            return HealthCamp(
              type: data['type'] ?? 'Health Camp',
              date: data['date'] ?? '',
              time: data['time'] ?? '',
              venue: data['venue'] ?? '',
              services: List<String>.from(data['services'] ?? []),
              icon: _getIconFromString(data['icon'] ?? 'favorite_rounded'),
              imagePath: data['imagePath'] ?? 'assets/health.jpg',
            );
          }).toList();

          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              // All Camps List
              const Padding(
                padding: EdgeInsets.only(bottom: 16),
                child: Text(
                  'All Upcoming Camps',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textDark,
                  ),
                ),
              ),
              ...camps.asMap().entries.map((entry) {
                final index = entry.key;
                final camp = entry.value;
                return TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: Duration(milliseconds: 400 + (index * 200)),
                  builder: (context, value, child) {
                    return Transform.translate(
                      offset: Offset(0, 50 * (1 - value)),
                      child: Opacity(
                        opacity: value,
                        child: CampCard(camp: camp),
                      ),
                    );
                  },
                );
              }),
            ],
          );
        },
      ),
    );
  }

  IconData _getIconFromString(String iconName) {
    switch (iconName) {
      case 'favorite_rounded':
        return Icons.favorite_rounded;
      case 'sentiment_satisfied_rounded':
        return Icons.sentiment_satisfied_rounded;
      case 'visibility_rounded':
        return Icons.visibility_rounded;
      default:
        return Icons.favorite_rounded;
    }
  }
}

// class CampCard extends StatelessWidget {
//   final HealthCamp camp;

//   const CampCard({super.key, required this.camp});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 20),
//       // decoration: BoxDecoration(
//       //   color: Colors.white,
//       //   borderRadius: BorderRadius.circular(25),
//       //   boxShadow: [
//       //     BoxShadow(
//       //       color: AppColors.navyBlue.withOpacity(0.15),
//       //       blurRadius: 20,
//       //       offset: const Offset(0, 10),
//       //     ),
//       //   ],
//       // ),
//       child: Column(
//         children: [
//           // Image Section with Gradient Overlay
//           ClipRRect(
//             borderRadius: const BorderRadius.only(
//               topLeft: Radius.circular(25),
//               topRight: Radius.circular(25),
//             ),
//             child: Stack(
//               children: [
//                 Image.asset(
//                   camp.imagePath,
//                   height: 100,
//                   width: double.infinity,
//                   fit: BoxFit.cover,
//                   errorBuilder: (context, error, stackTrace) {
//                     return Container(
//                       height: 100,
//                       decoration: const BoxDecoration(
//                         // gradient: LinearGradient(
//                         //   colors: [AppColors.navyBlue, Color(0xFF1976D2)],
//                         // ),
//                       ),
//                       child: Center(
//                         // child: Icon(
//                         //   camp.icon,
//                         //   size: 80,
//                         //   color: Colors.white.withOpacity(0.5),
//                         // ),
//                       ),
//                     );
//                   },
//                 ),
//                 Container(
//                   //height: 100,
//                   decoration: BoxDecoration(
//                     // gradient: LinearGradient(
//                     //   begin: Alignment.topCenter,
//                     //   end: Alignment.bottomCenter,
//                     //   colors: [
//                     //     Colors.transparent,
//                     //     Colors.black.withOpacity(0.7),
//                     //   ],
//                     // ),
//                   ),
//                 ),
//                 // Camp Title and Date (Removed icon and background container)
//                 Positioned(
//                   // bottom: 20,
//                   left: 20,
//                   right: 20,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         camp.type,
//                         style: const TextStyle(
//                           fontSize: 28,
//                           fontWeight: FontWeight.w800,
//                           color: AppColors.navyBlue,
//                           letterSpacing: 0.5,
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                       Row(
//                         children: [
//                           const Icon(
//                             Icons.calendar_today_rounded,
//                             size: 16,
//                             color: AppColors.navyBlue,
//                           ),
//                           const SizedBox(width: 8),
//                           Text(
//                             camp.date,
//                             style: const TextStyle(
//                               color: AppColors.navyBlue,
//                               fontSize: 14,
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           // Details Section
//           Padding(
//             padding: const EdgeInsets.all(24),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Time and Venue Container
//                 Container(
//                   padding: const EdgeInsets.all(16),
//                   decoration: BoxDecoration(
//                     color: AppColors.background,
//                     borderRadius: BorderRadius.circular(15),
//                     border: Border.all(
//                       color: AppColors.navyBlue.withOpacity(0.1),
//                       width: 1,
//                     ),
//                   ),
//                   child: Column(
//                     children: [
//                       Row(
//                         children: [
//                           Container(
//                             padding: const EdgeInsets.all(8),
//                             decoration: BoxDecoration(
//                               color: AppColors.primaryOrange.withOpacity(0.1),
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                             child: const Icon(
//                               Icons.access_time_rounded,
//                               size: 20,
//                               color: AppColors.primaryOrange,
//                             ),
//                           ),
//                           const SizedBox(width: 12),
//                           Expanded(
//                             child: Text(
//                               camp.time,
//                               style: const TextStyle(
//                                 fontSize: 14,
//                                 color: AppColors.textDark,
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 12),
//                       Row(
//                         children: [
//                           Container(
//                             padding: const EdgeInsets.all(8),
//                             decoration: BoxDecoration(
//                               color: AppColors.successGreen.withOpacity(0.1),
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                             child: const Icon(
//                               Icons.location_on_rounded,
//                               size: 20,
//                               color: AppColors.successGreen,
//                             ),
//                           ),
//                           const SizedBox(width: 12),
//                           Expanded(
//                             child: Text(
//                               camp.venue,
//                               style: const TextStyle(
//                                 fontSize: 14,
//                                 color: AppColors.textDark,
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 20),

//                 // Services Section
//                 const Text(
//                   'Services Available',
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w700,
//                     color: AppColors.textDark,
//                   ),
//                 ),
//                 const SizedBox(height: 12),
//                 Wrap(
//                   spacing: 8,
//                   runSpacing: 8,
//                   children: camp.services.map((service) {
//                     return Container(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 14,
//                         vertical: 10,
//                       ),
//                       decoration: BoxDecoration(
//                         gradient: LinearGradient(
//                           colors: [
//                             AppColors.navyBlue.withOpacity(0.1),
//                             const Color(0xFF1976D2).withOpacity(0.1),
//                           ],
//                         ),
//                         borderRadius: BorderRadius.circular(12),
//                         border: Border.all(
//                           color: AppColors.navyBlue.withOpacity(0.2),
//                           width: 1.5,
//                         ),
//                       ),
//                       child: Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           const Icon(
//                             Icons.check_circle_rounded,
//                             size: 16,
//                             color: AppColors.navyBlue,
//                           ),
//                           const SizedBox(width: 6),
//                           Text(
//                             service,
//                             style: const TextStyle(
//                               color: AppColors.navyBlue,
//                               fontSize: 12,
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                         ],
//                       ),
//                     );
//                   }).toList(),
//                 ),
//                 const SizedBox(height: 24),

//                 // Register Button
//                 SizedBox(
//                   width: double.infinity,
//                   height: 54,
//                   child: ElevatedButton(
//                     onPressed: () {
//                       // Navigate to Register Page
//                       // Navigator.push(
//                       //   context,
//                       //   MaterialPageRoute(
//                       //     builder: (context) => RegisterPage(campType: camp.type),
//                       //   ),
//                       // );
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: AppColors.primaryOrange,
//                       foregroundColor: Colors.white,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(18),
//                       ),
//                       elevation: 4,
//                       shadowColor: AppColors.primaryOrange.withOpacity(0.4),
//                     ),
//                     child: const Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Icon(
//                           Icons.how_to_reg_rounded,
//                           color: Colors.white,
//                           size: 24,
//                         ),
//                         SizedBox(width: 10),
//                         Text(
//                           'Register Now',
//                           style: TextStyle(
//                             fontSize: 17,
//                             fontWeight: FontWeight.w700,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

class CampCard extends StatelessWidget {
  final HealthCamp camp;

  const CampCard({super.key, required this.camp});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
            child: Stack(
              children: [
                Image.asset(
                  camp.imagePath,
                  height: 100,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 100,
                      // decoration: const BoxDecoration(
                      //   gradient: LinearGradient(
                      //     colors: [AppColors.navyBlue, Color(0xFF1976D2)],
                      //   ),
                      // ),
                      // child: Center(
                      //   child: Icon(
                      //     camp.icon,
                      //     size: 80,
                      //     color: Colors.white.withOpacity(0.5),
                      //   ),
                      // ),
                    );
                  },
                ),
                Positioned(
                  bottom: 10,
                  left: 10,
                  right: 10,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        camp.type,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: AppColors.navyBlue,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_today_rounded,
                            size: 16,
                            color: AppColors.navyBlue,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            camp.date,
                            style: const TextStyle(
                              color: AppColors.navyBlue,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
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
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.primaryOrange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.access_time_rounded,
                        size: 20,
                        color: AppColors.primaryOrange,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        camp.time,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textDark,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.successGreen.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.location_on_rounded,
                        size: 20,
                        color: AppColors.successGreen,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        camp.venue,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textDark,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                  'Services Available',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: camp.services.map((service) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.navyBlue.withOpacity(0.1),
                            const Color(0xFF1976D2).withOpacity(0.1),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.navyBlue.withOpacity(0.2),
                          width: 1.5,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.check_circle_rounded,
                            size: 16,
                            color: AppColors.navyBlue,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            service,
                            style: const TextStyle(
                              color: AppColors.navyBlue,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) =>
                      //         RegisterPage(campType: camp.type),
                      //   ),
                      // );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryOrange,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      elevation: 4,
                      shadowColor: AppColors.primaryOrange.withOpacity(0.4),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.how_to_reg_rounded,
                          color: Colors.white,
                          size: 24,
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Register Now',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
