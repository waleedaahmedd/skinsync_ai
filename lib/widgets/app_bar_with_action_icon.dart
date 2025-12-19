import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skinsync_ai/utills/custom_fonts.dart';

import '../utills/color_constant.dart';

class AppBarWithActionIcon extends StatelessWidget
    implements PreferredSizeWidget {
  const AppBarWithActionIcon({
    super.key,
    required this.title,
    required this.subTitle,
    this.action,
  });
  @override
  Size get preferredSize => Size.fromHeight(110.h);

  final Widget title;
  final Widget subTitle;
  final Widget? action;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),

        child: Column(
          children: [
            SizedBox(height: 17.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [title, SizedBox(height: 4), subTitle],
                ),
                ?action,
              ],
            ),
            Spacer(),
            Divider(color: CustomColors.greyColor),
          ],
        ),
      ),
    );
  }
}
