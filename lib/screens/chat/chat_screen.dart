import 'package:chatter/services/auth/auth_service.dart';
import 'package:chatter/services/chat/chat_service.dart';
import 'package:chatter/widgets/my_text_form_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  final String receivername;
  final String receiverID;

  ChatScreen({
    super.key,
    required this.receivername,
    required this.receiverID,
  });

  final TextEditingController _messageController = TextEditingController();
  final AuthService _authService = AuthService();
  final ChatService _chatService = ChatService();

  // send message
  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      // send the message
      await _chatService.sendMessage(receiverID, _messageController.text);

      // clear the controller
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(receivername),
      ),
      body: Column(
        children: [
          Expanded(
            child: _buildMessageList(),
          ),
          Row(
            children: [
              Expanded(
                child: MyTextFormField(
                  controller: _messageController,
                  hintText: "Type a message",
                ),
              ),
              IconButton(
                onPressed: sendMessage,
                icon: const Icon(Icons.send_rounded),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    String senderID = _authService.getcurrentUser()!.uid;
    return StreamBuilder(
      stream: _chatService.getMessages(receiverID, senderID),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text("Error!!");
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        return ListView(
          children:
              snapshot.data!.docs.map((doc) => _buildMessageItem(doc)).toList(),
        );
      },
    );
  }

  // build message item
  Widget _buildMessageItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return Text(data["message"]);
  }
}
