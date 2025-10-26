import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'Firebase_Initializer.dart';

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
//   runApp(const GroupChatPage());
// }
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const GroupChatPage());
}

class AppColors {
  static const Color navyBlue = Color(0xFF1A3A52);
  static const Color primaryOrange = Color(0xFFF97316);
  static const Color lightGrey = Color(0xFFF5F5F5);
  static const Color darkGrey = Color(0xFF707070);
  static const Color white = Colors.white;
  static const Color successGreen = Color(0xFF4CAF50);
}

class GroupChatPage extends StatelessWidget {
  const GroupChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NSS SCOE Group Chat',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        scaffoldBackgroundColor: AppColors.lightGrey,
        fontFamily: 'Roboto',
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
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
            borderSide: BorderSide(color: Colors.red.shade400),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.red.shade400, width: 2),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryOrange,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 2,
          ),
        ),
      ),
      home: const GroupChatScreen(),
    );
  }
}

// Group Chat Screen with Firebase Integration
class GroupChatScreen extends StatefulWidget {
  const GroupChatScreen({super.key});

  @override
  State<GroupChatScreen> createState() => _GroupChatScreenState();
}

final FirebaseFirestore _firestoreObj = FirebaseFirestore.instance;

class _GroupChatScreenState extends State<GroupChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // Send message to Firebase
  Future<void> _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;

    try {
      await _firestoreObj.collection('messages').add({
        'sender': 'You',
        'content': _messageController.text.trim(),
        'timestamp': FieldValue.serverTimestamp(),
        'isAnnouncement': false,
      });

      _messageController.clear();
      _scrollToBottom();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(child: Text('Error sending message: $e')),
            ],
          ),
          backgroundColor: Colors.red.shade600,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
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

  void _showMembersSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const MembersBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGrey,
      appBar: AppBar(
        automaticallyImplyLeading: false,

        // leading: IconButton(
        //   icon: const Icon(Icons.arrow_back, color: Colors.white),
        //   onPressed: () => Navigator.of(context).pop(),
        // ),
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: Image.asset(
                  'assets/Nss_Logo.jpg',
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                  // errorBuilder: (context, error, stackTrace) {
                  //   // return const Icon(
                  //   //   Icons.school,
                  //   //   color: AppColors.navyBlue,
                  //   //   size: 24,
                  //   // );
                  // },
                ),
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'NSS SCOE Group',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Community Updates',
                    style: TextStyle(fontSize: 12, color: Colors.white70),
                  ),
                ],
              ),
            ),
          ],
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.navyBlue, Color(0xFF1976D2)],
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.group, color: Colors.white),
            onPressed: _showMembersSheet,
          ),
        ],
        elevation: 4,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestoreObj
                  .collection('messages')
                  .orderBy('timestamp', descending: false)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 48,
                          color: Colors.red.shade400,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Error: ${snapshot.error}',
                          style: TextStyle(color: AppColors.darkGrey),
                          textAlign: TextAlign.center,
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
                          color: AppColors.darkGrey.withOpacity(0.5),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No messages yet.\nStart the conversation!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.darkGrey,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                final messages = snapshot.data!.docs;

                // Auto scroll to bottom when new messages arrive
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
                    final messageId = messages[index].id;

                    return MessageBubble(
                      messageId: messageId,
                      sender: messageData['sender'] ?? 'Unknown',
                      content: messageData['content'] ?? '',
                      timestamp: messageData['timestamp'] != null
                          ? (messageData['timestamp'] as Timestamp).toDate()
                          : DateTime.now(),
                      isAnnouncement: messageData['isAnnouncement'] ?? false,
                    );
                  },
                );
              },
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Type a message...',
                hintStyle: TextStyle(color: AppColors.darkGrey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide(color: AppColors.lightGrey),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide(color: AppColors.lightGrey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide(
                    color: AppColors.primaryOrange,
                    width: 2,
                  ),
                ),
                filled: true,
                fillColor: AppColors.lightGrey,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
              ),
              maxLines: null,
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.navyBlue, Color(0xFF1976D2)],
              ),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(25),
                onTap: _sendMessage,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  child: const Icon(Icons.send, color: Colors.white, size: 24),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}

// Message Bubble Widget
class MessageBubble extends StatelessWidget {
  final String messageId;
  final String sender;
  final String content;
  final DateTime timestamp;
  final bool isAnnouncement;

  const MessageBubble({
    super.key,
    required this.messageId,
    required this.sender,
    required this.content,
    required this.timestamp,
    required this.isAnnouncement,
  });

