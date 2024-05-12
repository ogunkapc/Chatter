import 'package:chatter/screens/chat_screen.dart';
import 'package:chatter/services/auth/auth_service.dart';
import 'package:chatter/widgets/custom_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../widgets/my_text_form_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.onTap});

  final void Function()? onTap;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  bool isSelectionOn = true;

  final _formkey = GlobalKey<FormState>();
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.message,
            size: 60,
            color: Theme.of(context).colorScheme.primary,
          ),
          const Padding(
            padding: EdgeInsets.only(top: 30.0, bottom: 40),
            child: Center(
              child: Text(
                "Welcome back! Sign in to your account",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Form(
            key: _formkey,
            child: Column(
              children: [
                MyTextFormField(
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  errorMessage: "Enter your email",
                  hintText: "Enter your Email address",
                ),
                const SizedBox(
                  height: 10,
                ),
                MyTextFormField(
                  controller: _password,
                  keyboardType: TextInputType.visiblePassword,
                  errorMessage: "Enter your password",
                  hintText: "Enter your password",
                  isPasswordField: true,
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          CustomButton(
            buttonLabel: "Login",
            submit: () async {
              final email = _email.text;
              final password = _password.text;
              if (_formkey.currentState!.validate()) {
                try {
                  _authService.signInWithEmailAndPassword(email, password);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ChatScreen()),
                  );
                  showModalBottomSheet(
                    context: context,
                    builder: (context) => Container(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                          "welcome ${_authService.currentUser?.displayName}"),
                    ),
                  );
                } on FirebaseAuthException catch (e) {
                  print(e.runtimeType);
                  print(e);
                  showModalBottomSheet(
                    context: context,
                    builder: (context) => Container(
                      padding: const EdgeInsets.all(24),
                      child: Text(e.code),
                    ),
                  );
                }
              } else {
                print("Error!!!");
              }
            },
          ),
          const SizedBox(
            height: 15,
          ),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Don't have an account? "),
                GestureDetector(
                  onTap: widget.onTap,
                  child: const Text(
                    "Register",
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
