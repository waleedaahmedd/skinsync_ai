import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../../models/responses/appointments_list_response.dart';
import '../../utills/color_constant.dart';
import '../../utills/custom_fonts.dart';
import '../../utills/date_time_utills.dart';
import '../../view_models/appointment_view_model.dart';
import '../../widgets/app_loader.dart';
import '../../widgets/custom_search_field.dart';
import '../appointment_detail_screen.dart';

class AppointmentsScreen extends ConsumerStatefulWidget {
  const AppointmentsScreen({super.key});
  static const String routeName = "/AppointmentsScreen";

  @override
  ConsumerState<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends ConsumerState<AppointmentsScreen> {
  String _selectedTypeFilter = "All";
  String _searchQuery = "";
  final TextEditingController _searchController = TextEditingController();

  final List<String> _appointmentTypes = [
    "All",
    "consultation",
    "Treatment session",
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(appointmentProvider.notifier).getAppointments();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<AppointmentItem> _getFilteredAppointments(List<AppointmentItem> items) {
    return items.where((appointment) {
      final query = _searchQuery.toLowerCase();
      final clinicName = appointment.clinic?.clinicName?.toLowerCase() ?? "";
      final doctorName = appointment.doctor?.doctorName?.toLowerCase() ?? "";
      final type = appointment.appointmentType?.toLowerCase() ?? "";

      final matchesSearch =
          clinicName.contains(query) ||
          doctorName.contains(query) ||
          type.contains(query);

      final matchesType =
          _selectedTypeFilter == "All" ||
          appointment.appointmentType == _selectedTypeFilter;

      return matchesSearch && matchesType;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final appointmentState = ref.watch(appointmentProvider);
    final appointments =
        appointmentState.appointmentsResponse?.data?.items ?? [];
    final filteredAppointments = _getFilteredAppointments(appointments);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: context.w(20)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (Navigator.of(context).canPop()) ...[
                    SizedBox(height: context.h(16)),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        height: context.w(42),
                        width: context.w(42),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: CustomColors.greyColor,
                            width: 1.5,
                          ),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.arrow_back_ios_new_rounded,
                            size: context.sp(18),
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                  SizedBox(height: context.h(20)),
                  Text(
                    "My Appointments",
                    style: CustomFonts.black30w600.copyWith(
                      fontSize: context.sp(28),
                    ),
                  ),
                  SizedBox(height: context.h(20)),
                  CustomSearchField(
                    controller: _searchController,
                    hintText: "Search appointments...",
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                  ),
                  SizedBox(height: context.h(16)),
                  _buildDropdown<String>(
                    label: "Appointment Type Filter",
                    value: _selectedTypeFilter,
                    items: _appointmentTypes.map((e) {
                      return DropdownMenuItem(
                        value: e,
                        child: Text(e, style: CustomFonts.black14w600),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null)
                        setState(() => _selectedTypeFilter = val);
                    },
                  ),
                ],
              ),
              Expanded(
                child: appointmentState.loading
                    ? const AppLoader()
                    : filteredAppointments.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        padding: EdgeInsets.only(
                          top: context.h(20),
                          bottom: 80,
                        ),
                        physics: const BouncingScrollPhysics(),
                        itemCount: filteredAppointments.length,
                        itemBuilder: (context, index) {
                          return _buildAppointmentCard(
                            filteredAppointments[index],
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown<T>({
    required String label,
    required T value,
    required List<DropdownMenuItem<T>> items,
    required ValueChanged<T?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: CustomFonts.grey700_11w700),
        SizedBox(height: context.h(6)),
        Container(
          padding: EdgeInsets.symmetric(horizontal: context.w(14)),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(context.r(30)),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<T>(
              value: value,
              items: items,
              onChanged: onChanged,
              isExpanded: true,
              icon: Icon(
                Icons.keyboard_arrow_down_rounded,
                size: context.sp(20),
                color: Colors.grey.shade600,
              ),
              dropdownColor: Colors.white,
              borderRadius: BorderRadius.circular(context.r(16)),
              style: CustomFonts.black13w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAppointmentCard(AppointmentItem appointment) {
    final type = appointment.appointmentType ?? "consultation";
    Color typeColor = _getTypeColor(type);
    TextStyle timeStyle = _getTimeStyle(type);

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

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          AppointmentDetailScreen.routeName,
          arguments: appointment,
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: context.h(22)),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(context.r(24)),
          border: Border.all(color: Colors.grey.shade100, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 25,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          children: [
            // 1. Top Section: Date, Slot & Status (Gradient background)
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: context.w(18),
                vertical: context.h(16),
              ),
              decoration: BoxDecoration(
                gradient: CustomColors.purpleBlueGradient,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(context.r(24)),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.calendar_today_rounded,
                                  size: 16,
                                  color: Colors.white,
                                ),
                                SizedBox(width: context.w(8)),
                                Text(dateStr, style: CustomFonts.white14w700),
                              ],
                            ),
                            if (appointment.appointmentKey != null) ...[
                              SizedBox(height: context.h(4)),
                              Text(
                                appointment.appointmentKey!,
                                style: CustomFonts.white10w600.copyWith(
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                            SizedBox(height: context.h(10)),
                            Row(
                              children: [
                                const Icon(
                                  Icons.access_time_filled_rounded,
                                  size: 14,
                                  color: Colors.white70,
                                ),
                                SizedBox(width: context.w(8)),
                                Text(
                                  timeString,
                                  style: CustomFonts.white14w600.copyWith(
                                    fontSize: context.sp(13),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          _buildTypeBadge(
                            type,
                            Colors.white,
                            timeStyle.copyWith(color: typeColor),
                          ),
                          if (appointment.status != null) ...[
                            SizedBox(height: context.h(10)),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: context.w(12),
                                vertical: context.h(5),
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(
                                  context.r(20),
                                ),
                                border: Border.all(color: Colors.white24),
                              ),
                              child: Text(
                                appointment.status!.toUpperCase(),
                                style: CustomFonts.white10w600.copyWith(
                                  letterSpacing: 1.2,
                                  fontSize: context.sp(8.5),
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // 2. Middle Section: Clinic & Doctor
            Padding(
              padding: EdgeInsets.all(context.w(18)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Doctor & Clinic Row
                  Row(
                    children: [
                      // Clinic Info
                      if (appointment.clinic != null)
                        Expanded(
                          child: Row(
                            children: [
                              ClipOval(
                                child: CachedNetworkImage(
                                  imageUrl:
                                      appointment.clinic?.clinicImage ?? "",
                                  height: context.w(32),
                                  width: context.w(32),
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) =>
                                      Container(color: Colors.grey.shade100),
                                  errorWidget: (context, url, error) =>
                                      Container(
                                        color: Colors.grey.shade100,
                                        child: const Icon(
                                          Icons.business,
                                          size: 16,
                                          color: Colors.grey,
                                        ),
                                      ),
                                ),
                              ),
                              SizedBox(width: context.w(10)),
                              Expanded(
                                child: Text(
                                  appointment.clinic!.clinicName ?? "N/A",
                                  style: CustomFonts.black14w600.copyWith(
                                    fontSize: context.sp(12),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      SizedBox(width: context.w(12)),
                      // Doctor Info
                      if (appointment.doctor != null)
                        Expanded(
                          child: Row(
                            children: [
                              ClipOval(
                                child: CachedNetworkImage(
                                  imageUrl:
                                      appointment.doctor?.doctorImage ?? "",
                                  height: context.w(32),
                                  width: context.w(32),
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) =>
                                      Container(color: Colors.grey.shade100),
                                  errorWidget: (context, url, error) =>
                                      Container(
                                        color: Colors.grey.shade100,
                                        child: const Icon(
                                          Icons.person,
                                          size: 16,
                                          color: Colors.grey,
                                        ),
                                      ),
                                ),
                              ),
                              SizedBox(width: context.w(10)),
                              Expanded(
                                child: Text(
                                  appointment.doctor!.doctorName ?? "N/A",
                                  style: CustomFonts.black14w600.copyWith(
                                    fontSize: context.sp(12),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),

                  if (appointment.treatments != null &&
                      appointment.treatments!.isNotEmpty) ...[
                    SizedBox(height: context.h(18)),
                    const Divider(height: 1, color: Colors.black12),
                    SizedBox(height: context.h(18)),

                    // 3. Treatments List
                    Row(
                      children: [
                        const Icon(
                          Icons.medical_services_rounded,
                          size: 14,
                          color: CustomColors.darkPurple,
                        ),
                        SizedBox(width: context.w(8)),
                        Text(
                          "Selected Treatments",
                          style: CustomFonts.darkPurple12w600,
                        ),
                      ],
                    ),
                    SizedBox(height: context.h(14)),
                    for (var t in appointment.treatments!)
                      Container(
                        margin: EdgeInsets.only(bottom: context.h(12)),
                        padding: EdgeInsets.all(context.w(12)),
                        decoration: BoxDecoration(
                          color: CustomColors.lightPurpleColor.withValues(
                            alpha: 0.05,
                          ),
                          borderRadius: BorderRadius.circular(context.r(16)),
                          border: Border.all(
                            color: CustomColors.lightPurpleColor.withValues(
                              alpha: 0.1,
                            ),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(
                                context.r(12),
                              ),
                              child: CachedNetworkImage(
                                imageUrl: t.treatmentImage ?? "",
                                height: context.w(40),
                                width: context.w(40),
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Container(
                                  color: Colors.white,
                                  child: const Center(
                                    child: CupertinoActivityIndicator(
                                      radius: 8,
                                    ),
                                  ),
                                ),
                                errorWidget: (context, url, error) => Container(
                                  color: Colors.white,
                                  padding: EdgeInsets.all(context.w(8)),
                                  child: Icon(
                                    Icons.auto_awesome_rounded,
                                    size: context.sp(14),
                                    color: CustomColors.purpleColor,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: context.w(14)),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          t.treatmentName ?? "N/A",
                                          style: CustomFonts.black14w600
                                              .copyWith(
                                                fontSize: context.sp(13),
                                              ),
                                        ),
                                      ),
                                      if (t.status != null)
                                        Text(
                                          t.status!.toUpperCase(),
                                          style: TextStyle(
                                            color: _getTreatmentStatusColor(
                                              t.status!,
                                            ),
                                            fontSize: context.sp(9),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                    ],
                                  ),
                                  SizedBox(height: context.h(4)),
                                  Row(
                                    children: [
                                      Text(
                                        "Area: ${t.areaName ?? 'N/A'}",
                                        style: CustomFonts.grey700_10w400
                                            .copyWith(fontSize: context.sp(11)),
                                      ),
                                      if (t.material != null) ...[
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: context.w(6),
                                          ),
                                          child: Text(
                                            "•",
                                            style: TextStyle(
                                              color: Colors.grey.shade300,
                                              fontSize: context.sp(10),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: context.w(6),
                                            vertical: context.h(2),
                                          ),
                                          decoration: BoxDecoration(
                                            color: CustomColors.darkPurple
                                                .withValues(alpha: 0.08),
                                            borderRadius: BorderRadius.circular(
                                              context.r(4),
                                            ),
                                          ),
                                          child: Text(
                                            "${t.material!.selectedQuantity} ${t.material!.name ?? 'Syringes'}",
                                            style: CustomFonts.darkPurple10w700
                                                .copyWith(
                                                  fontSize: context.sp(9),
                                                ),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                  if (t.startTime != null ||
                                      t.endTime != null) ...[
                                    SizedBox(height: context.h(4)),
                                    Text(
                                      "${t.startTime != null ? DateTimeUtils.formatTimestampToTime(t.startTime!) : '--:--'} - ${t.endTime != null ? DateTimeUtils.formatTimestampToTime(t.endTime!) : '--:--'}",
                                      style: CustomFonts.grey700_10w400
                                          .copyWith(fontSize: context.sp(10)),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            Icon(
                              Icons.chevron_right_rounded,
                              size: context.sp(18),
                              color: Colors.grey.shade300,
                            ),
                          ],
                        ),
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

  Color _getTreatmentStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'start':
        return Colors.blue;
      case 'end':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  Color _getTypeColor(String type) {
    switch (type.toLowerCase()) {
      case "consultation":
        return CustomColors.blueColor;
      case "treatment session":
        return CustomColors.pinkColor;
      default:
        return CustomColors.purpleColor;
    }
  }

  TextStyle _getTimeStyle(String type) {
    switch (type.toLowerCase()) {
      case "consultation":
        return CustomFonts.blue10w700;
      case "treatment session":
        return CustomFonts.pink10w700;
      default:
        return CustomFonts.blue10w700;
    }
  }

  Widget _buildTypeBadge(String type, Color color, TextStyle textStyle) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.w(8),
        vertical: context.h(3),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(context.r(20)),
        border: Border.all(color: Colors.black12, width: 0.5),
      ),
      child: Text(
        type,
        style: textStyle.copyWith(
          fontSize: context.sp(8),
        ), // permitted copyWith for dynamic auto font size only
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: context.w(40)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.event_busy_rounded,
              size: context.sp(64),
              color: Colors.grey.shade300,
            ),
            SizedBox(height: context.h(16)),
            Text("No Appointments Found", style: CustomFonts.grey800_20w600),
            SizedBox(height: context.h(6)),
            Text(
              "Try adjusting your filters, modifying your search, or booking a new clinical slot.",
              textAlign: TextAlign.center,
              style: CustomFonts.textGrey14w400,
            ),
          ],
        ),
      ),
    );
  }
}
