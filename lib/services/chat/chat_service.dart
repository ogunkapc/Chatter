import 'package:cloud_firestore/cloud_firestore.dart';

class ChatService {
  // firestore instance
  final FirebaseFirestore _firestoreInstance = FirebaseFirestore.instance;

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

    // create new message

    //construct chat room ID for two users

    // add new messages to database
  }

  // get messages
}
