import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart';

import 'package:pinput/pinput.dart';
import 'package:skinsync_ai/route_generator.dart';
import 'package:skinsync_ai/screens/bottom_nav_screens/scan_your_face_screen.dart';
import 'package:skinsync_ai/screens/face_scan_screen.dart';
import 'package:skinsync_ai/screens/login_screen.dart';
import 'package:skinsync_ai/screens/signup_onboarding.dart';
import 'package:skinsync_ai/utills/assets.dart';
import 'package:skinsync_ai/utills/color_constant.dart';
import 'package:skinsync_ai/utills/custom_fonts.dart';
import 'package:skinsync_ai/utills/shared_pref.dart';
import 'package:skinsync_ai/view_models/auth_view_model.dart';
import 'package:skinsync_ai/view_models/sign_up_onboarding_view_model.dart';
import 'package:skinsync_ai/view_models/sign_up_onboarding_view_model.dart'
    as state;

class OtpScreen extends StatelessWidget {
  const OtpScreen({super.key});
  static const String routeName = '/OtpScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: CustomColors.iconColor,
              ),
              child: Icon(
                CupertinoIcons.arrow_left,
                size: 20.w,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),

      body: Padding(
        padding: EdgeInsets.only(
          left: 30.w,
          right: 30.w,
          bottom: MediaQuery.paddingOf(context).bottom,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 43.h),
            Container(
              padding: EdgeInsets.all(14.w),
              height: 79.h,
              width: 79.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: CustomColors.lightBlueColor,
              ),
              child: Image.asset(PngAssets.email, height: 50.h, width: 50.w),
            ),
            SizedBox(height: 27.h),
            Text("Enter Your Code", style: CustomFonts.black30w600),
            SizedBox(height: 4.h),
            Text(
              "We sent a verification code to your email",
              style: CustomFonts.grey18w400,
            ),
            SizedBox(height: 2.h),
            Consumer(
              builder: (context, ref, child) {
                final email = ref
                    .read(authViewModel.notifier)
                    .emailController
                    .text;
                return Text(email, style: CustomFonts.grey18w500);
              },
            ),
            SizedBox(height: 22.h),
            Consumer(
              builder: (context, ref, child) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Pinput(
                        controller: ref
                            .read(authViewModel.notifier)
                            .otpController,
                        mainAxisAlignment: MainAxisAlignment.center,
                        separatorBuilder: (index) => SizedBox(width: 4.w),
                        length: 6,
                        defaultPinTheme: PinTheme(
                          width: 82.w,
                          height: 55.h,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: CustomColors.textFeildBoaderColor,
                            ),
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          textStyle: TextStyle(
                            fontSize: 16.sp,
                            color: CustomColors.blackColor,
                          ),
                        ),
                        focusedPinTheme: PinTheme(
                          width: 82.5.w,
                          height: 55.h,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: CustomColors.textFeildBoaderColor,
                            ),
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          textStyle: TextStyle(
                            fontSize: 16.sp,
                            color: CustomColors.blackColor,
                          ),
                        ),
                        submittedPinTheme: PinTheme(
                          width: 82.5.w,
                          height: 55.h,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: CustomColors.textFeildBoaderColor,
                            ),
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          textStyle: TextStyle(
                            fontSize: 16.sp,
                            color: CustomColors.blackColor,
                          ),
                        ),
                        onChanged: (pin) {},
                        onCompleted: (pin) {},
                      ),
                    ),
                    if (ref.watch(authViewModel).otpError != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          ref.watch(authViewModel).otpError!,
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
            Spacer(),
            Consumer(
              builder: (context, ref, child) => SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    if (ref.read(authViewModel.notifier).validateOtp()) {
                      await ref
                          .read(authViewModel.notifier)
                          .callVerifyOtpApi()
                          .then((value) async {
                            if (value == true) {
                              bool? isLoggedIn =
                                  ref
                                      .read(authViewModel)
                                      .authResponse
                                      ?.data
                                      ?.isFirstLogin ??
                                  false;
                              isLoggedIn
                                  ? Navigator.pushNamedAndRemoveUntil(
                                      context,
                                      FaceScanScreen.routeName,
                                      (Route<dynamic> route) => false,
                                    )
                                  : Navigator.pushNamedAndRemoveUntil(
                                      context,
                                      SignupOnboarding.routeName,
                                      (Route<dynamic> route) =>
                                          route.settings.name ==
                                          LoginScreen.routeName,
                                    );
                            }
                          });
                    }
                  },
                  child: ref.watch(authViewModel).loading
                      ? CircularProgressIndicator()
                      : Text("Next"),
                ),
              ),
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}
