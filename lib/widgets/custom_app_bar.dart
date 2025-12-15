import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skinsync_ai/utills/color_constant.dart';
import 'package:skinsync_ai/utills/custom_fonts.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool showTitle;
  final String? title;

  const CustomAppBar({
    super.key,
    required this.showTitle,
    this.title,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          onTap: () => Navigator.pop(context),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: CustomColors.iconColor,
            ),
            child: Icon(
              CupertinoIcons.arrow_left,
              size: 20.w,
              color: Colors.black,
            ),
          ),
        ),
      ),
      title: showTitle
          ? Text(
              title ?? '',
              style: CustomFonts.black26w600,
            )
          : const SizedBox.shrink(),
    );
  }
}
