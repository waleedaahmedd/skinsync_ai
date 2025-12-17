import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import 'package:pinput/pinput.dart';
import 'package:skinsync_ai/route_generator.dart';
import 'package:skinsync_ai/screens/signup_onboarding.dart';
import 'package:skinsync_ai/utills/assets.dart';
import 'package:skinsync_ai/utills/color_constant.dart';
import 'package:skinsync_ai/utills/custom_fonts.dart';

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
        padding: EdgeInsets.only(left: 30.w,right: 30.w, bottom: MediaQuery.paddingOf(context).bottom),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 43.h),
            Container(
              padding: EdgeInsets.all(14.w),
              height: 79.h, width: 79.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: CustomColors.lightBlueColor
              ),
              child: Image.asset(PngAssets.email, height: 50.h, width: 50.w)),
            SizedBox(height: 27.h),
            Text("Enter Your Code", style: CustomFonts.black30w600),
            SizedBox(height: 4.h),
            Text(
              "We sent a verification code to your email",
              style: CustomFonts.grey18w400,
            ),
            SizedBox(height: 2.h),
            Text("jhonsmith@gmail.com", style: CustomFonts.grey18w500),
            SizedBox(height: 22.h),
            Center(
              child: Pinput(
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
                   textStyle: TextStyle(fontSize: 16.sp,color: CustomColors.blackColor),
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
                  textStyle: TextStyle(fontSize: 16.sp,color: CustomColors.blackColor),
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
                  textStyle: TextStyle(fontSize: 16.sp,color: CustomColors.blackColor),
                ),
                onChanged: (pin) {},
                onCompleted: (pin) {},
              ),
            ),
            Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(onPressed: () {
                Navigator.pushNamed(context, SignupOnboarding.routeName);
              }, child: Text("Next"))),
              SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}
