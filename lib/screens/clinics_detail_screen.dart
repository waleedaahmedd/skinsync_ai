import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_glass_morphism/flutter_glass_morphism.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iconsax/iconsax.dart';
import 'package:skinsync_ai/screens/clinic_service_screen.dart';
import 'package:skinsync_ai/utills/assets.dart';
import 'package:skinsync_ai/utills/color_constant.dart';
import 'package:skinsync_ai/utills/custom_fonts.dart';

class ClinicsDetailScreen extends StatelessWidget {
  const ClinicsDetailScreen({super.key});
  static const String routeName = '/ClinicsDetailScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Glow Skin Clinic", style: CustomFonts.black30w600),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 6.w,
                          vertical: 4.w,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50.r),
                          color: CustomColors.lightBlueColor.withValues(
                            alpha: 0.2,
                          ),
                        ),
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              SvgAssets.flame,
                              height: 16.05.h,
                              width: 12.58,
                            ),
                            SizedBox(width: 7.5.w),
                            Text("Top Choice", style: CustomFonts.black12w600),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      Icon(Icons.star, size: 18.sp, color: Colors.amberAccent),
                      SizedBox(width: 4.5.w),
                      Text("5.0", style: CustomFonts.black18w600),
                      SizedBox(width: 8.w),
                      Text(
                        "( 30k Reviews ) 1M+ Booked",
                        style: CustomFonts.black16w400,
                      ),
                    ],
                  ),
                  SizedBox(height: 14.h),
                  Text(
                    "Achieve a youthful appearance with our aesthetic treatments to highlight your features. Whether adding volume, smoothing lines, or redefining contours, our solutions help you look and feel your best.",
                    style: CustomFonts.black16w400,
                  ),
                  SizedBox(height: 20.h),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 30.w),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 22.h),
                decoration: BoxDecoration(
                  color: CustomColors.lightPurpleColor.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10.r),
                    bottomLeft: Radius.circular(10.r),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "What Are Off-Peak Hours?",
                      style: CustomFonts.black22w600,
                    ),
                    SizedBox(height: 11.w),
                    Text(
                      "Book your appointment during quieter times and enjoy exclusive discounts.",
                      style: CustomFonts.black16w400,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 22.h),
            Divider(color: CustomColors.greyColor),
            SizedBox(height: 20.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.w),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 21.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                  color: CustomColors.lightBlueColor.withValues(alpha: 0.4),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Monday - Sunday", style: CustomFonts.black20w600),
                        Text(
                          "7 : 00 AM - 12 : 00 PM",
                          style: CustomFonts.black16w400,
                        ),
                      ],
                    ),
                    SizedBox(height: 25.h),
                    Divider(
                      height: 0.h,
                      color: CustomColors.blackColor.withValues(alpha: 0.1)),
                    SizedBox(height: 18.h),
                    Row(children: [
                      Icon(Iconsax.location,color: Colors.black,size: 20.sp,),
                      SizedBox(width: 14.w,),
                      Text("Bedford-Stuyvesant, Brooklyn, NY 11221",style: CustomFonts.black20w600,)

                    ],),
                    
                    Image.asset(DummyAssets.map,height: 203.h,width: 380.w,)
                  ],
                ),
              ),
            ),

            SizedBox(height: 160.h),
          ],
        ),
      ),
      bottomNavigationBar: GlassMorphismContainer(
        borderRadius: BorderRadius.all(Radius.circular(0.r)),
        blurIntensity: 30.0,
        opacity: 0.10,
        glassThickness: 1.0,

        // tintColor: Colors.white.withOpacity(0.15),
        enableBackgroundDistortion: true,
        enableGlassBorder: true,
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
              padding: EdgeInsets.only(top: 10.h,left: 30.w,right: 30.w),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(onPressed: (){
                  Navigator.pushNamed(context,ClinicServiceScreen.routeName);
                }, child: Text("Book An Appointment")))
            ),
          ],
        ),
      ),
    );
  }
}
