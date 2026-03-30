import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skinsync_ai/screens/bottom_nav_page.dart';
import 'package:skinsync_ai/screens/get_started_screen.dart';
import 'package:skinsync_ai/screens/your_profile_screen.dart';

import 'package:skinsync_ai/utills/assets.dart';
import 'package:skinsync_ai/utills/color_constant.dart';
import 'package:skinsync_ai/utills/secure_storage_service.dart';
import 'package:skinsync_ai/utills/shared_pref.dart';

import 'package:skinsync_ai/view_models/auth_view_model.dart';

import '../utills/enums.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});
  static const String routeName = '/';

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  bool _animate = false;
  final int _duration = 1000; // animation duration

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(const Duration(milliseconds: 1000));
      setState(() {
        _animate = true;
      });

      await Future.delayed(Duration(milliseconds: _duration - 800));

      if (mounted) {
        final isBioMetricEnabled =
            SharedPref().readBool(
              SharedPreferencesKeys.biometricAuthKey.keyText,
            ) ??
            false;
        if (isBioMetricEnabled) {
          Navigator.of(context).pushReplacement(
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  const GetStartedScreen(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                    // Use ease-in curve
                    var curve = Curves.easeIn;
                    var curvedAnimation = CurvedAnimation(
                      parent: animation,
                      curve: curve,
                    );
                    return FadeTransition(
                      opacity: curvedAnimation,
                      child: child,
                    );
                  },
              transitionDuration: const Duration(milliseconds: 900),
            ),
          );
        } else {
          final token = SecureStorage().cachedAuthToken;

          if (token != null) {
            ref.read(authViewModel.notifier).callGetMe().then((value) {
              if (value == true) {
                final islogin = ref
                    .read(authViewModel)
                    .authResponse
                    ?.data
                    ?.isFirstLogin;
                if (islogin == false) {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    BottomNavPage.routeName,
                    (Route<dynamic> route) => false,
                  );
                } else {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    YourProfileScreen.routeName,
                    (Route<dynamic> route) => false,
                  );
                }
              } else {
                Navigator.of(context).pushReplacement(
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        const GetStartedScreen(),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                          // Use ease-in curve
                          var curve = Curves.easeIn;
                          var curvedAnimation = CurvedAnimation(
                            parent: animation,
                            curve: curve,
                          );
                          return FadeTransition(
                            opacity: curvedAnimation,
                            child: child,
                          );
                        },
                    transitionDuration: const Duration(milliseconds: 900),
                  ),
                );
              }
            });
          } else {
            // Navigator.pushNamedAndRemoveUntil(
            //   context,
            //   BottomNavPage.routeName,
            //   (Route<dynamic> route) => false,
            // );
            Navigator.of(context).pushReplacement(
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    const GetStartedScreen(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                      // Use ease-in curve
                      var curve = Curves.easeIn;
                      var curvedAnimation = CurvedAnimation(
                        parent: animation,
                        curve: curve,
                      );
                      return FadeTransition(
                        opacity: curvedAnimation,
                        child: child,
                      );
                    },
                transitionDuration: const Duration(milliseconds: 900),
              ),
            );
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: CustomColors.purpleBlueGradient,
            ),
          ),

          AnimatedOpacity(
            opacity: _animate ? 0.0 : 1.0,
            duration: Duration(milliseconds: 400),
            curve: Curves.easeInOut,
            child: Center(
              child: Image.asset(
                PngAssets.splashLogo,
                height: 169.h,
                width: 169.w,
              ),
            ),
          ),

          AnimatedPositioned(
            duration: Duration(milliseconds: _duration),
            top: _animate ? screenHeight : -screenHeight,
            left: _animate ? screenWidth : -362.r,
            child: CircleAvatar(
              radius: 362.r,
              backgroundColor: CustomColors.lightBlueColor,
            ),
          ),

          AnimatedPositioned(
            duration: Duration(milliseconds: _duration),
            bottom: _animate ? screenHeight : -screenHeight,
            right: _animate ? screenWidth : -362.r,
            child: CircleAvatar(
              radius: 362.r,
              backgroundColor: CustomColors.lightPurpleColor,
            ),
          ),
        ],
      ),
    );
  }
}
