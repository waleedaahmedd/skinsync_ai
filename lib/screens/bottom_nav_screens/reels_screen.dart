import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../../view_models/explore_view_model.dart';
import '../../view_models/reels_view_model.dart';
import '../../widgets/reel_card.dart';
import '../../widgets/social_toggle_button.dart';

class ReelsScreen extends ConsumerStatefulWidget {
  const ReelsScreen({super.key});

  static const String routeName = '/ReelsScreen';

  @override
  ConsumerState<ReelsScreen> createState() => _ReelsScreenState();
}

class _ReelsScreenState extends ConsumerState<ReelsScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;
  // int _selectedTab = 1; // 0: Following, 1: For You, 2: Nearby

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(reelsViewModel);

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            // Infinite Vertical PageView
            PageView.builder(
              controller: _pageController,
              scrollDirection: Axis.vertical,
              itemCount: state.reels.length,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              itemBuilder: (context, index) {
                return ReelCard(
                  reel: state.reels[index],
                  isActive: _currentIndex == index,
                );
              },
            ),

            // Header with Icons and Tabs
            SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: context.w(12),
                  vertical: context.h(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // SocialToggleButton(
                    //   onTap: () => Navigator.pop(context),
                    //   icon: Icons.arrow_back_ios_new_rounded,
                    //   isReels: true,
                    // ),

                    // Search Icon (Top Left)
                    // GestureDetector(
                    //   onTap: () {},
                    //   child: Padding(
                    //     padding: EdgeInsets.all(context.r(8)),
                    //     child: Icon(Icons.search_rounded, color: Colors.white, size: context.sp(26)),
                    //   ),
                    // ),

                    // Tabs (Center)
                    // Row(
                    //   children: [
                    //     _buildTab("Following", 0),
                    //     Padding(
                    //       padding: EdgeInsets.symmetric(horizontal: context.w(8)),
                    //       child: Text("|", style: CustomFonts.white14w400.copyWith(color: Colors.white38)),
                    //     ),
                    //     _buildTab("For You", 1),
                    //     Padding(
                    //       padding: EdgeInsets.symmetric(horizontal: context.w(8)),
                    //       child: Text("|", style: CustomFonts.white14w400.copyWith(color: Colors.white38)),
                    //     ),
                    //     _buildTab("Nearby", 2),
                    //   ],
                    // ),

                    // Right Actions (Plus & Toggle)
                    Row(
                      children: [
                        // GestureDetector(
                        //   onTap: () {
                        //     Navigator.push(
                        //       context,
                        //       MaterialPageRoute(builder: (context) => const CreatePostScreen()),
                        //     );
                        //   },
                        //   child: Padding(
                        //     padding: EdgeInsets.all(context.r(8)),
                        //     child: Icon(Icons.add_box_outlined, color: Colors.white, size: context.sp(26)),
                        //   ),
                        // ),
                        SizedBox(width: context.w(4)),
                        SocialToggleButton(
                          onTap: () => ref
                              .read(exploreViewModel.notifier)
                              .toggleViewType(),
                          icon: Icons.grid_view_rounded,
                          isReels: true,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget _buildTab(String title, int index) {
  //   bool isSelected = _selectedTab == index;
  //   return GestureDetector(
  //     onTap: () {
  //       setState(() {
  //         _selectedTab = index;
  //       });
  //     },
  //     child: Column(
  //       mainAxisSize: MainAxisSize.min,
  //       children: [
  //         Text(
  //           title,
  //           style: CustomFonts.white16w600.copyWith(
  //             color: isSelected ? Colors.white : Colors.white70,
  //             fontSize: isSelected ? context.sp(16) : context.sp(15),
  //           ),
  //         ),
  //         if (isSelected)
  //           Container(
  //             margin: EdgeInsets.only(top: context.h(4)),
  //             height: context.h(2),
  //             width: context.w(20),
  //             decoration: BoxDecoration(
  //               color: Colors.white,
  //               borderRadius: BorderRadius.circular(context.r(2)),
  //             ),
  //           ),
  //       ],
  //     ),
  //   );
  // }
}
