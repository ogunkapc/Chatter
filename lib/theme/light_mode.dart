import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  colorScheme: ColorScheme.light(
    surface: Colors.red.shade100,
    primary: Colors.red.shade300,
    secondary: Colors.red.shade50,
    tertiary: Colors.white,
    inversePrimary: Colors.grey.shade900,
  ),
  useMaterial3: true,
);
