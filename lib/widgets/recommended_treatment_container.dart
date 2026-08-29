import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import '../screens/treatment_detail_screen.dart';
import '../utils/string_utils.dart';
import '../utils/custom_fonts.dart';

class RecommendedTreatmentContainer extends StatelessWidget {
  final String treatmentImage;
  final String treatmentName;
  const RecommendedTreatmentContainer({
    super.key,
    required this.treatmentImage,
    required this.treatmentName,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, TreatmentDetailScreen.routeName);
      },
      child: Container(
        height: context.h(299),
        width: context.w(279),
        padding: EdgeInsets.only(bottom: context.w(20)),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(treatmentImage),
            fit: BoxFit.fill,
          ),
          borderRadius: BorderRadius.circular(context.r(10)),
        ),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: context.w(25),
              vertical: context.h(8),
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(context.r(50)),
              color: Colors.transparent.withValues(alpha: 0.2),
            ),
            child: Text(
              treatmentName.capitalize,
              style: CustomFonts.white14w600,
            ),
          ),
        ),
      ),
    );
  }
}
