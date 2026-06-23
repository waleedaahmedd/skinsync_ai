import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../screens/progress_detail_screen.dart';
import '../utills/assets.dart';
import '../utills/color_constant.dart';
import '../utills/custom_fonts.dart';

class ProgressCard extends StatelessWidget {
  const ProgressCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.pushNamed(context, ProgressDetailScreen.routeName);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 248.h,
            width: 379.w,
            decoration: BoxDecoration(
              image: const DecorationImage(
                image: AssetImage(DummyAssets.treatmentimage),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 16.h,
                  right: 16.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 8.h,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50.r),
                      color: Colors.black.withValues(alpha: 0.3),
                    ),
                    child: Text(
                      "Next Appointment In 4hrs",
                      style: CustomFonts.white14w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 11.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Dermal Fillers – Cheeks", style: CustomFonts.black18w600),
      
              Row(
                children: [
                  SvgPicture.asset(
                    SvgAssets.progressfilled,
                    color: CustomColors.lightBlueColor,
                    height: 18.h,
                    width: 18.w,
                  ),
                  SizedBox(width: 7.w),
                  Text("28%", style: CustomFonts.black17w500),
                ],
              ),
            ],
          ),
          SizedBox(height: 4.h),
          Text("Glow Skin Clinic", style: CustomFonts.grey14w400),
          SizedBox(height: 1.h),
          Text("08 Sessions", style: CustomFonts.grey14w400),
          SizedBox(height: 22.h),
        ],
      ),
    );
  }
}
