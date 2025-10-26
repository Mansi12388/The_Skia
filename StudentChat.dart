import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:parivartan/firebase_options.dart';

// App Colors matching SignUp page
class AppColors {
  static const Color navyBlue = Color(0xFF1A3A52);
  static const Color primaryOrange = Color(0xFFF97316);
  static const Color lightGrey = Color(0xFFF5F5F5);
  static const Color darkGrey = Color(0xFF707070);
  static const Color white = Colors.white;
  static const Color successGreen = Color(0xFF4CAF50);
}

// Initialize Firebase Messaging for notifications
final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
DefaultFirebaseOptions firebaseObject = DefaultFirebaseOptions();
// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//     options: FirebaseOptions(
//       apiKey: 'AIzaSyDkmtgkymdThtASpBdxmWOGd6l2oyIgK_E',
//       appId: '1:776412307701:android:fe13f2c79d8260293d25bc',
//       messagingSenderId: '776412307701',
//       projectId: 'parivartan-c3238',
//       storageBucket: 'parivartan-c3238.firebasestorage.app',
//     ),
//   );

//   // Request notification permissions
//   await _firebaseMessaging.requestPermission(
//     alert: true,
//     badge: true,
//     sound: true,
//   );

//   runApp(const MemberApp());
// }

class MemberApp extends StatelessWidget {
  const MemberApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NSS SCOE Member',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: AppColors.lightGrey,
        fontFamily: 'Roboto',
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.lightGrey),
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
            borderSide: BorderSide(color: Colors.red),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryOrange,
            foregroundColor: AppColors.white,
            padding: EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 2,
          ),
        ),
      ),
      home: const ReadOnlyGroupChatScreen(),
    );
  }
}

// Read-Only Group Chat Screen
class ReadOnlyGroupChatScreen extends StatefulWidget {
  const ReadOnlyGroupChatScreen({super.key});

  @override
  State<ReadOnlyGroupChatScreen> createState() =>
      _ReadOnlyGroupChatScreenState();
}

