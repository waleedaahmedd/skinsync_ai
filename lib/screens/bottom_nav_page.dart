import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:showcaseview/showcaseview.dart';

import '../view_models/bottom_nav_view_model.dart';
import '../view_models/forms_view_model.dart';
import '../view_models/onboarding_view_model.dart';
import '../view_models/subscription_view_model.dart';
import '../view_models/treatment_view_model.dart';
import '../widgets/scan_face_button.dart';
import 'bottom_nav_bar.dart';
import 'bottom_nav_screens/explore_screen.dart';
import 'bottom_nav_screens/home_screen.dart';
import 'bottom_nav_screens/my_profile_screen.dart';
import 'bottom_nav_screens/treatment_explore_screen.dart';
import 'treatment_journey_screen.dart';

class BottomNavPage extends ConsumerStatefulWidget {
  const BottomNavPage({super.key});
  static const String routeName = '/BottomNavPage';

  @override
  ConsumerState<BottomNavPage> createState() => _BottomNavPageState();
}

class _BottomNavPageState extends ConsumerState<BottomNavPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Bottom Nav Tour Keys
  final GlobalKey _homeTabKey = GlobalKey();
  final GlobalKey _treatmentTabKey = GlobalKey();
  final GlobalKey _exploreTabKey = GlobalKey();
  final GlobalKey _journeyTabKey = GlobalKey();
  final GlobalKey _profileTabKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(bottomNavViewModel.notifier).changePage(0);
      ref.read(treatmentViewModel.notifier).init();
      ref.read(subscriptionProvider.notifier).fetchSubscriptionPlans();
      ref.read(formsViewModel.notifier).fetchForms();

      // Initialize/Add bottom nav keys to the onboarding tour
      ref.read(onboardingViewModelProvider.notifier).addKeys([
        _homeTabKey,
        _treatmentTabKey,
        _exploreTabKey,
        _journeyTabKey,
        _profileTabKey,
      ]);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(bottomNavViewModel, (previous, next) {
      if (_tabController.index != next) {
        _tabController.animateTo(next);
      }
    });

    final onboardingNotifier = ref.read(onboardingViewModelProvider.notifier);

    Widget pageContent(BuildContext showcaseContext) => Consumer(
      builder: (context, ref, child) {
        final index = ref.watch(bottomNavViewModel);
        return Scaffold(
          body: Stack(
            alignment: Alignment.center,
            children: [
              switch (index) {
                0 => const HomeScreen(),
                1 => const TreatmentExploreScreen(),
                2 => const ExploreScreen(),
                3 => const TreatmentJourneyScreen(isFromBottomNav: true),
                4 => const MyProfileScreen(),
                int() => throw UnimplementedError(),
              },
              if (index != 2 && index != 3)
                Positioned(
                  bottom: 110.h + MediaQuery.paddingOf(context).bottom,
                  child: const ScanFaceButton(),
                ),
            ],
          ),
          extendBody: true,
          bottomNavigationBar: BottomNavBar(
            controller: _tabController,
            tourKeys: [
              _homeTabKey,
              _treatmentTabKey,
              _exploreTabKey,
              _journeyTabKey,
              _profileTabKey,
            ],
          ),
        );
      },
    );

    // ignore: deprecated_member_use
    return ShowCaseWidget(
      onStart: (index, key) => onboardingNotifier.scrollToTarget(key),
      onFinish: () => onboardingNotifier.onFinish(),
      globalFloatingActionWidget: (showcaseContext) => FloatingActionWidget(
        left: 16,
        right: 16,
        bottom: 16,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () => onboardingNotifier.skip(showcaseContext),
              style: TextButton.styleFrom(
                backgroundColor: Colors.grey.shade700,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text(
                'Skip',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () => onboardingNotifier.next(showcaseContext),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(
                  0xFF6C63FF,
                ), // Use your purple color
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 10,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text(
                'Next',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
      builder: (showcaseContext) => pageContent(showcaseContext),
    );
  }
}
