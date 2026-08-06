import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_svg/svg.dart';
import '../utills/color_constant.dart';
import '../utills/custom_fonts.dart';

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
          padding: EdgeInsets.symmetric(vertical: context.h(16)),
          decoration: BoxDecoration(
            color: isSelected ? Colors.black : CustomColors.greyColor,
            borderRadius: BorderRadius.circular(context.r(10)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                icon,
                height: context.h(18),
                width: context.w(18),
                colorFilter: ColorFilter.mode(
                  isSelected ? Colors.white : Colors.black,
                  BlendMode.srcIn,
                ),
              ),
              SizedBox(width: context.w(7)),
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
