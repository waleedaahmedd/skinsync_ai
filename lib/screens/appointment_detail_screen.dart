import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../models/responses/get_appointment_response.dart';
import '../utills/color_constant.dart';
import '../utills/custom_fonts.dart';
import '../utills/date_time_utills.dart';

class AppointmentDetailScreen extends StatelessWidget {
  final AppointmentItem appointment;

  const AppointmentDetailScreen({super.key, required this.appointment});

  @override
  Widget build(BuildContext context) {
    final type = appointment.appointmentType ?? "consultation";

    final dateStr = appointment.date != null
        ? DateTimeUtils.formatTimestampToDayDate(appointment.date!)
        : "N/A";

    final startTime = appointment.slot?.startTime != null
        ? DateTimeUtils.formatTimestampToTime(appointment.slot!.startTime!)
        : "--:--";
    final endTime = appointment.slot?.endTime != null
        ? DateTimeUtils.formatTimestampToTime(appointment.slot!.endTime!)
        : "--:--";
    final timeString = "$startTime - $endTime";

    return Scaffold(
      backgroundColor: CustomColors.whiteColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(CupertinoIcons.arrow_left, color: Colors.black, size: 22),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("Appointment Detail", style: CustomFonts.black24w600),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoSection(
              title: "Appointment Information",
              children: [
                _buildDetailRow("Type", type, isType: true),
                _buildDetailRow("Date", dateStr),
                _buildDetailRow("Time Slot", timeString),
                _buildDetailRow("Status", appointment.status ?? "Confirmed", isStatus: true),
              ],
            ),
            SizedBox(height: 16.h),
            _buildInfoSection(
              title: "Treatment Details",
              children: [
                if (appointment.treatments?.isEmpty ?? true)
                  _buildDetailRow("Treatment", "General Consultation")
                else
                  ...appointment.treatments!.map(
                    (t) => Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.auto_awesome_rounded,
                                size: 14,
                                color: CustomColors.purpleColor,
                              ),
                              SizedBox(width: 8.w),
                              Text(t.treatmentName ?? "N/A", style: CustomFonts.black14w700),
                              const Spacer(),
                              if (t.material != null)
                                Text(
                                  "${t.material!.selectedQuantity} Syringes",
                                  style: CustomFonts.darkPurple10w700,
                                ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 22.w),
                            child: Text(
                              "Area: ${t.areaName ?? 'N/A'}",
                              style: CustomFonts.grey700_10w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 16.h),
            _buildInfoSection(
              title: "Clinic & Provider",
              children: [
                _buildDetailRow("Clinic", appointment.clinic?.clinicName ?? "N/A", icon: Icons.business_outlined),
                _buildDetailRow("Doctor", appointment.doctor?.doctorName ?? "N/A", icon: Icons.person_outline),
              ],
            ),
            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection({required String title, required List<Widget> children}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: CustomColors.greyColor.withValues(alpha: 0.5),
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
          Text(
            title,
            style: CustomFonts.darkPurple12w600,
          ),
          SizedBox(height: 10.h),
          Divider(color: Colors.grey.shade100, height: 1.h),
          SizedBox(height: 6.h),
          ...children,
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isType = false, bool isStatus = false, IconData? icon}) {
    Color? accentColor;
    Color? badgeBgColor;
    TextStyle badgeStyle = CustomFonts.darkPurple10w700;

    if (isType) {
      switch (value.toLowerCase()) {
        case "consultation":
          accentColor = CustomColors.blueColor;
          badgeBgColor = CustomColors.blueColor.withValues(alpha: 0.08);
          badgeStyle = CustomFonts.blue10w700;
          break;
        case "treatment session":
          accentColor = CustomColors.pinkColor;
          badgeBgColor = CustomColors.pinkColor.withValues(alpha: 0.08);
          badgeStyle = CustomFonts.pink10w700;
          break;
        default:
          accentColor = CustomColors.purpleColor;
          badgeBgColor = CustomColors.purpleColor.withValues(alpha: 0.08);
          badgeStyle = CustomFonts.darkPurple10w700;
      }
    }

    if (isStatus) {
      accentColor = Colors.green.shade700;
      badgeBgColor = Colors.green.shade50;
      badgeStyle = CustomFonts.darkPurple10w700; // fallback
    }

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 16.sp, color: Colors.grey.shade400),
            SizedBox(width: 8.w),
          ],
          Text(
            "$label:",
            style: CustomFonts.grey700_10w400,
          ),
          const Spacer(),
          if (isType || isStatus)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: badgeBgColor,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Text(
                value,
                style: isStatus
                    ? TextStyle(
                        color: accentColor,
                        fontSize: 8.sp,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Degular',
                      )
                    : badgeStyle.copyWith(fontSize: 8.sp),
              ),
            )
          else
            Expanded(
              flex: 2,
              child: Text(
                value,
                textAlign: TextAlign.right,
                style: CustomFonts.black13w600,
              ),
            ),
        ],
      ),
    );
  }
}
