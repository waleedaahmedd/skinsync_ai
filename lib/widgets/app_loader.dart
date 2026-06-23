import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../utills/color_constant.dart';

import '../utills/assets.dart';

class AppLoader extends StatelessWidget {
  const AppLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 60.w,
        width: 60.w,
        child: Stack(
          children: [
            Center(
              child: Image.asset(
                PngAssets.splashLogo,
                width: 50.w,
                height: 50.w,
              ),
            ),
            SizedBox(
              height: 60.w,
              width: 60.w,
              child: const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(
                  CustomColors.lightPurpleColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
