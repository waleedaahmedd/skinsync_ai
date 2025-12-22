import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:skinsync_ai/utills/assets.dart';
import 'package:skinsync_ai/utills/custom_fonts.dart';
import 'package:skinsync_ai/widgets/frosted_container.dart';

class CustomGridViewTile extends StatelessWidget {
  const CustomGridViewTile({super.key, required this.onTap});
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10.r),
                child: Image.asset(
                  PngAssets.laserTreatment,
                  fit: BoxFit.fitWidth,
                ),
              ),
              Positioned(
                top: 6.h,
                left: 5.w,
                child: FrostedContainer(
                  borderRadius: 8.r,
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(SvgAssets.flame),
                      SizedBox(width: 7.w),
                      Text("Top Choice", style: CustomFonts.black12w600),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 6.h,
                right: 5.w,
                child: FrostedContainer(
                  borderRadius: 8.r,
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.star, color: Color(0XFFF68712), size: 16.sp),
                      SizedBox(width: 4.w),
                      Text("4.9", style: CustomFonts.black12w600),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 6.h,
                right: 5.w,
                child: FrostedContainer(
                  borderRadius: 50.r,
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
                  child: Icon(
                    Icons.favorite_border,
                    color: Colors.white,
                    size: 19.sp,
                  ),
                ),
              ),
            ],
          ),
          Text("Facial Aesthetic Clinic", style: CustomFonts.black18w600),
          Text("Dermal Fillers – Cheeks", style: CustomFonts.black14w400),
          Text("11:00 AM - 12:00 PM", style: CustomFonts.black14w400),
        ],
      ),
    );
  }
}
