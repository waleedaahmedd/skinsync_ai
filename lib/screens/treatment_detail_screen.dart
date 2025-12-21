import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iconsax/iconsax.dart';
import 'package:skinsync_ai/utills/assets.dart';
import 'package:skinsync_ai/utills/color_constant.dart';
import 'package:skinsync_ai/utills/custom_fonts.dart';
import 'package:skinsync_ai/widgets/app_bar_with_action_icon.dart';
import 'package:skinsync_ai/widgets/custom_app_bar.dart';

class TreatmentDetailScreen extends StatelessWidget {
  const TreatmentDetailScreen({super.key});
  static const String routeName = '/TreatmentDetailScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              alignment: Alignment.topCenter,
              height: 293.h,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(DummyAssets.treatmentimage),
                  fit: BoxFit.cover,
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 55.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: EdgeInsets.all(11),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey.withValues(alpha: 0.7),
                        ),
                        child: Icon(
                          CupertinoIcons.arrow_left,
                          size: 22.sp,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    Container(
                      padding: EdgeInsets.all(11),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey.withValues(alpha: 0.7),
                      ),
                      child: Icon(
                        Iconsax.heart,
                        size: 22.sp,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 15.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Derma Fillers - Cheeks",
                    style: CustomFonts.black30w600,
                  ),
                  SizedBox(height: 6.h),
                  Row(
                    children: [
                      Icon(Icons.star, size: 18.sp, color: Colors.amberAccent),
                      SizedBox(width: 4.5.w),
                      Text("5.0", style: CustomFonts.black18w600),
                      SizedBox(width: 8.w),
                      Text("( 30k Reviews )", style: CustomFonts.black16w400),
                    ],
                  ),
                ],
              ),
            ),
            Divider(color: CustomColors.greyColor),
            SizedBox(height: 15.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.0.w),
              child: Row(
                children: [
                  ClipOval(
                    child: Image.asset(
                      DummyAssets.acen,
                      height: 57.w,
                      width: 57.w,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(width: 13.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Glow Skin Clinic", style: CustomFonts.black18w600),
                      Row(
                        children: [
                          SvgPicture.asset(
                            SvgAssets.flame,
                            height: 11.h,
                            width: 8.83.w,
                          ),
                          SizedBox(width: 3.37.w),
                          Text(
                            "Top Rated aesthetic Clinic",
                            style: CustomFonts.black12w400,
                          ),
                        ],
                      ),
                    ],
                  ),
                  Spacer(),
                  Icon(Icons.more_vert, color: Colors.black, size: 18.sp),
                ],
              ),
            ),
            SizedBox(height: 14.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.0.w),
              child: Column(
                children: [
                  Text(
                    "Achieve a youthful appearance with our aesthetic treatments to highlight your features. Whether adding volume, smoothing lines, or redefining contours, our solutions help you look and feel your best.",
                    style: CustomFonts.black16w400,
                  ),
                  SizedBox(height: 12.h),
                  richTitleDescription(
                    title: "Add Volume: ",
                    description:
                        "Restore lost fullness to areas like cheeks and lips for a plump, vibrant look.",
                  ),
                  SizedBox(height: 16.h),
                  richTitleDescription(
                    title: "Smooth Wrinkles: ",
                    description:
                        "Restore lost fullness to areas like cheeks and lips for a plump, vibrant look.",
                  ),
                  SizedBox(height: 16.h),
                  richTitleDescription(
                    title: "Contour & Define: ",
                    description:
                        "Sculpt and enhance key areas such as your jawline, under-eyes, and lips for balanced, natural-looking results",
                  ),
                ],
              ),
            ),
            SizedBox(height: 15.h),
            Divider(color: CustomColors.greyColor),
            SizedBox(height: 15.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.w),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.r),
                  color: CustomColors.lightPurpleColor.withValues(alpha: 0.4),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Proof Of Expertise", style: CustomFonts.black18w600),
                    SizedBox(height: 4.h),
                    Text(
                      "Achieve a youthful appearance with our aesthetic treatments to highlight your features. Whether adding volume, smoothing lines, or redefining contours, our solutions help you look and feel your best.",
                      style: CustomFonts.black16w400,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10.h),
          ],
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: 144.h,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 12.h),
              color: CustomColors.lightPurpleColor,
              child: Center(
                child: Text(
                  "Complete The Appointment Timing Slot To View Full Price",
                  style: CustomFonts.black14w600,
                ),
              ),
            ),
            Padding(
              padding:EdgeInsets.only( top: 10.h),
              child: Center(
                child: Row(
                  
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Text("\$ 650", style: CustomFonts.black28w600),
                
                        Text(
                          "View Pricing Policy",
                          style: CustomFonts.black14w500Underline,
                        ),
                      ],
                    ),
                   SizedBox(width: 47.h,),
                    Container(
                      width: 187.w,
                      height: 60.h,
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(vertical: 19.h),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50.r),
                        color: Colors.black,
                      ),
                      child:  Text("Book Now", style: CustomFonts.white22w600),
                    ),
                  
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget richTitleDescription({
    required String title,
    required String description,
  }) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(text: '$title ', style: CustomFonts.black18w600),
          TextSpan(text: description, style: CustomFonts.black16w400),
        ],
      ),
    );
  }
}
