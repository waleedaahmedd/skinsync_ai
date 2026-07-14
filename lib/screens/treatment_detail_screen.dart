import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_glass_morphism/flutter_glass_morphism.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iconsax/iconsax.dart';
import 'clinics_detail_screen.dart';
import '../widgets/custom_button.dart';
import '../utills/assets.dart';
import '../utills/color_constant.dart';
import '../utills/custom_fonts.dart';

import '../models/responses/treatment_list_response.dart';

class TreatmentDetailScreen extends StatelessWidget {
  final TreatmentData treatments;

  const TreatmentDetailScreen({super.key, required this.treatments});

  static const String routeName = '/TreatmentDetailScreen';

  @override
  Widget build(BuildContext context) {
    // Premium fallback logic matching TreatmentContainer
    final bgImage = treatments.imageUrl ??
        (treatments.name == "Botox"
            ? "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQl-cyJqFlcZav1TlRMEuajtrg2RJlWY3rTQA&s"
            : "https://movelmedspa.com/storage/2024/05/Cheek-Filler-Treatment-at-Movel-Med-Spa.webp");

    return Scaffold(
      extendBody: true,
      backgroundColor: CustomColors.whiteColor,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Premium Curved Image Banner with Overlays
            Stack(
              children: [
                Hero(
                  tag: 'treatment_image_${treatments.id}',
                  child: ClipRRect(
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(32.r),
                    ),
                    child: Container(
                      height: 310.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: CachedNetworkImage(
                        imageUrl: bgImage,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          decoration: const BoxDecoration(
                            gradient: CustomColors.purpleBlueGradient,
                          ),
                          child: const Center(
                            child: CupertinoActivityIndicator(color: Colors.white),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          decoration: const BoxDecoration(
                            gradient: CustomColors.purpleBlueGradient,
                          ),
                          child: const Icon(
                            Icons.broken_image_rounded,
                            color: Colors.white38,
                            size: 40,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // Translucent Top & Bottom Gradients for Button readability
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(32.r),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withValues(alpha: 0.45),
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.3),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // Floating Actions (Back and Favorite buttons)
                Positioned(
                  top: MediaQuery.paddingOf(context).top + 10.h,
                  left: 24.w,
                  right: 24.w,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Back Button
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          height: 42.w,
                          width: 42.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black.withValues(alpha: 0.35),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.2),
                              width: 1.5,
                            ),
                          ),
                          child: Center(
                            child: Icon(
                              CupertinoIcons.arrow_left,
                              size: 20.sp,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),

                      // Favorite Button
                      Container(
                        height: 42.w,
                        width: 42.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black.withValues(alpha: 0.35),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.2),
                            width: 1.5,
                          ),
                        ),
                        child: Center(
                          child: Icon(
                            Iconsax.heart,
                            size: 20.sp,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: 24.h),

            // 2. Title & Reviews Section
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category Badge
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: CustomColors.purpleColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                    child: Text(
                      "CLINICAL TREATMENT",
                      style: CustomFonts.darkPurple12w600,
                    ),
                  ),
                  SizedBox(height: 12.h),

                  // Treatment Name
                  Text(
                    treatments.name ?? "Derma Fillers",
                    style: CustomFonts.black28w600,
                  ),
                  SizedBox(height: 8.h),

                  // Rating and review count
                  Row(
                    children: [
                      Icon(Icons.star_rounded, size: 20.sp, color: Colors.amber),
                      SizedBox(width: 4.w),
                      Text("5.0", style: CustomFonts.black16w600),
                      SizedBox(width: 8.w),
                      Text(
                        "(30k Reviews)",
                        style: CustomFonts.grey14w400,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: 20.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Divider(color: CustomColors.greyColor.withValues(alpha: 0.6), height: 1.h),
            ),
            SizedBox(height: 20.h),

            // 3. Elegant Glow Skin Clinic Card
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, ClinicsDetailScreen.routeName);
                },
                child: Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(
                      color: CustomColors.greyColor,
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.02),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: CustomColors.purpleColor.withValues(alpha: 0.4),
                            width: 2.w,
                          ),
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            DummyAssets.acen,
                            height: 52.w,
                            width: 52.w,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Glow Skin Clinic",
                              style: CustomFonts.black17w600,
                            ),
                            SizedBox(height: 4.h),
                            Row(
                              children: [
                                SvgPicture.asset(
                                  SvgAssets.flame,
                                  height: 12.h,
                                  width: 10.w,
                                  colorFilter: const ColorFilter.mode(
                                    CustomColors.pinkColor,
                                    BlendMode.srcIn,
                                  ),
                                ),
                                SizedBox(width: 4.w),
                                Text(
                                  "Top Rated Aesthetic Clinic",
                                  style: CustomFonts.pink13w500,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.chevron_right_rounded,
                        color: Colors.grey.shade400,
                        size: 24.sp,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            SizedBox(height: 24.h),

            // 4. Description and Key Benefits
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    treatments.description ??
                        "Achieve a youthful appearance with our aesthetic treatments to highlight your features. Whether adding volume, smoothing lines, or redefining contours, our solutions help you look and feel your best.",
                    style: CustomFonts.textGrey16w400,
                  ),
                  SizedBox(height: 24.h),

                  Text(
                    "Key Treatment Benefits",
                    style: CustomFonts.black18w600,
                  ),
                  SizedBox(height: 16.h),

                  _buildHighlightItem(
                    title: "Add Volume:",
                    description: "Restore lost fullness to areas like cheeks and lips for a plump, vibrant look.",
                  ),
                  SizedBox(height: 16.h),
                  _buildHighlightItem(
                    title: "Smooth Wrinkles:",
                    description: "Soften and diminish fine lines, giving your face a naturally refreshed texture.",
                  ),
                  SizedBox(height: 16.h),
                  _buildHighlightItem(
                    title: "Contour & Define:",
                    description: "Sculpt and enhance key areas such as your jawline, under-eyes, and lips for balanced, natural-looking results.",
                  ),
                ],
              ),
            ),

            SizedBox(height: 28.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Divider(color: CustomColors.greyColor.withValues(alpha: 0.6), height: 1.h),
            ),
            SizedBox(height: 28.h),

            // 5. Proof of Expertise Section Card
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Container(
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24.r),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      CustomColors.lightPurpleColor.withValues(alpha: 0.25),
                      CustomColors.lightBlueColor.withValues(alpha: 0.12),
                    ],
                  ),
                  border: Border.all(
                    color: CustomColors.lightPurpleColor.withValues(alpha: 0.4),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(8.w),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.8),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.verified_user_rounded,
                            color: CustomColors.darkPurple,
                            size: 20.sp,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Text(
                          "Proof Of Expertise",
                          style: CustomFonts.black20w600,
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      "Our certified clinical experts leverage advanced state-of-the-art technology and state-licensed medical professionals to deliver incredibly natural-looking and clinically precise results tailored exclusively for you.",
                      style: CustomFonts.black87_15w400,
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 160.h), // Provide padding for floating bottom bar
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 15,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.paddingOf(context).bottom),
          child: GlassMorphismContainer(
            blurIntensity: 25.0,
            opacity: 0.85,
            glassThickness: 1.0,
            enableBackgroundDistortion: true,
            enableGlassBorder: true,
            height: 146.h,
            child: Column(
              children: [
                // Alert Banner inside the bar
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  color: CustomColors.lightPurpleColor.withValues(alpha: 0.4),
                  child: Center(
                    child: Text(
                      "Complete booking steps to confirm total price",
                      style: CustomFonts.darkPurple12w600,
                    ),
                  ),
                ),

                // Pricing and CTA Action Button Row
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Left Price Column
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "\$650",
                              style: CustomFonts.black26w600,
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              "View Pricing Policy",
                              style: CustomFonts.grey12w500Underline,
                            ),
                          ],
                        ),

                        // Right CTA Button (Reusable Custom Button)
                        CustomButton(
                          text: "Book Now",
                          width: 175.w,
                          height: 50.h,
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              ClinicsDetailScreen.routeName,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Elegant Highlight/Bullet Item with soft-colored check icon
  Widget _buildHighlightItem({
    required String title,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(top: 3.h),
          padding: EdgeInsets.all(5.w),
          decoration: BoxDecoration(
            color: CustomColors.purpleColor.withValues(alpha: 0.18),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.check_rounded,
            size: 11.sp,
            color: CustomColors.darkPurple,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: "$title ",
                  style: CustomFonts.black16w600,
                ),
                TextSpan(
                  text: description,
                  style: CustomFonts.textGrey15w400,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
