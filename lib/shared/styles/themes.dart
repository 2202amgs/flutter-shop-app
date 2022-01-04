import 'package:flutter/material.dart';

ThemeData light = ThemeData(
  primarySwatch: Colors.teal,
  fontFamily: 'ReadexPro',
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.white,
    titleTextStyle: TextStyle(
      color: Colors.black38,
      fontSize: 22,
      fontWeight: FontWeight.bold,
    ),
    foregroundColor: Colors.black87,
    elevation: 0.0,
    titleSpacing: 20,
    actionsIconTheme: IconThemeData(
      color: Colors.black,
    ),
  ),
);
