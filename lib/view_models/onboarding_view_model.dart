import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:showcaseview/showcaseview.dart';

/// State class for Onboarding
class OnboardingState {
  final List<GlobalKey> keys;
  final ScrollController? scrollController;
  final bool isActive;

  OnboardingState({
    this.keys = const [],
    this.scrollController,
    this.isActive = false,
  });

  OnboardingState copyWith({
    List<GlobalKey>? keys,
    ScrollController? scrollController,
    bool? isActive,
  }) {
    return OnboardingState(
      keys: keys ?? this.keys,
      scrollController: scrollController ?? this.scrollController,
      isActive: isActive ?? this.isActive,
    );
  }
}

/// ViewModel to handle onboarding/showcase logic across different screens
class OnboardingViewModel extends Notifier<OnboardingState> {
  @override
  OnboardingState build() {
    return OnboardingState();
  }

  /// Initialize the tour with keys and an optional scroll controller
  void initTour({
    required List<GlobalKey> keys,
    ScrollController? scrollController,
  }) {
    state = state.copyWith(keys: keys, scrollController: scrollController);
  }

  /// Add more keys to the existing tour (e.g. from children or siblings)
  void addKeys(List<GlobalKey> newKeys, {bool atStart = false}) {
    // filter out keys already in state to avoid duplicates
    final existingKeys = state.keys.toSet();
    final uniqueNewKeys = newKeys
        .where((k) => !existingKeys.contains(k))
        .toList();

    if (uniqueNewKeys.isNotEmpty) {
      state = state.copyWith(
        keys: atStart
            ? [...uniqueNewKeys, ...state.keys]
            : [...state.keys, ...uniqueNewKeys],
      );
      log(
        'OnboardingViewModel: Added ${uniqueNewKeys.length} keys ${atStart ? "at start" : "at end"}. Total: ${state.keys.length}',
      );
    }
  }

  /// Clear all keys
  void clearKeys() {
    state = state.copyWith(keys: []);
  }

  /// Start the showcase tour
  void startTour(BuildContext context) {
    if (state.keys.isEmpty) {
      log('OnboardingViewModel: No keys registered to start tour.');
      return;
    }

    state = state.copyWith(isActive: true);

    // ignore: deprecated_member_use
    ShowCaseWidget.of(context).startShowCase(state.keys);
  }

  /// Handle scrolling to the target widget
  void scrollToTarget(GlobalKey key) {
    log('OnboardingViewModel: Scrolling to target $key');

    // Use post frame callback to ensure the target is rendered
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final context = key.currentContext;
      if (context == null) {
        log('OnboardingViewModel: Context null for key $key');
        return;
      }

      // If a scroll controller is provided, we can use it,
      // but Scrollable.ensureVisible works even without one if the widget is inside any Scrollable.
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
        alignment: 0.5,
      );
    });
  }

  /// Move to the next step
  void next(BuildContext context) {
    // ignore: deprecated_member_use
    ShowCaseWidget.of(context).next();
  }

  /// Skip/Dismiss the tour
  void skip(BuildContext context) {
    // ignore: deprecated_member_use
    ShowCaseWidget.of(context).dismiss();
    state = state.copyWith(isActive: false);
  }

  /// Finish the tour
  void onFinish() {
    log('OnboardingViewModel: Tour finished');
    state = state.copyWith(isActive: false);
  }
}

/// Provider for OnboardingViewModel
final onboardingViewModelProvider =
    NotifierProvider<OnboardingViewModel, OnboardingState>(() {
      return OnboardingViewModel();
    });
