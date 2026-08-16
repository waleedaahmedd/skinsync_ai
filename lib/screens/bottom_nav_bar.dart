import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../models/bottom_nav.dart';
import '../utills/color_constant.dart';
import '../view_models/bottom_nav_view_model.dart';
import '../view_models/checkout_view_model.dart';

class BottomNavBar extends StatelessWidget {
  final TabController? controller;
  const BottomNavBar({super.key, this.controller});

  static final List<BottomNavItem> _items = [
    const BottomNavItem(
      label: 'Home',
      selectedIcon: FontAwesomeIcons.solidHouse,
      unselectedIcon: FontAwesomeIcons.house,
    ),
    const BottomNavItem(
      label: 'Treatment',
      selectedIcon: FontAwesomeIcons.syringe,
      unselectedIcon: FontAwesomeIcons.syringe,
    ),
    const BottomNavItem(
      label: 'Explore',
      selectedIcon: FontAwesomeIcons.solidCompass,
      unselectedIcon: FontAwesomeIcons.compass,
    ),
    const BottomNavItem(
      label: 'Journey',
      selectedIcon: FontAwesomeIcons.route,
      unselectedIcon: FontAwesomeIcons.route,
    ),
    const BottomNavItem(
      label: 'Profile',
      selectedIcon: FontAwesomeIcons.solidUser,
      unselectedIcon: FontAwesomeIcons.user,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        return ConvexAppBar(
          controller: controller,
          style: TabStyle.reactCircle,
          backgroundColor: Colors.white,
          color: CustomColors.bottomNavText,
          activeColor: Colors.transparent,
          height: kBottomNavigationBarHeight + 15.h,
          elevation: 0.5,
          items: _items
              .map(
                (item) => TabItem(
                  icon: FaIcon(
                    item.unselectedIcon,
                    size: context.h(18),
                    color: CustomColors.bottomNavText,
                  ),
                  activeIcon: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: CustomColors.purpleBlueGradient,
                    ),
                    child: Center(
                      child: FaIcon(
                        item.selectedIcon,
                        size: context.h(25),
                        color: CustomColors.blackColor,
                      ),
                    ),
                  ),
                  title: item.label,
                ),
              )
              .toList(),

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
