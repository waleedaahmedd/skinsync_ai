import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iconsax/iconsax.dart';
import 'package:skinsync_ai/screens/allergy_and_medical_history.dart';
import 'package:skinsync_ai/screens/get_started_screen.dart';
import 'package:skinsync_ai/screens/personal_detail_screen.dart';
import 'package:skinsync_ai/screens/saved_treatment_screen.dart';
import 'package:skinsync_ai/screens/setting_screen.dart';
import 'package:skinsync_ai/screens/webview_page.dart';
import 'package:skinsync_ai/utills/assets.dart';
import 'package:skinsync_ai/utills/color_constant.dart';
import 'package:skinsync_ai/utills/custom_fonts.dart';
import 'package:skinsync_ai/utills/secure_storage_service.dart';
import 'package:skinsync_ai/view_models/auth_view_model.dart';
import 'package:skinsync_ai/widgets/logout_dialog_box.dart';

import '../../main.dart';
import '../../widgets/dialogs/delete_account_dialog.dart';
import '../simulation_history_screen.dart';

class MyProfileScreen extends StatelessWidget {
  const MyProfileScreen({super.key});
  static const String routeName = "/MyProfileScreen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 16.h),
            // Header: Title and Settings Button
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("My Profile", style: CustomFonts.black26w600),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, SettingScreen.routeName);
                    },
                    child: Container(
                      height: 42.w,
                      width: 42.w,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: CustomColors.greyColor,
                          width: 1.5,
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          Iconsax.setting_2,
                          size: 18.sp,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24.h),

            // Profile Avatar & Name Block
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: CustomColors.purpleColor.withValues(alpha: 0.4),
                        width: 4.w,
                      ),
                    ),
                    child: Consumer(
                      builder: (context, ref, _) {
                        final image = ref
                            .watch(authViewModel)
                            .authResponse
                            ?.data
                            ?.userDetails
                            ?.profileImageUrl;
                        return ClipOval(
                          child: CachedNetworkImage(
                            imageUrl: image ?? "",
                            fit: BoxFit.cover,
                            height: 80.w,
                            width: 80.w,
                            placeholder: (context, url) => Container(
                              height: 80.w,
                              width: 80.w,
                              color: Colors.grey.shade100,
                              child: const Center(child: CupertinoActivityIndicator()),
                            ),
                            errorWidget: (context, url, error) => Container(
                              height: 80.w,
                              width: 80.w,
                              color: Colors.grey.shade100,
                              child: Icon(
                                Icons.person_outline_rounded,
                                size: 36.sp,
                                color: Colors.grey.shade400,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(width: 18.w),
                  Expanded(
                    child: Consumer(
                      builder: (context, ref, _) {
                        final name = ref
                            .watch(authViewModel)
                            .authResponse
                            ?.data
                            ?.userDetails
                            ?.name;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name ?? 'Guest User',
                              style: CustomFonts.black22w600,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              "Platinum Glow Member",
                              style: CustomFonts.pink10w700,
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Divider(color: CustomColors.greyColor.withValues(alpha: 0.6), height: 1.h),
            ),

            // Profile Options organized in Premium Cards with Unified Icon Colors
            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.fromLTRB(24.w, 20.h, 24.w, 40.h),
                children: [
                  // CARD 1: Clinical Portal Section
                  _buildOptionCard([
                    _buildCardOption(
                      callBack: () {
                        Navigator.pushNamed(
                          context,
                          PersonalDetailScreen.routeName,
                        );
                      },
                      icon: SvgAssets.profileIcon,
                      title: "Personal Details",
                    ),
                    if (!isDeploymentMode) ...[
                      _buildCardOption(
                        callBack: () {
                          Navigator.pushNamed(
                            context,
                            AllergyAndMedicalHistory.routeName,
                          );
                        },
                        icon: SvgAssets.medical,
                        title: "Medical History",
                      ),
                      _buildCardOption(
                        callBack: () {
                          Navigator.pushNamed(
                            context,
                            SimulationHistoryScreen.routeName,
                          );
                        },
                        icon: SvgAssets.appointments,
                        title: "Simulation History",
                      ),
                    ],
                  ]),
                  SizedBox(height: 16.h),

                  // CARD 2: Preferences & History Section
                  if (!isDeploymentMode) ...[
                    _buildOptionCard([
                      _buildCardOption(
                        callBack: () {
                          Navigator.pushNamed(
                            context,
                            SavedTreatmentScreen.routeName,
                          );
                        },
                        icon: SvgAssets.saveTreatment,
                        title: "Saved Treatments & Clinics",
                      ),
                      _buildCardOption(
                        callBack: () {},
                        icon: SvgAssets.loyalty,
                        title: "Loyalty & Rewards",
                      ),
                      _buildCardOption(
                        callBack: () {},
                        icon: SvgAssets.receipts,
                        title: "Treatment Receipts",
                      ),
                    ]),
                    SizedBox(height: 16.h),
                  ] else ...[
                    // Legal and Policy Section
                    _buildOptionCard([
                      _buildCardOption(
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
                      _buildCardOption(
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
                    ]),
                    SizedBox(height: 16.h),
                  ],

                  // CARD 3: Account Security Section
                  _buildOptionCard([
                    _buildCardOption(
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
                    _buildCardOption(
                      callBack: () {
                        showLogoutDialog(
                          screenContext: context,
                          desc: "Logout successful",
                          onSuccess: () async {
                            final navigator = Navigator.of(context);
                            SecureStorage secureStorage = SecureStorage();
                            await secureStorage.clearAllSecureStrings();

                            navigator.pushNamedAndRemoveUntil(
                              GetStartedScreen.routeName,
                              (route) => false,
                            );
                          },
                        );
                      },
                      icon: SvgAssets.logOut,
                      title: "Log Out",
                      isLast: true,
                    ),
                  ]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Wrapper for group options inside a Card
  Widget _buildOptionCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(
          color: CustomColors.greyColor.withValues(alpha: 0.5),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.015),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: children,
      ),
    );
  }

  // Individual list option row inside a Card with Unified Colors
  Widget _buildCardOption({
    required dynamic icon,
    required String title,
    required VoidCallback callBack,
    bool isLast = false,
  }) {
    // Single Unified Brand Color for all Icons (Consistent Aesthetic)
    const Color unifiedColor = CustomColors.darkPurple;

    return Column(
      children: [
        InkWell(
          onTap: callBack,
          borderRadius: BorderRadius.circular(24.r),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            child: Row(
              children: [
                // Unified soft background tint & icon color
                Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: unifiedColor.withValues(alpha: 0.08),
                    shape: BoxShape.circle,
                  ),
                  child: icon is String
                      ? SvgPicture.asset(
                          icon,
                          height: 18.w,
                          width: 18.w,
                          colorFilter: const ColorFilter.mode(unifiedColor, BlendMode.srcIn),
                        )
                      : Icon(
                          icon as IconData,
                          size: 18.w,
                          color: unifiedColor,
                        ),
                ),
                SizedBox(width: 14.w),
                Expanded(
                  child: Text(
                    title,
                    style: CustomFonts.black16w500,
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: Colors.grey.shade400,
                  size: 20.sp,
                ),
              ],
            ),
          ),
        ),
        if (!isLast)
          Padding(
            padding: EdgeInsets.only(left: 54.w, right: 16.w),
            child: Divider(
              color: Colors.grey.shade100,
              height: 1.h,
            ),
          ),
      ],
    );
  }
}
