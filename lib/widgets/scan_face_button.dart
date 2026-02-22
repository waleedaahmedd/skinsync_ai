import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:skinsync_ai/screens/bottom_nav_screens/face_detection_screen.dart';
import 'package:skinsync_ai/utills/assets.dart';
import 'package:skinsync_ai/utills/custom_fonts.dart';
import 'package:skinsync_ai/view_models/checkout_view_model.dart';
import 'package:skinsync_ai/view_models/face_scan_provider.dart';
import 'package:skinsync_ai/view_models/treatment_view_model.dart';

import '../utills/color_constant.dart';

class ScanFaceButton extends ConsumerWidget {
  // final VoidCallback onTap;
  const ScanFaceButton({
    super.key,
    //  required this.onTap
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        ref.read(checkoutViewModel.notifier).clearState();
        ref.read(treatmentViewModel.notifier).clearAllSelectedTreatments();
        ref.read(faceScanProvider.notifier).clearAiImage();
        Navigator.of(context).pushNamed(FaceDetectionScreen.routeName);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 14.h),
        decoration: BoxDecoration(
         // color: CustomColors.lightBlueColor,
          gradient: CustomColors.purpleBlueGradient,
          borderRadius: BorderRadius.circular(40),
          boxShadow: [
            // Outer glow
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 30,
              spreadRadius: 10,
            ),
            // Soft white diffuse glow
            BoxShadow(
              color: Colors.white.withOpacity(0.15),
              blurRadius: 40,
              spreadRadius: 20,
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(SvgAssets.faceId,color: CustomColors.blackColor,),
            const SizedBox(width: 8),
            Text(
              "Scan Your Face",
              style: CustomFonts.black18w600,
            ),
          ],
        ),
      ),
    );
  }
}
