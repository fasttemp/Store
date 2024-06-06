import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  bool _isDarkMode = false;
  String _fontFamily = 'Roboto';

  bool get isDarkMode => _isDarkMode;
  String get fontFamily => _fontFamily;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  void setTheme(bool isDarkMode) {
    _isDarkMode = isDarkMode;
    notifyListeners();
  }

  void setFontFamily(String fontFamily) {
    _fontFamily = fontFamily;
    notifyListeners();
  }
}