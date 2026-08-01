import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/responses/appointments_list_response.dart';
import '../models/responses/appointment_detail_response.dart';
import '../utills/assets.dart';
import '../utills/color_constant.dart';
import '../utills/custom_fonts.dart';
import '../utills/date_time_utills.dart';
import '../view_models/appointment_view_model.dart';

class AppointmentDetailScreen extends ConsumerStatefulWidget {
  final AppointmentItem appointment;

  const AppointmentDetailScreen({super.key, required this.appointment});

  @override
  ConsumerState<AppointmentDetailScreen> createState() => _AppointmentDetailScreenState();
}

class _AppointmentDetailScreenState extends ConsumerState<AppointmentDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.appointment.appointmentId != null) {
        ref.read(appointmentProvider.notifier).getAppointmentDetail(widget.appointment.appointmentId!);
      }
    });
  }

  void _showQrDialog(BuildContext context, int? id) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32.r)),
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Check-in QR Code",
                style: CustomFonts.black18w600,
              ),
              SizedBox(height: 4.h),
              Text(
                "Appointment ID: #${id ?? 'N/A'}",
                style: CustomFonts.grey700_12w400,
              ),
              SizedBox(height: 24.h),
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24.r),
                  boxShadow: [
                    BoxShadow(
                      color: CustomColors.darkPurple.withValues(alpha: 0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: SizedBox(
                  width: 180.w,
                  height: 180.w,
                  child: PrettyQrView.data(
                    data: id?.toString() ?? "N/A",
                    decoration: const PrettyQrDecoration(
                      shape: PrettyQrSmoothSymbol(
                        color: CustomColors.darkPurple,
                        roundFactor: 1,
                      ),
                      image: PrettyQrDecorationImage(
                        image: AssetImage(PngAssets.splashLogo),
                        scale: 0.25,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 24.h),
              Text(
                "Please scan this code at the clinic reception to confirm your arrival.",
                textAlign: TextAlign.center,
                style: CustomFonts.textGrey13w400.copyWith(height: 1.4),
              ),
              SizedBox(height: 24.h),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  decoration: BoxDecoration(
                    gradient: CustomColors.purpleBlueGradient,
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Center(
                    child: Text(
                      "Dismiss",
                      style: CustomFonts.white14w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appointmentState = ref.watch(appointmentProvider);
    final detail = appointmentState.appointmentDetail;
    final isLoading = appointmentState.loading && detail == null;

    final type = detail?.appointmentType ?? widget.appointment.appointmentType ?? "consultation";
    final dateVal = detail?.date ?? widget.appointment.date;
    final dateStr = dateVal != null ? DateTimeUtils.formatTimestampToDayDate(dateVal) : "N/A";

    final slot = detail?.slot ?? widget.appointment.slot;
    final startTime = slot?.startTime != null ? DateTimeUtils.formatTimestampToTime(slot!.startTime!) : "--:--";
    final endTime = slot?.endTime != null ? DateTimeUtils.formatTimestampToTime(slot!.endTime!) : "--:--";
    final timeString = "$startTime - $endTime";

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(CupertinoIcons.arrow_left, color: Colors.black, size: 22),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("Appointment Detail", style: CustomFonts.black22w600),
        actions: [
          IconButton(
            onPressed: () => _showQrDialog(context, detail?.appointmentId ?? widget.appointment.appointmentId),
            icon: Icon(Icons.qr_code_scanner_rounded, color: CustomColors.darkPurple, size: 24.sp),
            tooltip: "Generate QR",
          ),
          SizedBox(width: 12.w),
        ],
      ),
      body: isLoading
          ? const Center(child: CupertinoActivityIndicator())
          : SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoSection(
                    title: "Appointment Schedule",
                    icon: Icons.event_available_rounded,
                    children: [
                      _buildDetailRow("Type", type, isType: true),
                      _buildDetailRow("Date", dateStr),
                      _buildDetailRow("Time Slot", timeString),
                      _buildDetailRow("Status", detail?.status ?? widget.appointment.status ?? "Confirmed", isStatus: true),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  _buildInfoSection(
                    title: "Financial Summary",
                    icon: Icons.account_balance_wallet_rounded,
                    children: [
                      _buildDetailRow("Payable Amount", "\$${detail?.payableAmount?.toStringAsFixed(2) ?? '0.00'}"),
                      _buildDetailRow("Paid Amount", "\$${detail?.paidAmount?.toStringAsFixed(2) ?? '0.00'}", isPaid: true),
                      if (detail?.discountAmount != null && detail!.discountAmount! > 0)
                        _buildDetailRow("Discount", "-\$${detail.discountAmount!.toStringAsFixed(2)}", color: Colors.orange),
                      const Divider(height: 24, color: Colors.black12),
                      _buildDetailRow(
                        "Balance Due",
                        "\$${((detail?.payableAmount ?? 0) - (detail?.paidAmount ?? 0)).toStringAsFixed(2)}",
                        isBold: true,
                        color: Colors.redAccent,
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  _buildInfoSection(
                    title: "Clinic & Specialist",
                    icon: Icons.local_hospital_rounded,
                    children: [
                      _buildDetailRow("Clinic", detail?.clinic?.clinicName ?? widget.appointment.clinic?.clinicName ?? "N/A", icon: Icons.business_outlined),
                      _buildDetailRow("Specialist", detail?.doctor?.doctorName ?? widget.appointment.doctor?.doctorName ?? "N/A", icon: Icons.person_outline),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  _buildTreatmentSection(detail?.treatments),
                  SizedBox(height: 40.h),
                ],
              ),
            ),
    );
  }

  Widget _buildInfoSection({required String title, required List<Widget> children, required IconData icon}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 25,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18.sp, color: CustomColors.darkPurple),
              SizedBox(width: 10.w),
              Text(
                title.toUpperCase(),
                style: CustomFonts.darkPurple12w600.copyWith(letterSpacing: 1.1),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          ...children,
        ],
      ),
    );
  }

  Widget _buildTreatmentSection(List<DetailedAppointmentTreatment>? treatments) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 4.w, bottom: 12.h),
          child: Text("TREATMENT DETAILS", style: CustomFonts.darkPurple12w600.copyWith(letterSpacing: 1.1)),
        ),
        if (treatments == null || treatments.isEmpty)
          _buildInfoSection(
            title: "General",
            icon: Icons.medical_services_rounded,
            children: [_buildDetailRow("Treatment", "General Consultation")],
          )
        else
          ...treatments.map((t) {
            Color statusColor = Colors.grey;
            switch (t.status?.toLowerCase()) {
              case 'pending': statusColor = Colors.orange; break;
              case 'start': statusColor = Colors.blue; break;
              case 'end': statusColor = Colors.green; break;
            }

            return Container(
              margin: EdgeInsets.only(bottom: 16.h),
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24.r),
                boxShadow: [
                  BoxShadow(
                    color: CustomColors.purpleColor.withValues(alpha: 0.12),
                    blurRadius: 25,
                    offset: const Offset(0, 12),
                  ),
                ],
                border: Border.all(color: CustomColors.purpleColor.withValues(alpha: 0.05)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16.r),
                        child: CachedNetworkImage(
                          imageUrl: t.treatmentImage ?? "",
                          height: 50.w,
                          width: 50.w,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            color: CustomColors.purpleColor.withValues(alpha: 0.1),
                            child: const Center(child: CupertinoActivityIndicator(radius: 8)),
                          ),
                          errorWidget: (context, url, error) => Container(
                            padding: EdgeInsets.all(10.w),
                            decoration: BoxDecoration(
                              color: CustomColors.purpleColor.withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.auto_awesome_rounded,
                              size: 18.sp,
                              color: CustomColors.purpleColor,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              t.treatmentName ?? "N/A",
                              style: CustomFonts.black16w700.copyWith(fontSize: 16.sp),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              "Area: ${t.areaName ?? 'N/A'}",
                              style: CustomFonts.grey700_12w400,
                            ),
                          ],
                        ),
                      ),
                      if (t.status != null)
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                          decoration: BoxDecoration(
                            color: statusColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Text(
                            t.status!.toUpperCase(),
                            style: TextStyle(
                              color: statusColor,
                              fontSize: 9.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  const Divider(color: Colors.black12),
                  SizedBox(height: 16.h),
                  if (t.startTime != null || t.endTime != null) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildTimeInfo("Start", t.startTime),
                        _buildTimeInfo("End", t.endTime),
                      ],
                    ),
                    SizedBox(height: 12.h),
                  ],
                  if (t.material != null)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Dosage/Material",
                          style: CustomFonts.grey700_10w400.copyWith(fontSize: 12.sp),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                          decoration: BoxDecoration(
                            color: CustomColors.darkPurple.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Text(
                            "${t.material!.selectedQuantity} ${t.material!.name ?? 'Syringes'}",
                            style: CustomFonts.darkPurple10w700.copyWith(fontSize: 11.sp),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            );
          }),
      ],
    );
  }

  Widget _buildTimeInfo(String label, int? timestamp) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: CustomFonts.grey700_10w400),
        SizedBox(height: 2.h),
        Text(
          timestamp != null ? DateTimeUtils.formatTimestampToTime(timestamp) : "--:--",
          style: CustomFonts.black13w600,
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value, {
    bool isType = false,
    bool isStatus = false,
    bool isPaid = false,
    bool isBold = false,
    Color? color,
    IconData? icon
  }) {
    Color? accentColor = color;
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

    if (isPaid) {
      accentColor = Colors.green.shade600;
    }

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 16.sp, color: Colors.grey.shade400),
            SizedBox(width: 10.w),
          ],
          Text(
            "$label:",
            style: CustomFonts.grey700_10w400.copyWith(fontSize: 12.sp),
          ),
          const Spacer(),
          if (isType || isStatus)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: badgeBgColor,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Text(
                value,
                style: isStatus
                    ? TextStyle(
                        color: accentColor,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Degular',
                      )
                    : badgeStyle.copyWith(fontSize: 10.sp),
              ),
            )
          else
            Text(
              value,
              style: isBold
                ? CustomFonts.black14w700.copyWith(color: accentColor ?? Colors.black, fontSize: 14.sp)
                : CustomFonts.black13w600.copyWith(color: accentColor ?? Colors.black87, fontSize: 13.sp),
            ),
        ],
      ),
    );
  }
}
