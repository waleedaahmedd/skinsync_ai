import 'package:flutter/material.dart';
import 'package:flutter_glass_morphism/flutter_glass_morphism.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../models/bottom_nav.dart';
import '../utills/color_constant.dart';
import '../view_models/bottom_nav_view_model.dart';

import '../view_models/checkout_view_model.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

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
    return GlassMorphismMaterial(
      blurIntensity: 30.0,
      opacity: 0.10,
      glassThickness: 1.0,
      enableBackgroundDistortion: true,
      enableGlassBorder: true,
      child: SafeArea(
        child: Consumer(
          builder: (context, ref, child) {
            final int currentPage = ref.watch(bottomNavViewModel);
            return SizedBox(
              height: context.h(98),
              child: Row(
                children: [
                  _buildNavBarItem(
                    context: context,
                    ref: ref,
                    item: _items[0],
                    index: 0,
                    isSelected: currentPage == 0,
                  ),
                  _buildNavBarItem(
                    context: context,
                    ref: ref,
                    item: _items[1],
                    index: 1,
                    isSelected: currentPage == 1,
                  ),

                  _buildNavBarItem(
                    context: context,
                    ref: ref,
                    item: _items[2],
                    index: 2,
                    isSelected: currentPage == 2,
                  ),
                  _buildNavBarItem(
                    context: context,
                    ref: ref,
                    item: _items[3],
                    index: 3,
                    isSelected: currentPage == 3,
                  ),
                  _buildNavBarItem(
                    context: context,
                    ref: ref,
                    item: _items[4],
                    index: 4,
                    isSelected: currentPage == 4,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Expanded _buildNavBarItem({
    required BuildContext context,
    required WidgetRef ref,
    required BottomNavItem item,
    required bool isSelected,
    required int index,
  }) {
    return Expanded(
      child: InkWell(
        onTap: () {
          ref.read(bottomNavViewModel.notifier).changePage(index);
          if (index == 1) {
            ref.read(checkoutViewModel.notifier).clearState();
          }
        },
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FaIcon(
                isSelected ? item.selectedIcon : item.unselectedIcon,
                size: context.h(24),
                color: isSelected
                    ? CustomColors.blackColor
                    : CustomColors.bottomNavText,
              ),
              SizedBox(height: context.h(8)),
              Text(
                item.label,
                style: TextStyle(
                  fontSize: context.sp(12),
                  color: isSelected
                      ? CustomColors.blackColor
                      : CustomColors.bottomNavText,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
