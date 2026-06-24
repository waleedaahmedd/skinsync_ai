import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skinsync_ai/screens/bottom_nav_screens/face_detection_screen.dart';
import 'package:skinsync_ai/screens/explore_clinics_screen.dart';
import 'package:skinsync_ai/utills/color_constant.dart';
import 'package:skinsync_ai/utills/custom_fonts.dart';

import '../view_models/treatment_view_model.dart';

void showMScanFaceDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: true, // tap outside to close
    builder: (context) {
      return Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.r),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Beautiful Branded Icon Badge
              Container(
                height: 72.w,
                width: 72.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: CustomColors.purpleColor.withValues(alpha: 0.15),
                ),
                child: Center(
                  child: Icon(
                    Icons.face_retouching_natural_rounded,
                    size: 32.sp,
                    color: CustomColors.darkPurple,
                  ),
                ),
              ),
              SizedBox(height: 24.h),

              Text("Get Started", style: CustomFonts.black24w600),
              SizedBox(height: 12.h),

              // Description
              Text(
                "Scan your face to get personalized skin analysis or explore nearby clinics for professional treatments.",
                textAlign: TextAlign.center,
                style: CustomFonts.textGrey14w400,
              ),
              SizedBox(height: 28.h),

              // Button 1: Scan Face (Primary Black Button)
              SizedBox(
                width: double.infinity,
                height: 52.h,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // close dialog
                    Navigator.of(context).pushNamed(FaceDetectionScreen.routeName);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: EdgeInsets.zero, // Zero padding prevents vertical text clipping
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(26.r),
                    ),
                    elevation: 1,
                  ),
                  child: Text(
                    "Scan Your Face",
                    style: CustomFonts.white16w600,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              SizedBox(height: 12.h),

              // Button 2: Explore Clinics (Secondary Outlined Button)
              Consumer(
                builder: (_, ref, __) {
                  return SizedBox(
                    width: double.infinity,
                    height: 50.h,
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        final state = ref.read(treatmentViewModel);
                        final treatment = state.selectedTreatment;
                        final sideAreaIds = state.selectedSubAreasList
                            .map((s) => s.id!)
                            .toList();
                        Navigator.pushNamed(
                          context,
                          ExploreClinicsScreen.routeName,
                          arguments: {
                            'treatmentId': treatment?.id,
                            'sideAreaIds': sideAreaIds,
                          },
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: CustomColors.darkPurple, width: 1.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.r),
                        ),
                      ),
                      child: Text(
                        "Explore Clinics",
                        style: CustomFonts.black14w600.copyWith(color: CustomColors.darkPurple),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      );
    },
  );
}
