import 'package:chatter/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatService {
  // firestore and auth instance
  final FirebaseFirestore _firestoreInstance = FirebaseFirestore.instance;
  final FirebaseAuth _authInstance = FirebaseAuth.instance;

  // get user stream
  Stream<List<Map<String, dynamic>>> getUsersStream() {
    return _firestoreInstance.collection("Users").snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        // go through each user
        final user = doc.data();

        return user;
      }).toList();
    });
  }

  // send message
  Future<void> sendMessage(String receiverID, String message) async {
    // get current user info
    final String currentUserID = _authInstance.currentUser!.uid;
    final String currentUserEmail = _authInstance.currentUser!.email!;
    final Timestamp timestamp = Timestamp.now();

    // create new message
    Message newMessage = Message(
      senderID: currentUserID,
      senderEmail: currentUserEmail,
      receiverID: receiverID,
      message: message,
      timestamp: timestamp,
    );

    //construct chat room ID for two users
    List<String> ids = [currentUserID, receiverID];
    // sort ids to ensure that the chatroomID is the same for any two people
    ids.sort();
    String chatRoomID = ids.join("_");

    // add new messages to firestore
    await _firestoreInstance
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .add(newMessage.toMap());
  }

  // get messages
  Stream<QuerySnapshot> getMessages(String userID, otherUserID) {
    //construct chat room ID for two users
    List<String> ids = [userID, otherUserID];
    // sort ids to ensure that the chatroomID is the same for any two people
    ids.sort();
    String chatRoomID = ids.join("_");

    return _firestoreInstance
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .orderBy("timestamp", descending: false)
        .snapshots();
  }
}
