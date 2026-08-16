import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../utils/assets.dart';
import '../utils/color_constant.dart';
import '../utils/custom_fonts.dart';
import '../widgets/custom_button.dart';
import 'biometric_screen.dart';

class GetNotifiedScreen extends StatelessWidget {
  const GetNotifiedScreen({super.key});
  static const String routeName = '/GetNotifiedScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.lightPurpleColor,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: context.w(30)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: context.h(123)),
            Container(
              height: context.h(79),
              width: context.w(79),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: Center(
                child: Image.asset(
                  PngAssets.notification,
                  height: context.h(50),
                  width: context.w(50),
                ),
              ),
            ),
            SizedBox(height: context.h(27)),
            Text("Get Notified", style: CustomFonts.black30w600),
            SizedBox(height: context.h(5)),
            Text(
              "Get timely reminders, skincare tips, promotions, and last-minute updates—all in one place.",
              style: CustomFonts.black18w400,
            ),
            SizedBox(height: context.h(64)),
            Image.asset(PngAssets.getNotified, height: context.h(320)),
            SizedBox(height: context.h(79)),
            SizedBox(
              width: double.infinity,
              child: CustomButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    BiometricScreen.routeName,
                    (Route<dynamic> route) => false,
                  );
                },
                text: "Turn On Notifications",
              ),
            ),
            SizedBox(height: context.h(19)),
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
