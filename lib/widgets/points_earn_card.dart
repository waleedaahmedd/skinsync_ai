import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skinsync_ai/utills/color_constant.dart';
import 'package:skinsync_ai/utills/custom_fonts.dart';

class PointsEarnCard extends StatelessWidget {
  const PointsEarnCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.r),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF2E1C38), // Deep purple night
            Color(0xFF140F26), // Deep midnight
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: CustomColors.purpleColor.withValues(alpha: 0.2),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 44.w,
                    height: 44.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.1),
                    ),
                    child: const Icon(
                      Icons.stars_rounded,
                      color: CustomColors.yellow,
                      size: 24,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Loyalty Rewards',
                        style: CustomFonts.white70_12w500,
                      ),
                      Text(
                        '0 pts',
                        style: CustomFonts.white24w700,
                      ),
                    ],
                  ),
                ],
              ),
              // Redeem Button
              Container(
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: CustomColors.purpleColor,
                  borderRadius: BorderRadius.circular(30.r),
                ),
                child: Text(
                  "Redeem",
                  style: CustomFonts.black12w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 18.h),
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  color: CustomColors.lightBlueColor,
                  size: 16.sp,
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    'Every \$1 spent earns 10 points. Accumulate points to unlock free clinical treatments!',
                    style: CustomFonts.white80_11w400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
