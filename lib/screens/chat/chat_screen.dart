import 'package:chatter/services/auth/auth_service.dart';
import 'package:chatter/services/chat/chat_service.dart';
import 'package:chatter/util/widgets/chat_bubble.dart';
import 'package:chatter/util/widgets/my_text_form_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final String receivername;
  final String receiverID;

  const ChatScreen({
    super.key,
    required this.receivername,
    required this.receiverID,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();

  final AuthService _authService = AuthService();
  final ChatService _chatService = ChatService();

  // textfield focus
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    // add listener to focus node
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        // cause a delay for the keyboard to show up
        Future.delayed(const Duration(milliseconds: 500), () {
          scrollDown();
        });
      }
    });

    // add a delay for listview to be built then scroll down
    Future.delayed(const Duration(milliseconds: 500), () {
      scrollDown();
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  // scroll controller
  final ScrollController _scrollController = ScrollController();
  void scrollDown() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(seconds: 1),
      curve: Curves.fastOutSlowIn,
    );
  }

  // send message
  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      // send the message
      await _chatService.sendMessage(
          widget.receiverID, _messageController.text);

      // clear the controller
      _messageController.clear();
      scrollDown();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.receivername),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: _buildMessageList(),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: MyTextFormField(
                    controller: _messageController,
                    hintText: "Type a message",
                    focusNode: _focusNode,
                  ),
                ),
                IconButton(
                  onPressed: sendMessage,
                  icon: const Icon(Icons.send_rounded),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    String senderID = _authService.getcurrentUser()!.uid;
    return StreamBuilder(
      stream: _chatService.getMessages(widget.receiverID, senderID),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text("Error!!");
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        return ListView(
          controller: _scrollController,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          children: snapshot.data!.docs
              .map((doc) => _buildMessageItem(context, doc))
              .toList(),
        );
      },
    );
  }

  // build message item
  Widget _buildMessageItem(BuildContext context, DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    // check if it's current user
    bool isCurrentUser = data["senderID"] == _authService.getcurrentUser()!.uid;

    // align message to the right if sender is current user else left
    var alignment =
        isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;

    return Container(
      padding: const EdgeInsets.all(8.0),
      alignment: alignment,
      child: ChatBubble(message: data["message"], isCurrentUser: isCurrentUser),
    );
  }
}
