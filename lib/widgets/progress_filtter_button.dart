import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:skinsync_ai/utills/color_constant.dart';
import 'package:skinsync_ai/utills/custom_fonts.dart';

class ProgressFillterButton extends StatelessWidget {
  final bool isSelected;
  final String label;
  final String icon;
  final VoidCallback onTap;

  const ProgressFillterButton({
    super.key,
    required this.isSelected,
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 16.h),
          decoration: BoxDecoration(
            color: isSelected ? Colors.black : CustomColors.greyColor,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                icon,
                height: 18.h,
                width: 18.w,
                color: isSelected ? Colors.white : Colors.black,
              ),
              SizedBox(width: 7.w),
              Text(
                label,
                style: isSelected
                    ? CustomFonts.white17w500
                    : CustomFonts.black17w500,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
