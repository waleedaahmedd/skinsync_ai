import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skinsync_ai/screens/get_started_screen.dart';
import 'package:skinsync_ai/utills/assets.dart';
import 'package:skinsync_ai/utills/color_constant.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _animate = false;
  final int _duration = 1000; // animation duration

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      setState(() {
        _animate = true; // start circle animation
      });

      await Future.delayed(Duration(milliseconds: _duration - 800));

      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const GetStartedScreen(), 
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              // Use ease-in curve
              var curve = Curves.easeIn;
              var curvedAnimation =
                  CurvedAnimation(parent: animation, curve: curve);
              return FadeTransition(
                opacity: curvedAnimation,
                child: child,
              );
            },
            transitionDuration: const Duration(milliseconds: 800),
          ),
        );
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

          Center(
            child: Image.asset(
              PngAssets.splashLogo,
              height: 169.h,
              width: 169.w,
            ),
          ),

          AnimatedPositioned(
            duration: Duration(milliseconds: _duration),
            top: _animate ? screenHeight : -362.r,
            left: _animate ? screenWidth : -362.r,
            child: CircleAvatar(
              radius: 362.r,
              backgroundColor: CustomColors.lightBlueColor,
            ),
          ),

          AnimatedPositioned(
            duration: Duration(milliseconds: _duration),
            bottom: _animate ? screenHeight : -362.r,
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
