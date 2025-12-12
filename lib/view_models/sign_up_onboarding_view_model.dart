import 'package:flutter/material.dart';

class SignUpOnboardingViewModel extends ChangeNotifier {
  int currentPage = 0;

  void updatePage(int index) {
    currentPage = index;
    notifyListeners();
  }

  void nextPage(int totalPages, PageController controller, BuildContext context) {
    if (currentPage < totalPages - 1) {
      controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pushNamed(context, '/profileScreen');
    }
  }

  void previousPage(PageController controller) {
    if (currentPage > 0) {
      controller.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  double progressValue(int totalPages) {
    return (currentPage + 1) / totalPages;
  }
}
