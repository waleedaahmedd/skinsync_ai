import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import '../utils/color_constant.dart';
import '../utils/custom_fonts.dart';

class PointsEarnCard extends StatelessWidget {
  const PointsEarnCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(context.w(20)),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(context.r(24)),
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
                    width: context.w(44),
                    height: context.w(44),
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
                  SizedBox(width: context.w(12)),
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
                padding: EdgeInsets.symmetric(horizontal: context.w(14), vertical: context.h(8)),
                decoration: BoxDecoration(
                  color: CustomColors.purpleColor,
                  borderRadius: BorderRadius.circular(context.r(30)),
                ),
                child: Text(
                  "Redeem",
                  style: CustomFonts.black12w600,
                ),
              ),
            ],
          ),
          SizedBox(height: context.h(18)),
          Container(
            padding: EdgeInsets.all(context.w(12)),
            decoration: BoxDecoration(
              color: CustomColors.purpleColor.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(context.r(16)),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.info_outline_rounded,
                  color: CustomColors.blueColor,
                  size: 16,
                ),
                SizedBox(width: context.w(8)),
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