class _ReadOnlyGroupChatScreenState extends State<ReadOnlyGroupChatScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ScrollController _scrollController = ScrollController();
  int _unreadCount = 0;

  @override
  void initState() {
    super.initState();
    _setupNotifications();
    _listenToNewMessages();
  }

  // Setup Firebase Cloud Messaging
  void _setupNotifications() async {
    // Get FCM token
    String? token = await _firebaseMessaging.getToken();
    print('FCM Token: $token');

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      setState(() {
        _unreadCount++;
      });

      // Show in-app notification
      if (message.notification != null) {
        _showInAppNotification(
          message.notification!.title ?? 'New Message',
          message.notification!.body ?? '',
        );
      }
    });

    // Handle notification tap when app is in background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _scrollToBottom();
    });
  }

  void _listenToNewMessages() {
    _firestore
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .limit(1)
        .snapshots()
        .listen((snapshot) {
          if (snapshot.docs.isNotEmpty) {
            final latestMessage = snapshot.docs.first.data();
            _showInAppNotification(
              latestMessage['sender'] ?? 'NSS Admin',
              latestMessage['content'] ?? 'New message received',
            );
          }
        });
  }

  void _showInAppNotification(String title, String body) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.notifications_active, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    body,
                    style: const TextStyle(fontSize: 12),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.navyBlue,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 300), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _markAsRead() {
    setState(() {
      _unreadCount = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // automaticallyImplyLeading: false,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.navyBlue, Color(0xFF1976D2)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        // leading: IconButton(
        //   icon: const Icon(Icons.arrow_back, color: AppColors.white),
        //   onPressed: () {
        //     Navigator.of(context).pop();
        //   },
        // ),
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                "assets/Nss_Logo.jpg",
                width: 40,
                height: 40,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.groups,
                      color: AppColors.navyBlue,
                      size: 24,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'NSS SCOE Updates',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.white,
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: AppColors.successGreen,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Text(
                        'Read Only • Member View',
                        style: TextStyle(fontSize: 11, color: Colors.white70),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          if (_unreadCount > 0)
            Stack(
              children: [
                IconButton(
                  icon: const Icon(Icons.notifications, color: AppColors.white),
                  onPressed: _markAsRead,
                ),
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: AppColors.primaryOrange,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      _unreadCount > 9 ? '9+' : '$_unreadCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          IconButton(
            icon: const Icon(Icons.info_outline, color: AppColors.white),
            onPressed: () => _showInfoDialog(),
          ),
        ],
      ),
      body: Column(
        children: [
          //  _buildReadOnlyBanner(),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('messages')
                  .orderBy('timestamp', descending: false)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Colors.red,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Error: ${snapshot.error}',
                          style: TextStyle(color: AppColors.darkGrey),
                        ),
                      ],
                    ),
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primaryOrange,
                    ),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.chat_bubble_outline,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No messages yet',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.darkGrey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Waiting for updates from NSS admins',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  );
                }

                final messages = snapshot.data!.docs;

                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _scrollToBottom();
                });

                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final messageData =
                        messages[index].data() as Map<String, dynamic>;

                    return ReadOnlyMessageCard(
                      sender: messageData['sender'] ?? 'NSS Admin',
                      content: messageData['content'] ?? '',
                      timestamp: messageData['timestamp'] != null
                          ? (messageData['timestamp'] as Timestamp).toDate()
                          : DateTime.now(),
                      isAnnouncement: messageData['isAnnouncement'] ?? false,
                      imageUrl: messageData['imageUrl'],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Widget _buildReadOnlyBanner() {
  //   return Container(
  //     width: double.infinity,
  //     padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
  //     decoration: BoxDecoration(
  //       gradient: LinearGradient(
  //         colors: [
  //           AppColors.navyBlue.withOpacity(0.9),
  //           Color(0xFF1976D2).withOpacity(0.9),
  //         ],
  //       ),
  //     ),
  //     // child: Row(
  //     //   children: [
  //     //     Icon(
  //     //       Icons.visibility,
  //     //       color: Colors.white.withOpacity(0.9),
  //     //       size: 18,
  //     //     ),
  //     //     const SizedBox(width: 8),
  //     //     const Expanded(
  //     //       child: Text(
  //     //         'You are viewing messages in read-only mode',
  //     //         style: TextStyle(
  //     //           color: Colors.white,
  //     //           fontSize: 13,
  //     //           fontWeight: FontWeight.w500,
  //     //         ),
  //     //       ),
  //     //     ),
  //     //   ],
  //     // ),
  //   );
  // }

  void _showInfoDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.info, color: AppColors.navyBlue),
            SizedBox(width: 8),
            Text(
              'About This Chat',
              style: TextStyle(color: AppColors.navyBlue),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'This is a read-only group chat where you can:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.navyBlue,
              ),
            ),
            SizedBox(height: 12),
            _buildInfoItem('View messages from NSS admins'),
            _buildInfoItem('See announcements and updates'),
            _buildInfoItem('View shared images'),
            _buildInfoItem('Receive notifications for new messages'),
            SizedBox(height: 12),
            Text(
              'You cannot send messages in this view.',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.darkGrey,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Got it',
              style: TextStyle(color: AppColors.primaryOrange),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(Icons.check_circle, size: 16, color: AppColors.successGreen),
          SizedBox(width: 8),
          Expanded(
            child: Text(text, style: TextStyle(color: AppColors.darkGrey)),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}

// Read-Only Message Card Widget
class ReadOnlyMessageCard extends StatelessWidget {
  final String sender;
  final String content;
  final DateTime timestamp;
  final bool isAnnouncement;
  final String? imageUrl;

  const ReadOnlyMessageCard({
    super.key,
    required this.sender,
    required this.content,
    required this.timestamp,
    required this.isAnnouncement,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isAnnouncement
                      ? [
                          AppColors.primaryOrange.withOpacity(0.1),
                          AppColors.primaryOrange.withOpacity(0.05),
                        ]
                      : [
                          AppColors.navyBlue.withOpacity(0.1),
                          Color(0xFF1976D2).withOpacity(0.05),
                        ],
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: isAnnouncement
                            ? [AppColors.primaryOrange, Color(0xFFF97316)]
                            : [AppColors.navyBlue, Color(0xFF1976D2)],
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isAnnouncement ? Icons.campaign : Icons.person,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          sender,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: isAnnouncement
                                ? AppColors.primaryOrange
                                : AppColors.navyBlue,
                          ),
                        ),
                        if (isAnnouncement)
                          Text(
                            'Important Announcement',
                            style: TextStyle(
                              fontSize: 11,
                              color: AppColors.primaryOrange,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                      ],
                    ),
                  ),
                  Text(
                    DateFormat('hh:mm a').format(timestamp),
                    style: TextStyle(fontSize: 11, color: AppColors.darkGrey),
                  ),
                ],
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (content.isNotEmpty)
                    Text(
                      content,
                      style: TextStyle(
                        fontSize: 15,
                        height: 1.5,
                        color: Color(0xFF212121),
                      ),
                    ),

                  // Image support
                  if (imageUrl != null && imageUrl!.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        imageUrl!,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            height: 200,
                            alignment: Alignment.center,
                            child: CircularProgressIndicator(
                              color: AppColors.primaryOrange,
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 200,
                            color: AppColors.lightGrey,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.broken_image,
                                  size: 48,
                                  color: AppColors.darkGrey,
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Failed to load image',
                                  style: TextStyle(color: AppColors.darkGrey),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // Footer
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.lightGrey,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 12,
                    color: AppColors.darkGrey,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    DateFormat('MMM dd, yyyy').format(timestamp),
                    style: TextStyle(fontSize: 11, color: AppColors.darkGrey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
