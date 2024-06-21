import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  // firebase auth and firestore instance
  final FirebaseAuth _authInstance = FirebaseAuth.instance;
  final FirebaseFirestore _firestoreInstance = FirebaseFirestore.instance;

  // get current user
  User? getcurrentUser() => _authInstance.currentUser;

  // sign in with email and password
  Future<UserCredential> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential =
          await _authInstance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // save user info if it doesn't exist in separate doc
      _firestoreInstance.collection("Users").doc(userCredential.user!.uid).set({
        "uid": userCredential.user!.uid,
        "email": email,
        "firstname": userCredential.user!.displayName,
      });

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  // register with email and password
  Future<UserCredential> registerWithEmailAndPassword(
      String email, String password, String firstName) async {
    try {
      UserCredential userCredential =
          await _authInstance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;

      if (user != null) {
        // User created successfully, now set the display name to firstName
        await user.updateDisplayName(firstName);

        // Optionally, reload the user to ensure the display name is updated
        await user.reload();
        return userCredential;
      }

      // save user info in separate doc
      _firestoreInstance.collection("Users").doc(user!.uid).set(
        {
          "uid": user.uid,
          "email": email,
          "firstname": firstName,
        },
      );

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  // sign out
  Future<void> signOut() async {
    await _authInstance.signOut();
  }
}
