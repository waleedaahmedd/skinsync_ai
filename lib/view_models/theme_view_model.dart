import 'package:flutter/material.dart';

import '../../services/storage_service.dart';

class ThemeViewModel extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;
  final StorageService _storageService = StorageService();
  ThemeViewModel() {
    _loadTheme();
  }

  void _loadTheme() async {
    _themeMode = _storageService.getThemeMode();
    notifyListeners();
  }

  void setThemeMode(ThemeMode themeMode) async {
    if (_themeMode == themeMode) return;

    _themeMode = themeMode;
    await _storageService.saveThemeMode(themeMode);
    notifyListeners();
  }

  void toggleTheme() {
    if (_themeMode == ThemeMode.light) {
      setThemeMode(ThemeMode.dark);
    } else {
      setThemeMode(ThemeMode.light);
    }
  }
}
