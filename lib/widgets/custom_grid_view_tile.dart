import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import '../utils/assets.dart';
import '../utils/custom_fonts.dart';

import '../utils/color_constant.dart';

class CustomGridViewTile extends StatelessWidget {
  final String? title;
  const CustomGridViewTile({
    super.key,
    required this.onTap,
    required this.title,
  });
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(context.r(10)),
          border: Border.all(
            color: CustomColors.lightPurpleColor.withValues(alpha: 0.3),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: CustomColors.purpleColor.withValues(alpha: 0.15),
              blurRadius: 20,
              offset: const Offset(0, 4),
              spreadRadius: 2,
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Spacer(),
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(context.r(10)),
                  child: Image.asset(
                    PngAssets.splashLogo,
                    fit: BoxFit.fitWidth,
                  ),
                ),

                // Positioned(
                //   top: context.h(6),
                //   left: context.w(5),
                //   child: FrostedContainer(
                //     borderRadius: context.r(8),
                //     padding: EdgeInsets.symmetric(horizontal: context.w(6), vertical: context.h(4)),
                //     child: Row(
                //       mainAxisSize: MainAxisSize.min,
                //       children: [
                //         SvgPicture.asset(SvgAssets.flame),
                //         SizedBox(width: context.w(7)),
                //         Text("Top Choice", style: CustomFonts.black12w600),
                //       ],
                //     ),
                //   ),
                // ),
                // Positioned(
                //   bottom: context.h(6),
                //   right: context.w(5),
                //   child: FrostedContainer(
                //     borderRadius: context.r(8),
                //     padding: EdgeInsets.symmetric(horizontal: context.w(6), vertical: context.h(4)),
                //     child: Row(
                //       mainAxisSize: MainAxisSize.min,
                //       children: [
                //         Icon(Icons.star, color: Color(0XFFF68712), size: context.sp(16)),
                //         SizedBox(width: context.w(4)),
                //         Text("4.9", style: CustomFonts.black12w600),
                //       ],
                //     ),
                //   ),
                // ),
                // Positioned(
                //   top: context.h(6),
                //   right: context.w(5),
                //   child: FrostedContainer(
                //     borderRadius: context.r(50),
                //     padding: EdgeInsets.symmetric(horizontal: context.w(6), vertical: context.h(4)),
                //     child: Icon(
                //       Icons.favorite_border,
                //       color: Colors.white,
                //       size: context.sp(19),
                //     ),
                //   ),
                // ),
              ],
            ),
            const Spacer(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: context.w(8)),
              child: Center(
                child: Text(
                  title ?? '',
                  style: CustomFonts.black20w600.copyWith(
                    fontSize: context.sp(14), // Smaller font for bottom sheet
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
