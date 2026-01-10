import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:skinsync_ai/utills/color_constant.dart';
import 'package:skinsync_ai/utills/custom_fonts.dart';

class PointsEarnCard extends StatelessWidget {
  const PointsEarnCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 21.h, horizontal: 31.w),

      decoration: BoxDecoration(
        gradient: CustomColors.purpleBlueGradient,
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularPercentIndicator(
            radius: 56.r,
            lineWidth: 10.0.w,
            animation: true,
            percent: 0.72,
            center: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("72%", style: CustomFonts.black28w600),
                Text("Points Earned!", style: CustomFonts.black10w600),
              ],
            ),

            circularStrokeCap: CircularStrokeCap.round,
            progressColor: Color(0xffEEA1F0),
            backgroundColor: Colors.white,
          ),

          SizedBox(width: 29.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Loyalty Rewards", style: CustomFonts.black20w600),
              SizedBox(height: 6.h),
              Text("Earn up to \$250/month!", style: CustomFonts.grey16w400),
              SizedBox(height: 13.h),
              Container(
                padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 9.w),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(5.r),
                ),
                child: Row(
                  children: [
                    Icon(Icons.star, color: Colors.white, size: 11.sp),
                    SizedBox(width: 4),
                    Text("Redeem Points", style: CustomFonts.white12w600),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
