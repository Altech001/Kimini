// theme_provider.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  ThemeData get themeData => _isDarkMode ? darkTheme : lightTheme;

  final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.black,
    scaffoldBackgroundColor: Colors.transparent,
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.black, fontFamily: 'Georgia'),
      bodyMedium: TextStyle(color: Colors.black87, fontFamily: 'Georgia'),
    ),
  );

  final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.white,
    scaffoldBackgroundColor: Colors.transparent,
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white, fontFamily: 'Georgia'),
      bodyMedium: TextStyle(color: Colors.white70, fontFamily: 'Georgia'),
    ),
  );

  ThemeProvider() {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool('isDarkMode') ?? false;
    notifyListeners();
  }

  Future<void> toggleTheme(bool value) async {
    _isDarkMode = !_isDarkMode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', _isDarkMode);
    notifyListeners();
    debugPrint("Theme toggled in provider: isDarkMode = $_isDarkMode");
  }
}
