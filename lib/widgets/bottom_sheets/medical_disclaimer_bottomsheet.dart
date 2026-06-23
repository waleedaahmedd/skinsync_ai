import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../utills/custom_fonts.dart';

import '../../utills/color_constant.dart';
import '../../utills/secure_storage_service.dart';

class MedicalDisclaimerBottomSheet extends StatelessWidget {
  final String title;
  final String description;

  const MedicalDisclaimerBottomSheet({
    super.key,
    required this.title,
    required this.description,
  });

  static void show(BuildContext context, {String? title, String? description}) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isDismissible: false,
      enableDrag: false,
      builder: (_) => MedicalDisclaimerBottomSheet(
        title: title ?? 'Medical Disclaimer',
        description:
            description ??
            'SkinSync AI Inc. does not provide medical advice, diagnosis, or treatment. All visualizations are AI-generated, illustrative, and for educational purposes only. They do not predict outcomes, guarantee results, or replace consultation with a licensed medical professional.',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.all(20.w),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.r),
            topRight: Radius.circular(20.r),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(width: 28.w),
                Text(title, style: CustomFonts.black20w600),
                GestureDetector(
                  onTap: () {
                    SecureStorage().saveMedicalDisclaimer();
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: 28.w,
                    height: 28.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: CustomColors.blackColor),
                    ),
                    child: Icon(
                      Icons.close,
                      size: 16.sp,
                      color: CustomColors.blackColor,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Text(
              description,
              style: CustomFonts.grey14w400,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.h),
          ],
        ),
      ),
    );
  }
}
