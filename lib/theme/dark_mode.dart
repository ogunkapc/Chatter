import 'package:flutter/material.dart';

ThemeData darkMode = ThemeData(
  colorScheme: ColorScheme.dark(
    surface: Colors.red.shade100,
    primary: Colors.red.shade300,
    secondary: Colors.red.shade50,
    tertiary: Colors.white,
    inversePrimary: Colors.grey.shade900,
  ),
  useMaterial3: true,
);
