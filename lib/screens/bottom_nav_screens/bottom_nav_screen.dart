import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:skinsync_ai/route_generator.dart';
import 'package:skinsync_ai/screens/bottom_nav_screens/apppointments_screen.dart';
import 'package:skinsync_ai/screens/bottom_nav_screens/home_screen.dart';
import 'package:skinsync_ai/screens/bottom_nav_screens/my_profile_screen.dart';
import 'package:skinsync_ai/screens/bottom_nav_screens/progress_screen.dart';
import 'package:skinsync_ai/screens/bottom_nav_screens/treatments_screen.dart';
import 'package:skinsync_ai/utills/assets.dart';

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
      extendBody: true, // Makes the body go behind the transparent navbar
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 5),
          ],
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          currentIndex: _currentIndex,
          selectedItemColor: Colors.black,
          unselectedItemColor: Color(0xFF636363),
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: SvgPicture.asset(SvgAssets.home,  color: _currentIndex == 0 ? Colors.black : Color(0xFF636363),
),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(SvgAssets.treatments,  color: _currentIndex == 1 ? Colors.black : Color(0xFF636363),
),
              label: 'Treatments',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(SvgAssets.appointments , color: _currentIndex == 2 ? Colors.black : Color(0xFF636363),
),
              label: 'Appointments',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(SvgAssets.progress,  color: _currentIndex == 3 ? Colors.black : Color(0xFF636363),
),
              label: 'Progress',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(SvgAssets.myProfile,  color: _currentIndex == 4 ? Colors.black : Color(0xFF636363),
),

              label: 'My Profile',
            ),
          ],
        ),
      ),
    );
  }
}


