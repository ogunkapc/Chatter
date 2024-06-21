import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyTextFormField extends StatefulWidget {
  const MyTextFormField({
    super.key,
    required this.controller,
    this.keyboardType,
    this.errorMessage,
    required this.hintText,
    this.isPasswordField = false,
    this.focusNode,
  });

  final TextEditingController controller;
  final TextInputType? keyboardType;
  final String? errorMessage;
  final String hintText;
  final bool isPasswordField;
  final FocusNode? focusNode;

  @override
  State<MyTextFormField> createState() => _MyTextFormFieldState();
}

class _MyTextFormFieldState extends State<MyTextFormField> {
  bool obscureText = false;

  // Initialize based on the type of field
  @override
  void initState() {
    obscureText = widget.isPasswordField;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: TextFormField(
        controller: widget.controller,
        focusNode: widget.focusNode,
        obscureText: obscureText,
        autocorrect: false,
        keyboardType: widget.keyboardType,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return widget.errorMessage;
          } else {
            return null;
          }
        },
        decoration: InputDecoration(
          hintText: widget.hintText,
          filled: true,
          fillColor: Colors.red.shade50,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          suffixIcon: widget.isPasswordField
              ? GestureDetector(
                  onTap: () {
                    setState(() {
                      obscureText = !obscureText;
                    });
                  },
                  child: Icon(obscureText
                      ? CupertinoIcons.eye_slash_fill
                      : CupertinoIcons.eye_fill),
                )
              : null,
        ),
      ),
    );
  }
}
