import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iconsax/iconsax.dart';
import 'package:skinsync_ai/utills/assets.dart';
import 'package:skinsync_ai/utills/color_constant.dart';
import 'package:skinsync_ai/utills/custom_fonts.dart';
import 'package:skinsync_ai/widgets/grey_container.dart';
import 'package:skinsync_ai/widgets/progress_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  static const String routeName = "HomeScreen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 84.h,
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Hello, Burak!", style: CustomFonts.black30w600),
            SizedBox(height: 4),
            Text(
              "Your journey to radiant skin starts now.",
              style: CustomFonts.grey18w400,
            ),
          ],
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20.0.w),
            child: GreyContainer(icon:   Icons.notifications_none_outlined,),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Divider(color: CustomColors.greyColor),
            SizedBox(height: 22.h),
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30.w),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 21.h,
                          horizontal: 31.w,
                        ),
                        height: 150.h,
                        decoration: BoxDecoration(
                          gradient: CustomColors.purpleBlueGradient,
                          borderRadius: BorderRadius.circular(15.r),
                        ),
                        child: Row(
                          children: [
                            CustomCircularIndicator(progress: 0.72),
                            SizedBox(width: 29.w),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Loyalty Rewards",
                                  style: CustomFonts.black20w600,
                                ),
                                SizedBox(height: 6.h),
                                Text(
                                  "Earn up to \$250/month!",
                                  style: CustomFonts.grey16w400,
                                ),
                                SizedBox(height: 13.h),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 8.h,
                                    horizontal: 9.w,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(5.r),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.star,
                                        color: Colors.white,
                                        size: 11.sp,
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        "Redeem Points",
                                        style: CustomFonts.white12w600,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 30.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Your Next Appointment",
                            style: CustomFonts.black22w600,
                          ),
                          Container(
                            padding: EdgeInsets.all(7.w),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: CustomColors.greyColor,
                            ),
                            child: Icon(
                              CupertinoIcons.arrow_right,
                              size: 16.sp,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 18.h),
                      Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 13.29.h,
                          horizontal: 15.51.w,
                        ),
                        height: 150.h,
                        decoration: BoxDecoration(
                          color: CustomColors.lightBlueColor.withValues(
                            alpha: 0.5,
                          ),
                          borderRadius: BorderRadius.circular(15.r),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                ClipOval(
                                  child: Center(
                                    child: Image.asset(
                                      DummyAssets.acen,
                                      fit: BoxFit.cover,
                                      height: 64.w,
                                      width: 64.w,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 9.w),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Botox Treatment",
                                      style: CustomFonts.black18w600,
                                    ),
                                    Text(
                                      "Glow Skin Clinic",
                                      style: CustomFonts.grey14w400,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 13.39.h),
                            Container(
                              padding: EdgeInsets.symmetric(
                                vertical: 8.86.h,
                                horizontal: 26.w,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.r),
                                color: CustomColors.lightBlueColor.withValues(
                                  alpha: 0.5,
                                ),
                              ),

                              child: Row(
                                children: [
                                  Icon(
                                    Iconsax.calendar_2,
                                    color: Colors.black,
                                    size: 11.sp,
                                  ),
                                  SizedBox(width: 11.71.w),
                                  Text(
                                    "Monday,july25",
                                    style: CustomFonts.black12w400,
                                  ),
                                  Spacer(),
                                  Icon(
                                    Iconsax.clock,
                                    size: 11,
                                    color: Colors.black,
                                  ),
                                  SizedBox(width: 11.71.w),
                                  Text(
                                    "10:30 am - 12:30 pm",
                                    style: CustomFonts.black12w400,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 25.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Suggested Treatments",
                            style: CustomFonts.black22w600,
                          ),
                          Container(
                            padding: EdgeInsets.all(7.w),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: CustomColors.greyColor,
                            ),
                            child: Icon(
                              CupertinoIcons.arrow_right,
                              size: 16.sp,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 18.h),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 200.h,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: 4,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Padding(
                    padding:  EdgeInsets.only(left: index == 0 ?30.w:17.w),
                    child: treatmentCard(),
                  );
                },
              ),
            ),
            SizedBox(height: 18.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.w),
              child: 
                  Text("promotions & discounts", style: CustomFonts.black22w600),
                  
            
            ),
            SizedBox(height: 18.h),
            SizedBox(
              height: 144.h,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: 4,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Padding(
                    padding:  EdgeInsets.only(left: index == 0 ?30.w:17.w),
                    child: discountCard(),
                  );
                },
              ),
            ),
            SizedBox(height: 185.h),
          ],
        ),
      ),
    );
  }

  Widget treatmentCard() {
    return SizedBox(
      width: 310.w,
      child: Column(
        children: [
          Container(
            height: 160.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Image.asset(DummyAssets.treatmentimage, height: 160.h),
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              Text("Botox Treatment", style: CustomFonts.black18w600),
              Spacer(),
              SvgPicture.asset(SvgAssets.mappin, height: 12.h, width: 12.w),
              SizedBox(width: 4.w),
              Text("Glow Skin Clinic", style: CustomFonts.grey14w400),
            ],
          ),
        ],
      ),
    );
  }
   discountCard(){
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
                      SizedBox(height: 4),
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
                      decoration: BoxDecoration(
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
                      padding: EdgeInsets.all(11),
                      decoration: BoxDecoration(shape: BoxShape.circle
                      
                      ,color: Color(0xffFF2F82)),
                     child: Text("20%\nOFF",style: CustomFonts.white20w700,),
                    ))
                  ],
                ),
              ],
            ),
          );
  }
}
