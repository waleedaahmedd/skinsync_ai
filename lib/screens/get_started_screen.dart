import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skinsync_ai/utills/assets.dart';
import 'package:skinsync_ai/utills/color_constant.dart';
import 'package:skinsync_ai/utills/custom_fonts.dart';
import 'package:skinsync_ai/widgets/login_bottom_sheet.dart';

class GetStartedScreen extends StatelessWidget {
  const GetStartedScreen({super.key});
  static const String routeName = '/GetStartedScreen';

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
                  color: Color(0xff88E3FB).withOpacity(0.7)
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(height: 60.h),
                    Text("Skinsync Ai", style: CustomFonts.grey20w500),
                    Text('Your Journey', style: CustomFonts.black50w600),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text('to ', style: CustomFonts.black50w600),
                        ShaderMask(
                          shaderCallback: (bounds) => LinearGradient(
                            colors: [
                              CustomColors.lightBlueColor, // Light blue
                              CustomColors.lightPurpleColor, // Light pink
                            ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ).createShader(bounds),
                          child: Text(
                            'Glowing Skin',
                            style: CustomFonts.white50w600,
                          ),
                        ),
                      ],
                    ),
                    Text('Starts Here!', style: CustomFonts.black50w600),
                    SizedBox(height: 37.2.h),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 19.h),
                          textStyle: CustomFonts.white22w600,
                          backgroundColor: Colors.black,

                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.r),
                          ),
                        ),
                        onPressed: () {
                          loginBottomSheet(context);
                        },
                        child: Text("Get Started"),
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
