import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skinsync_ai/route_generator.dart';
import 'package:skinsync_ai/screens/life_style_habbits.dart';
import 'package:skinsync_ai/screens/main_skin_concerns_screen.dart';
import 'package:skinsync_ai/screens/skin_allergies_screen.dart';
import 'package:skinsync_ai/screens/skin_goals_screen.dart';

import 'package:skinsync_ai/screens/skin_type.dart';
import 'package:skinsync_ai/utills/assets.dart';
import 'package:skinsync_ai/utills/color_constant.dart';
import 'package:skinsync_ai/utills/custom_fonts.dart';

class SignupOnboarding extends StatefulWidget {
  const SignupOnboarding({super.key});

  @override
  State<SignupOnboarding> createState() => _SignupOnboardingState();
}

class _SignupOnboardingState extends State<SignupOnboarding> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Only SkinType pages
  final List<Widget> _pages = [
    SkinType(),
    MainSkinConcernsScreen(),
    LifeStyleHabbits(),

    SkinAllergiesScreen(),
    SkinGoalsScreen(),
  ];

  int get _totalPages => _pages.length;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  void _goToPreviousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _skipOnboarding() {

    if (_currentPage < _totalPages - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );

    } else if(_currentPage == 4) {
      Navigator.pushNamed(context, profileScreen);
    } else {
      Navigator.of(context).pushReplacementNamed(bottomNavScreen);
    }
  }

  double get _progressValue {
    return (_currentPage + 1) / _totalPages;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 30.w),
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
                              '${_currentPage + 1}/$_totalPages',
                              style: CustomFonts.black20w600,
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10.r),
                                child: LinearProgressIndicator(
                                  value: _progressValue,
                                  minHeight: 10.h,
                                  backgroundColor: Colors.white,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    CustomColors.lightBlueColor,
                                  ),
                                ),
                              ),
                            ),
                            // SizedBox(width: 12.w),
                            // Container(
                            //   decoration: BoxDecoration(
                            //     shape: BoxShape.circle,
                            //     color: Colors.grey,
                            //   ),
                            //   child: Icon(
                            //     Icons.close,
                            //     size: 24.h,
                            //     color: Colors.grey.shade200,
                            //   ),
                            // ),
                          ],
                        ),
                        SizedBox(height: 16.h),

                        // Navigation Buttons Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _currentPage > 0
                                ? GestureDetector(
                                    onTap: () {
                                      _goToPreviousPage();
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
                                _skipOnboarding();
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
                      onPageChanged: _onPageChanged,
                      itemCount: _totalPages,
                      itemBuilder: (context, index) {
                        return _pages[index]; // only SkinType()
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      // bottomNavigationBar: Padding(
      //   padding: EdgeInsets.all(20.w),
      //   child: ElevatedButton(
      //     onPressed: _skipOnboarding,
      //     style: ElevatedButton.styleFrom(
      //       minimumSize: Size(double.infinity, 56.h),
      //       shape: RoundedRectangleBorder(
      //         borderRadius: BorderRadius.circular(12.r),
      //       ),
      //     ),
      //     child: Text(
      //       _currentPage == _totalPages - 1 ? 'Finish' : 'Next',
      //       style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
      //     ),
      //   ),
      // ),
    );
  }
}
