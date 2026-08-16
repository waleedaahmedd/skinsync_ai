import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_glass_morphism/flutter_glass_morphism.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iconsax/iconsax.dart';
import 'clinics_detail_screen.dart';
import '../widgets/custom_button.dart';
import '../widgets/medical_disclaimer_banner.dart';
import '../utils/assets.dart';
import '../utils/color_constant.dart';
import '../utils/custom_fonts.dart';

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
                      bottom: Radius.circular(context.r(32)),
                    ),
                    child: Container(
                      height: context.h(310),
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
                      bottom: Radius.circular(context.r(32)),
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
                  top: MediaQuery.paddingOf(context).top + context.h(10),
                  left: context.w(24),
                  right: context.w(24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Back Button
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          height: context.w(42),
                          width: context.w(42),
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
                              size: context.sp(20),
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),

                      // Favorite Button
                      Container(
                        height: context.w(42),
                        width: context.w(42),
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
                            size: context.sp(20),
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: context.h(24)),

            // 2. Title & Reviews Section
            Padding(
              padding: EdgeInsets.symmetric(horizontal: context.w(24)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category Badge
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: context.w(12), vertical: context.h(6)),
                    decoration: BoxDecoration(
                      color: CustomColors.purpleColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(context.r(30)),
                    ),
                    child: Text(
                      "CLINICAL TREATMENT",
                      style: CustomFonts.darkPurple12w600,
                    ),
                  ),
                  SizedBox(height: context.h(12)),

                  // Treatment Name
                  Text(
                    treatments.name ?? "Derma Fillers",
                    style: CustomFonts.black28w600,
                  ),
                  SizedBox(height: context.h(8)),

                  // Rating and review count
                  Row(
                    children: [
                      Icon(Icons.star_rounded, size: context.sp(20), color: Colors.amber),
                      SizedBox(width: context.w(4)),
                      Text("5.0", style: CustomFonts.black16w600),
                      SizedBox(width: context.w(8)),
                      Text(
                        "(30k Reviews)",
                        style: CustomFonts.grey14w400,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: context.h(20)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: context.w(24)),
              child: Divider(color: CustomColors.greyColor.withValues(alpha: 0.6), height: context.h(1)),
            ),
            SizedBox(height: context.h(20)),

            // 3. Elegant Glow Skin Clinic Card
            Padding(
              padding: EdgeInsets.symmetric(horizontal: context.w(24)),
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, ClinicsDetailScreen.routeName);
                },
                child: Container(
                  padding: EdgeInsets.all(context.w(16)),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(context.r(20)),
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
                            width: context.w(2),
                          ),
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            DummyAssets.acen,
                            height: context.w(52),
                            width: context.w(52),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(width: context.w(16)),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Glow Skin Clinic",
                              style: CustomFonts.black17w600,
                            ),
                            SizedBox(height: context.h(4)),
                            Row(
                              children: [
                                SvgPicture.asset(
                                  SvgAssets.flame,
                                  height: context.h(12),
                                  width: context.w(10),
                                  colorFilter: const ColorFilter.mode(
                                    CustomColors.pinkColor,
                                    BlendMode.srcIn,
                                  ),
                                ),
                                SizedBox(width: context.w(4)),
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
                        size: context.sp(24),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            SizedBox(height: context.h(24)),

            // 4. Description and Key Benefits
            Padding(
              padding: EdgeInsets.symmetric(horizontal: context.w(24)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    treatments.description ??
                        "Achieve a youthful appearance with our aesthetic treatments to highlight your features. Whether adding volume, smoothing lines, or redefining contours, our solutions help you look and feel your best.",
                    style: CustomFonts.textGrey16w400,
                  ),
                  SizedBox(height: context.h(24)),

                  Text(
                    "Key Treatment Benefits",
                    style: CustomFonts.black18w600,
                  ),
                  SizedBox(height: context.h(16)),

                  _buildHighlightItem(
                    context: context,
                    title: "Add Volume:",
                    description: "Restore lost fullness to areas like cheeks and lips for a plump, vibrant look.",
                  ),
                  SizedBox(height: context.h(16)),
                  _buildHighlightItem(
                    context: context,
                    title: "Smooth Wrinkles:",
                    description: "Soften and diminish fine lines, giving your face a naturally refreshed texture.",
                  ),
                  SizedBox(height: context.h(16)),
                  _buildHighlightItem(
                    context: context,
                    title: "Contour & Define:",
                    description: "Sculpt and enhance key areas such as your jawline, under-eyes, and lips for balanced, natural-looking results.",
                  ),
                ],
              ),
            ),

            SizedBox(height: context.h(28)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: context.w(24)),
              child: Divider(color: CustomColors.greyColor.withValues(alpha: 0.6), height: context.h(1)),
            ),
            SizedBox(height: context.h(28)),

            // 5. Proof of Expertise Section Card
            Padding(
              padding: EdgeInsets.symmetric(horizontal: context.w(24)),
              child: Container(
                padding: EdgeInsets.all(context.w(20)),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(context.r(24)),
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
                          padding: EdgeInsets.all(context.w(8)),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.8),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.verified_user_rounded,
                            color: CustomColors.darkPurple,
                            size: context.sp(20),
                          ),
                        ),
                        SizedBox(width: context.w(12)),
                        Text(
                          "Proof Of Expertise",
                          style: CustomFonts.black20w600,
                        ),
                      ],
                    ),
                    SizedBox(height: context.h(12)),
                    Text(
                      "Our certified clinical experts leverage advanced state-of-the-art technology and state-licensed medical professionals to deliver incredibly natural-looking and clinically precise results tailored exclusively for you.",
                      style: CustomFonts.black87_15w400,
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: context.h(24)),
            const MedicalDisclaimerBanner(),

            SizedBox(height: context.h(160)), // Provide padding for floating bottom bar
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
            height: context.h(146),
            child: Column(
              children: [
                // Alert Banner inside the bar
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: context.h(8)),
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
                    padding: EdgeInsets.symmetric(horizontal: context.w(24)),
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
                            SizedBox(height: context.h(2)),
                            Text(
                              "View Pricing Policy",
                              style: CustomFonts.grey12w500Underline,
                            ),
                          ],
                        ),

                        // Right CTA Button (Reusable Custom Button)
                        CustomButton(
                          text: "Book Now",
                          width: context.w(175),
                          height: context.h(50),
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
    required BuildContext context,
    required String title,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(top: context.h(3)),
          padding: EdgeInsets.all(context.w(5)),
          decoration: BoxDecoration(
            color: CustomColors.purpleColor.withValues(alpha: 0.18),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.check_rounded,
            size: context.sp(11),
            color: CustomColors.darkPurple,
          ),
        ),
        SizedBox(width: context.w(12)),
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
