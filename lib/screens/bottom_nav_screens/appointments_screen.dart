import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../models/responses/get_appointment_response.dart';
import '../../utills/color_constant.dart';
import '../../utills/custom_fonts.dart';
import '../../utills/date_time_utills.dart';
import '../../view_models/appointment_view_model.dart';

import '../appointment_detail_screen.dart';
import '../../widgets/custom_search_field.dart';
import 'package:cached_network_image/cached_network_image.dart';

enum AppointmentGrouping { dayWise, treatmentWise, clinicWise, doctorWise }

class AppointmentsScreen extends ConsumerStatefulWidget {
  const AppointmentsScreen({super.key});
  static const String routeName = "/AppointmentsScreen";

  @override
  ConsumerState<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends ConsumerState<AppointmentsScreen> {
  AppointmentGrouping _selectedGrouping = AppointmentGrouping.dayWise;
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

  Map<String, List<AppointmentItem>> _getGroupedAppointments(List<AppointmentItem> items) {
    List<AppointmentItem> filteredList = items.where((appointment) {
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

    Map<String, List<AppointmentItem>> grouped = {};

    for (var appointment in filteredList) {
      String key = "";
      switch (_selectedGrouping) {
        case AppointmentGrouping.dayWise:
          if (appointment.date != null) {
            key = DateTimeUtils.formatTimestampToDayDate(appointment.date!);
          } else {
            key = "Unknown Date";
          }
          break;
        case AppointmentGrouping.treatmentWise:
          key = appointment.treatments?.firstOrNull?.treatmentName ?? "No Treatment";
          break;
        case AppointmentGrouping.clinicWise:
          key = appointment.clinic?.clinicName ?? "Unknown Clinic";
          break;
        case AppointmentGrouping.doctorWise:
          key = appointment.doctor?.doctorName ?? "Unknown Doctor";
          break;
      }

      if (!grouped.containsKey(key)) {
        grouped[key] = [];
      }
      grouped[key]!.add(appointment);
    }

    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    final appointmentState = ref.watch(appointmentProvider);
    final appointments = appointmentState.appointmentsResponse?.data?.items ?? [];
    final groupedAppointments = _getGroupedAppointments(appointments);

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
                  Row(
                    children: [
                      Expanded(
                        child: _buildDropdown<AppointmentGrouping>(
                          label: "Group By",
                          value: _selectedGrouping,
                          items: AppointmentGrouping.values.map((e) {
                            return DropdownMenuItem(
                              value: e,
                              child: Text(_getGroupingLabel(e), style: CustomFonts.black14w600),
                            );
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) setState(() => _selectedGrouping = val);
                          },
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: _buildDropdown<String>(
                          label: "Type",
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
                      ),
                    ],
                  ),
                ],
              ),
              Expanded(
                child: appointmentState.loading
                    ? const Center(child: CupertinoActivityIndicator())
                    : groupedAppointments.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        padding: EdgeInsets.only( top: 20.h,bottom: 80),
                        physics: const BouncingScrollPhysics(),
                        itemCount: groupedAppointments.length,
                        itemBuilder: (context, index) {
                          String key = groupedAppointments.keys.elementAt(index);
                          List<AppointmentItem> appointments = groupedAppointments[key]!;
                          return Container(
                            padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 8.h),
                            margin: EdgeInsets.only(bottom: 16.h),
                            decoration: BoxDecoration(
                              gradient: CustomColors.purpleBlueGradient,
                              borderRadius: BorderRadius.circular(24.r),
                              boxShadow: [
                                BoxShadow(
                                  color: CustomColors.purpleColor.withValues(alpha: 0.15),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: _buildGroupSection(key, appointments),
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

  String _getGroupingLabel(AppointmentGrouping grouping) {
    switch (grouping) {
      case AppointmentGrouping.dayWise: return "Day";
      case AppointmentGrouping.treatmentWise: return "Treatment";
      case AppointmentGrouping.clinicWise: return "Clinic";
      case AppointmentGrouping.doctorWise: return "Doctor";
    }
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

  Widget _buildGroupSection(String title, List<AppointmentItem> appointments) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 4.w, bottom: 15.h),
          child: Row(
            children: [
              const Icon(Icons.stars_rounded, color: CustomColors.yellow, size: 16),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  title,
                  style: CustomFonts.black14w700,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        ...appointments.map((appointment) => _buildAppointmentCard(appointment)),
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
        margin: EdgeInsets.only(bottom: 16.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24.r),
          border: Border.all(color: Colors.grey.shade100, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 15,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          children: [
            // 1. Top Section: Date & Appointment Slot (Gradient-style background)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 14.h),
              decoration: BoxDecoration(
                color: typeColor.withValues(alpha: 0.08),
                borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(Icons.calendar_today_rounded, size: 16.sp, color: typeColor),
                      SizedBox(width: 8.w),
                      Text(dateStr, style: CustomFonts.black14w700),
                      const Spacer(),
                      _buildTypeBadge(type, typeColor, timeStyle),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time_filled_rounded,
                        size: 14.sp,
                        color: typeColor.withValues(alpha: 0.7),
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        timeString,
                        style: CustomFonts.black13w600.copyWith(color: Colors.black87),
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
                                  style: CustomFonts.grey700_12w400,
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
                                  style: CustomFonts.grey700_12w400,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),

                  if (appointment.treatments?.isNotEmpty ?? false) ...[
                    SizedBox(height: 18.h),
                    const Divider(height: 1, color: Colors.black12),
                    SizedBox(height: 18.h),

                    // 3. Treatments List
                    Text("Selected Treatments", style: CustomFonts.darkPurple12w600),
                    SizedBox(height: 12.h),
                    ...appointment.treatments!.map(
                      (t) => Padding(
                        padding: EdgeInsets.only(bottom: 10.h),
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(6.w),
                              decoration: BoxDecoration(
                                color: CustomColors.purpleColor.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: Icon(
                                Icons.auto_awesome_rounded,
                                size: 14.sp,
                                color: CustomColors.purpleColor,
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(t.treatmentName ?? "N/A", style: CustomFonts.black13w600),
                                  Text(
                                    "${t.areaName ?? ''} ${t.material != null ? '(${t.material!.selectedQuantity} Syringes)' : ''}",
                                    style: CustomFonts.grey700_10w400,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
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
