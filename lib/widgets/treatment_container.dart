import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:skinsync_ai/screens/treatment_detail_screen.dart';
import 'package:skinsync_ai/utills/assets.dart';
import 'package:skinsync_ai/utills/custom_fonts.dart';

class TreatmentContainer extends StatelessWidget {
  final String treatmentName;
  final String dateTime;
  final String clinicName;
  final String treatmentimage;
  const TreatmentContainer({
    super.key,
    required this.treatmentName,
    required this.clinicName,
    required this.dateTime,
    required this.treatmentimage,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.pushNamed(context,TreatmentDetailScreen.routeName);
      },
      child: SizedBox(
        width: 310.w,
        child: Column(
          children: [
            Container(
              height: 160.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Image.asset(treatmentimage, height: 160.h),
            ),
            SizedBox(height: 8.h),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(treatmentName, style: CustomFonts.black18w600),
                    Text(dateTime, style: CustomFonts.grey14w400),
                  ],
                ),
                Spacer(),
                SvgPicture.asset(SvgAssets.mappin, height: 12.h, width: 12.w),
                SizedBox(width: 4.w),
                Text(clinicName, style: CustomFonts.grey14w400),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
