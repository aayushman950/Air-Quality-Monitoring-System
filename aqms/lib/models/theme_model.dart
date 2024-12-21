import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeModel extends ChangeNotifier {
  bool _isDarkMode =
      false; // underscore means the variable is private to this file

  bool get isDarkMode => _isDarkMode; // public getter

  ThemeModel(bool isDark) {
    if (isDark) {
      _isDarkMode = true;
    } else {
      _isDarkMode = false;
    }
  }

  void toggleTheme() async {
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
