import 'package:flutter/material.dart';

// ThemeData for Light Theme

// you need to restart the app after making changes to see the changes


final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primarySwatch: Colors.blue,
  scaffoldBackgroundColor: Colors.grey.shade200,
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.transparent,
    foregroundColor: Colors.black,
  ),
);
