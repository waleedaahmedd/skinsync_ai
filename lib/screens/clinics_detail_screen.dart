import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_glass_morphism/flutter_glass_morphism.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:iconsax/iconsax.dart';

import '../models/responses/get_clinic_response.dart';
import '../utills/assets.dart';
import '../utills/color_constant.dart';
import '../utills/custom_fonts.dart';
import '../view_models/checkout_view_model.dart';
import '../widgets/custom_button.dart';
import 'select_appointment_type_screen.dart';

class ClinicsDetailScreen extends ConsumerWidget {
  final Clinic? clinic;
  const ClinicsDetailScreen({super.key, this.clinic});

  static const String routeName = '/ClinicsDetailScreen';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final checkoutState = ref.watch(checkoutViewModel);
    return Scaffold(
      backgroundColor: CustomColors.whiteColor,
      body: Stack(
        children: [
           Positioned.fill(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Curved Logo Cover Banner with Overlays
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.vertical(
                          bottom: Radius.circular(context.r(32)),
                        ),
                        child: Container(
                          height: context.h(310),
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            gradient: CustomColors.purpleBlueGradient,
                          ),
                          child: clinic?.logo != null
                              ? CachedNetworkImage(
                                  imageUrl: clinic!.logo!,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => Container(
                                    decoration: const BoxDecoration(
                                      gradient: CustomColors.purpleBlueGradient,
                                    ),
                                    child: const Center(
                                      child: CupertinoActivityIndicator(
                                        color: Colors.white,
                                      ),
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
                                )
                              : const Icon(
                                  Icons.storefront_rounded,
                                  size: 60,
                                  color: Colors.white70,
                                ),
                        ),
                      ),
            
                      // Translucent Gradient Overlay for Button readability
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
            
                      // Back and Favorite Buttons
                      Positioned(
                        top: MediaQuery.paddingOf(context).top + context.h(10),
                        left: context.w(24),
                        right: context.w(24),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
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
            
                  // 2. Clinic Name and Reviews Info Section
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: context.w(24)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                clinic?.name ?? 'N/A',
                                style: CustomFonts.black28w600,
                              ),
                            ),
                            SizedBox(width: context.w(12)),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: context.w(10),
                                vertical: context.h(6),
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                  context.r(30),
                                ),
                                color: CustomColors.lightBlueColor.withValues(
                                  alpha: 0.15,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
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
                                    "Top Choice",
                                    style: CustomFonts.pink10w700,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: context.h(10)),
                        Row(
                          children: [
                            Icon(
                              Icons.star_rounded,
                              size: context.sp(20),
                              color: Colors.amber,
                            ),
                            SizedBox(width: context.w(4)),
                            Text(
                              '${clinic?.place?.rating ?? 0}',
                              style: CustomFonts.black16w600,
                            ),
                            SizedBox(width: context.w(8)),
                            Text(
                              "(${clinic?.place?.userRatingCount ?? 0} Reviews) • 1M+ Booked",
                              style: CustomFonts.textGrey14w400,
                            ),
                          ],
                        ),
                        SizedBox(height: context.h(16)),
                        Text(
                          clinic?.place?.primaryTypeDisplayName?.text ??
                              "Achieve a youthful appearance with our aesthetic treatments to highlight your features. Whether adding volume, smoothing lines, or redefining contours, our solutions help you look and feel your best.",
                          style: CustomFonts.textGrey16w400,
                        ),
                      ],
                    ),
                  ),
            
                  SizedBox(height: context.h(24)),
            
                  // 3. Off-Peak Hours Card
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: context.w(24)),
                    child: Container(
                      padding: EdgeInsets.all(context.w(20)),
                      decoration: BoxDecoration(
                        color: CustomColors.lightPurpleColor.withValues(
                          alpha: 0.25,
                        ),
                        borderRadius: BorderRadius.circular(context.r(24)),
                        border: Border.all(
                          color: CustomColors.lightPurpleColor.withValues(
                            alpha: 0.4,
                          ),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Iconsax.clock,
                                color: CustomColors.darkPurple,
                                size: context.sp(20),
                              ),
                              SizedBox(width: context.w(8)),
                              Text(
                                "What Are Off-Peak Hours?",
                                style: CustomFonts.black18w600,
                              ),
                            ],
                          ),
                          SizedBox(height: context.h(10)),
                          Text(
                            "Book your appointment during quieter times and enjoy exclusive discounts.",
                            style: CustomFonts.black87_15w400,
                          ),
                        ],
                      ),
                    ),
                  ),
            
                  SizedBox(height: context.h(24)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: context.w(24)),
                    child: Divider(
                      color: CustomColors.greyColor.withValues(alpha: 0.6),
                      height: context.h(1),
                    ),
                  ),
                  SizedBox(height: context.h(24)),
            
                  // 4. Map & Working Days Section
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: context.w(24)),
                    child: Container(
                      padding: EdgeInsets.all(context.w(18)),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(context.r(24)),
                        color: Colors.white,
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.calendar_today_outlined,
                                    color: CustomColors.blueColor,
                                    size: context.sp(16),
                                  ),
                                  SizedBox(width: context.w(8)),
                                  switch (clinic
                                          ?.place
                                          ?.currentOpeningHours
                                          ?.periods
                                          ?.length ??
                                      0) {
                                    0 => Text(
                                      'Closed',
                                      style: CustomFonts.black18w600,
                                    ),
                                    1 => Text(
                                      'Monday',
                                      style: CustomFonts.black18w600,
                                    ),
                                    2 => Text(
                                      'Monday - Tuesday',
                                      style: CustomFonts.black18w600,
                                    ),
                                    3 => Text(
                                      'Monday - Wednesday',
                                      style: CustomFonts.black18w600,
                                    ),
                                    4 => Text(
                                      'Monday - Thursday',
                                      style: CustomFonts.black18w600,
                                    ),
                                    5 => Text(
                                      'Monday - Friday',
                                      style: CustomFonts.black18w600,
                                    ),
                                    6 => Text(
                                      'Monday - Saturday',
                                      style: CustomFonts.black18w600,
                                    ),
                                    7 => Text(
                                      'Monday - Sunday',
                                      style: CustomFonts.black18w600,
                                    ),
                                    int() => throw UnimplementedError(),
                                  },
                                ],
                              ),
                              Text(
                                clinic
                                        ?.place
                                        ?.currentOpeningHours
                                        ?.todayOpeningHours ??
                                    '',
                                style: CustomFonts.textGrey14w400,
                              ),
                            ],
                          ),
                          SizedBox(height: context.h(18)),
                          Divider(
                            height: context.h(1),
                            color: CustomColors.greyColor.withValues(alpha: 0.6),
                          ),
                          SizedBox(height: context.h(18)),
                          if (clinic?.place?.location != null)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(context.r(16)),
                              child: SizedBox(
                                height: context.h(240),
                                width: double.infinity,
                                child: GoogleMap(
                                  initialCameraPosition: CameraPosition(
                                    target: LatLng(
                                      clinic!.place!.location!.latitude!,
                                      clinic!.place!.location!.longitude!,
                                    ),
                                    zoom: 13,
                                  ),
                                  padding: MediaQuery.paddingOf(ref.context),
                                  markers: {
                                    Marker(
                                      markerId: const MarkerId("clinic_location"),
                                      position: LatLng(
                                        clinic!.place!.location!.latitude!,
                                        clinic!.place!.location!.longitude!,
                                      ),
                                    ),
                                  },
                                  zoomControlsEnabled: false,
                                  zoomGesturesEnabled: false,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
            
                  SizedBox(
                    height: context.h(160),
                  ), // Provide padding so content isn't hidden behind fixed bar
                ],
              ),
            ),
          ),

          
          // Fixed bottom bar
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              // include bottom safe-area inset so the glass bg reaches the screen edge
              height: context.h(146) + MediaQuery.paddingOf(context).bottom,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 15,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: GlassMorphismContainer(
                borderRadius: BorderRadius.zero,
                blurIntensity: 25.0,
                opacity: 0.85,
                glassThickness: 1.0,
                enableBackgroundDistortion: true,
                enableGlassBorder: true,
                height: context.h(146) + MediaQuery.paddingOf(context).bottom,
                child: Padding(
                  // push content above the safe area; background still fills to bottom
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.paddingOf(context).bottom,
                  ),
                  child: Column(
                    children: [
                      // Alert Banner
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: context.h(8)),
                        color: CustomColors.lightPurpleColor.withValues(
                          alpha: 0.4,
                        ),
                        child: Center(
                          child: Text(
                            'Complete The Appointment Timing Slot To View Full Price',
                            style: CustomFonts.darkPurple12w600,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),

                      // Book Appointment Button
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: context.w(20),
                            vertical: context.h(28),
                          ),
                          child: SizedBox(
                            height: context.h(52),
                            width: double.infinity,
                            child: CustomButton(
                              text: checkoutState.isInviteClinic
                                  ? 'Invite this Medical Spa'
                                  : 'Book an Appointment',
                              height: context.h(52),
                              borderRadius: context.r(25),
                              onPressed: () {
                                if (clinic != null) {
                                  ref
                                      .read(checkoutViewModel.notifier)
                                      .setSelectedClinic(clinic!);
                                }

                                Navigator.pushNamed(
                                  context,
                                  SelectAppointmentTypeScreen.routeName,
                                  arguments: clinic,
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
