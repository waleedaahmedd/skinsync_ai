import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../utills/color_constant.dart';
import '../utills/custom_fonts.dart';

class PointsEarnCard extends StatelessWidget {
  const PointsEarnCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.r),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            CustomColors.purpleColor.withValues(alpha: 0.6),
            CustomColors.lightBlueColor.withValues(alpha: 0.6),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Row(
            mainAxisAlignment: .start,
            spacing: 15.w,
            children: [
              Container(
                width: 48.w,
                height: 48.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: CustomColors.whiteColor,
                  border: Border.all(
                    color: CustomColors.purpleColor,
                    width: 8.r,
                  ),
                ),
                child: const Icon(Icons.star, color: CustomColors.yellow),
              ),
              Column(
                crossAxisAlignment: .start,
                children: [
                  Text('Current Points', style: CustomFonts.black14w700),
                  Text('0 pts', style: CustomFonts.purple30w700),
                ],
              ),
            ],
          ),
          SizedBox(height: 24.h),
          Text('Reward Points', style: CustomFonts.black20w600),
          Text(
            'Every \$1 spent earns 10 points: \$1 = 10 points,eg: \$10 = 100 points.',
            style: CustomFonts.grey14w400,
          ),
        ],
      ),
    );
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
                Text("0%", style: CustomFonts.black28w600),
                Text("Points Earned!", style: CustomFonts.black10w600),
              ],
            ),

            circularStrokeCap: CircularStrokeCap.round,
            progressColor: const Color(0xffEEA1F0),
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
                    const SizedBox(width: 4),
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
