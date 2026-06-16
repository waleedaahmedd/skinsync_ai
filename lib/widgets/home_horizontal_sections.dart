import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../models/dummy_list_model.dart';
import '../screens/appointment_detail_screen.dart';
import '../utills/color_constant.dart';
import '../utills/custom_fonts.dart';

class DoctorHomeCard extends StatelessWidget {
  final DummyDoctor doctor;
  const DoctorHomeCard({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160.w,
      margin: EdgeInsets.only(right: 15.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(12.r)),
            child: CachedNetworkImage(
              imageUrl: doctor.image,
              height: 100.h,
              width: double.infinity,
              fit: BoxFit.cover,
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
                        const Icon(Icons.star, color: Colors.amber, size: 10),
                        SizedBox(width: 2.w),
                        Text(doctor.rating.toString(), style: CustomFonts.black10w600.copyWith(fontSize: 9.sp)),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                Text(
                  doctor.specialization,
                  style: CustomFonts.grey14w400.copyWith(fontSize: 10.sp),
                  maxLines: 1,
                ),
                SizedBox(height: 4.h),
                Text(
                  doctor.clinicName,
                  style: CustomFonts.black10w600.copyWith(color: CustomColors.darkPurple, fontSize: 9.sp),
                  maxLines: 1,
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
      width: 240.w,
      margin: EdgeInsets.only(right: 15.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(12.r)),
            child: CachedNetworkImage(
              imageUrl: clinic.image,
              height: 110.h,
              width: double.infinity,
              fit: BoxFit.cover,
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
                      ),
                    ),
                    Text(
                      "${clinic.doctorCount} Doctors",
                      style: CustomFonts.black10w600.copyWith(color: CustomColors.darkPurple, fontSize: 9.sp),
                    ),
                  ],
                ),
                SizedBox(height: 4.h),
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
      margin: EdgeInsets.only(right: 15.w),
      padding: EdgeInsets.fromLTRB(14.w, 10.h, 4.w, 10.h),
      decoration: BoxDecoration(
        color: CustomColors.blueColor,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: CustomColors.lightPurpleColor.withValues(alpha: 0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 2.w),
            child: Text(
              dateTitle,
              style: CustomFonts.black14w600.copyWith(
                color: CustomColors.whiteColor,
                letterSpacing: 0.3,
                fontSize: 13.sp,
              ),
            ),
          ),
          SizedBox(height: 8.h),
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

  Color _getTypeColor(String type) {
    switch (type) {
      case "Consultation": return CustomColors.lightBlueColor;
      case "Sessions": return CustomColors.purpleColor;
      case "Follow-Up / Touch-Up": return CustomColors.lightPurpleColor;
      case "Provisional Booking": return CustomColors.yellow;
      default: return Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    Color typeColor = _getTypeColor(appointment.type);
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
        width: 230.w,
        margin: EdgeInsets.only(right: 10.w),
        decoration: BoxDecoration(
          color: typeColor,
          borderRadius: BorderRadius.circular(14.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
              child: Text(
                appointment.type,
                style: CustomFonts.black14w400,
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(6.w, 0, 6.w, 6.h),
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${appointment.treatmentName} - ${appointment.area}",
                    style: CustomFonts.black14w600.copyWith(fontSize: 13.sp),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 6.h),
                  _buildIconLabel(Icons.business_outlined, appointment.clinicName),
                  SizedBox(height: 4.h),
                  _buildIconLabel(Icons.person_outline, appointment.doctorName),
                  SizedBox(height: 8.h),
                  const Divider(height: 1),
                  SizedBox(height: 6.h),
                  Row(
                    children: [
                      Icon(Icons.access_time, size: 12.sp, color: CustomColors.blueColor),
                      SizedBox(width: 6.w),
                      Text(
                        appointment.time,
                        style: CustomFonts.black12w600.copyWith(fontSize: 10.sp, color: CustomColors.blueColor),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconLabel(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 12.sp, color: Colors.grey.shade600),
        SizedBox(width: 6.w),
        Expanded(
          child: Text(
            label,
            style: CustomFonts.grey14w400.copyWith(fontSize: 11.sp),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
