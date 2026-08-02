import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
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
  static const String routeName = '/AppointmentDetailScreen';
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(context.r(32))),
        child: Padding(
          padding: EdgeInsets.all(context.w(24)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Check-in QR Code",
                style: CustomFonts.black18w600,
              ),
              SizedBox(height: context.h(4)),
              Text(
                "Appointment ID: #${id ?? 'N/A'}",
                style: CustomFonts.grey700_12w400,
              ),
              SizedBox(height: context.h(24)),
              Container(
                padding: EdgeInsets.all(context.w(16)),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(context.r(24)),
                  boxShadow: [
                    BoxShadow(
                      color: CustomColors.darkPurple.withValues(alpha: 0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: SizedBox(
                  width: context.w(180),
                  height: context.w(180),
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
              SizedBox(height: context.h(24)),
              Text(
                "Please scan this code at the clinic reception to confirm your arrival.",
                textAlign: TextAlign.center,
                style: CustomFonts.textGrey13w400.copyWith(height: 1.4),
              ),
              SizedBox(height: context.h(24)),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: context.h(14)),
                  decoration: BoxDecoration(
                    gradient: CustomColors.purpleBlueGradient,
                    borderRadius: BorderRadius.circular(context.r(16)),
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

    final type = detail?.appointmentType?.title ?? widget.appointment.appointmentType ?? "consultation";
    final dateVal = detail?.date ?? widget.appointment.date;
    final dateStr = dateVal != null ? DateTimeUtils.formatTimestampToDayDate(dateVal) : "N/A";

    final startTimeVal = detail?.startTime ?? widget.appointment.slot?.startTime;
    final endTimeVal = detail?.endTime ?? widget.appointment.slot?.endTime;
    final startTime = startTimeVal != null ? DateTimeUtils.formatTimestampToTime(startTimeVal) : "--:--";
    final endTime = endTimeVal != null ? DateTimeUtils.formatTimestampToTime(endTimeVal) : "--:--";
    final timeString = "$startTime - $endTime";

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: Icon(CupertinoIcons.arrow_left, color: Colors.black, size: context.sp(22)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("Appointment Detail", style: CustomFonts.black22w600),
        actions: [
          IconButton(
            onPressed: () => _showQrDialog(context, detail?.appointmentId ?? widget.appointment.appointmentId),
            icon: Icon(Icons.qr_code_scanner_rounded, color: CustomColors.darkPurple, size: context.sp(24)),
            tooltip: "Generate QR",
          ),
          SizedBox(width: context.w(12)),
        ],
      ),
      body: isLoading
          ? const Center(child: CupertinoActivityIndicator())
          : SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: context.w(20), vertical: context.h(20)),
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
                  SizedBox(height: context.h(20)),
                  _buildInfoSection(
                    title: "Financial Summary",
                    icon: Icons.account_balance_wallet_rounded,
                    children: [
                      _buildDetailRow("Treatment Total", "\$${detail?.treatmentTotal?.toStringAsFixed(2) ?? '0.00'}"),
                      if (detail?.discount != null && detail!.discount! > 0)
                        _buildDetailRow(
                          "Discount", 
                          "${detail.discountType == 'percent' ? '-' : '-\$'}${detail.discount}${detail.discountType == 'percent' ? '%' : ''}", 
                          color: Colors.orange
                        ),
                      _buildDetailRow("Payment Type", detail?.paymentType?.type?.toUpperCase() ?? "N/A"),
                      _buildDetailRow(
                        "Payment Status", 
                        detail?.paymentType?.status?.toUpperCase() ?? "N/A", 
                        isStatus: true,
                        color: detail?.paymentType?.status == 'completed' ? Colors.green : Colors.orange,
                      ),
                    ],
                  ),
                  SizedBox(height: context.h(20)),
                  _buildInfoSection(
                    title: "Clinic & Specialist",
                    icon: Icons.local_hospital_rounded,
                    children: [
                      _buildDetailRow("Clinic", detail?.clinic?.clinicName ?? widget.appointment.clinic?.clinicName ?? "N/A", icon: Icons.business_outlined),
                      _buildDetailRow("Address", detail?.clinic?.address ?? widget.appointment.clinic?.address ?? "N/A", icon: Icons.location_on_outlined),
                      _buildDetailRow("Specialist", detail?.doctor?.doctorName ?? widget.appointment.doctor?.doctorName ?? "N/A", icon: Icons.person_outline),
                      _buildDetailRow("Specialization", detail?.doctor?.specialization ?? widget.appointment.doctor?.specialization ?? "N/A", icon: Icons.star_outline),
                    ],
                  ),
                  SizedBox(height: context.h(20)),
                  _buildTreatmentSection(detail?.treatments),
                  SizedBox(height: context.h(40)),
                ],
              ),
            ),
    );

  }

  Widget _buildInfoSection({required String title, required List<Widget> children, required IconData icon}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(context.w(20)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(context.r(24)),
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
              Icon(icon, size: context.sp(18), color: CustomColors.darkPurple),
              SizedBox(width: context.w(10)),
              Text(
                title.toUpperCase(),
                style: CustomFonts.darkPurple12w600.copyWith(letterSpacing: 1.1),
              ),
            ],
          ),
          SizedBox(height: context.h(16)),
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
          padding: EdgeInsets.only(left: context.w(4), bottom: context.h(12)),
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
              margin: EdgeInsets.only(bottom: context.h(16)),
              padding: EdgeInsets.all(context.w(20)),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(context.r(24)),
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
                        borderRadius: BorderRadius.circular(context.r(16)),
                        child: CachedNetworkImage(
                          imageUrl: t.treatmentImage ?? "",
                          height: context.w(50),
                          width: context.w(50),
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            color: CustomColors.purpleColor.withValues(alpha: 0.1),
                            child: const Center(child: CupertinoActivityIndicator(radius: 8)),
                          ),
                          errorWidget: (context, url, error) => Container(
                            padding: EdgeInsets.all(context.w(10)),
                            decoration: BoxDecoration(
                              color: CustomColors.purpleColor.withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.auto_awesome_rounded,
                              size: context.sp(18),
                              color: CustomColors.purpleColor,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: context.w(16)),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              t.treatmentName ?? "N/A",
                              style: CustomFonts.black16w700.copyWith(fontSize: context.sp(16)),
                            ),
                            SizedBox(height: context.h(4)),
                            Text(
                              "Area: ${t.areaName ?? 'N/A'}",
                              style: CustomFonts.grey700_12w400,
                            ),
                            if (t.treatmentCost != null)
                              Text(
                                "Cost: \$${t.treatmentCost!.toStringAsFixed(2)}",
                                style: CustomFonts.darkPurple10w700.copyWith(fontSize: context.sp(11)),
                              ),
                          ],
                        ),
                      ),
                      if (t.status != null)
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: context.w(10), vertical: context.h(4)),
                          decoration: BoxDecoration(
                            color: statusColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(context.r(8)),
                          ),
                          child: Text(
                            t.status!.toUpperCase(),
                            style: TextStyle(
                              color: statusColor,
                              fontSize: context.sp(9),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: context.h(16)),
                  const Divider(color: Colors.black12),
                  SizedBox(height: context.h(16)),
                  if (t.startTime != null || t.endTime != null) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildTimeInfo("Start", t.startTime),
                        _buildTimeInfo("End", t.endTime),
                      ],
                    ),
                    SizedBox(height: context.h(12)),
                  ],
                  if (t.material != null)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Dosage/Material",
                          style: CustomFonts.grey700_10w400.copyWith(fontSize: context.sp(12)),
                        ),
                        SizedBox(width: context.w(10)),
                        Flexible(
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: context.w(12), vertical: context.h(6)),
                            decoration: BoxDecoration(
                              color: CustomColors.darkPurple.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(context.r(8)),
                            ),
                            child: Text(
                              "${t.material!.selectedQuantity} ${t.material!.name ?? 'Syringes'}",
                              textAlign: TextAlign.end,
                              style: CustomFonts.darkPurple10w700.copyWith(fontSize: context.sp(11)),
                            ),
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
        SizedBox(height: context.h(2)),
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
      accentColor = color ?? Colors.green.shade700;
      badgeBgColor = (color ?? Colors.green).withValues(alpha: 0.1);
      badgeStyle = CustomFonts.darkPurple10w700; // fallback
    }

    if (isPaid) {
      accentColor = Colors.green.shade600;
    }

    return Padding(
      padding: EdgeInsets.symmetric(vertical: context.h(10)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) ...[
            Padding(
              padding: EdgeInsets.only(top: context.h(2)),
              child: Icon(icon, size: context.sp(16), color: Colors.grey.shade400),
            ),
            SizedBox(width: context.w(10)),
          ],
          Text(
            "$label:",
            style: CustomFonts.grey700_10w400.copyWith(fontSize: context.sp(12)),
          ),
          SizedBox(width: context.w(10)),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: isType || isStatus
                  ? Container(
                      padding: EdgeInsets.symmetric(horizontal: context.w(12), vertical: context.h(6)),
                      decoration: BoxDecoration(
                        color: badgeBgColor,
                        borderRadius: BorderRadius.circular(context.r(20)),
                      ),
                      child: Text(
                        value,
                        style: isStatus
                            ? TextStyle(
                                color: accentColor,
                                fontSize: context.sp(10),
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Degular',
                              )
                            : badgeStyle.copyWith(fontSize: context.sp(10)),
                      ),
                    )
                  : Text(
                      value,
                      textAlign: TextAlign.end,
                      style: isBold
                          ? CustomFonts.black14w700.copyWith(color: accentColor ?? Colors.black, fontSize: context.sp(14))
                          : CustomFonts.black13w600.copyWith(color: accentColor ?? Colors.black87, fontSize: context.sp(13)),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
