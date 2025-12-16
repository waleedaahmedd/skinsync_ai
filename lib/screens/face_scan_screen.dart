import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skinsync_ai/route_generator.dart';
import 'package:skinsync_ai/utills/assets.dart';
import 'package:skinsync_ai/utills/color_constant.dart';
import 'package:skinsync_ai/utills/custom_fonts.dart';
import 'package:skinsync_ai/widgets/login_bottom_sheet.dart';

class FaceScanScreen extends StatelessWidget {
  const FaceScanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        top: false,
        child: Container(
          decoration: BoxDecoration(
            gradient: CustomColors.BlueWithWhiteGradient,
          ),
          child: Stack(
            children: [
              Positioned(
                top: 70.h,
                right: 0.w,
                left: 0.w,
                child: Image.asset(
                  PngAssets.vector2,
                  height: 552.h,
                  fit: BoxFit.fill,
                ),
              ),
              Positioned(
                top: 70.h,
                right: 0.w,
                left: 0.w,
                child: Image.asset(
                  PngAssets.vector,
                  height: 376.h,
                  fit: BoxFit.fill,
                  color: Color(0xff88E3FB).withOpacity(0.7),
                ),
              ),

              Positioned(
                top: 92.h,
                right: 0,
                left: 0,

                child: Image.asset(
                  PngAssets.face,
                  height: 599.h,
                  fit: BoxFit.fitWidth,
                ),
              ),

              Positioned(
                top: 180.h,
                left: 25.w,
                child: Image.asset(
                  PngAssets.faceMarks,
                  height: 339.h,
                  fit: BoxFit.fitWidth,
                ),
              ),
              Positioned(
                top: 432.h,
                child: Image.asset(PngAssets.blur, height: 564.h),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(height: 60.h),

                    Text('Face Scan', style: CustomFonts.black30w600),
                    SizedBox(height: 2.h),
                    Text(
                      "We’ll scan your face and create a cool model just for you to enhance your experience!",
                      style: CustomFonts.grey16w400,
                    ),

                    SizedBox(height: 37.5.h),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed(scanYourFace);
                        },
                        child: Text("Scan Your Face"),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    InkWell(
                      onTap: () {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          bottomNavPage,
                          (route) => false,
                        );
                      },
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          horizontal: 121.w,
                          vertical: 19.h,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(width: 1.w, color: Colors.black),
                          borderRadius: BorderRadius.circular(50.r),
                        ),
                        child: Text(
                          " Explore Clinics",
                          style: CustomFonts.black22w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
