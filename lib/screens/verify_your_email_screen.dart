import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:pinput/pinput.dart';
import 'package:skinsync_ai/utills/color_constant.dart';

class VerifyYourEmailScreen extends StatelessWidget {
  const VerifyYourEmailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
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
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 24.h),
            Text(
              textAlign: TextAlign.center,
              "We just sent 5-digit code to sarah.jansen@gmail.com, enter it bellow:",
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
               
              ),
            ),
            SizedBox(height: 32.h),
            Text(
              "Enter OTP",
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
              
              ),
            ),
            SizedBox(height: 10.h),
            Center(
              child: Pinput(
                mainAxisAlignment: MainAxisAlignment.center,
                separatorBuilder: (index) => SizedBox(width: 4.w),
                length: 4,
                defaultPinTheme: PinTheme(
                  width: 82.w,
                  height: 48.h,
                  decoration: BoxDecoration(
                    color: CustomColors.textFeildBoaderColor,
                    border: Border.all(color:CustomColors.textFeildBoaderColor),
                    borderRadius: BorderRadius.circular(50.r),
                  ),
                  textStyle: TextStyle(fontSize: 16.sp),
                ),
                focusedPinTheme: PinTheme(
                  width: 82.5.w,
                  height: 48.h,
                  decoration: BoxDecoration(
                    color: CustomColors.textFeildBoaderColor,
                    border: Border.all(color: CustomColors.textFeildBoaderColor),
                    borderRadius: BorderRadius.circular(50.r),
                  ),
                  textStyle: TextStyle(fontSize: 16.sp),
                ),
                submittedPinTheme: PinTheme(
                  width: 82.5.w,
                  height: 48.h,
                  decoration: BoxDecoration(
                    color:CustomColors.textFeildBoaderColor,
                    border: Border.all(color:CustomColors.textFeildBoaderColor),
                    borderRadius: BorderRadius.circular(50.r),
                  ),
                  textStyle: TextStyle(fontSize: 16.sp),
                ),
                onChanged: (pin) {},
                onCompleted: (pin) {},
              ),
            ),
            SizedBox(height: 20.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Navigator.pushNamedAndRemoveUntil(
                  //   context,
                  //   createPasswordScreen,
                  //   ModalRoute.withName(addYourEmailScreen),
                  // );
                },
                child: Text("Verify email"),
              ),
            ),
            SizedBox(height: 20.h),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Wrong email? ",
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: CustomColors.textFeildBoaderColor,
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: Text(
                    "Send to different email",
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: CustomColors.textFeildBoaderColor,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
