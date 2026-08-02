import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../utills/assets.dart';
import '../utills/color_constant.dart';

class AppLoader extends StatelessWidget {
  final double? size;
  const AppLoader({super.key, this.size});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: size ?? context.w(60),
        width: size ?? context.w(60),
        child: Stack(
          children: [
            Center(
              child: Image.asset(
                PngAssets.splashLogo,
                width: context.w(50),
                height: context.w(50),
              ),
            ),
            SizedBox(
              height: context.w(60),
              width: context.w(60),
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
