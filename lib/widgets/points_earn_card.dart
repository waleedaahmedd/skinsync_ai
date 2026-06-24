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
        gradient: CustomColors.purpleBlueGradient,
        border: Border.all(
          color: CustomColors.greyColor.withValues(alpha: 0.6),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
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
                      color: CustomColors.purpleColor.withValues(alpha: 0.1),
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
                        style: CustomFonts.textGrey13w400,
                      ),
                      Text(
                        '0 pts',
                        style: CustomFonts.black24w600,
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
              color: CustomColors.purpleColor.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.info_outline_rounded,
                  color: CustomColors.blueColor,
                  size: 16,
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    'Every \$1 spent earns 10 points. Accumulate points to unlock free clinical treatments!',
                    style: CustomFonts.textGrey13w400,
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
