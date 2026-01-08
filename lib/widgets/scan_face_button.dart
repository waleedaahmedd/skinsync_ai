import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:skinsync_ai/route_generator.dart';
import 'package:skinsync_ai/screens/bottom_nav_screens/scan_your_face_screen.dart';
import 'package:skinsync_ai/utills/assets.dart';
import 'package:skinsync_ai/utills/custom_fonts.dart';
import 'package:skinsync_ai/view_models/checkout_view_model.dart';

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
        Navigator.of(context).pushNamed(ScanYourFaceScreen.routeName);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: Colors.black,
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
            SvgPicture.asset(SvgAssets.faceId),
            const SizedBox(width: 8),
            Text(
              "Scan Your Face",
              style: CustomFonts.black18w600.copyWith(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
