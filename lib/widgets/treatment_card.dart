import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iconsax/iconsax.dart';
import 'package:skinsync_ai/utills/assets.dart';
import 'package:skinsync_ai/utills/color_constant.dart';
import 'package:skinsync_ai/utills/custom_fonts.dart';

class TreamentCard extends StatelessWidget {
  final VoidCallback onTap;
  const TreamentCard({super.key,required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:onTap ,
      child: SizedBox(
        width: 181.w,
        height: 238.h,
        child: Container(
          margin: EdgeInsets.zero,
          clipBehavior: Clip.antiAlias,
      
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10.r),
              topRight: Radius.circular(10.r),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
      
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 7.h),
                height: 174.h,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(PngAssets.laserTreatment),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(50.r),
                        ),
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              SvgAssets.flame,
                              height: 17.41.h,
                              width: 13.44,
                            ),
                            SizedBox(width: 8.w),
                            Text("Top Choice", style: CustomFonts.black12w600),
                          ],
                        ),
                      ),
                      Spacer(),
                      Container(
                        padding: EdgeInsets.all(7),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey.withValues(alpha: 0.5),
                        ),
                        child: Icon(
                          Iconsax.heart,
                          size: 16.sp,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 6.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 3.0.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Treatment Name", style: CustomFonts.black18w600),
                    Text("Glow Skin Clinic", style: CustomFonts.grey14w400),
                    Row(
                      children: [
                        Text("\$ 800 ", style: CustomFonts.grey14w400LineThrough),
                        Text("\$ 650", style: CustomFonts.black14w600),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
