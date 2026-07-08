import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skinsync_ai/screens/bottom_nav_screens/face_detection_screen.dart';
import 'package:skinsync_ai/screens/explore_clinics_screen.dart';
import 'package:skinsync_ai/screens/treatment_area_screen.dart';
import 'package:skinsync_ai/utills/color_constant.dart';
import 'package:skinsync_ai/utills/custom_fonts.dart';
import 'package:skinsync_ai/widgets/custom_button.dart';
import 'package:skinsync_ai/view_models/checkout_view_model.dart';

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
              CustomButton(
                text: "Scan Your Face",
                borderRadius: 26.r,
                backgroundColor: Colors.black,
                textColor: Colors.white,
                onPressed: () {
                  Navigator.pop(context); // close dialog
                  Navigator.of(context).pushNamed(FaceDetectionScreen.routeName);
                },
              ),
              SizedBox(height: 12.h),

              // Button 2: Explore Clinics or Select Treatment Areas (Secondary Button)
              Consumer(
                builder: (context, ref, _) {
                  final checkoutState = ref.watch(checkoutViewModel);
                  final hasSelectedAreas = checkoutState.selectedTreatmentsAndAreas.isNotEmpty &&
                      checkoutState.selectedTreatmentsAndAreas.any((item) => item.selectedAreas.isNotEmpty);

                  final String buttonTitle = hasSelectedAreas ? "Explore Clinics" : "Select Treatment Areas";

                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25.r),
                      border: Border.all(color: CustomColors.darkPurple, width: 1.5),
                    ),
                    child: CustomButton(
                      text: buttonTitle,
                      backgroundColor: Colors.transparent,
                      textColor: CustomColors.darkPurple,
                      borderRadius: 25.r,
                      onPressed: () {
                        Navigator.pop(context); // close dialog

                        if (hasSelectedAreas) {
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
                        } else {
                          Navigator.pushNamed(
                            context,
                            TreatmentAreaScreen.routeName,
                            arguments: {
                              'title': 'Focus Areas',
                            },
                          );
                        }
                      },
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
