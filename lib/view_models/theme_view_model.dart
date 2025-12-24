import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../services/storage_service.dart';
import 'base_view_model.dart';

final themeViewModel = NotifierProvider(() => ThemeViewModel());

class ThemeViewModel extends BaseViewModel<ThemeMode> {
  final StorageService _storageService = StorageService.instance;
  ThemeViewModel() : super(initialState: ThemeMode.light);

  @override
  void init() {
    _loadTheme();
    super.init();
  }

  void _loadTheme() async {
    state = _storageService.getThemeMode();
  }

  void setThemeMode(ThemeMode themeMode) async {
    if (state == themeMode) return;

    state = themeMode;
    await _storageService.saveThemeMode(themeMode);
  }

  void toggleTheme() {
    if (state == ThemeMode.light) {
      setThemeMode(ThemeMode.dark);
    } else {
      setThemeMode(ThemeMode.light);
    }
  }
}
