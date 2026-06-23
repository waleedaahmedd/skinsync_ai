import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'biometric_screen.dart';
import '../utills/assets.dart';
import '../utills/color_constant.dart';
import '../utills/custom_fonts.dart';

class GetNotifiedScreen extends StatelessWidget {
  const GetNotifiedScreen({super.key});
  static const String routeName = '/GetNotifiedScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.lightPurpleColor,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 123.h),
            Container(
              height: 79.h,
              width: 79.w,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: Center(
                child: Image.asset(
                  PngAssets.notification,
                  height: 50.h,
                  width: 50.w,
                ),
              ),
            ),
            SizedBox(height: 27.h),
            Text("Get Notified", style: CustomFonts.black30w600),
            SizedBox(height: 5.h),
            Text(
              "Get timely reminders, skincare tips, promotions, and last-minute updates—all in one place.",
              style: CustomFonts.black18w400,
            ),
            SizedBox(height: 64.h),
            Image.asset(PngAssets.getNotified, height: 320.h),
            SizedBox(height: 79.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                 Navigator.pushNamedAndRemoveUntil(
                  context,
                  BiometricScreen.routeName,
                  (Route<dynamic> route) => false,
                );
                },
                child: const Text("Turn On Notifications"),
              ),
            ),
            SizedBox(height: 19.h),
            GestureDetector(
              onTap: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  BiometricScreen.routeName,
                  (Route<dynamic> route) => false,
                );
              },
              child: Center(
                child: Text("Not Right Now", style: CustomFonts.grey22w500),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
