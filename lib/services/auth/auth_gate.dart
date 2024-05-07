import 'package:chatter/screens/auth/login_or_register.dart';
import 'package:chatter/screens/chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // If the user is logged in
          if (snapshot.hasData) {
            return const ChatScreen();
          }
          // If the user is not logged in,
          else {
            return const LoginOrRegister();
          }
        },
      ),
    );
  }
}
