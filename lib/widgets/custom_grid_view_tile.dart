import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../utills/assets.dart';
import '../utills/custom_fonts.dart';

import '../utills/color_constant.dart';

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
          borderRadius: BorderRadius.circular(10.r),
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
                  borderRadius: BorderRadius.circular(10.r),
                  child: Image.asset(
                    PngAssets.splashLogo,
                    fit: BoxFit.fitWidth,
                  ),
                ),

                // Positioned(
                //   top: 6.h,
                //   left: 5.w,
                //   child: FrostedContainer(
                //     borderRadius: 8.r,
                //     padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
                //     child: Row(
                //       mainAxisSize: MainAxisSize.min,
                //       children: [
                //         SvgPicture.asset(SvgAssets.flame),
                //         SizedBox(width: 7.w),
                //         Text("Top Choice", style: CustomFonts.black12w600),
                //       ],
                //     ),
                //   ),
                // ),
                // Positioned(
                //   bottom: 6.h,
                //   right: 5.w,
                //   child: FrostedContainer(
                //     borderRadius: 8.r,
                //     padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
                //     child: Row(
                //       mainAxisSize: MainAxisSize.min,
                //       children: [
                //         Icon(Icons.star, color: Color(0XFFF68712), size: 16.sp),
                //         SizedBox(width: 4.w),
                //         Text("4.9", style: CustomFonts.black12w600),
                //       ],
                //     ),
                //   ),
                // ),
                // Positioned(
                //   top: 6.h,
                //   right: 5.w,
                //   child: FrostedContainer(
                //     borderRadius: 50.r,
                //     padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
                //     child: Icon(
                //       Icons.favorite_border,
                //       color: Colors.white,
                //       size: 19.sp,
                //     ),
                //   ),
                // ),
              ],
            ),
            const Spacer(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: Center(
                child: Text(
                  title ?? '',
                  style: CustomFonts.black20w600.copyWith(
                    fontSize: 14.sp, // Smaller font for bottom sheet
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
