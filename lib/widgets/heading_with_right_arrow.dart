import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skinsync_ai/utills/color_constant.dart';
import 'package:skinsync_ai/utills/custom_fonts.dart';

class HeadingWithRightArrow extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  const HeadingWithRightArrow({
    super.key,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: CustomFonts.black22w600),
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.all(7.w),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: CustomColors.greyColor,
            ),
            child: Icon(
              CupertinoIcons.arrow_right,
              size: 16.sp,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}
