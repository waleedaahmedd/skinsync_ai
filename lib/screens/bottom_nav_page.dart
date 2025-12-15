import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:skinsync_ai/screens/bottom_nav_screens/my_profile_screen.dart';
import 'package:skinsync_ai/screens/bottom_nav_bar.dart';

import 'package:skinsync_ai/screens/home_screen.dart';
import 'package:skinsync_ai/screens/skin_type.dart';

import '../view_models/bottom_nav_view_model.dart';


class BottomNavPage extends StatelessWidget {
  const BottomNavPage({super.key});

  static final List<Widget> _children = [
    HomeScreen(),
     HomeScreen(),
      HomeScreen(),
       HomeScreen(),
       MyProfileScreen(),
    // HomeScreen(),
    // ChangeNotifierProvider(
    //   lazy: true,
    //   create: (context) => VisitsViewModel(),
    //   child: VisitsScreen(),
    // ),
    // RiderOnTheWayScreen(),
    // ChatListScreen(),
    // SettingScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<BottomNavViewModel>(
      builder: (context, provider, child) {
        return Scaffold(
          body: _children[provider.currentPage],
          extendBody: true,
          // floatingActionButton: Visibility(
          //   visible: MediaQuery.viewInsetsOf(context).bottom == 0,
          //   child: SizedBox(
          //     height: 55.h,
          //     width: 55.h,
          //     child: InkWell(
          //       onTap: () {
          //         Navigator.pushNamed(context, selectServiceScreen);
          //       },
          //       child: Card(
          //         color: AppColors.kPrimaryColor,
          //         elevation: 0,
          //         shape: RoundedRectangleBorder(
          //           borderRadius: BorderRadius.circular(100),
          //           side: BorderSide(color: Colors.white, width: 3.r),
          //         ),
          //         child: Icon(Icons.add, size: 24.sp, color: Colors.white),
          //       ),
          //     ),
          //   ),
          // ),
          // floatingActionButtonLocation:
          //     FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: BottomNavBar(),
        );
      },
    );
  }
}
