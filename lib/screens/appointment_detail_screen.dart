import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../models/dummy_list_model.dart';
import '../utills/color_constant.dart';
import '../utills/custom_fonts.dart';

class AppointmentDetailScreen extends StatelessWidget {
  final DummyAppointment appointment;

  const AppointmentDetailScreen({super.key, required this.appointment});

  @override
  Widget build(BuildContext context) {
    final bool hasHistory = appointment.type != "Provisional Booking";

    return DefaultTabController(
      length: hasHistory ? 2 : 1,
      child: Scaffold(
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
          bottom: hasHistory
              ? TabBar(
                  indicatorColor: CustomColors.darkPurple,
                  indicatorSize: TabBarIndicatorSize.label,
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.grey.shade500,
                  labelStyle: CustomFonts.black13w600,
                  unselectedLabelStyle: CustomFonts.grey700_10w400,
                  dividerColor: Colors.transparent,
                  tabs: const [
                    Tab(text: "Details"),
                    Tab(text: "Treatment History"),
                  ],
                )
              : null,
        ),
        body: TabBarView(
          physics: const BouncingScrollPhysics(),
          children: [
            _buildDetailsTab(),
            if (hasHistory) _buildHistoryTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailsTab() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoSection(
            title: "Appointment Information",
            children: [
              _buildDetailRow("Type", appointment.type, isType: true),
              _buildDetailRow("Date", DateFormat('EEEE, MMM d, yyyy').format(appointment.date)),
              _buildDetailRow("Time Slot", appointment.time),
              _buildDetailRow("Status", appointment.status, isStatus: true),
            ],
          ),
          SizedBox(height: 16.h),
          _buildInfoSection(
            title: "Treatment Details",
            children: [
              _buildDetailRow("Treatment", appointment.treatmentName),
              _buildDetailRow("Target Area", appointment.area),
            ],
          ),
          SizedBox(height: 16.h),
          _buildInfoSection(
            title: "Clinic & Provider",
            children: [
              _buildDetailRow("Clinic", appointment.clinicName, icon: Icons.business_outlined),
              _buildDetailRow("Doctor", appointment.doctorName, icon: Icons.person_outline),
            ],
          ),
          SizedBox(height: 16.h),
          _buildInfoSection(
            title: "Notes & Remarks",
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.h),
                child: Text(
                  appointment.notes.isNotEmpty ? appointment.notes : "No special instructions or comments noted.",
                  style: CustomFonts.textGrey14w400,
                ),
              ),
            ],
          ),
          SizedBox(height: 40.h),
        ],
      ),
    );
  }

  Widget _buildHistoryTab() {
    if (appointment.pastSessions.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 40.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.history_toggle_off_rounded,
                size: 64.sp,
                color: Colors.grey.shade300,
              ),
              SizedBox(height: 16.h),
              Text(
                "No past treatment history found",
                style: CustomFonts.grey800_20w600,
              ),
              SizedBox(height: 6.h),
              Text(
                "Completed treatment sessions or clinical records will appear on this timeline.",
                textAlign: TextAlign.center,
                style: CustomFonts.textGrey14w400,
              ),
            ],
          ),
        ),
      );
    }

    // Grouping for session timeline summary
    int totalSessions = appointment.pastSessions.where((s) => s.type == "Session").length;
    int totalFollowups = appointment.pastSessions.where((s) => s.type == "Follow-up").length;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 18.h, horizontal: 16.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(
                color: CustomColors.lightPurpleColor.withValues(alpha: 0.4),
                width: 1,
              ),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  CustomColors.lightPurpleColor.withValues(alpha: 0.15),
                  CustomColors.lightBlueColor.withValues(alpha: 0.08),
                ],
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildSummaryStat("Sessions", totalSessions.toString()),
                Container(
                  width: 1.w,
                  height: 32.h,
                  color: CustomColors.lightPurpleColor.withValues(alpha: 0.5),
                ),
                _buildSummaryStat("Follow-ups", totalFollowups.toString()),
              ],
            ),
          ),
          SizedBox(height: 24.h),
          Text(
            "Timeline History",
            style: CustomFonts.grey800_20w600,
          ),
          SizedBox(height: 16.h),
          ...appointment.pastSessions.map((session) => _buildHistoryTimelineEntry(session)),
          SizedBox(height: 40.h),
        ],
      ),
    );
  }

  Widget _buildSummaryStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: CustomFonts.black24w600,
        ),
        SizedBox(height: 2.h),
        Text(
          label,
          style: CustomFonts.grey700_11w700,
        ),
      ],
    );
  }

  Widget _buildHistoryTimelineEntry(DummySession session) {
    bool isSession = session.type == "Session";
    final accentColor = isSession ? CustomColors.darkPurple : Colors.orange.shade700;
    final textStyle = isSession ? CustomFonts.darkPurple10w700 : CustomFonts.amber10w700;

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.r),
        child: Stack(
          children: [
            // Vertical Left Colored Accent Bar matching home style
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              width: 4.w,
              child: Container(color: accentColor),
            ),

            // Content
            Padding(
              padding: EdgeInsets.fromLTRB(18.w, 14.h, 14.w, 14.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        DateFormat('dd MMM yyyy').format(session.date),
                        style: CustomFonts.black13w600,
                      ),
                      _buildSmallBadge(session.type, accentColor, textStyle),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  _buildHistoryInfoRow(Icons.business_rounded, session.clinicName),
                  SizedBox(height: 4.h),
                  _buildHistoryInfoRow(Icons.person_rounded, session.doctorName),
                  SizedBox(height: 12.h),
                  Divider(color: Colors.grey.shade100, height: 1.h),
                  SizedBox(height: 12.h),
                  Text(
                    "Outcome:",
                    style: CustomFonts.grey700_11w700,
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    session.outcome,
                    style: CustomFonts.textGrey13w400,
                  ),
                  if (isSession) ...[
                    SizedBox(height: 12.h),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildProductDetail("Products Used", session.products.join(", ")),
                        SizedBox(width: 16.w),
                        _buildProductDetail("Materials", session.materials),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      "Post-Care Instructions:",
                      style: CustomFonts.grey700_11w700,
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      session.postCare,
                      style: CustomFonts.textGrey13w400,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductDetail(String label, String value) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: CustomFonts.grey700_11w700,
          ),
          SizedBox(height: 2.h),
          Text(
            value,
            style: CustomFonts.textGrey13w400,
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryInfoRow(IconData icon, String text) {
    return Padding(
      padding: EdgeInsets.only(top: 4.h),
      child: Row(
        children: [
          Icon(icon, size: 14.sp, color: Colors.grey.shade500),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              text,
              style: CustomFonts.grey700_10w400,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
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
      switch (value) {
        case "Consultation":
          accentColor = CustomColors.blueColor;
          badgeBgColor = CustomColors.blueColor.withValues(alpha: 0.08);
          badgeStyle = CustomFonts.blue10w700;
          break;
        case "Sessions":
          accentColor = CustomColors.pinkColor;
          badgeBgColor = CustomColors.pinkColor.withValues(alpha: 0.08);
          badgeStyle = CustomFonts.pink10w700;
          break;
        case "Follow-Up / Touch-Up":
          accentColor = CustomColors.darkPurple;
          badgeBgColor = CustomColors.darkPurple.withValues(alpha: 0.08);
          badgeStyle = CustomFonts.darkPurple10w700;
          break;
        case "Provisional Booking":
          accentColor = CustomColors.yellow;
          badgeBgColor = CustomColors.yellow.withValues(alpha: 0.12);
          badgeStyle = CustomFonts.amber10w700;
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

  Widget _buildSmallBadge(String text, Color color, TextStyle style) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        text,
        style: style.copyWith(fontSize: 8.sp),
      ),
    );
  }
}
