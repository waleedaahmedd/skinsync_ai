import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../screens/bottom_nav_screens/face_detection_screen.dart';
import '../screens/explore_clinics_screen.dart';
import '../utills/custom_fonts.dart';

import '../view_models/treatment_view_model.dart';

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
              Text("Get Started", style: CustomFonts.black24w600),

              SizedBox(height: 10.h),

              // 🔹 Description
              Text(
                "Scan your face to get personalized skin analysis or explore nearby clinics for professional treatments.",
                textAlign: TextAlign.center,
                style: CustomFonts.grey14w400,
              ),

              const SizedBox(height: 25),
              // Button 1
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // close dialog
                    Navigator.of(
                      context,
                    ).pushNamed(FaceDetectionScreen.routeName);
                  },
                  child: const Text("Scan Your Face"),
                ),
              ),

              SizedBox(height: 20.h),

              // Button 2
              Consumer(
                builder: (_, ref, _) {
                  return InkWell(
                    onTap: () {
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
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
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
                          style: CustomFonts.black18w600,
                        ),
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
