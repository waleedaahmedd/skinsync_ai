import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../models/dummy_list_model.dart';
import '../../utills/color_constant.dart';
import '../../utills/custom_fonts.dart';

import '../appointment_detail_screen.dart';

enum AppointmentGrouping { dayWise, treatmentWise, clinicWise, doctorWise }

class AppointmentsScreen extends ConsumerStatefulWidget {
  const AppointmentsScreen({super.key});

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
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        title: Text("My Appointments", style: CustomFonts.black28w600),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: Colors.white,
              padding: EdgeInsets.only(bottom: 25.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value;
                        });
                      },
                      style: CustomFonts.black18w400,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.search, color: Colors.grey, size: 24),
                        hintText: "Search appointments...",
                        hintStyle: CustomFonts.grey16w400,
                        contentPadding: EdgeInsets.symmetric(vertical: 14.h),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide(color: Colors.grey.shade200),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide(color: Colors.grey.shade200),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: const BorderSide(color: CustomColors.darkPurple),
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade50,
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Row(
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
                        SizedBox(width: 15.w),
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
                  ),
                ],
              ),
            ),
            Expanded(
              child: groupedAppointments.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 25.h),
                      itemCount: groupedAppointments.length,
                      itemBuilder: (context, index) {
                        String key = groupedAppointments.keys.elementAt(index);
                        List<DummyAppointment> appointments = groupedAppointments[key]!;
                        return Container(
                            padding: EdgeInsets.all(14.w),
                            margin: EdgeInsets.only(bottom: 14.w),
                            decoration: BoxDecoration(
                              color: CustomColors.blueColor,
                              borderRadius: BorderRadius.circular(18.r),
                            ),
                            child: Column(
                              children: [
                                _buildGroupSection(key, appointments),
                              ],
                            ));
                      },
                    ),
            ),
          ],
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
        Text(label, style: CustomFonts.grey15w400.copyWith(fontWeight: FontWeight.w600)),
        SizedBox(height: 6.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 14.w),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<T>(
              value: value,
              items: items,
              onChanged: onChanged,
              isExpanded: true,
              icon: Icon(Icons.keyboard_arrow_down, size: 24, color: Colors.grey.shade600),
              dropdownColor: Colors.white,
              borderRadius: BorderRadius.circular(10.r),
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
          child: Text(
            title,
            style: CustomFonts.white18w600,
          ),
        ),
        ...appointments.map((appointment) => _buildAppointmentCard(appointment)),
      ],
    );
  }

  Widget _buildAppointmentCard(DummyAppointment appointment) {
    bool isProvisional = appointment.type == "Provisional Booking";
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
        margin: EdgeInsets.only(bottom: 15.h),
        decoration: BoxDecoration(
          color: CustomColors.whiteColor,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: 90.w,
                decoration: BoxDecoration(
                  color: typeColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16.r),
                    bottomLeft: Radius.circular(16.r),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  child: Center(
                    child: Text(
                      appointment.time.replaceAll(" - ", "\n-\n"),
                      textAlign: TextAlign.center,
                      style: CustomFonts.black12w600.copyWith(
                        height: 1.4,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              "${appointment.treatmentName} – ${appointment.area}",
                              style: CustomFonts.black18w600.copyWith(fontSize: 16.sp, color: Colors.black),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          _buildTypeBadge(appointment.type, typeColor),
                        ],
                      ),
                      SizedBox(height: 10.h),
                      _buildInfoRow(Icons.business_outlined, appointment.clinicName, isSolid: true),
                      if (appointment.doctorName != "Pending")
                        Padding(
                          padding: EdgeInsets.only(top: 6.h),
                          child: _buildInfoRow(Icons.person_outline, appointment.doctorName, isSolid: true),
                        ),
                      if (isProvisional)
                        Container(
                          margin: EdgeInsets.only(top: 12.h),
                          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.info_outline, size: 12.sp, color: Colors.black87),
                              SizedBox(width: 6.w),
                              Text(
                                "Awaiting clinic onboarding",
                                style: CustomFonts.black10w600.copyWith(
                                  color: Colors.black87,
                                  fontSize: 10.sp,
                                ),
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
      ),
    );
  }

  Color _getTypeColor(String type) {
    switch (type) {
      case "Consultation": return CustomColors.lightBlueColor;
      case "Sessions": return CustomColors.purpleColor;
      case "Follow-Up / Touch-Up": return CustomColors.lightPurpleColor;
      case "Provisional Booking": return CustomColors.yellow;
      default: return Colors.white;
    }
  }

  Widget _buildInfoRow(IconData icon, String text, {bool isSolid = false}) {
    return Row(
      children: [
        Icon(icon, size: 16.sp, color: isSolid ? Colors.black.withValues(alpha: 0.4) : Colors.grey.shade400),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            text,
            style: CustomFonts.black14w400.copyWith(color: isSolid ? Colors.black87 : Colors.grey.shade600),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildTypeBadge(String type, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Text(
        type,
        style: TextStyle(
          color: Colors.black87,
          fontSize: 10.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off_rounded, size: 64.sp, color: Colors.grey.shade300),
          SizedBox(height: 20.h),
          Text("No appointments found", style: CustomFonts.grey18w400),
          SizedBox(height: 8.h),
          Text("Try adjusting your filters", style: CustomFonts.grey14w400),
        ],
      ),
    );
  }
}
