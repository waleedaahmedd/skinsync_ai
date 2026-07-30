import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../models/dummy_list_model.dart';
import '../models/responses/auth_response.dart';
import '../screens/appointment_detail_screen.dart';
import '../utills/color_constant.dart';
import '../utills/custom_fonts.dart';
import '../utills/date_time_utills.dart';
import 'doctor_card.dart';

class DoctorHomeCard extends StatelessWidget {
  final DummyDoctor doctor;
  const DoctorHomeCard({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    return DoctorCard(doctor: doctor);
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
        border: Border.all(
          color: CustomColors.greyColor.withValues(alpha: 0.6),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
            child: CachedNetworkImage(
              imageUrl: clinic.image,
              height: 100.h,
              width: double.infinity,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                color: Colors.grey.shade100,
                child: const Center(child: CupertinoActivityIndicator()),
              ),
              errorWidget: (context, url, error) => Container(
                color: Colors.grey.shade100,
                child: const Icon(
                  Icons.storefront_rounded,
                  size: 30,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
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
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: CustomColors.purpleColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Text(
                        "${clinic.doctorCount} Doctors",
                        style: CustomFonts.darkPurple12w600,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 6.h),
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 12.sp,
                      color: Colors.grey,
                    ),
                    SizedBox(width: 4.w),
                    Expanded(
                      child: Text(
                        clinic.address,
                        style: CustomFonts.grey700_10w400,
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
  const UpcomingAppointmentDateSection({
    super.key,
    required this.dateTitle,
    required this.appointments,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 16.w),
      padding: EdgeInsets.fromLTRB(16.w, 10.h, 10.w, 10.h),
      decoration: BoxDecoration(
        gradient: CustomColors.purpleBlueGradient,
        borderRadius: BorderRadius.circular(22.r),
        border: Border.all(
          color: CustomColors.greyColor.withValues(
            alpha: 0.6,
          ), // Delicate border
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: 0.02,
            ), // Ultra-soft feathered shadow
            blurRadius: 16,
            offset: const Offset(0, 6),
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
              const Icon(
                Icons.calendar_today_rounded,
                color: CustomColors.blackColor,
                size: 13,
              ),
              SizedBox(width: 6.w),
              Text(dateTitle, style: CustomFonts.black13w600),
            ],
          ),
          SizedBox(height: 10.h),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: appointments
                .map(
                  (appointment) =>
                      UpcomingAppointmentHomeCard(appointment: appointment),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}

class DashboardAppointmentDateSection extends StatelessWidget {
  final String dateTitle;
  final List<DashboardAppointment> appointments;
  const DashboardAppointmentDateSection({
    super.key,
    required this.dateTitle,
    required this.appointments,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 16.w),
      padding: EdgeInsets.fromLTRB(16.w, 10.h, 10.w, 10.h),
      decoration: BoxDecoration(
        gradient: CustomColors.purpleBlueGradient,
        borderRadius: BorderRadius.circular(22.r),
        border: Border.all(
          color: CustomColors.greyColor.withValues(alpha: 0.6),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 16,
            offset: const Offset(0, 6),
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
              const Icon(
                Icons.calendar_today_rounded,
                color: CustomColors.blackColor,
                size: 13,
              ),
              SizedBox(width: 6.w),
              Text(dateTitle, style: CustomFonts.black13w600),
            ],
          ),
          SizedBox(height: 10.h),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: appointments
                .map(
                  (appointment) =>
                      DashboardAppointmentHomeCard(appointment: appointment),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}

class DashboardAppointmentHomeCard extends StatelessWidget {
  final DashboardAppointment appointment;
  const DashboardAppointmentHomeCard({super.key, required this.appointment});

  Color _getTypeAccentColor(String? type) {
    switch (type?.toLowerCase()) {
      case "consultation":
        return CustomColors.blueColor;
      case "treatment":
      case "sessions":
        return CustomColors.pinkColor;
      default:
        return CustomColors.purpleColor;
    }
  }

  TextStyle _getTimeStyle(String? type) {
    switch (type?.toLowerCase()) {
      case "consultation":
        return CustomFonts.blue10w700;
      case "treatment":
      case "sessions":
        return CustomFonts.pink10w700;
      default:
        return CustomFonts.blue10w700;
    }
  }

  @override
  Widget build(BuildContext context) {
    final accentColor = _getTypeAccentColor(appointment.appointmentType);
    final timeStyle = _getTimeStyle(appointment.appointmentType);

    final treatment = appointment.treatments?.firstOrNull?.firstOrNull;
    final treatmentName = treatment?.treatmentName ?? "Consultation";
    final areaName = treatment?.areaName ?? "Full Face";

    final bgImage = treatmentName.toLowerCase().contains("botox")
        ? "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQl-cyJqFlcZav1TlRMEuajtrg2RJlWY3rTQA&s"
        : "https://movelmedspa.com/storage/2024/05/Cheek-Filler-Treatment-at-Movel-Med-Spa.webp";

    final timeString = appointment.date != null
        ? DateTimeUtils.fromTimestamp(appointment.date!).formattedTime
        : "--:--";

    return GestureDetector(
      onTap: () {
        // Handle navigation or detail view
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
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16.r),
          child: Stack(
            children: [
              Positioned.fill(
                child: CachedNetworkImage(
                  imageUrl: bgImage,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: Colors.grey.shade100,
                    child: const Center(child: CupertinoActivityIndicator()),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: Colors.grey.shade100,
                    child: const Icon(
                      Icons.broken_image_rounded,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                child: Container(color: Colors.white.withValues(alpha: 0.75)),
              ),
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                width: 4.w,
                child: Container(color: accentColor),
              ),
              Positioned.fill(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(14.w, 10.h, 10.w, 10.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  treatmentName,
                                  style: CustomFonts.black13w600,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 1.h),
                                Text(
                                  areaName,
                                  style: CustomFonts.grey700_10w400,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 6.w),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.w,
                              vertical: 3.h,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20.r),
                              border: Border.all(
                                color: Colors.black12,
                                width: 0.5,
                              ),
                            ),
                            child: Text(
                              appointment.appointmentType ?? "N/A",
                              style: timeStyle.copyWith(fontSize: 8.sp),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.business_rounded,
                                size: 12,
                                color: Colors.grey.shade600,
                              ),
                              SizedBox(width: 6.w),
                              Expanded(
                                child: Text(
                                  appointment.clinic?.clinicName ??
                                      "Awaiting Confirmation",
                                  style: CustomFonts.textGrey13w400,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 2.h),
                          Row(
                            children: [
                              Icon(
                                Icons.person_rounded,
                                size: 12,
                                color: Colors.grey.shade600,
                              ),
                              SizedBox(width: 6.w),
                              Expanded(
                                child: Text(
                                  appointment.doctor?.doctorName ?? "Pending",
                                  style: CustomFonts.textGrey13w400,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 3.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.access_time_filled_rounded,
                              size: 10,
                              color: Colors.grey.shade600,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              timeString,
                              style: CustomFonts.black10w600,
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

class DashboardDoctorHomeCard extends StatelessWidget {
  final TopDoctor doctor;
  const DashboardDoctorHomeCard({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160.w,
      margin: EdgeInsets.only(right: 16.w, bottom: 8.h, top: 4.h),
      padding: EdgeInsets.all(12.w),
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
        border: Border.all(
          color: CustomColors.greyColor.withValues(alpha: 0.6),
        ),
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: CachedNetworkImage(
              imageUrl: doctor.doctorImage ?? "",
              height: 100.h,
              width: double.infinity,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                color: Colors.grey.shade100,
                child: const Center(child: CupertinoActivityIndicator()),
              ),
              errorWidget: (context, url, error) => Container(
                color: Colors.grey.shade100,
                child: const Icon(Icons.person, color: Colors.grey),
              ),
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            doctor.doctorName ?? "Unknown Doctor",
            style: CustomFonts.black14w600,
            maxLines: 1,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 2.h),
          Text(
            doctor.specialization ?? "Specialist",
            style: CustomFonts.grey700_10w400,
            maxLines: 1,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 4.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.star_rounded, color: Colors.amber, size: 14),
              SizedBox(width: 2.w),
              Text(
                (doctor.doctorRating ?? 0.0).toStringAsFixed(1),
                style: CustomFonts.black12w600,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class DashboardClinicHomeCard extends StatelessWidget {
  final TopClinic clinic;
  const DashboardClinicHomeCard({super.key, required this.clinic});

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
        border: Border.all(
          color: CustomColors.greyColor.withValues(alpha: 0.6),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
            child: CachedNetworkImage(
              imageUrl: clinic.clinicImage ?? "",
              height: 100.h,
              width: double.infinity,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                color: Colors.grey.shade100,
                child: const Center(child: CupertinoActivityIndicator()),
              ),
              errorWidget: (context, url, error) => Container(
                color: Colors.grey.shade100,
                child: const Icon(
                  Icons.storefront_rounded,
                  size: 30,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        clinic.clinicName ?? "Unknown Clinic",
                        style: CustomFonts.black14w600,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: CustomColors.purpleColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Text(
                        "${clinic.doctorCount ?? 0} Doctors",
                        style: CustomFonts.darkPurple12w600,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 6.h),
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 12.sp,
                      color: Colors.grey,
                    ),
                    SizedBox(width: 4.w),
                    Expanded(
                      child: Text(
                        clinic.address ?? "No address provided",
                        style: CustomFonts.grey700_10w400,
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

class UpcomingAppointmentHomeCard extends StatelessWidget {
  final DummyAppointment appointment;
  const UpcomingAppointmentHomeCard({super.key, required this.appointment});

  // Vertical Left Accent Color & Badge Styling based on type
  Color _getTypeAccentColor(String type) {
    switch (type) {
      case "Consultation":
        return CustomColors.blueColor;
      case "Sessions":
        return CustomColors.pinkColor;
      case "Follow-Up / Touch-Up":
        return CustomColors.darkPurple;
      case "Provisional Booking":
        return CustomColors.yellow;
      default:
        return CustomColors.purpleColor;
    }
  }

  TextStyle _getTimeStyle(String type) {
    switch (type) {
      case "Consultation":
        return CustomFonts.blue10w700;
      case "Sessions":
        return CustomFonts.pink10w700;
      case "Follow-Up / Touch-Up":
        return CustomFonts.darkPurple10w700;
      case "Provisional Booking":
        return CustomFonts.amber10w700;
      default:
        return CustomFonts.blue10w700;
    }
  }

  @override
  Widget build(BuildContext context) {
    final accentColor = _getTypeAccentColor(appointment.type);
    final timeStyle = _getTimeStyle(appointment.type);

    // Dynamic background image matching TreatmentContainer falling back logic
    final bgImage = appointment.treatmentName.toLowerCase().contains("botox")
        ? "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQl-cyJqFlcZav1TlRMEuajtrg2RJlWY3rTQA&s"
        : "https://movelmedspa.com/storage/2024/05/Cheek-Filler-Treatment-at-Movel-Med-Spa.webp";

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                AppointmentDetailScreen(appointment: appointment),
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
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16.r),
          child: Stack(
            children: [
              // 1. Cover Image Background
              Positioned.fill(
                child: CachedNetworkImage(
                  imageUrl: bgImage,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: Colors.grey.shade100,
                    child: const Center(child: CupertinoActivityIndicator()),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: Colors.grey.shade100,
                    child: const Icon(
                      Icons.broken_image_rounded,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),

              // 2. Translucent Premium White Mask Overlay (Guarantees absolute legibility)
              Positioned.fill(
                child: Container(color: Colors.white.withValues(alpha: 0.75)),
              ),

              // 3. Vertical Accent Left Indicator Bar
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                width: 4.w,
                child: Container(color: accentColor),
              ),

              // 4. Card Content Layout
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
                                  style: CustomFonts.black13w600,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 1.h),
                                Text(
                                  appointment.area,
                                  style: CustomFonts.grey700_10w400,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 6.w),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.w,
                              vertical: 3.h,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20.r),
                              border: Border.all(
                                color: Colors.black12,
                                width: 0.5,
                              ),
                            ),
                            child: Text(
                              appointment.type,
                              style: timeStyle.copyWith(
                                fontSize: 8.sp,
                              ), // permitted copyWith for dynamic auto font size only
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
                              Icon(
                                Icons.business_rounded,
                                size: 12,
                                color: Colors.grey.shade600,
                              ),
                              SizedBox(width: 6.w),
                              Expanded(
                                child: Text(
                                  appointment.clinicName,
                                  style: CustomFonts.textGrey13w400,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 2.h),
                          Row(
                            children: [
                              Icon(
                                Icons.person_rounded,
                                size: 12,
                                color: Colors.grey.shade600,
                              ),
                              SizedBox(width: 6.w),
                              Expanded(
                                child: Text(
                                  appointment.doctorName,
                                  style: CustomFonts.textGrey13w400,
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
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 3.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.access_time_filled_rounded,
                              size: 10,
                              color: Colors.grey.shade600,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              appointment.time,
                              style: CustomFonts.black10w600,
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
