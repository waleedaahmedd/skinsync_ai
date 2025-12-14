import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:skinsync_ai/screens/bottom_nav_screens/apppointments_screen.dart';
import 'package:skinsync_ai/screens/bottom_nav_screens/home_screen.dart';
import 'package:skinsync_ai/screens/bottom_nav_screens/my_profile_screen.dart';
import 'package:skinsync_ai/screens/bottom_nav_screens/progress_screen.dart';
import 'package:skinsync_ai/screens/bottom_nav_screens/treatments_screen.dart';
import 'package:skinsync_ai/utills/assets.dart';

import '../../widgets/scan_face_button.dart';

class BottomNavScreen extends StatefulWidget {
  const BottomNavScreen({super.key});

  @override
  State<BottomNavScreen> createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(),
    TreatmentsScreen(),
    ApppointmentsScreen(),
    ProgressScreen(),
    MyProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          _screens[_currentIndex],
           Positioned(
            bottom: 0,
             child: Column(
               children: [
                // ScanFaceButton(
                   
                //  ),
                //  SizedBox(height: 10.h,),
                //  ClipRRect(
                //    borderRadius: BorderRadius.circular(20),
                //    child: BackdropFilter(
                //                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                //                child: Container(
                //                 height: 98.h,
                //                  padding: EdgeInsets.symmetric(vertical: 21.h, horizontal: 30.w),
                //                   width: MediaQuery.of(context).size.width,
                //                  decoration: BoxDecoration(
                //                    color: Colors.transparent,
                //                    borderRadius: BorderRadius.circular(20),
                //                    border: Border.all(color: Colors.white.withOpacity(0.3)),
                //                  ),
                //                  child: Row(
                //                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //                    children: [
                //                      _buildNavItem(SvgAssets.home, 0, 'Home'),
                //                      _buildNavItem(SvgAssets.treatments, 1, 'Treatments'),
                //                      _buildNavItem(SvgAssets.appointments, 2, 'Appointments'),
                //                      _buildNavItem(SvgAssets.progress, 3, 'Progress'),
                //                      _buildNavItem(SvgAssets.myProfile, 4, 'Profile'),
                //                    ],
                //                  ),
                //                ),
                //    ),
                //  ),
               ],
             ),
           ),
        ],
      ),
    );
  }

  Widget _buildNavItem(String asset, int index, String label) {
    bool isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            asset,
            color: isSelected ? Colors.black : Colors.grey.shade600,
            height: 24,
            width: 24,
          ),
          SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isSelected ? Colors.black : Colors.grey.shade600,
            ),
          )
        ],
      ),
    );
  }
}
