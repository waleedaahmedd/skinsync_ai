import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:skinsync_ai/utills/assets.dart';
import 'package:skinsync_ai/utills/color_constant.dart';
import 'package:skinsync_ai/utills/custom_fonts.dart';

class FillterContainer extends StatelessWidget {
  final String title;
  final String? svgImage;
  final bool isSelected;
  final VoidCallback onTap;
  const FillterContainer({
    super.key,
    required this.isSelected,
    this.svgImage,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : CustomColors.greyColor,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Row(
          children: [
            Row(
              children: [
                svgImage != null
                    ? SvgPicture.asset(
                        svgImage ?? "",
                        height: 21.h,
                        width: 21.w,
                        colorFilter: ColorFilter.mode(
                          isSelected ? Colors.white : Colors.black,
                          BlendMode.srcIn,
                        ),
                      )
                    : SizedBox(),
                svgImage != null ? SizedBox(width: 7.w) : SizedBox(),
                Text(
                  title,
                  style: isSelected
                      ? CustomFonts.white17w500
                      : CustomFonts.black16w400,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
