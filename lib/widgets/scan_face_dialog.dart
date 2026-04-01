import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skinsync_ai/screens/bottom_nav_page.dart';
import 'package:skinsync_ai/screens/bottom_nav_screens/face_detection_screen.dart';
import 'package:skinsync_ai/screens/explore_clinics_screen.dart';
import 'package:skinsync_ai/utills/custom_fonts.dart';

void showMScanFaceDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: true, // tap outside to close
    builder: (context) {
      return Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
                 Text(
                "Get Started",
                style: CustomFonts.black24w600
              ),

              SizedBox(height: 10.h),

              // 🔹 Description
              Text(
                "Scan your face to get personalized skin analysis or explore nearby clinics for professional treatments.",
                textAlign: TextAlign.center,
                  style: CustomFonts.grey14w400
              ),

              SizedBox(height: 25),
              // Button 1
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // close dialog
                    Navigator.of(context).pushNamed(
                      FaceDetectionScreen.routeName,
                    );
                  },
                  child: Text("Scan Your Face"),
                ),
              ),

              SizedBox(height: 20.h),

              // Button 2
              InkWell(
                onTap: () {
                  Navigator.pop(context); // close dialog
                  Navigator.pushNamed(
                    context,
                    ExploreClinicsScreen.routeName,
                    
                  );
                },
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 15,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Center(
                    child: Text(
                      "Explore Clinics",
                      style:CustomFonts.black18w600  
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}