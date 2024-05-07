import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  // initialise firebase auth
  final FirebaseAuth _authInstance = FirebaseAuth.instance;

  // get current user
  User? get currentUser => _authInstance.currentUser;

  // sign in with email and password
  Future<UserCredential> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      final UserCredential userCredential =
          await _authInstance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      print(e);
      throw Exception(e.code);
    }
  }

  // register with email and password
  Future<UserCredential> registerWithEmailAndPassword(
      String email, String password, String firstName) async {
    try {
      final UserCredential userCredential =
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
      } else {
        print("User not found");
      }

      return userCredential;
    } on FirebaseAuthException catch (e) {
      print(e);
      throw Exception(e.code);
    }
  }

  // send email verification
  // Future<void> sendEmailVerification() async {
  //   try {
  //     User? user = _authInstance.currentUser;
  //     if (user != null && !user.emailVerified) {
  //       await user.sendEmailVerification();
  //     }
  //   } catch (e) {
  //     print(e);
  //     throw Exception('Failed to send email verification');
  //   }
  // }

  // sign out

  Future<void> signOut() async {
    await _authInstance.signOut();
  }
}
