import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_svg/svg.dart';
import '../utills/color_constant.dart';
import '../utills/custom_fonts.dart';

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
        padding: EdgeInsets.all(context.w(16)),
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : CustomColors.greyColor,
          borderRadius: BorderRadius.circular(context.r(10)),
        ),
        child: Row(
          children: [
            Row(
              children: [
                svgImage != null
                    ? SvgPicture.asset(
                        svgImage ?? "",
                        height: context.h(21),
                        width: context.w(21),
                        colorFilter: ColorFilter.mode(
                          isSelected ? Colors.white : Colors.black,
                          BlendMode.srcIn,
                        ),
                      )
                    : const SizedBox(),
                svgImage != null ? SizedBox(width: context.w(7)) : const SizedBox(),
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
