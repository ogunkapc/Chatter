import 'package:chatter/services/auth/auth_service.dart';
import 'package:chatter/widgets/custom_button.dart';
import 'package:chatter/widgets/my_text_form_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  void register() {
    final AuthService authService = AuthService();

    final email = _email.text;
    final password = _password.text;
    final firstName = _firstName.text;

    if (_formKey.currentState!.validate()) {
      try {
        authService.registerWithEmailAndPassword(email, password, firstName);

        showModalBottomSheet(
          context: context,
          builder: (context) => Container(
            padding: const EdgeInsets.all(24),
            child: const Text("Registration Successful"),
          ),
        );
      } on FirebaseAuthException catch (e) {
        showModalBottomSheet(
          context: context,
          builder: (context) => Container(
            padding: const EdgeInsets.all(24),
            child: Text(e.code),
          ),
        );
      }
    }
  }

  bool isSelectionOn = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(
          Icons.message,
          size: 60,
          color: Theme.of(context).colorScheme.primary,
        ),
        const Padding(
          padding: EdgeInsets.only(top: 30.0, bottom: 40),
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
              MyTextFormField(
                controller: _firstName,
                errorMessage: "Enter first name",
                hintText: "Enter your first name",
              ),
              const SizedBox(
                height: 10,
              ),
              MyTextFormField(
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                errorMessage: "Enter your email",
                hintText: "Enter your email address",
              ),
              const SizedBox(
                height: 10,
              ),
              MyTextFormField(
                controller: _password,
                keyboardType: TextInputType.visiblePassword,
                errorMessage: "Enter your password",
                hintText: "Enter your your password",
                isPasswordField: true,
              ),
              const SizedBox(
                height: 10,
              ),
              CustomButton(
                buttonLabel: "Register",
                submit: register,
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
                        style: TextStyle(fontWeight: FontWeight.bold),
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
