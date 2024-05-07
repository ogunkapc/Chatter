import 'package:chatter/screens/auth/login_or_register.dart';
import 'package:chatter/services/auth/auth_service.dart';
import 'package:chatter/widgets/custom_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({
    super.key,
    required this.onTap,
  });

  final void Function() onTap;

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _firstName = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final AuthService _authService = AuthService();

  bool isSelectionOn = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: Center(
            child: Text(
              "Welcome! Create your account",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Enter your first name";
                  } else {
                    return null;
                  }
                },
                controller: _firstName,
                decoration: InputDecoration(
                  hintText: "Enter your first name",
                  filled: true,
                  fillColor: Colors.red.shade50,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Enter your email";
                  } else {
                    return null;
                  }
                },
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: "Enter your email",
                  filled: true,
                  fillColor: Colors.red.shade50,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Enter a Password";
                  } else {
                    return null;
                  }
                },
                controller: _password,
                obscureText: true,
                decoration: InputDecoration(
                    hintText: "Enter a Password",
                    filled: true,
                    fillColor: Colors.red.shade50,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          isSelectionOn = !isSelectionOn;
                        });
                      },
                      child: Icon(isSelectionOn
                          ? CupertinoIcons.eye_slash_fill
                          : CupertinoIcons.eye_fill),
                    )),
              ),
              const SizedBox(
                height: 10,
              ),
              CustomButton(
                buttonLabel: "Register",
                submit: () async {
                  final email = _email.text;
                  final password = _password.text;
                  final firstName = _firstName.text;
                  if (_formKey.currentState!.validate()) {
                    try {
                      _authService.registerWithEmailAndPassword(
                          email, password, firstName);
                      // _authService.sendEmailVerification();
                      // navigate to verification screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginOrRegister()),
                      );
                      showModalBottomSheet(
                        context: context,
                        builder: (context) => Container(
                          padding: const EdgeInsets.all(24),
                          child: const Text("Registration Successful"),
                        ),
                      );
                    } on FirebaseAuthException catch (e) {
                      // print(e.runtimeType);
                      print(e);
                      showModalBottomSheet(
                        context: context,
                        builder: (context) => Container(
                          padding: const EdgeInsets.all(24),
                          child: Text(e.code),
                        ),
                      );
                    }
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
                    const Text("Already have an account? "),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        "Login",
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ]),
    );
  }
}
