import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../utills/assets.dart';
import '../utills/color_constant.dart';
import '../utills/secure_storage_service.dart';
import '../view_models/auth_view_model.dart';
import 'bottom_nav_page.dart';
import 'get_started_screen.dart';
import 'update_version_screen.dart';

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
        // final isBioMetricEnabled =
        //     SharedPref().readBool(
        //       SharedPreferencesKeys.biometricEnabledKey.keyText,
        //     ) ??
        //     false;
        // if (isBioMetricEnabled) {
        //   Navigator.of(context).pushReplacement(
        //     PageRouteBuilder(
        //       pageBuilder: (context, animation, secondaryAnimation) =>
        //           const GetStartedScreen(),
        //       transitionsBuilder:
        //           (context, animation, secondaryAnimation, child) {
        //             // Use ease-in curve
        //             var curve = Curves.easeIn;
        //             var curvedAnimation = CurvedAnimation(
        //               parent: animation,
        //               curve: curve,
        //             );
        //             return FadeTransition(
        //               opacity: curvedAnimation,
        //               child: child,
        //             );
        //           },
        //       transitionDuration: const Duration(milliseconds: 900),
        //     ),
        //   );
        // } else {
        final token = await SecureStorage().getToken();

        if (token != null) {
          ref.read(authViewModel.notifier).callGetMe().then((authData) async {
            if (authData != null) {
              final isUpdateAvailable = await authData.isUpdateAvailable();
              if (isUpdateAvailable) {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  UpdateVersionScreen.routeName,
                  (route) => false,
                );
                return;
              }
              final isLogin = authData.isFirstLogin;
              if (isLogin ?? false) {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  GetStartedScreen.routeName,
                  (_) => false,
                );
              } else {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  BottomNavPage.routeName,
                  (_) => false,
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
            decoration: const BoxDecoration(
              gradient: CustomColors.purpleBlueGradient,
            ),
          ),

          AnimatedOpacity(
            opacity: _animate ? 0.0 : 1.0,
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
            child: Center(
              child: Image.asset(
                PngAssets.splashLogo,
                height: context.h(169),
                width: context.w(169),
              ),
            ),
          ),

          AnimatedPositioned(
            duration: Duration(milliseconds: _duration),
            top: _animate ? screenHeight : -screenHeight,
            left: _animate ? screenWidth : -context.r(362),
            child: CircleAvatar(
              radius: context.r(362),
              backgroundColor: CustomColors.lightBlueColor,
            ),
          ),

          AnimatedPositioned(
            duration: Duration(milliseconds: _duration),
            bottom: _animate ? screenHeight : -screenHeight,
            right: _animate ? screenWidth : -context.r(362),
            child: CircleAvatar(
              radius: context.r(362),
              backgroundColor: CustomColors.lightPurpleColor,
            ),
          ),
        ],
      ),
    );
  }
}
