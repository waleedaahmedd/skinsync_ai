import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../screens/bottom_nav_page.dart';
import '../screens/login_screen.dart';
import '../utills/assets.dart';
import '../utills/biometric_helper.dart';
import '../utills/color_constant.dart';
import '../utills/custom_fonts.dart';
import '../utills/enums.dart';
import '../view_models/auth_view_model.dart';

import '../screens/face_scan_screen.dart';

void loginBottomSheet(BuildContext context) {
  showModalBottomSheet(
    backgroundColor: Colors.transparent,
    constraints: const BoxConstraints(minWidth: double.infinity),
    context: context,
    isScrollControlled: true,

    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
    ),
    builder: (context) {
      return SafeArea(
        child: Container(
          color: Colors.transparent,
          padding: EdgeInsets.only(
            top: 10.h,
            left: 10.w,
            right: 10.w,
            bottom: 10.h + MediaQuery.viewInsetsOf(context).bottom,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(44.r),
                topRight: Radius.circular(44.r),
                bottomLeft: Radius.circular(55.r),
                bottomRight: Radius.circular(55.r),
              ),
            ),
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 28.h),
            child: SingleChildScrollView(
              child: Consumer(
                builder: (context, ref, _) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Text(
                        "Get Started",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 30.sp,
                          color: Colors.black,
                        ),
                      ),

                      SizedBox(height: 4.h),

                      Text(
                        "Smart skincare powered by AI.\nSign in to get personalized insights.",
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xff494949),
                        ),
                      ),
                      SizedBox(height: 18.h),
                      // SizedBox(
                      //   width: double.infinity,
                      //   child: InkWell(
                      //     onTap: () {
                      //       ref.read(authViewModel.notifier).clearData();
                      //       // Navigator.pushNamed(context, loginScreen);
                      //       Navigator.of(context).pushReplacement(
                      //         PageRouteBuilder(
                      //           pageBuilder:
                      //               (context, animation, secondaryAnimation) =>
                      //                   const LoginScreen(
                      //                     loginWith: LoginProviders.phone,
                      //                   ),
                      //           transitionsBuilder:
                      //               (
                      //                 context,
                      //                 animation,
                      //                 secondaryAnimation,
                      //                 child,
                      //               ) {
                      //                 // Use ease-in curve
                      //                 var curve = Curves.easeIn;
                      //                 var curvedAnimation = CurvedAnimation(
                      //                   parent: animation,
                      //                   curve: curve,
                      //                 );
                      //                 return FadeTransition(
                      //                   opacity: curvedAnimation,
                      //                   child: child,
                      //                 );
                      //               },
                      //           transitionDuration: const Duration(
                      //             milliseconds: 500,
                      //           ),
                      //         ),
                      //       );
                      //     },
                      //     child: Container(
                      //       padding: EdgeInsets.symmetric(vertical: 16.h),
                      //       decoration: BoxDecoration(
                      //         borderRadius: BorderRadius.circular(10.r),
                      //         color: Colors.black,
                      //       ),
                      //       child: Center(
                      //         child: Text(
                      //           "Continue With Phone",
                      //           style: CustomFonts.white18w600,
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      // SizedBox(height: 10.h),
                      Consumer(
                        builder: (_, ref, _) {
                          final loading = ref.watch(
                            authViewModel.select((s) => s.loading),
                          );
                          if (loading) {
                            return const Center(
                              child: CircularProgressIndicator(
                                color: CustomColors.pinkColor,
                              ),
                            );
                          }
                          return Column(
                            children: [
                              SizedBox(
                                width: double.infinity,
                                child: InkWell(
                                  onTap: () {
                                    ref
                                        .read(authViewModel.notifier)
                                        .clearData();
                                    Navigator.pushNamed(
                                      context,
                                      LoginScreen.routeName,
                                      arguments: LoginProviders.email,
                                    );
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 16.h,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.r),
                                      color: CustomColors.greyColor,
                                    ),
                                    child: Center(
                                      child: Text(
                                        "Continue With Email",
                                        style: CustomFonts.black18w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10.h),
                              _buildSocialSignIns(ref),
                              SizedBox(height: 20.h),

                              _buildBiometricButton(ref),
                            ],
                          );
                        },
                      ),

                      SizedBox(height: 10.h),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      );
    },
  );
}

Row _buildSocialSignIns(WidgetRef ref) {
  return Row(
    children: [
      Expanded(
        child: GestureDetector(
          onTap: () async {
            final success = await ref
                .read(authViewModel.notifier)
                .callGoogleSignInApi();
            if (success ?? false) {
              /* bool? isLoggedIn =
                  ref.read(authViewModel).authResponse?.data?.isFirstLogin ??
                  false;
              isLoggedIn
                  ? Navigator.pushNamedAndRemoveUntil(
                      ref.context,
                      SignupOnboarding.routeName,
                      (Route<dynamic> route) =>
                          route.settings.name == LoginScreen.routeName,
                    )
                  : */
              Navigator.pushNamedAndRemoveUntil(
                      ref.context,
                      FaceScanScreen.routeName,
                      (Route<dynamic> route) => false,
                    );
            }
          },
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 16.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.r),
              color: CustomColors.greyColor,
            ),
            child: Center(
              child: Image.asset(
                PngAssets.google,
                height: 32.h,
                width: 32.w,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ),
      const SizedBox(width: 8),
      Expanded(
        child: GestureDetector(
          onTap: () async {
            final success = await ref
                .read(authViewModel.notifier)
                .callAppleSignInApi();
            if (success ?? false) {
             /* bool? isLoggedIn =
                  ref.read(authViewModel).authResponse?.data?.isFirstLogin ??
                  false;
              isLoggedIn
                  ? Navigator.pushNamedAndRemoveUntil(
                      ref.context,
                      SignupOnboarding.routeName,
                      (Route<dynamic> route) =>
                          route.settings.name == LoginScreen.routeName,
                    )
                  : */
                  Navigator.pushNamedAndRemoveUntil(
                      ref.context,
                      FaceScanScreen.routeName,
                      (Route<dynamic> route) => false,
                    );
            }
          },
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 16.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.r),
              color: CustomColors.greyColor,
            ),
            child: Center(
              child: Image.asset(
                PngAssets.apple,
                height: 32.h,
                width: 32.w,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ),
    ],
  );
}

// lib/widgets/login_bottom_sheet.dart

Widget _buildBiometricButton(WidgetRef ref) {
  final state = ref.watch(authViewModel);

  // Decides whether to show the button based on state
  if (!state.isBiometricAvailable || state.biometricIcon == null) {
    return const SizedBox.shrink();
  }

  return Center(
    child: InkWell(
      onTap: () async {
        bool authenticated = await BiometricHelper().authenticate(
          reason: 'Login with Biometrics',
        );
        if (authenticated && ref.context.mounted) {
          final success = await ref
              .read(authViewModel.notifier)
              .callBiometricLoginApi();

          if (success == true) {
            Navigator.pushNamedAndRemoveUntil(
              ref.context,
              BottomNavPage.routeName,
              (route) => false,
            );
          }
        }
      },
      child: Icon(state.biometricIcon, size: 60.h),
    ),
  );
}
