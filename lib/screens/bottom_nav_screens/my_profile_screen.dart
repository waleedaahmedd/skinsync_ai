import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iconsax/iconsax.dart';
import '../allergy_and_medical_history.dart';
import '../get_started_screen.dart';
import '../personal_detail_screen.dart';
import '../saved_treatment_screen.dart';
import '../setting_screen.dart';
import '../webview_page.dart';
import '../../utills/assets.dart';
import '../../utills/color_constant.dart';
import '../../utills/custom_fonts.dart';
import '../../utills/secure_storage_service.dart';
import '../../view_models/auth_view_model.dart';
import '../../widgets/logout_dialog_box.dart';

import '../../main.dart';
import '../../widgets/dialogs/delete_account_dialog.dart';
import '../simulation_history_screen.dart';

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
                  child: Consumer(
                    builder: (context, ref, _) {
                      final image = ref
                          .watch(authViewModel)
                          .authResponse
                          ?.data
                          ?.user
                          ?.profileImageUrl;
                      return ClipOval(
                        child: Center(
                          child: Image.network(
                            image ?? "",
                            fit: BoxFit.cover,
                            height: 103.w,
                            width: 103.w,
                            errorBuilder: (context, error, stackTrace) {
                              return SizedBox(
                                height: 103.w,
                                width: 103.w,
                                child: Center(
                                  child: Icon(Icons.broken_image, size: 51.sp),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(width: 25.w),
                Consumer(
                  builder: (context, ref, _) {
                    final name = ref
                        .watch(authViewModel)
                        .authResponse
                        ?.data
                        ?.user
                        ?.name;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(name ?? 'N/A', style: CustomFonts.black28w600),
                        // Row(
                        //   children: [
                        //     Icon(Icons.star, size: 17.sp, color: Colors.black),
                        //     SizedBox(width: 3.w),
                        //     Text(
                        //       "214 Points Earned!",
                        //       style: CustomFonts.black16w400,
                        //     ),
                        //   ],
                        // ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
          SizedBox(height: 26.h),
          const Divider(color: CustomColors.greyColor),
          SizedBox(height: 31.h),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.0.w),
              child: ListView(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.paddingOf(context).bottom,
                ),
                children: [
                  profileOption(
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
                  if (!isDeploymentMode) ...{
                    profileOption(
                      callBack: () {
                        Navigator.pushNamed(
                          context,
                          SavedTreatmentScreen.routeName,
                        );
                      },
                      icon: SvgAssets.saveTreatment,
                      title: "Saved Treatments & Clinics",
                    ),
                    SizedBox(height: 36.h),
                    profileOption(
                      callBack: () {},
                      icon: SvgAssets.loyalty,
                      title: "Loyalty & Rewards",
                    ),
                    SizedBox(height: 36.h),
                    profileOption(
                      callBack: () {
                        Navigator.pushNamed(
                          context,
                          AllergyAndMedicalHistory.routeName,
                        );
                      },
                      icon: SvgAssets.medical,
                      title: "Medical History",
                    ),
                    SizedBox(height: 36.h),
                    profileOption(
                      callBack: () {
                        Navigator.pushNamed(
                          context,
                          SimulationHistoryScreen.routeName,
                        );
                      },
                      icon: SvgAssets.appointments,
                      title: "Simulation History",
                    ),
                    SizedBox(height: 36.h),
                    profileOption(
                      callBack: () {},
                      icon: SvgAssets.receipts,
                      title: "Treatment Receipts",
                    ),
                  } else ...{
                    profileOption(
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
                    profileOption(
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
                  },
                  SizedBox(height: 36.h),
                  profileOption(
                    callBack: () {
                      showDeleteAccountDialog(
                        screenContext: context,
                        onSuccess: () async {
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            GetStartedScreen.routeName,
                            (route) => false,
                          );
                        },
                      );
                    },
                    icon: Iconsax.user_remove,
                    title: "Delete Account",
                  ),
                  SizedBox(height: 36.h),
                  profileOption(
                    callBack: () {
                      showLogoutDialog(
                        screenContext: context,
                        desc: "Logout successful",
                        onSuccess: () async {
                          SecureStorage secureStorage = SecureStorage();
                          await secureStorage.clearAllSecureStrings();

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
                  SizedBox(height: 100.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  InkWell profileOption({
    required dynamic icon,
    required String title,
    required VoidCallback callBack,
  }) {
    return InkWell(
      onTap: callBack,
      child: Row(
        children: [
          if (icon is String)
            SvgPicture.asset(icon, height: 24.w, width: 24.w)
          else
            Icon(icon, size: 24.w),
          SizedBox(width: 16.w),
          Text(title, style: CustomFonts.black22w500),
        ],
      ),
    );
  }
}
