import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_glass_morphism/flutter_glass_morphism.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:iconsax/iconsax.dart';
import 'package:skinsync_ai/models/responses/get_clinic_response.dart';
import 'package:skinsync_ai/utills/assets.dart';
import 'package:skinsync_ai/utills/color_constant.dart';
import 'package:skinsync_ai/utills/custom_fonts.dart';

import '../widgets/bottom_sheets/before_you_bookbottomsheet.dart';
import '../widgets/bottom_sheets/pre_booking_bottom_sheet.dart';
import '../widgets/bottom_sheets/wallet_confirmation_bottom_sheet.dart';
import '../widgets/dialogs/appointment_success_dialog.dart';
import 'bottom_nav_page.dart';
import 'select_appointment_type_screen.dart';

class ClinicsDetailScreen extends ConsumerWidget {
  final Clinic? clinic;
  const ClinicsDetailScreen({super.key, this.clinic});

  static const String routeName = '/ClinicsDetailScreen';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      extendBody: true,
      backgroundColor: CustomColors.whiteColor,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Curved Logo Cover Banner with Overlays
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(32.r),
                  ),
                  child: Container(
                    height: 310.h,
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

                // Back and Favorite Buttons
                Positioned(
                  top: MediaQuery.paddingOf(context).top + 10.h,
                  left: 24.w,
                  right: 24.w,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
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

            // 2. Clinic Name and Reviews Info Section
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          clinic?.clinicName ?? 'N/A',
                          style: CustomFonts.black28w600,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 6.h,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30.r),
                          color: CustomColors.lightBlueColor.withValues(
                            alpha: 0.15,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
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
                              "Top Choice",
                              style: CustomFonts.pink10w700,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    children: [
                      Icon(Icons.star_rounded, size: 20.sp, color: Colors.amber),
                      SizedBox(width: 4.w),
                      Text(
                        '${clinic?.place?.rating ?? 0}',
                        style: CustomFonts.black16w600,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        "(${clinic?.place?.userRatingCount ?? 0} Reviews) • 1M+ Booked",
                        style: CustomFonts.textGrey14w400,
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    clinic?.place?.primaryTypeDisplayName?.text ??
                        "Achieve a youthful appearance with our aesthetic treatments to highlight your features. Whether adding volume, smoothing lines, or redefining contours, our solutions help you look and feel your best.",
                    style: CustomFonts.textGrey16w400,
                  ),
                ],
              ),
            ),

            SizedBox(height: 24.h),

            // 3. Off-Peak Hours Card
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Container(
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  color: CustomColors.lightPurpleColor.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(24.r),
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
                        Icon(
                          Iconsax.clock,
                          color: CustomColors.darkPurple,
                          size: 20.sp,
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          "What Are Off-Peak Hours?",
                          style: CustomFonts.black18w600,
                        ),
                      ],
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      "Book your appointment during quieter times and enjoy exclusive discounts.",
                      style: CustomFonts.black87_15w400,
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 24.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Divider(color: CustomColors.greyColor.withValues(alpha: 0.6), height: 1.h),
            ),
            SizedBox(height: 24.h),

            // 4. Map & Working Days Section
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Container(
                padding: EdgeInsets.all(18.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24.r),
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
                              size: 16.sp,
                            ),
                            SizedBox(width: 8.w),
                            switch (clinic?.place?.currentOpeningHours?.periods?.length ?? 0) {
                              0 => Text('Closed', style: CustomFonts.black18w600),
                              1 => Text('Monday', style: CustomFonts.black18w600),
                              2 => Text('Monday - Tuesday', style: CustomFonts.black18w600),
                              3 => Text('Monday - Wednesday', style: CustomFonts.black18w600),
                              4 => Text('Monday - Thursday', style: CustomFonts.black18w600),
                              5 => Text('Monday - Friday', style: CustomFonts.black18w600),
                              6 => Text('Monday - Saturday', style: CustomFonts.black18w600),
                              7 => Text('Monday - Sunday', style: CustomFonts.black18w600),
                              int() => throw UnimplementedError(),
                            },
                          ],
                        ),
                        Text(
                          clinic?.place?.currentOpeningHours?.todayOpeningHours ?? '',
                          style: CustomFonts.textGrey14w400,
                        ),
                      ],
                    ),
                    SizedBox(height: 18.h),
                    Divider(
                      height: 1.h,
                      color: CustomColors.greyColor.withValues(alpha: 0.6),
                    ),
                    SizedBox(height: 18.h),
                    if (clinic?.place?.location != null)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16.r),
                        child: SizedBox(
                          height: 240.h,
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

            SizedBox(height: 160.h), // Provide padding for floating bottom bar
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 15,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.paddingOf(context).bottom),
          child: GlassMorphismContainer(
            borderRadius: BorderRadius.all(Radius.circular(0.r)),
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
                      "Complete The Appointment Timing Slot To View Full Price",
                      style: CustomFonts.darkPurple12w600,
                    ),
                  ),
                ),

                // Full-width Button Booking Slot Row
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                    child: SizedBox(
                      width: double.infinity,
                      height: 52.h,
                      child: ElevatedButton(
                        onPressed: () {
                          if (clinic?.place != null) {
                            PreBookingBottomSheet.show(
                              context,
                              clinic: clinic!,
                              onConfirm: () {
                                WalletConfirmationBottomSheet.show(
                                  context,
                                  onConfirm: () {
                                    BeforeYouBookBottomSheet.show(
                                      context,
                                      onConfirm: () {
                                        showAppointmentSuccessDialog(
                                          context: context,
                                          onDone: () {
                                            Navigator.pushNamedAndRemoveUntil(
                                              context,
                                              BottomNavPage.routeName,
                                              (_) => false,
                                            );
                                          },
                                        );
                                      },
                                    );
                                  },
                                );
                              },
                            );
                          } else {
                            Navigator.pushNamed(
                              context,
                              SelectAppointmentTypeScreen.routeName,
                              arguments: clinic,
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          textStyle: CustomFonts.white16w600,
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.r),
                          ),
                          elevation: 2,
                        ),
                        child: Text(
                          clinic?.place != null
                              ? "Invite this Medical Spa"
                              : 'Book an Appointment',
                        ),
                      ),
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
}
