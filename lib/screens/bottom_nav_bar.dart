import 'package:flutter/material.dart';
import 'package:flutter_glass_morphism/flutter_glass_morphism.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:provider/provider.dart';
import 'package:skinsync_ai/models/bottom_nav.dart';
import 'package:skinsync_ai/utills/assets.dart';
import 'package:skinsync_ai/utills/color_constant.dart';
import 'package:skinsync_ai/view_models/bottom_nav_view_model.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  static const List<BottomNavItem> _items = [
    BottomNavItem(
      label: 'Home',
      selectedIcon: SvgAssets.homefilled,
      unselectedIcon: SvgAssets.home,
    ),
     BottomNavItem(
      label: 'Treatment',
      selectedIcon: SvgAssets.treatmentfilled,
      unselectedIcon: SvgAssets.treatment,
    ),
    BottomNavItem(
      label: 'Appointment',
      selectedIcon: SvgAssets.appointmentfilled,
      unselectedIcon: SvgAssets.appointment,
    ),
   
    BottomNavItem(
      label: 'Progress',
      selectedIcon: SvgAssets.progressfilled,
      unselectedIcon: SvgAssets.progress,
    ),
    BottomNavItem(
      label: 'Profile',
      selectedIcon: SvgAssets.profilefilled,
      unselectedIcon: SvgAssets.profile,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return GlassMorphismMaterial(
      blurIntensity: 30.0,
      opacity: 0.10,
      glassThickness: 1.0,
    
      //tintColor: Colors.white.withOpacity(0.15),
      enableBackgroundDistortion: true,
      enableGlassBorder: true,
    
      child: Consumer<BottomNavViewModel>(
        builder: (context, provider, child) {
          final int currentPage = provider.currentPage;
          return Container(
            height: 98.h,
            child: Row(
              children: [
                _buildNavBarItem(
                  context: context,
                  item: _items[0],
                  index: 0,
                  isSelected: currentPage == 0,
                ),
                _buildNavBarItem(
                  context: context,
                  item: _items[1],
                  index: 1,
                  isSelected: currentPage == 1,
                ),
    
                _buildNavBarItem(
                  context: context,
                  item: _items[2],
                  index: 2,
                  isSelected: currentPage == 2,
                ),
                _buildNavBarItem(
                  context: context,
                  item: _items[3],
                  index: 3,
                  isSelected: currentPage == 3,
                ),
                _buildNavBarItem(
                  context: context,
                  item: _items[4],
                  index: 4,
                  isSelected: currentPage == 4,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Expanded _buildNavBarItem({
    required BuildContext context,
    required BottomNavItem item,
    required bool isSelected,
    required int index,
  }) {
    return Expanded(
      child: InkWell(
        onTap: () {
          context.read<BottomNavViewModel>().changePage(index);
        },
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                isSelected ? item.selectedIcon : item.unselectedIcon,
                //  color: isSelected ? Colors.pink : null,
                height: 24.h,
                width: 24.h,
              ),
              SizedBox(height: 8.h),
              Text(
                item.label,
                style: TextStyle(
                  fontSize: 12.sp,
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
