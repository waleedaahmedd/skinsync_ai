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
        backgroundColor: Colors.grey.shade50,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: false,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text("Appointment Detail", style: CustomFonts.black22w600),
          bottom: hasHistory
              ? TabBar(
                  labelColor: CustomColors.darkPurple,
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: CustomColors.darkPurple,
                  indicatorSize: TabBarIndicatorSize.label,
                  labelStyle: CustomFonts.black14w600,
                  tabs: const [
                    Tab(text: "Details"),
                    Tab(text: "Treatment History"),
                  ],
                )
              : null,
        ),
        body: TabBarView(
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
      padding: EdgeInsets.all(20.w),
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
          SizedBox(height: 20.h),
          _buildInfoSection(
            title: "Treatment Details",
            children: [
              _buildDetailRow("Treatment", appointment.treatmentName),
              _buildDetailRow("Target Area", appointment.area),
            ],
          ),
          SizedBox(height: 20.h),
          _buildInfoSection(
            title: "Clinic & Provider",
            children: [
              _buildDetailRow("Clinic", appointment.clinicName, icon: Icons.business_outlined),
              _buildDetailRow("Doctor", appointment.doctorName, icon: Icons.person_outline),
            ],
          ),
          SizedBox(height: 20.h),
          _buildInfoSection(
            title: "Notes & Remarks",
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.h),
                child: Text(
                  appointment.notes,
                  style: CustomFonts.black14w400.copyWith(height: 1.5, color: Colors.grey.shade700),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryTab() {
    if (appointment.pastSessions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.history_toggle_off_rounded, size: 64.sp, color: Colors.grey.shade300),
            SizedBox(height: 16.h),
            Text("No past treatment history found", style: CustomFonts.grey16w400),
          ],
        ),
      );
    }

    // Grouping for session timeline summary
    int totalSessions = appointment.pastSessions.where((s) => s.type == "Session").length;
    int totalFollowups = appointment.pastSessions.where((s) => s.type == "Follow-up").length;

    return SingleChildScrollView(
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: CustomColors.darkPurple.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: CustomColors.darkPurple.withValues(alpha: 0.1)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildSummaryStat("Sessions", totalSessions.toString()),
                Container(width: 1, height: 30.h, color: CustomColors.darkPurple.withValues(alpha: 0.2)),
                _buildSummaryStat("Follow-ups", totalFollowups.toString()),
              ],
            ),
          ),
          SizedBox(height: 25.h),
          Text("Timeline", style: CustomFonts.black18w600),
          SizedBox(height: 15.h),
          ...appointment.pastSessions.map((session) => _buildHistoryTimelineEntry(session)),
        ],
      ),
    );
  }

  Widget _buildSummaryStat(String label, String value) {
    return Column(
      children: [
        Text(value, style: CustomFonts.black20w600.copyWith(color: CustomColors.darkPurple)),
        Text(label, style: CustomFonts.grey14w400.copyWith(fontSize: 12.sp)),
      ],
    );
  }

  Widget _buildHistoryTimelineEntry(DummySession session) {
    bool isSession = session.type == "Session";

    return Container(
      margin: EdgeInsets.only(bottom: 20.h),
      padding: EdgeInsets.only(left: 15.w),
      decoration: BoxDecoration(
        border: Border(left: BorderSide(color: isSession ? CustomColors.darkPurple : Colors.orange, width: 3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                DateFormat('dd MMM yyyy').format(session.date),
                style: CustomFonts.black16w600,
              ),
              _buildSmallBadge(session.type, isSession ? CustomColors.darkPurple : Colors.orange),
            ],
          ),
          SizedBox(height: 8.h),
          _buildHistoryInfoRow(Icons.business_outlined, session.clinicName),
          _buildHistoryInfoRow(Icons.person_outline, session.doctorName),
          SizedBox(height: 12.h),
          Text("Outcome:", style: CustomFonts.black14w600.copyWith(fontSize: 12.sp)),
          Text(session.outcome, style: CustomFonts.black14w400.copyWith(color: Colors.grey.shade700, fontSize: 13.sp)),
          if (isSession) ...[
            SizedBox(height: 12.h),
            Row(
              children: [
                _buildProductDetail("Products", session.products.join(", ")),
                SizedBox(width: 20.w),
                _buildProductDetail("Materials", session.materials),
              ],
            ),
            SizedBox(height: 12.h),
            Text("Post-Care Instructions:", style: CustomFonts.black14w600.copyWith(fontSize: 12.sp)),
            Text(session.postCare, style: CustomFonts.black14w400.copyWith(color: Colors.grey.shade700, fontSize: 13.sp)),
          ],
        ],
      ),
    );
  }

  Widget _buildProductDetail(String label, String value) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: CustomFonts.black14w600.copyWith(fontSize: 12.sp)),
          Text(value, style: CustomFonts.black14w400.copyWith(color: Colors.grey.shade600, fontSize: 13.sp)),
        ],
      ),
    );
  }

  Widget _buildHistoryInfoRow(IconData icon, String text) {
    return Padding(
      padding: EdgeInsets.only(top: 4.h),
      child: Row(
        children: [
          Icon(icon, size: 14.sp, color: Colors.grey),
          SizedBox(width: 8.w),
          Text(text, style: CustomFonts.black14w400.copyWith(color: Colors.grey.shade600, fontSize: 13.sp)),
        ],
      ),
    );
  }

  Widget _buildInfoSection({required String title, required List<Widget> children}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
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
          Text(title, style: CustomFonts.black16w600.copyWith(color: CustomColors.darkPurple)),
          SizedBox(height: 10.h),
          const Divider(height: 1),
          SizedBox(height: 5.h),
          ...children,
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isType = false, bool isStatus = false, IconData? icon}) {
    Color? textColor;
    if (isType) {
      switch (value) {
        case "Consultation": textColor = Colors.blue; break;
        case "Sessions": textColor = Colors.green; break;
        case "Follow-Up / Touch-Up": textColor = Colors.purple; break;
        case "Provisional Booking": textColor = Colors.orange; break;
      }
    }
    if (isStatus) textColor = Colors.green;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 18.sp, color: Colors.grey.shade400),
            SizedBox(width: 10.w),
          ],
          Text("$label:", style: CustomFonts.grey15w400.copyWith(fontWeight: FontWeight.w600)),
          const Spacer(),
          Expanded(
            flex: 2,
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: CustomFonts.black16w600.copyWith(
                color: textColor ?? Colors.black87,
                fontSize: 15.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSmallBadge(String text, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Text(
        text,
        style: TextStyle(color: color, fontSize: 10.sp, fontWeight: FontWeight.bold),
      ),
    );
  }
}
