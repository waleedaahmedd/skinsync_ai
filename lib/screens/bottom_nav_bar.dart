import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../models/bottom_nav.dart';
import '../utils/color_constant.dart';
import '../utils/onboarding_descriptions.dart';
import '../view_models/bottom_nav_view_model.dart';
import '../view_models/checkout_view_model.dart';
import '../widgets/custom_showcase.dart';

class BottomNavBar extends StatelessWidget {
  final TabController? controller;
  final List<GlobalKey>? tourKeys;

  const BottomNavBar({super.key, this.controller, this.tourKeys});

  static final List<BottomNavItem> _items = [
    const BottomNavItem(
      label: 'Home',
      selectedIcon: FontAwesomeIcons.house,
      unselectedIcon: FontAwesomeIcons.house,
    ),
    const BottomNavItem(
      label: 'Treatment',
      selectedIcon: FontAwesomeIcons.syringe,
      unselectedIcon: FontAwesomeIcons.syringe,
    ),
    const BottomNavItem(
      label: 'Explore',
      selectedIcon: FontAwesomeIcons.compass,
      unselectedIcon: FontAwesomeIcons.compass,
    ),
    const BottomNavItem(
      label: 'Journey',
      selectedIcon: FontAwesomeIcons.route,
      unselectedIcon: FontAwesomeIcons.route,
    ),
    const BottomNavItem(
      label: 'Profile',
      selectedIcon: FontAwesomeIcons.user,
      unselectedIcon: FontAwesomeIcons.user,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final currentIndex = ref.watch(bottomNavViewModel);

        return ConvexAppBar(
          controller: controller,
          style: TabStyle.reactCircle,
          backgroundColor: Colors.white,
          color: CustomColors.bottomNavText,
          activeColor: Colors.transparent,
          height: kBottomNavigationBarHeight + context.w(15),
          elevation: 0.5,
          items: List.generate(_items.length, (index) {
            final item = _items[index];
            final GlobalKey? showcaseKey =
                (tourKeys != null && tourKeys!.length > index)
                ? tourKeys![index]
                : null;

            String title = "";
            String desc = "";
            switch (index) {
              case 0:
                title = OnboardingDescriptions.homeTabTitle;
                desc = OnboardingDescriptions.homeTabDesc;
                break;
              case 1:
                title = OnboardingDescriptions.treatmentTabTitle;
                desc = OnboardingDescriptions.treatmentTabDesc;
                break;
              case 2:
                title = OnboardingDescriptions.exploreTabTitle;
                desc = OnboardingDescriptions.exploreTabDesc;
                break;
              case 3:
                title = OnboardingDescriptions.journeyTabTitle;
                desc = OnboardingDescriptions.journeyTabDesc;
                break;
              case 4:
                title = OnboardingDescriptions.profileTabTitle;
                desc = OnboardingDescriptions.profileTabDesc;
                break;
            }

            Widget buildIcon(bool active) {
              final widget = active
                  ? Container(
                      padding: EdgeInsets.all(context.w(8)),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: CustomColors.purpleBlueGradient,
                      ),
                      child: Center(
                        child: FaIcon(
                          item.selectedIcon,
                          size: context.h(22),
                          color: CustomColors.blackColor,
                        ),
                      ),
                    )
                  : FaIcon(
                      item.unselectedIcon,
                      size: context.h(20),
                      color: CustomColors.bottomNavText,
                    );

              // Only attach the GlobalKey if this icon's 'active' state matches
              // the tab's current state. This prevents "Duplicate GlobalKey" errors
              // when ConvexAppBar keeps both icon states in memory during transitions.
              final bool isCurrentlyShowingThisState =
                  active == (currentIndex == index);

              if (showcaseKey != null && isCurrentlyShowingThisState) {
                return CustomShowcase(
                  showcaseKey: showcaseKey,
                  title: title,
                  description: desc,
                  targetPadding: EdgeInsets.all(context.w(10)),
                  shapeBorder: const CircleBorder(),
                  child: widget,
                );
              }
              return widget;
            }

            return TabItem(
              icon: buildIcon(false),
              activeIcon: buildIcon(true),
              title: item.label,
            );
          }),
          onTap: (int index) {
            ref.read(bottomNavViewModel.notifier).changePage(index);
            if (index == 1) {
              ref.read(checkoutViewModel.notifier).clearState();
            }
          },
        );
      },
    );
  }
}
