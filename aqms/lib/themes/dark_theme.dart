import 'package:flutter/material.dart';

// ThemeData for Dark Theme

// you need to restart the app after making changes to see the changes

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primarySwatch: Colors.blue,
  scaffoldBackgroundColor: Colors.black,
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.transparent,
    foregroundColor: Colors.white,
  ),
);
