import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../screens/bottom_nav_page.dart';
import '../screens/face_scan_screen.dart';
import '../screens/login_screen.dart';
import '../utills/assets.dart';
import '../utills/biometric_helper.dart';
import '../utills/color_constant.dart';
import '../utills/custom_fonts.dart';
import '../utills/enums.dart';
import '../view_models/auth_view_model.dart';
import 'app_loader.dart';

void loginBottomSheet(BuildContext context) {
  showModalBottomSheet(
    backgroundColor: Colors.transparent,
    constraints: const BoxConstraints(minWidth: double.infinity),
    context: context,
    isScrollControlled: true,

    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(context.r(20))),
    ),
    builder: (context) {
      return SafeArea(
        child: Container(
          color: Colors.transparent,
          padding: EdgeInsets.only(
            top: context.h(10),
            left: context.w(10),
            right: context.w(10),
            bottom: context.h(10) + MediaQuery.viewInsetsOf(context).bottom,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(context.r(44)),
                topRight: Radius.circular(context.r(44)),
                bottomLeft: Radius.circular(context.r(55)),
                bottomRight: Radius.circular(context.r(55)),
              ),
            ),
            padding: EdgeInsets.symmetric(horizontal: context.w(20), vertical: context.h(28)),
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
                          fontSize: context.sp(30),
                          color: Colors.black,
                        ),
                      ),

                      SizedBox(height: context.h(4)),

                      Text(
                        "Smart skincare powered by AI.\nSign in to get personalized insights.",
                        style: TextStyle(
                          fontSize: context.sp(16),
                          fontWeight: FontWeight.w400,
                          color: const Color(0xff494949),
                        ),
                      ),
                      SizedBox(height: context.h(18)),
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
                      //       padding: EdgeInsets.symmetric(vertical: context.h(16)),
                      //       decoration: BoxDecoration(
                      //         borderRadius: BorderRadius.circular(context.r(10)),
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
                      // SizedBox(height: context.h(10)),
                      Consumer(
                        builder: (_, ref, _) {
                          final loading = ref.watch(
                            authViewModel.select((s) => s.loading),
                          );
                          if (loading) {
                            return const Center(
                              child: AppLoader()
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
                                      vertical: context.h(16),
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(context.r(10)),
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
                              SizedBox(height: context.h(10)),
                              _buildSocialSignIns(context, ref),
                              SizedBox(height: context.h(20)),

                              _buildBiometricButton(context, ref),
                            ],
                          );
                        },
                      ),

                      SizedBox(height: context.h(10)),
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

Row _buildSocialSignIns(BuildContext context, WidgetRef ref) {
  return Row(
    children: [
      Expanded(
        child: GestureDetector(
          onTap: () async {
            final success = await ref
                .read(authViewModel.notifier)
                .callGoogleSignInApi();
            if (success ?? false) {
              Navigator.pushNamedAndRemoveUntil(
                context,
                FaceScanScreen.routeName,
                (Route<dynamic> route) => false,
              );
            }
          },
          child: Container(
            padding: EdgeInsets.symmetric(vertical: context.h(16)),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(context.r(10)),
              color: CustomColors.greyColor,
            ),
            child: Center(
              child: Image.asset(
                PngAssets.google,
                height: context.h(32),
                width: context.w(32),
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
                context,
                FaceScanScreen.routeName,
                (Route<dynamic> route) => false,
              );
            }
          },
          child: Container(
            padding: EdgeInsets.symmetric(vertical: context.h(16)),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(context.r(10)),
              color: CustomColors.greyColor,
            ),
            child: Center(
              child: Image.asset(
                PngAssets.apple,
                height: context.h(32),
                width: context.w(32),
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

Widget _buildBiometricButton(BuildContext context, WidgetRef ref) {
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
        if (authenticated && context.mounted) {
          final success = await ref
              .read(authViewModel.notifier)
              .callBiometricLoginApi();

          if (success == true) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              BottomNavPage.routeName,
              (route) => false,
            );
          }
        }
      },
      child: Icon(state.biometricIcon, size: context.h(60)),
    ),
  );
}
