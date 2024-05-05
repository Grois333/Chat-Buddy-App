import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

//import 'package:chat_buddy/screens/user_list.dart';

import 'package:chat_buddy/widgets/group_chat_messages.dart';
import 'package:chat_buddy/widgets/new_group_message.dart';

//Origianl
class GroupChatScreen extends StatefulWidget {
  const GroupChatScreen({super.key});

  @override
  State<GroupChatScreen> createState() => _GroupChatScreenState();
}


class _GroupChatScreenState extends State<GroupChatScreen> {
  void setupPushNotifications() async {
    final fcm = FirebaseMessaging.instance;

    await fcm.requestPermission();

    //Test Token
    //final token = await fcm.getToken();
    //print(token); //you can send this token to http, or firestore sdk to a beackend

    fcm.subscribeToTopic('chat');
  }

  @override
  void initState() {
    super.initState();

    setupPushNotifications();
  }

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
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
      body: Column(
        children: const [
          Expanded(
            child: GroupChatMessages(),
          ),
          GroupNewMessage(),
        ],
      ),
    );
  }
}