import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../view_models/bottom_nav_view_model.dart';
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

class _BottomNavPageState extends ConsumerState<BottomNavPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(bottomNavViewModel.notifier).changePage(0);
      ref.read(treatmentViewModel.notifier).init();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
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
                3 => const TreatmentJourneyScreen(),
                4 => const MyProfileScreen(),
                int() => throw UnimplementedError(),
              },
              if (index != 2)
                Positioned(
                  bottom: 110.h + MediaQuery.paddingOf(context).bottom,
                  child: const ScanFaceButton(),
                ),
            ],
          ),
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
          bottomNavigationBar: const BottomNavBar(),
        );
      },
    );
  }
}
