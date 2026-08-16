import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../utils/assets.dart';
import '../utils/color_constant.dart';
import '../utils/custom_fonts.dart';
import '../widgets/custom_bordered_button.dart';
import '../widgets/custom_button.dart';
import 'bottom_nav_page.dart';
import 'bottom_nav_screens/face_detection_screen.dart';
import 'face_pose_capture_screen.dart';

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
                top: context.h(70),
                right: context.w(0),
                left: context.w(0),
                child: Image.asset(
                  PngAssets.vector2,
                  height: context.h(552),
                  fit: BoxFit.fill,
                ),
              ),
              Positioned(
                top: context.h(70),
                right: context.w(0),
                left: context.w(0),
                child: Image.asset(
                  PngAssets.vector,
                  height: context.h(376),
                  fit: BoxFit.fill,
                  color: const Color(0xff88E3FB).withValues(alpha: 0.7),
                ),
              ),
              Positioned(
                top: context.h(92),
                right: 0,
                left: 0,
                child: Image.asset(
                  faceAsset,
                  height: context.h(599),
                  fit: isFront ? BoxFit.fitWidth : BoxFit.contain,
                  alignment: Alignment.topCenter,
                ),
              ),
              if (isFront)
                Positioned(
                  top: context.h(215),
                  left: context.w(0),
                  right: context.w(0),
                  child: Image.asset(
                    PngAssets.faceMarks,
                    height: context.w(300),
                    fit: BoxFit.fitHeight,
                  ),
                ),
              Positioned(
                top: context.h(432),
                child: Image.asset(PngAssets.blur, height: context.h(564)),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: context.w(20),
                  vertical: context.h(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(height: context.h(60)),
                    Text(titleText, style: CustomFonts.black30w600),
                    SizedBox(height: context.h(2)),
                    Text(subTitleText, style: CustomFonts.grey16w400),
                    SizedBox(height: context.h(37.5)),
                    SizedBox(
                      width: double.infinity,
                      child: CustomButton(
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
                        text: isFront && pose == 'front'
                            ? "Scan Your Face"
                            : "Start $titleText",
                      ),
                    ),
                    SizedBox(height: context.h(20)),
                    if (isFront && pose == 'front')
                      CustomBorderedButton(
                        text: " Explore Clinics",
                        onPressed: () {
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            BottomNavPage.routeName,
                            (route) => false,
                          );
                        },
                      ),

                    // InkWell(
                    //   onTap: () {
                    //     Navigator.pushNamedAndRemoveUntil(
                    //       context,
                    //       BottomNavPage.routeName,
                    //       (route) => false,
                    //     );
                    //   },
                    //   child: Container(
                    //     width: double.infinity,
                    //     padding: EdgeInsets.symmetric(
                    //       horizontal: context.w(121),
                    //       vertical: context.h(19),
                    //     ),
                    //     decoration: BoxDecoration(
                    //       border: Border.all(
                    //         width: context.w(1),
                    //         color: Colors.black,
                    //       ),
                    //       borderRadius: BorderRadius.circular(context.r(50)),
                    //     ),
                    //     child: Center(
                    //       child: Text(
                    //         " Explore Clinics",
                    //         style: CustomFonts.black22w600,
                    //       ),
                    //     ),
                    //   ),
                    // ),
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
