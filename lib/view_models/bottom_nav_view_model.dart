import 'package:flutter/material.dart';

class BottomNavViewModel extends ChangeNotifier {
  int currentPage = 0;

  void changePage(int newPage) {
    currentPage = newPage;
    notifyListeners();
  }
}
