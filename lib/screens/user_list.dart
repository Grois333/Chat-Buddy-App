import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:chat_buddy/screens/chat.dart';

import 'package:chat_buddy/widgets/chat_messages.dart';
//import 'package:chat_buddy/widgets/new_message.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({Key? key}) : super(key: key);

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  late Map<String, String> chatIds; // Map to store chat IDs

  @override
  void initState() {
    super.initState();
    chatIds = {};
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        final users = snapshot.data?.docs ?? [];
        return ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            final user = users[index].data() as Map<String, dynamic>;
            final userId = users[index].id;

            if (currentUser?.uid == userId) {
              return SizedBox.shrink();
            }

            return ListTile(
              title: Text(user['username']),
              onTap: () async {
                final chatId = await getOrCreateChatId(userId);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatMessages(
                      chatId: chatId,
                      userId: userId,
                      username: user['username'],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Future<String> getOrCreateChatId(String userId) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    final userPair = [currentUser!.uid, userId].join('_');
    if (chatIds.containsKey(userPair)) {
      return chatIds[userPair]!;
    } else {
      final chatId = await createChatId(userId);
      chatIds[userPair] = chatId;
      return chatId;
    }
  }

  Future<String> createChatId(String userId) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    final sortedUserIds = [currentUser!.uid, userId]..sort(); // Sort user IDs
    final chatId = sortedUserIds.join('_'); // Combine sorted user IDs

    final chatRef = FirebaseFirestore.instance.collection('chat').doc(chatId);
    if (!(await chatRef.get()).exists) {
      await chatRef.set({
        'members': sortedUserIds,
      });
    }

    return chatId;
  }


}