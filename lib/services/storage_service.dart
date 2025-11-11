import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  late SharedPreferences _prefs;

  static const String _themeModeKey = 'theme-mode';
  static const String _accessTokenKey = 'access-token';

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  ThemeMode getThemeMode() {
    final int? index = _prefs.getInt(_themeModeKey);
    if (index == null) {
      return ThemeMode.system;
    }
    return ThemeMode.values[index];
  }

  Future<void> saveThemeMode(ThemeMode? mode) async {
    if (mode == null) {
      return;
    }
    await _prefs.setInt(_themeModeKey, mode.index);
  }

  Future<void> saveAccessToken(String? token) async {
    if (token != null) {
      await _prefs.setString(_accessTokenKey, token);
    }
  }

  String? getAccessToken() {
    return _prefs.getString(_accessTokenKey);
  }
}
