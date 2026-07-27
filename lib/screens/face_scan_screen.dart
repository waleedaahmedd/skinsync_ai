import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'bottom_nav_page.dart';
import '../utills/assets.dart';
import '../utills/color_constant.dart';
import '../utills/custom_fonts.dart';

import 'face_pose_capture_screen.dart';
import 'bottom_nav_screens/face_detection_screen.dart';

class FaceScanScreen extends StatelessWidget {
  final String pose;
  const FaceScanScreen({super.key, this.pose = 'front'});
  static const String routeName = '/FaceScanScreen';

  @override
  Widget build(BuildContext context) {
    final bool isFront = pose == 'front';
    final bool isLeft = pose == 'left';

    final String faceAsset = isFront
        ? PngAssets.face
        : isLeft
            ? PngAssets.leftFace
            : PngAssets.rightFace;

    final String titleText = isFront
        ? "Face Scan"
        : isLeft
            ? "Left Profile Scan"
            : "Right Profile Scan";

    final String subTitleText = isFront
        ? "We’ll scan your face and create a cool model just for you to enhance your experience!"
        : isLeft
            ? "Capturing your left profile helps our AI understand your facial structure from every angle."
            : "Capturing your right profile completes your 3D model for the most accurate simulation.";

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        top: false,
        child: Container(
          decoration: BoxDecoration(
            gradient: CustomColors.blueWithWhiteGradient,
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
                  color: const Color(0xff88E3FB).withValues(alpha: 0.7),
                ),
              ),
              Positioned(
                top: 92.h,
                right: 0,
                left: 0,
                child: Image.asset(
                  faceAsset,
                  height: 599.h,
                  fit: isFront ? BoxFit.fitWidth : BoxFit.contain,
                  alignment: Alignment.topCenter,
                ),
              ),
              if (isFront)
                Positioned(
                  top: 215.h,
                  left: 0.w,
                  right: 0.w,
                  child: Image.asset(
                    PngAssets.faceMarks,
                    height: 300.w,
                    fit: BoxFit.fitHeight,
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
                    Text(titleText, style: CustomFonts.black30w600),
                    SizedBox(height: 2.h),
                    Text(subTitleText, style: CustomFonts.grey16w400),
                    SizedBox(height: 37.5.h),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (isFront && pose == 'front') {
                            Navigator.of(
                              context,
                            ).pushNamed(FacePoseCaptureScreen.routeName);
                          } else {
                            Navigator.of(context).pushNamed(
                              FaceDetectionScreen.routeName,
                              arguments: pose,
                            );
                          }
                        },
                        child: Text(
                          isFront && pose == 'front'
                              ? "Scan Your Face"
                              : "Start $titleText",
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    if (isFront && pose == 'front')
                      InkWell(
                        onTap: () {
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            BottomNavPage.routeName,
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
                          child: Center(
                            child: Text(
                              " Explore Clinics",
                              style: CustomFonts.black22w600,
                            ),
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
