import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../screens/your_profile_screen.dart';
import 'base_view_model.dart';

final onBoardingViewModel = NotifierProvider.autoDispose(
  () => SignUpOnboardingViewModel(),
);

class SignUpOnboardingViewModel extends BaseViewModel<int> {
  SignUpOnboardingViewModel() : super(initialState: 0);

  static const int totalPages = 5;
  PageController? _pageController;

  void setPageController(PageController controller) {
    _pageController = controller;
  }

  void onPageChanged(int index) {
    state = index;
  }

  void goToPreviousPage() {
    if (_pageController != null && state > 0) {
      _pageController!.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void onSkipThis(BuildContext context) {
    Navigator.pushReplacementNamed(context, YourProfileScreen.routeName);
  }

  void onNextButton(BuildContext context) {
    if (_pageController == null) return;

    if (state < totalPages - 1) {
      _pageController!.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else if (state == 4) {
      Navigator.pushNamed(context, YourProfileScreen.routeName);
    }
  }

  double progressValue() {
    return (state + 1) / totalPages;
  }
}
