import 'package:flutter/material.dart';

class AppTheme {
  // Tema Terang
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.blue,
    colorScheme: ColorScheme.light(
      primary: Colors.blue,
      secondary: Colors.redAccent,
      surface: Colors.white, // Menggantikan background yang deprecated
      onSurface: Colors.black,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.blue,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Colors.redAccent,
    ),
  );

  // Tema Gelap
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.teal,
    colorScheme: ColorScheme.dark(
      primary: Colors.teal,
      secondary: Colors.lightGreenAccent,
      surface: Colors.black, // Menggantikan background yang deprecated
      onSurface: Colors.white,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.grey[900],
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Colors.lightGreenAccent,
    ),
  );
}