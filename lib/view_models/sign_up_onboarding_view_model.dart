import 'package:flutter/material.dart';
import 'package:skinsync_ai/route_generator.dart';
import 'package:skinsync_ai/screens/bottom_nav_screens/my_profile_screen.dart';

class SignUpOnboardingViewModel extends ChangeNotifier {
  int currentPage = 0;
  static const int totalPages = 5;
  PageController? _pageController;

  void setPageController(PageController controller) {
    _pageController = controller;
  }

  void onPageChanged(int index) {
    currentPage = index;
    notifyListeners();
  }

  void goToPreviousPage() {
    if (_pageController != null && currentPage > 0) {
      _pageController!.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void skipOnboarding(BuildContext context) {
    if (_pageController == null) return;
    
    if (currentPage < totalPages - 1) {
      _pageController!.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else if (currentPage == 4) {
      Navigator.pushNamed(context, MyProfileScreen.routeName);
    } 
  }

  double progressValue() {
    return (currentPage + 1) / totalPages;
  }
}
