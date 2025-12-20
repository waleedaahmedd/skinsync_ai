import 'package:flutter/material.dart';

class TreatmentViewModel extends ChangeNotifier {
  bool _treamentMainScreen = true;
  bool get treamentMainScreen => _treamentMainScreen;
  void settreamentMainScreen({required bool value}) {
    _treamentMainScreen = value;
    notifyListeners();
  }
}