  @override
  Widget build(BuildContext context) {
    final isMe = sender == 'You';

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: isMe
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          if (isAnnouncement)
            _buildAnnouncementBubble()
          else
            _buildRegularBubble(isMe),
          const SizedBox(height: 4),
          Text(
            DateFormat('MMM dd, yyyy • hh:mm a').format(timestamp),
            style: TextStyle(fontSize: 11, color: AppColors.darkGrey),
          ),
        ],
      ),
    );
  }

  Widget _buildAnnouncementBubble() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primaryOrange, Color(0xFFFF9800)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryOrange.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.campaign, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Text(
                sender,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRegularBubble(bool isMe) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 280),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: isMe
            ? const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.navyBlue, Color(0xFF1976D2)],
              )
            : null,
        color: isMe ? null : Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(16),
          topRight: const Radius.circular(16),
          bottomLeft: isMe
              ? const Radius.circular(16)
              : const Radius.circular(4),
          bottomRight: isMe
              ? const Radius.circular(4)
              : const Radius.circular(16),
        ),
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
          if (!isMe)
            Text(
              sender,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.navyBlue,
                fontSize: 13,
              ),
            ),
          if (!isMe) const SizedBox(height: 6),
          Text(
            content,
            style: TextStyle(
              color: isMe ? Colors.white : AppColors.navyBlue,
              fontSize: 14,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

// Members Bottom Sheet with Firebase Integration
class MembersBottomSheet extends StatefulWidget {
  const MembersBottomSheet({super.key});

  @override
  State<MembersBottomSheet> createState() => _MembersBottomSheetState();
}

class _MembersBottomSheetState extends State<MembersBottomSheet> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _showAddMemberDialog() {
    final nameController = TextEditingController();
    final roleController = TextEditingController();
    final phoneController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Add New Member',
          style: TextStyle(
            color: AppColors.navyBlue,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                prefixIcon: Icon(Icons.person, color: AppColors.primaryOrange),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: AppColors.primaryOrange,
                    width: 2,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: roleController,
              decoration: InputDecoration(
                labelText: 'Role',
                prefixIcon: Icon(Icons.badge, color: AppColors.primaryOrange),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: AppColors.primaryOrange,
                    width: 2,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: phoneController,
              decoration: InputDecoration(
                labelText: 'Phone (Optional)',
                prefixIcon: Icon(Icons.phone, color: AppColors.primaryOrange),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: AppColors.primaryOrange,
                    width: 2,
                  ),
                ),
              ),
              keyboardType: TextInputType.phone,
            ),
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
          ElevatedButton(
            onPressed: () async {
              if (nameController.text.trim().isNotEmpty &&
                  roleController.text.trim().isNotEmpty) {
                try {
                  await _firestore.collection('members').add({
                    'name': nameController.text.trim(),
                    'role': roleController.text.trim(),
                    'phone': phoneController.text.trim().isEmpty
                        ? null
                        : phoneController.text.trim(),
                    'addedAt': FieldValue.serverTimestamp(),
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        children: [
                          const Icon(Icons.check_circle, color: Colors.white),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Text('Member added successfully'),
                          ),
                        ],
                      ),
                      backgroundColor: AppColors.successGreen,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        children: [
                          const Icon(Icons.error_outline, color: Colors.white),
                          const SizedBox(width: 12),
                          Expanded(child: Text('Error adding member: $e')),
                        ],
                      ),
                      backgroundColor: Colors.red.shade600,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryOrange,
            ),
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  Future<void> _removeMember(String memberId, String memberName) async {
    try {
      await _firestore.collection('members').doc(memberId).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(child: Text('$memberName removed successfully')),
            ],
          ),
          backgroundColor: AppColors.successGreen,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(child: Text('Error removing member: $e')),
            ],
          ),
          backgroundColor: Colors.red.shade600,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.lightGrey,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Group Members',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.navyBlue,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.navyBlue, Color(0xFF1976D2)],
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.person_add, color: Colors.white),
                    onPressed: _showAddMemberDialog,
                  ),
                ),
              ],
            ),
          ),
          Flexible(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('members').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error: ${snapshot.error}',
                      style: TextStyle(color: AppColors.darkGrey),
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
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.people_outline,
                            size: 48,
                            color: AppColors.darkGrey.withOpacity(0.5),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'No members yet.\nAdd members to get started!',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: AppColors.darkGrey),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                final members = snapshot.data!.docs;

                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: members.length,
                  itemBuilder: (context, index) {
                    final memberData =
                        members[index].data() as Map<String, dynamic>;
                    final memberId = members[index].id;
                    final name = memberData['name'] ?? 'Unknown';
                    final role = memberData['role'] ?? 'Member';
                    final phone = memberData['phone'];

                    return Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.lightGrey,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [AppColors.navyBlue, Color(0xFF1976D2)],
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(
                              name[0].toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        title: Text(
                          name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.navyBlue,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              role,
                              style: TextStyle(color: AppColors.darkGrey),
                            ),
                            if (phone != null)
                              Text(
                                '📞 $phone',
                                style: TextStyle(
                                  color: AppColors.darkGrey,
                                  fontSize: 12,
                                ),
                              ),
                          ],
                        ),
                        trailing: IconButton(
                          icon: const Icon(
                            Icons.remove_circle_outline,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                title: const Text(
                                  'Remove Member',
                                  style: TextStyle(
                                    color: AppColors.navyBlue,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                content: Text('Remove $name from the group?'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text(
                                      'Cancel',
                                      style: TextStyle(
                                        color: AppColors.darkGrey,
                                      ),
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      _removeMember(memberId, name);
                                      Navigator.pop(context);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                    ),
                                    child: const Text('Remove'),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
