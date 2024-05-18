import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  final String receivername;
  const ChatScreen({super.key, required this.receivername});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(receivername),
      ),
    );
  }
}
