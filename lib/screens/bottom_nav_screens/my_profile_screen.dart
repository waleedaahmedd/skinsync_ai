import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iconsax/iconsax.dart';
import 'package:skinsync_ai/screens/get_started_screen.dart';
import 'package:skinsync_ai/screens/personal_detail_screen.dart';
import 'package:skinsync_ai/screens/setting_screen.dart';
import 'package:skinsync_ai/screens/webview_page.dart';
import 'package:skinsync_ai/utills/assets.dart';
import 'package:skinsync_ai/utills/color_constant.dart';
import 'package:skinsync_ai/utills/custom_fonts.dart';
import 'package:skinsync_ai/view_models/auth_view_model.dart';
import 'package:skinsync_ai/widgets/logout_dialog_box.dart';

class MyProfileScreen extends StatelessWidget {
  const MyProfileScreen({super.key});
  static const String routeName = "/MyProfileScreen";

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
                    Navigator.pushNamed(context, SettingScreen.routeName);
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
                    child: Consumer(
                      builder: (context, ref, _) {
                        // final name = ref
                        //     .watch(authViewModel)
                        //     .authResponse
                        //     ?.data
                        //     ?.userDetails
                        //     ?.name;
                        return Center(
                          child: Image.asset(
                            DummyAssets.acen,
                            fit: BoxFit.cover,
                            height: 103.w,
                            width: 103.w,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(width: 25.w),
                Consumer(
                  builder: (context, ref, _) {
                    final name = ref
                        .watch(authViewModel)
                        .authResponse
                        ?.data
                        ?.userDetails
                        ?.name;
                    return Column(
                      crossAxisAlignment: .start,
                      children: [
                        Text(name ?? 'N/A', style: CustomFonts.black28w600),
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
                    );
                  },
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
                    Navigator.pushNamed(
                      context,
                      PersonalDetailScreen.routeName,
                    );
                  },
                  icon: SvgAssets.profileIcon,
                  title: "Personal Details",
                ),
                SizedBox(height: 36.h),
                profileOppition(
                  callBack: () {
                    WebviewPage.open(
                      context: context,
                      url: 'https://skinsyncai.com/terms-of-service/',
                      title: 'Terms Of Service',
                    );
                  },
                  icon: Iconsax.document,
                  title: "Terms Of Service",
                ),
                SizedBox(height: 36.h),
                profileOppition(
                  callBack: () {
                    WebviewPage.open(
                      context: context,
                      url: 'https://skinsyncai.com/privacy-policy/',
                      title: 'Privacy Policy',
                    );
                  },
                  icon: Iconsax.security,
                  title: "Privacy Policy",
                ),
                // SizedBox(height: 36.h),
                // profileOppition(
                //   callBack: () {
                //     Navigator.pushNamed(
                //       context,
                //       SavedTreatmentScreen.routeName,
                //     );
                //   },
                //   icon: SvgAssets.saveTreatment,
                //   title: "Saved Treatments & Clinics",
                // ),
                // SizedBox(height: 36.h),
                // profileOppition(
                //   callBack: () {},
                //   icon: SvgAssets.loyalty,
                //   title: "Loyalty & Rewards",
                // ),
                // SizedBox(height: 36.h),
                // profileOppition(
                //   callBack: () {
                //     Navigator.pushNamed(
                //       context,
                //       AllergyAndMedicalHistory.routeName,
                //     );
                //   },
                //   icon: SvgAssets.medical,
                //   title: "Medical History",
                // ),
                // SizedBox(height: 36.h),
                // profileOppition(
                //   callBack: () {},
                //   icon: SvgAssets.receipts,
                //   title: "treatment receipts",
                // ),
                SizedBox(height: 36.h),
                profileOppition(
                  callBack: () {
                    showLogoutDialog(
                      screenContext: context,
                      desc: "Logout successful",
                      onSuccess: () async {
                        // SecureStorage secureStorage = SecureStorage();
                        // await secureStorage.clearAllSecureStrings();

                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          GetStartedScreen.routeName,
                          (route) => false,
                        );
                      },
                    );
                  },
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

InkWell profileOppition({
  required dynamic icon,
  required String title,
  required VoidCallback callBack,
}) {
  return InkWell(
    onTap: callBack,

    child: Row(
      children: [
        if (icon is String)
          SvgPicture.asset(icon, height: 24.h, width: 24.w)
        else
          Icon(icon, size: 24.sp, weight: 1),
        SizedBox(width: 16.w),
        Text(title, style: CustomFonts.black22w500),
      ],
    ),
  );
}
