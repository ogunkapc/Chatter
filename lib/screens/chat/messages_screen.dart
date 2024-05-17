import 'package:chatter/screens/chat/chat_screen.dart';
import 'package:chatter/services/auth/auth_service.dart';
import 'package:chatter/services/chat/chat_service.dart';
import 'package:chatter/widgets/user_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

User? loggedInUser;

class MessagesScreen extends StatelessWidget {
  MessagesScreen({super.key});

  final AuthService _authService = AuthService();

  final ChatService _chatService = ChatService();

  void logout() {
    final AuthService authService = AuthService();
    authService.signOut();
  }

  // @override
  // void initState() {
  //   super.initState();

  //   getCurrentUser();
  // }

  // void getCurrentUser() {
  //   try {
  //     final user = _authService.currentUser;
  //     if (user != null) {
  //       loggedInUser = user;
  //       print(loggedInUser?.email);
  //     }
  // } catch (e) {
  //     print(e);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const CircleAvatar(),
            const SizedBox(
              width: 10,
            ),
            Text("Hi ${loggedInUser!.displayName}")
          ],
        ),
        actions: [
          IconButton(onPressed: logout, icon: const Icon(Icons.logout)),
        ],
      ),
      body: _buildUserList(),
    );
  }

  Widget _buildUserList() {
    return StreamBuilder(
      stream: _chatService.getUsersStream(),
      builder: (context, snapshot) {
        // if it has error
        if (snapshot.hasError) {}

        // if it is loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading...");
        }

        return ListView(
          children: snapshot.data!
              .map<Widget>((userData) => _buildUserListItem(userData, context))
              .toList(),
        );
      },
    );
  }

  Widget _buildUserListItem(
      Map<String, dynamic> userData, BuildContext context) {
    // display all users except current user
    if (userData["email"] != _authService.getcurrentUser()!.email) {
      return UserTile(
        text: 'firstname',
        onTap: () {
          // navigate to chat page
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatScreen(
                receivername: userData["firstname"],
              ),
            ),
          );
        },
      );
    } else {
      return Container();
    }
  }
}
