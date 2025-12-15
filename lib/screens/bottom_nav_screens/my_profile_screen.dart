import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iconsax/iconsax.dart';
import 'package:skinsync_ai/route_generator.dart';
import 'package:skinsync_ai/utills/assets.dart';
import 'package:skinsync_ai/utills/color_constant.dart';
import 'package:skinsync_ai/utills/custom_fonts.dart';

class MyProfileScreen extends StatelessWidget {
  const MyProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 55.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.0.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("My Profile", style: CustomFonts.black26w600),
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, settingScreen);
                  },
                  child: Container(
                    height: 44.h,
                    width: 44.w,
                    decoration: BoxDecoration(
                      color: CustomColors.greyColor,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Center(
                      child: Icon(
                        Iconsax.setting_2,
                        size: 22.sp,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 26.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.0.w),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: CustomColors.lightPurpleColor,
                      width: 7.w,
                    ),
                  ),
                  child: ClipOval(
                    child: Center(
                      child: Image.asset(
                        DummyAssets.acen,
                        fit: BoxFit.cover,
                        height: 103.w,
                        width: 103.w,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 25.w),
                Column(
                  children: [
                    Text("Lizzy Johnson", style: CustomFonts.black28w600),
                    Row(
                      children: [
                        Icon(Icons.star, size: 17.sp, color: Colors.black),
                        SizedBox(width: 3.w),
                        Text(
                          "214 Points Earned!",
                          style: CustomFonts.black16w400,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 26.h),
          Divider(color: CustomColors.greyColor),
          SizedBox(height: 31.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.0.w),
            child: Column(
              children: [
                profileOppition(
                  callBack: () {
                    Navigator.pushNamed(context, personalDetailScreen);
                  },
                  icon: SvgAssets.profileIcon,
                  title: "Personal Details",
                ),
                SizedBox(height: 36.h),
                profileOppition(
                  callBack: () {
                    Navigator.pushNamed(context, savedTreatmentScreen);
                  },
                  icon: SvgAssets.saveTreatment,
                  title: "Saved Treatments & Clinics",
                ),
                SizedBox(height: 36.h),
                profileOppition(
                  callBack: () {},
                  icon: SvgAssets.loyalty,
                  title: "Loyalty & Rewards",
                ),
                SizedBox(height: 36.h),
                profileOppition(
                  callBack: () {},
                  icon: SvgAssets.medical,
                  title: "Medical History",
                ),
                SizedBox(height: 36.h),
                profileOppition(
                  callBack: () {},
                  icon: SvgAssets.receipts,
                  title: "treatment receipts",
                ),
                SizedBox(height: 36.h),
                profileOppition(
                  callBack: () {},
                  icon: SvgAssets.logOut,
                  title: "Log Out",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

profileOppition({
  required String icon,
  required String title,
  required VoidCallback callBack,
}) {
  return InkWell(
    onTap: callBack,

    child: Row(
      children: [
        SvgPicture.asset(icon, height: 24.h, width: 24.w),
        SizedBox(width: 16.w),
        Text(title, style: CustomFonts.black22w500),
      ],
    ),
  );
}
