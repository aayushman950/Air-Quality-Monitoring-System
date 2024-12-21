import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/*

This is the Theme Provider.

ThemeModel class encapsulates the variables and methods required for switching between Light/Dark Mode.

{ThemeModel is put above the entire widget tree in main.dart (because the entire app needs the Light/Dark state) }

*/

class ThemeModel extends ChangeNotifier {
  bool _isDarkMode =
      false; // underscore means the variable is private to this file

  bool get isDarkMode => _isDarkMode; // public getter

  // isDark is the shared preference
  ThemeModel(bool isDark) {
    if (isDark) {
      _isDarkMode = true;
    } else {
      _isDarkMode = false;
    }
  }

  void toggleTheme() async {
    // shared preference is used to keep the app state persist even after restarting.
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    _isDarkMode = !_isDarkMode;

    if (_isDarkMode) {
      sharedPreferences.setBool('isDark', true);
    } else {
      sharedPreferences.setBool('isDark', false);
    }

    notifyListeners();
  }
}
