import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../models/responses/appointments_list_response.dart';
import '../../utills/color_constant.dart';
import '../../utills/custom_fonts.dart';
import '../../utills/date_time_utills.dart';
import '../../view_models/appointment_view_model.dart';

import '../appointment_detail_screen.dart';
import '../../widgets/custom_search_field.dart';
import 'package:cached_network_image/cached_network_image.dart';

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

      final matchesSearch = clinicName.contains(query) ||
          doctorName.contains(query) ||
          type.contains(query);

      final matchesType = _selectedTypeFilter == "All" ||
          appointment.appointmentType == _selectedTypeFilter;

      return matchesSearch && matchesType;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final appointmentState = ref.watch(appointmentProvider);
    final appointments = appointmentState.appointmentsResponse?.data?.items ?? [];
    final filteredAppointments = _getFilteredAppointments(appointments);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (Navigator.of(context).canPop()) ...[
                    SizedBox(height: 16.h),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        height: 42.w,
                        width: 42.w,
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
                            size: 18.sp,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                  SizedBox(height: 20.h),
                  Text(
                    "My Appointments",
                    style: CustomFonts.black30w600.copyWith(fontSize: 28.sp),
                  ),
                  SizedBox(height: 20.h),
                  CustomSearchField(
                    controller: _searchController,
                    hintText: "Search appointments...",
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                  ),
                  SizedBox(height: 16.h),
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
                      if (val != null) setState(() => _selectedTypeFilter = val);
                    },
                  ),
                ],
              ),
              Expanded(
                child: appointmentState.loading
                    ? const Center(child: CupertinoActivityIndicator())
                    : filteredAppointments.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        padding: EdgeInsets.only( top: 20.h,bottom: 80),
                        physics: const BouncingScrollPhysics(),
                        itemCount: filteredAppointments.length,
                        itemBuilder: (context, index) {
                          return _buildAppointmentCard(filteredAppointments[index]);
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
        Text(
          label,
          style: CustomFonts.grey700_11w700,
        ),
        SizedBox(height: 6.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 14.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30.r),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<T>(
              value: value,
              items: items,
              onChanged: onChanged,
              isExpanded: true,
              icon: Icon(Icons.keyboard_arrow_down_rounded, size: 20.sp, color: Colors.grey.shade600),
              dropdownColor: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
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
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AppointmentDetailScreen(appointment: appointment),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 22.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24.r),
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
              padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 16.h),
              decoration: BoxDecoration(
                gradient: CustomColors.purpleBlueGradient,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
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
                                const Icon(Icons.calendar_today_rounded, size: 16, color: Colors.white),
                                SizedBox(width: 8.w),
                                Text(dateStr, style: CustomFonts.white14w700),
                              ],
                            ),
                            if (appointment.appointmentKey != null) ...[
                              SizedBox(height: 4.h),
                              Text(
                                appointment.appointmentKey!,
                                style: CustomFonts.white10w600.copyWith(color: Colors.white70),
                              ),
                            ],
                            SizedBox(height: 10.h),
                            Row(
                              children: [
                                const Icon(
                                  Icons.access_time_filled_rounded,
                                  size: 14,
                                  color: Colors.white70,
                                ),
                                SizedBox(width: 8.w),
                                Text(
                                  timeString,
                                  style: CustomFonts.white14w600.copyWith(fontSize: 13.sp),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          _buildTypeBadge(type, Colors.white, timeStyle.copyWith(color: typeColor)),
                          if (appointment.status != null) ...[
                            SizedBox(height: 10.h),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(20.r),
                                border: Border.all(color: Colors.white24),
                              ),
                              child: Text(
                                appointment.status!.toUpperCase(),
                                style: CustomFonts.white10w600.copyWith(
                                  letterSpacing: 1.2,
                                  fontSize: 8.5.sp,
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
              padding: EdgeInsets.all(18.w),
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
                                  imageUrl: appointment.clinic?.clinicImage ?? "",
                                  height: 32.w,
                                  width: 32.w,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => Container(color: Colors.grey.shade100),
                                  errorWidget: (context, url, error) => Container(
                                    color: Colors.grey.shade100,
                                    child: const Icon(Icons.business, size: 16, color: Colors.grey),
                                  ),
                                ),
                              ),
                              SizedBox(width: 10.w),
                              Expanded(
                                child: Text(
                                  appointment.clinic!.clinicName ?? "N/A",
                                  style: CustomFonts.black14w600.copyWith(fontSize: 12.sp),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      SizedBox(width: 12.w),
                      // Doctor Info
                      if (appointment.doctor != null)
                        Expanded(
                          child: Row(
                            children: [
                              ClipOval(
                                child: CachedNetworkImage(
                                  imageUrl: appointment.doctor?.doctorImage ?? "",
                                  height: 32.w,
                                  width: 32.w,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => Container(color: Colors.grey.shade100),
                                  errorWidget: (context, url, error) => Container(
                                    color: Colors.grey.shade100,
                                    child: const Icon(Icons.person, size: 16, color: Colors.grey),
                                  ),
                                ),
                              ),
                              SizedBox(width: 10.w),
                              Expanded(
                                child: Text(
                                  appointment.doctor!.doctorName ?? "N/A",
                                  style: CustomFonts.black14w600.copyWith(fontSize: 12.sp),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),

                  if (appointment.treatments != null && appointment.treatments!.isNotEmpty) ...[
                    SizedBox(height: 18.h),
                    const Divider(height: 1, color: Colors.black12),
                    SizedBox(height: 18.h),

                    // 3. Treatments List
                    Row(
                      children: [
                        const Icon(Icons.medical_services_rounded, size: 14, color: CustomColors.darkPurple),
                        SizedBox(width: 8.w),
                        Text("Selected Treatments", style: CustomFonts.darkPurple12w600),
                      ],
                    ),
                    SizedBox(height: 14.h),
                    for (var t in appointment.treatments!)
                      Container(
                        margin: EdgeInsets.only(bottom: 12.h),
                        padding: EdgeInsets.all(12.w),
                        decoration: BoxDecoration(
                          color: CustomColors.lightPurpleColor.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(16.r),
                          border: Border.all(
                            color: CustomColors.lightPurpleColor.withValues(alpha: 0.1),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12.r),
                              child: CachedNetworkImage(
                                imageUrl: t.treatmentImage ?? "",
                                height: 40.w,
                                width: 40.w,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Container(
                                  color: Colors.white,
                                  child: const Center(child: CupertinoActivityIndicator(radius: 8)),
                                ),
                                errorWidget: (context, url, error) => Container(
                                  color: Colors.white,
                                  padding: EdgeInsets.all(8.w),
                                  child: Icon(
                                    Icons.auto_awesome_rounded,
                                    size: 14.sp,
                                    color: CustomColors.purpleColor,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 14.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          t.treatmentName ?? "N/A",
                                          style: CustomFonts.black14w600.copyWith(fontSize: 13.sp),
                                        ),
                                      ),
                                      if (t.status != null)
                                        Text(
                                          t.status!.toUpperCase(),
                                          style: TextStyle(
                                            color: _getTreatmentStatusColor(t.status!),
                                            fontSize: 9.sp,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                    ],
                                  ),
                                  SizedBox(height: 4.h),
                                  Row(
                                    children: [
                                      Text(
                                        "Area: ${t.areaName ?? 'N/A'}",
                                        style: CustomFonts.grey700_10w400.copyWith(fontSize: 11.sp),
                                      ),
                                      if (t.material != null) ...[
                                        Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 6.w),
                                          child: Text("•", style: TextStyle(color: Colors.grey.shade300, fontSize: 10.sp)),
                                        ),
                                        Container(
                                          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                                          decoration: BoxDecoration(
                                            color: CustomColors.darkPurple.withValues(alpha: 0.08),
                                            borderRadius: BorderRadius.circular(4.r),
                                          ),
                                          child: Text(
                                            "${t.material!.selectedQuantity} ${t.material!.name ?? 'Syringes'}",
                                            style: CustomFonts.darkPurple10w700.copyWith(fontSize: 9.sp),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                  if (t.startTime != null || t.endTime != null) ...[
                                    SizedBox(height: 4.h),
                                    Text(
                                      "${t.startTime != null ? DateTimeUtils.formatTimestampToTime(t.startTime!) : '--:--'} - ${t.endTime != null ? DateTimeUtils.formatTimestampToTime(t.endTime!) : '--:--'}",
                                      style: CustomFonts.grey700_10w400.copyWith(fontSize: 10.sp),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            Icon(Icons.chevron_right_rounded, size: 18.sp, color: Colors.grey.shade300),
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
      case 'pending': return Colors.orange;
      case 'start': return Colors.blue;
      case 'end': return Colors.green;
      default: return Colors.grey;
    }
  }

  Color _getTypeColor(String type) {
    switch (type.toLowerCase()) {
      case "consultation": return CustomColors.blueColor;
      case "treatment session": return CustomColors.pinkColor;
      default: return CustomColors.purpleColor;
    }
  }

  TextStyle _getTimeStyle(String type) {
    switch (type.toLowerCase()) {
      case "consultation": return CustomFonts.blue10w700;
      case "treatment session": return CustomFonts.pink10w700;
      default: return CustomFonts.blue10w700;
    }
  }

  Widget _buildTypeBadge(String type, Color color, TextStyle textStyle) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: Colors.black12, width: 0.5),
      ),
      child: Text(
        type,
        style: textStyle.copyWith(fontSize: 8.sp), // permitted copyWith for dynamic auto font size only
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 40.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.event_busy_rounded,
              size: 64.sp,
              color: Colors.grey.shade300,
            ),
            SizedBox(height: 16.h),
            Text(
              "No Appointments Found",
              style: CustomFonts.grey800_20w600,
            ),
            SizedBox(height: 6.h),
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
