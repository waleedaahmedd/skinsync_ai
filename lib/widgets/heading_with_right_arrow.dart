import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import '../utils/color_constant.dart';
import '../utils/custom_fonts.dart';

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
            padding: EdgeInsets.all(context.w(7)),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: CustomColors.greyColor,
            ),
            child: Icon(
              CupertinoIcons.arrow_right,
              size: context.sp(16),
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}
