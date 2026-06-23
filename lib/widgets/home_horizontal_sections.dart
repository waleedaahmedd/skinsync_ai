import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skinsync_ai/models/dummy_list_model.dart';
import 'package:skinsync_ai/screens/appointment_detail_screen.dart';
import 'package:skinsync_ai/utills/color_constant.dart';
import 'package:skinsync_ai/utills/custom_fonts.dart';

class DoctorHomeCard extends StatelessWidget {
  final DummyDoctor doctor;
  const DoctorHomeCard({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 165.w,
      margin: EdgeInsets.only(right: 16.w, bottom: 8.h, top: 4.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: CustomColors.greyColor.withValues(alpha: 0.6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
            child: CachedNetworkImage(
              imageUrl: doctor.image,
              height: 100.h,
              width: double.infinity,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                color: Colors.grey.shade100,
                child: const Center(child: CupertinoActivityIndicator()),
              ),
              errorWidget: (context, url, error) => Container(
                color: Colors.grey.shade100,
                child: const Icon(Icons.person_outline_rounded, size: 30, color: Colors.grey),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        doctor.name,
                        style: CustomFonts.black12w600.copyWith(fontSize: 12.sp),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.star_rounded, color: Colors.amber, size: 14),
                        SizedBox(width: 2.w),
                        Text(
                          doctor.rating.toString(),
                          style: CustomFonts.black10w600.copyWith(fontSize: 9.sp),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 4.h),
                Text(
                  doctor.specialization,
                  style: CustomFonts.grey14w400.copyWith(fontSize: 10.sp),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 6.h),
                Text(
                  doctor.clinicName,
                  style: CustomFonts.black10w600.copyWith(
                    color: CustomColors.darkPurple,
                    fontSize: 9.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ClinicHomeCard extends StatelessWidget {
  final DummyClinic clinic;
  const ClinicHomeCard({super.key, required this.clinic});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 245.w,
      margin: EdgeInsets.only(right: 16.w, bottom: 8.h, top: 4.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: CustomColors.greyColor.withValues(alpha: 0.6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
            child: CachedNetworkImage(
              imageUrl: clinic.image,
              height: 110.h,
              width: double.infinity,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                color: Colors.grey.shade100,
                child: const Center(child: CupertinoActivityIndicator()),
              ),
              errorWidget: (context, url, error) => Container(
                color: Colors.grey.shade100,
                child: const Icon(Icons.storefront_rounded, size: 30, color: Colors.grey),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(12.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        clinic.name,
                        style: CustomFonts.black14w600,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: CustomColors.purpleColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Text(
                        "${clinic.doctorCount} Doctors",
                        style: CustomFonts.black10w600.copyWith(
                          color: CustomColors.darkPurple,
                          fontSize: 9.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 6.h),
                Row(
                  children: [
                    Icon(Icons.location_on_outlined, size: 12.sp, color: Colors.grey),
                    SizedBox(width: 4.w),
                    Expanded(
                      child: Text(
                        clinic.address,
                        style: CustomFonts.grey14w400.copyWith(fontSize: 10.sp),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class UpcomingAppointmentDateSection extends StatelessWidget {
  final String dateTitle;
  final List<DummyAppointment> appointments;
  const UpcomingAppointmentDateSection({super.key, required this.dateTitle, required this.appointments});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 16.w),
      padding: EdgeInsets.fromLTRB(16.w, 10.h, 10.w, 10.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF2E1C38), // Deep luxury purple (Loyalty rewards consistency)
            Color(0xFF140F26), // Midnight black
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: CustomColors.purpleColor.withValues(alpha: 0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Icon(Icons.calendar_today_rounded, color: CustomColors.purpleColor, size: 14),
              SizedBox(width: 6.w),
              Text(
                dateTitle,
                style: CustomFonts.black14w600.copyWith(
                  color: Colors.white,
                  letterSpacing: 0.2,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: appointments.map((appointment) => UpcomingAppointmentHomeCard(appointment: appointment)).toList(),
          ),
        ],
      ),
    );
  }
}

class UpcomingAppointmentHomeCard extends StatelessWidget {
  final DummyAppointment appointment;
  const UpcomingAppointmentHomeCard({super.key, required this.appointment});

  // Vertical Left Accent Color & Badge Styling based on type
  Color _getTypeAccentColor(String type) {
    switch (type) {
      case "Consultation": return CustomColors.blueColor;
      case "Sessions": return CustomColors.pinkColor;
      case "Follow-Up / Touch-Up": return CustomColors.darkPurple;
      case "Provisional Booking": return CustomColors.yellow;
      default: return CustomColors.purpleColor;
    }
  }

  Color _getTypeBgColor(String type) {
    switch (type) {
      case "Consultation": return CustomColors.blueColor.withValues(alpha: 0.08);
      case "Sessions": return CustomColors.pinkColor.withValues(alpha: 0.08);
      case "Follow-Up / Touch-Up": return CustomColors.darkPurple.withValues(alpha: 0.08);
      case "Provisional Booking": return CustomColors.yellow.withValues(alpha: 0.12);
      default: return CustomColors.purpleColor.withValues(alpha: 0.08);
    }
  }

  @override
  Widget build(BuildContext context) {
    final accentColor = _getTypeAccentColor(appointment.type);
    final badgeBgColor = _getTypeBgColor(appointment.type);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AppointmentDetailScreen(appointment: appointment),
          ),
        );
      },
      child: Container(
        width: 245.w,
        height: 135.h,
        margin: EdgeInsets.only(right: 8.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16.r),
          child: Stack(
            children: [
              // 1. Vertical Accent Left Indicator Bar
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                width: 4.w,
                child: Container(color: accentColor),
              ),

              // 2. Card Content Layout
              Positioned.fill(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(14.w, 10.h, 10.w, 10.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Header Row: Treatment Title & Type Badge
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  appointment.treatmentName,
                                  style: CustomFonts.black14w600.copyWith(
                                    fontSize: 13.sp,
                                    height: 1.1,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 1.h),
                                Text(
                                  appointment.area,
                                  style: CustomFonts.grey14w400.copyWith(
                                    fontSize: 10.sp,
                                    color: Colors.grey.shade600,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 6.w),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                            decoration: BoxDecoration(
                              color: badgeBgColor,
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            child: Text(
                              appointment.type,
                              style: TextStyle(
                                color: accentColor,
                                fontSize: 8.sp,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Degular',
                              ),
                            ),
                          ),
                        ],
                      ),

                      // Middle Section: Clinic & Doctor Info
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.business_rounded, size: 12.sp, color: Colors.grey.shade500),
                              SizedBox(width: 4.w),
                              Expanded(
                                child: Text(
                                  appointment.clinicName,
                                  style: CustomFonts.grey14w400.copyWith(fontSize: 10.sp, color: Colors.grey.shade700),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 2.h),
                          Row(
                            children: [
                              Icon(Icons.person_rounded, size: 12.sp, color: Colors.grey.shade500),
                              SizedBox(width: 4.w),
                              Expanded(
                                child: Text(
                                  appointment.doctorName,
                                  style: CustomFonts.grey14w400.copyWith(fontSize: 10.sp, color: Colors.grey.shade700),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      // Bottom Section: Clock Time Badge
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                        decoration: BoxDecoration(
                          color: CustomColors.blueColor.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.access_time_filled_rounded, size: 10.sp, color: CustomColors.blueColor),
                            SizedBox(width: 4.w),
                            Text(
                              appointment.time,
                              style: CustomFonts.black12w600.copyWith(
                                fontSize: 9.sp,
                                color: CustomColors.blueColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
