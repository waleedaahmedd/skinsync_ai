import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../../models/responses/appointments_list_response.dart';
import '../../utills/color_constant.dart';
import '../../utills/custom_fonts.dart';
import '../../view_models/appointment_view_model.dart';
import '../../widgets/app_loader.dart';
import '../../widgets/appointment_card.dart';
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
                          final appointment = filteredAppointments[index];
                          return AppointmentCard(
                            appointment: appointment,
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                AppointmentDetailScreen.routeName,
                                arguments: appointment,
                              );
                            },
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
