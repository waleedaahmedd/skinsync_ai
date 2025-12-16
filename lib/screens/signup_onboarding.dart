import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:skinsync_ai/route_generator.dart';
import 'package:skinsync_ai/screens/life_style_habbits.dart';
import 'package:skinsync_ai/screens/main_skin_concerns_screen.dart';
import 'package:skinsync_ai/screens/skin_allergies_screen.dart';
import 'package:skinsync_ai/screens/skin_goals_screen.dart';

import 'package:skinsync_ai/screens/skin_type.dart';
import 'package:skinsync_ai/utills/assets.dart';
import 'package:skinsync_ai/utills/color_constant.dart';
import 'package:skinsync_ai/utills/custom_fonts.dart';
import 'package:skinsync_ai/view_models/sign_up_onboarding_view_model.dart';

class SignupOnboarding extends StatefulWidget {
  const SignupOnboarding({super.key});

  @override
  State<SignupOnboarding> createState() => _SignupOnboardingState();
}

class _SignupOnboardingState extends State<SignupOnboarding> {
  late final PageController _pageController;

  // Only SkinType pages
  final List<Widget> _pages = [
    SkinType(),
    MainSkinConcernsScreen(),
    LifeStyleHabbits(),
    SkinAllergiesScreen(),
    SkinGoalsScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final signupViewModel = context.read<SignUpOnboardingViewModel>();
        signupViewModel.setPageController(_pageController);
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final signupViewModel = context.watch<SignUpOnboardingViewModel>();
    
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(right: 30.w,left:30.w,bottom: MediaQuery.paddingOf(context).bottom,top: MediaQuery.paddingOf(context).top),
        decoration: BoxDecoration(
          gradient: CustomColors.blueWhitePurpleGradient,
        ),
        child: Stack(
          children: [
            Positioned(
              top: -40,
              left: 0,
              right: 0,
              child: Opacity(
                opacity: 0.5,
                child: SizedBox(
                  width: double.infinity,
                  height: 201.h,
                  child: Image.asset(PngAssets.signupVector),
                ),
              ),
            ),
            Column(
              children: [
                SizedBox(height: 28.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 00.w),
                  child: Column(
                    children: [
                      // Progress Bar
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${signupViewModel.currentPage + 1}/${SignUpOnboardingViewModel.totalPages}',
                            style: CustomFonts.black20w600,
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10.r),
                              child: LinearProgressIndicator(
                                value: signupViewModel.progressValue(),
                                minHeight: 10.h,
                                backgroundColor: Colors.white,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  CustomColors.lightBlueColor,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),
      
                      // Navigation Buttons Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          signupViewModel.currentPage > 0
                              ? GestureDetector(
                                  onTap: () {
                                    signupViewModel.goToPreviousPage();
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 8.w,
                                      vertical: 10.h,
                                    ),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: CustomColors.purpleColor,
                                    ),
                                    child: Icon(
                                      CupertinoIcons.arrow_left,
                                      size: 18.sp,
                                      color: Colors.white,
                                    ),
                                  ),
                                )
                              : SizedBox(),
                          GestureDetector(
                            onTap: () {
                              signupViewModel.skipOnboarding(
                                context,
                              
                              );
                            },
                            child: Row(
                              children: [
                                Text(
                                  'Skip This',
                                  style: CustomFonts.black16w400,
                                ),
                                SizedBox(width: 8.w),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8.w,
                                    vertical: 10.h,
                                  ),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: CustomColors.purpleColor,
                                  ),
                                  child: Icon(
                                    CupertinoIcons.arrow_right,
                                    size: 18.sp,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
      
                // PageView
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) => signupViewModel.onPageChanged(index),
                    itemCount: SignUpOnboardingViewModel.totalPages,
                    itemBuilder: (context, index) {
                      return _pages[index];
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
