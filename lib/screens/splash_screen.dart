
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'bottom_nav_page.dart';
import 'get_started_screen.dart';
import '../utills/assets.dart';
import '../utills/color_constant.dart';
import '../utills/secure_storage_service.dart';
import '../view_models/auth_view_model.dart';

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
                  GetStartedScreen.routeName,
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
