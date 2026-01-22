import 'package:flutter/material.dart';

class MyAppTheme {
  MyAppTheme._myTheme();

  static ThemeData get myTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlueAccent),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
        headlineMedium: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        headlineSmall: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        bodyLarge: TextStyle(fontSize: 18),
        bodyMedium: TextStyle(fontSize: 14),
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          textStyle: MaterialStatePropertyAll(TextStyle(fontSize: 22)),
          backgroundColor: MaterialStatePropertyAll(Colors.grey[50]),
          foregroundColor: MaterialStatePropertyAll(Colors.blue),
          side: MaterialStatePropertyAll(BorderSide(color: Colors.black)),
        ),
      ),
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: AppBarTheme(backgroundColor: Colors.blueAccent),
    );
  }
}
