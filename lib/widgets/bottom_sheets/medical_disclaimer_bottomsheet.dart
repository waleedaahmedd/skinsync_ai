import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import '../../utils/custom_fonts.dart';

import '../../utils/color_constant.dart';
import '../../utils/secure_storage_service.dart';

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
            'SkinSync AI Inc. does not provide medical advice, diagnosis, or treatment. All visualizations are AI-generated, illustrative, and for educational purposes only. They do not predict outcomes, guarantee results, or replace consultation with a licensed medical professional. Always consult a healthcare professional for medical advice, diagnosis, or treatment.',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.all(context.w(20)),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(context.r(20)),
            topRight: Radius.circular(context.r(20)),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(width: context.w(28)),
                Text(title, style: CustomFonts.black20w600),
                GestureDetector(
                  onTap: () {
                    SecureStorage().saveMedicalDisclaimer();
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: context.w(28),
                    height: context.w(28),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: CustomColors.blackColor),
                    ),
                    child: Icon(
                      Icons.close,
                      size: context.sp(16),
                      color: CustomColors.blackColor,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: context.h(12)),
            Text(
              description,
              style: CustomFonts.grey14w400,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: context.h(8)),
          ],
        ),
      ),
    );
  }
}
