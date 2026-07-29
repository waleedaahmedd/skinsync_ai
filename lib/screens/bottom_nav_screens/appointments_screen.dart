import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../models/dummy_list_model.dart';
import '../../utills/color_constant.dart';
import '../../utills/custom_fonts.dart';

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
    "Consultation",
    "Sessions",
    "Follow-Up / Touch-Up",
    "Provisional Booking",
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Map<String, List<DummyAppointment>> _getGroupedAppointments() {
    List<DummyAppointment> filteredList = dummyAppointments.where((appointment) {
      final query = _searchQuery.toLowerCase();
      final matchesSearch = appointment.clinicName.toLowerCase().contains(query) ||
          appointment.doctorName.toLowerCase().contains(query) ||
          appointment.treatmentName.toLowerCase().contains(query) ||
          appointment.area.toLowerCase().contains(query) ||
          appointment.type.toLowerCase().contains(query);

      final matchesType = _selectedTypeFilter == "All" || appointment.type == _selectedTypeFilter;

      return matchesSearch && matchesType;
    }).toList();

    Map<String, List<DummyAppointment>> grouped = {};

    for (var appointment in filteredList) {
      String key = "";
      switch (_selectedGrouping) {
        case AppointmentGrouping.dayWise:
          key = DateFormat('EEEE, MMM d, yyyy').format(appointment.date);
          break;
        case AppointmentGrouping.treatmentWise:
          key = appointment.treatmentName;
          break;
        case AppointmentGrouping.clinicWise:
          key = appointment.clinicName;
          break;
        case AppointmentGrouping.doctorWise:
          key = appointment.doctorName;
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
    final groupedAppointments = _getGroupedAppointments();

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
                child: groupedAppointments.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        padding: EdgeInsets.only( top: 20.h,bottom: 80),
                        physics: const BouncingScrollPhysics(),
                        itemCount: groupedAppointments.length,
                        itemBuilder: (context, index) {
                          String key = groupedAppointments.keys.elementAt(index);
                          List<DummyAppointment> appointments = groupedAppointments[key]!;
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

  Widget _buildGroupSection(String title, List<DummyAppointment> appointments) {
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

  Widget _buildAppointmentCard(DummyAppointment appointment) {
    bool isProvisional = appointment.type == "Provisional Booking";
    Color typeColor = _getTypeColor(appointment.type);
    TextStyle timeStyle = _getTimeStyle(appointment.type);

    final bgImage = appointment.treatmentName.toLowerCase().contains("botox")
        ? "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQl-cyJqFlcZav1TlRMEuajtrg2RJlWY3rTQA&s"
        : "https://movelmedspa.com/storage/2024/05/Cheek-Filler-Treatment-at-Movel-Med-Spa.webp";

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
        margin: EdgeInsets.only(bottom: 12.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18.r),
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
                    child: const Icon(Icons.broken_image_rounded, color: Colors.grey),
                  ),
                ),
              ),

              // 2. Translucent Premium White Mask Overlay
              Positioned.fill(
                child: Container(
                  color: Colors.white.withValues(alpha: 0.75),
                ),
              ),

              // 3. Card Content Layout (IntrinsicHeight Row)
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Left Time Block with custom translucent background styling
                    Container(
                      width: 85.w,
                      decoration: BoxDecoration(
                        color: typeColor.withValues(alpha: 0.25),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(18.r),
                          bottomLeft: Radius.circular(18.r),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.w),
                        child: Center(
                          child: Text(
                            appointment.time.replaceAll(" - ", "\n-\n"),
                            textAlign: TextAlign.center,
                            style: CustomFonts.black10w600.copyWith(
                              height: 1.3,
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                              fontSize: 10.sp,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(14.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
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
                                SizedBox(width: 4.w),
                                _buildTypeBadge(appointment.type, typeColor, timeStyle),
                              ],
                            ),
                            SizedBox(height: 8.h),
                            _buildInfoRow(Icons.business_rounded, appointment.clinicName),
                            if (appointment.doctorName != "Pending")
                              Padding(
                                padding: EdgeInsets.only(top: 3.h),
                                child: _buildInfoRow(Icons.person_rounded, appointment.doctorName),
                              ),
                            if (isProvisional)
                              Container(
                                margin: EdgeInsets.only(top: 8.h),
                                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.05),
                                  borderRadius: BorderRadius.circular(6.r),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.info_outline_rounded, size: 10, color: Colors.black54),
                                    SizedBox(width: 4.w),
                                    Text(
                                      "Awaiting clinic onboarding",
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getTypeColor(String type) {
    switch (type) {
      case "Consultation": return CustomColors.blueColor;
      case "Sessions": return CustomColors.pinkColor;
      case "Follow-Up / Touch-Up": return CustomColors.darkPurple;
      case "Provisional Booking": return CustomColors.yellow;
      default: return CustomColors.purpleColor;
    }
  }

  TextStyle _getTimeStyle(String type) {
    switch (type) {
      case "Consultation": return CustomFonts.blue10w700;
      case "Sessions": return CustomFonts.pink10w700;
      case "Follow-Up / Touch-Up": return CustomFonts.darkPurple10w700;
      case "Provisional Booking": return CustomFonts.amber10w700;
      default: return CustomFonts.blue10w700;
    }
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 13.sp, color: Colors.grey.shade500),
        SizedBox(width: 6.w),
        Expanded(
          child: Text(
            text,
            style: CustomFonts.grey700_10w400,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
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
