import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_messaging/firebase_messaging.dart';
//import 'package:chat_buddy/widgets/chat_messages.dart';
//import 'package:chat_buddy/widgets/new_message.dart';
import 'package:chat_buddy/screens/user_list.dart';

import 'package:chat_buddy/screens/group_chat.dart';
//import 'package:chat_buddy/widgets/group_chat_messages.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat Buddy'),
        actions: [
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
            icon: Icon(
              Icons.exit_to_app,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GroupChatScreen()),
                );
              },
              child: Text('Group Chat'),
            ),
          ),
        ),
          Expanded(
            child: UserListScreen(),
          ),
        ],
      ),
    );
  }
}