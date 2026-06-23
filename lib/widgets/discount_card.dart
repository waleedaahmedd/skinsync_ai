import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../utills/assets.dart';
import '../utills/color_constant.dart';
import '../utills/custom_fonts.dart';

class DiscountCard extends StatelessWidget {
  const DiscountCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: CustomColors.lightBlueColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      height: 144.h,
      width: 380.w,
      child: Row(
        children: [
          SizedBox(
            width: 181.w,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 25.h),
                Padding(
                  padding: EdgeInsets.only(left: 27.w),
                  child: Text(
                    "Botox Treatment",
                    style: CustomFonts.black18w600,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 27.w),
                  child: Text(
                    "Glow Skin Clinic",
                    style: CustomFonts.black14w400,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: EdgeInsets.only(right: 5.w, left: 27.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(8.r),
                      bottomRight: Radius.circular(8.r),
                    ),
                  ),
                  child: Text("20% Off", style: CustomFonts.black14w600),
                ),
                SizedBox(height: 5.h),
                Padding(
                  padding: EdgeInsets.only(left: 27.w),
                  child: Text(
                    "Valid Till 30 March",
                    style: CustomFonts.black14w400,
                  ),
                ),
              ],
            ),
          ),

          Stack(
            children: [
              Container(
                width: 199.w,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(DummyAssets.treatmentimage),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Positioned(
                top: 16.h,
                right: 14.w,
                child: Container(
                  padding: const EdgeInsets.all(11),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xffFF2F82),
                  ),
                  child: Text("20%\nOFF", style: CustomFonts.white20w700),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}