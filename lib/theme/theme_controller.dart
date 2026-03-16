import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends ChangeNotifier {

  bool _isDark = false;

  bool get isDark => _isDark;

  ThemeMode get themeMode =>
      _isDark ? ThemeMode.dark : ThemeMode.light;

  ThemeController() {
    loadTheme();
  }

  void toggleTheme() async {

    _isDark = !_isDark;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("darkMode", _isDark);

    notifyListeners();
  }

  void loadTheme() async {

    final prefs = await SharedPreferences.getInstance();

    _isDark = prefs.getBool("darkMode") ?? false;

    notifyListeners();
  }
}