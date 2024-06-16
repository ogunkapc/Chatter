import 'package:chatter/screens/chat/chat_screen.dart';
import 'package:chatter/screens/settings.dart';
import 'package:chatter/services/auth/auth_service.dart';
import 'package:chatter/services/chat/chat_service.dart';
import 'package:chatter/util/menu_action.dart';
import 'package:chatter/util/show_logout_dialog.dart';
import 'package:chatter/util/widgets/user_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MessagesScreen extends StatelessWidget {
  MessagesScreen({super.key});

  final AuthService _authService = AuthService();
  final ChatService _chatService = ChatService();

  final User? loggedInUser = FirebaseAuth.instance.currentUser;

  void logout() {
    final AuthService authService = AuthService();
    authService.signOut();
  }

  @override
  Widget build(BuildContext context) {
    final String displayName = (loggedInUser?.displayName?.isNotEmpty == true)
        ? loggedInUser!.displayName!
        : 'User';

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text("$displayName's Chats"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          // IconButton(onPressed: logout, icon: const Icon(Icons.logout)),
          PopupMenuButton<MenuAction>(
              // color: Colors.white,
              onSelected: (value) async {
            switch (value) {
              case MenuAction.settings:
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SettingsScreen(),
                  ),
                );
                break;
              case MenuAction.logout:
                final shouldLogout = await showLogOutDialog(context);
                if (shouldLogout) {
                  logout();
                }
                break;
              default:
            }
          }, itemBuilder: (value) {
            return [
              const PopupMenuItem<MenuAction>(
                value: MenuAction.settings,
                child: Text("Settings"),
              ),
              const PopupMenuItem<MenuAction>(
                value: MenuAction.logout,
                child: Text("Log out"),
              )
            ];
          })
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
        if (snapshot.hasError) {
          return const Text("Error");
        }

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
      final displayName = userData["firstname"] ?? userData["email"];
      return UserTile(
        text: displayName,
        onTap: () {
          // navigate to chat page
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatScreen(
                receivername: displayName,
                receiverID: userData["uid"],
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
