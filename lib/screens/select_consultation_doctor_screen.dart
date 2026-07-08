import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:skinsync_ai/models/dummy_list_model.dart';
import 'package:skinsync_ai/models/responses/get_clinic_response.dart';
import 'package:skinsync_ai/utills/color_constant.dart';
import 'package:skinsync_ai/utills/custom_fonts.dart';
import 'package:skinsync_ai/widgets/custom_app_bar.dart';
import 'package:skinsync_ai/widgets/doctor_card.dart';
import 'package:skinsync_ai/widgets/custom_search_field.dart';
import 'clinic_service_screen.dart';

class SelectConsultationDoctorScreen extends StatefulWidget {
  static const routeName = '/select_consultation_doctor_screen';
  final Clinic clinic;

  const SelectConsultationDoctorScreen({
    super.key,
    required this.clinic,
  });

  @override
  State<SelectConsultationDoctorScreen> createState() =>
      _SelectConsultationDoctorScreenState();
}

class _SelectConsultationDoctorScreenState
    extends State<SelectConsultationDoctorScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  DateTime? _selectedDate;
  String? _selectedSlot;

  final List<String> _slots = [
    "09:00 AM - 11:00 AM",
    "11:00 AM - 01:00 PM",
    "01:00 PM - 03:00 PM",
    "03:00 PM - 05:00 PM",
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.trim().toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _clearFilters() {
    setState(() {
      _selectedDate = null;
      _selectedSlot = null;
      _searchController.clear();
      _searchQuery = "";
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: CustomColors.pinkColor,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: CustomColors.pinkColor,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  List<DummyDoctor> _getFilteredDoctors(bool isVirtual) {
    return dummyDoctors.where((doctor) {
      // 1. Filter by Tab (In-Person: Even-indexed id; Virtual: Odd-indexed id)
      final int idNum = int.tryParse(doctor.id) ?? 0;
      final bool isDocVirtual = idNum % 2 == 0;
      if (isVirtual != isDocVirtual) return false;

      // 2. Filter by Search Query
      if (_searchQuery.isNotEmpty) {
        final matchesName = doctor.name.toLowerCase().contains(_searchQuery);
        final matchesSpec = doctor.specialization.toLowerCase().contains(_searchQuery);
        final matchesClinic = doctor.clinicName.toLowerCase().contains(_searchQuery);
        if (!matchesName && !matchesSpec && !matchesClinic) return false;
      }

      // 3. Filter by Date (Simulated availability matching)
      if (_selectedDate != null) {
        final day = _selectedDate!.weekday;
        // Sarah Smith ID 1 works Mon, Wed, Fri
        // John Doe ID 2 works Tue, Thu, Sat
        // Emily Brown ID 3 works Wed, Fri, Sun
        if (doctor.id == "1" && ![1, 3, 5].contains(day)) return false;
        if (doctor.id == "2" && ![2, 4, 6].contains(day)) return false;
        if (doctor.id == "3" && ![3, 5, 7].contains(day)) return false;
      }

      // 4. Filter by Slot (Simulated availability matching)
      if (_selectedSlot != null) {
        // Sarah Smith (ID 1) works Morning and Afternoon
        // John Doe (ID 2) works Afternoon and Evening
        // Emily Brown (ID 3) works Morning and Evening
        if (_selectedSlot == "09:00 AM - 11:00 AM" && doctor.id == "2") return false;
        if (_selectedSlot == "11:00 AM - 01:00 PM" && doctor.id == "3") return false;
        if (_selectedSlot == "01:00 PM - 03:00 PM" && doctor.id == "1") return false;
        if (_selectedSlot == "03:00 PM - 05:00 PM" && doctor.id == "1") return false;
      }

      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final hasActiveFilters = _selectedDate != null || _selectedSlot != null || _searchQuery.isNotEmpty;

    return Scaffold(
      backgroundColor: CustomColors.whiteColor,
      appBar: const CustomAppBar(showTitle: true, title: "Select Doctor"),
      body: Container(
        decoration: const BoxDecoration(
          gradient: CustomColors.whiteBlueGradient,
        ),
        child: Column(
          children: [
            SizedBox(height: 16.h),

            // Search Bar & Filter Clear Button Row
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Row(
                children: [
                  Expanded(
                    child: CustomSearchField(
                      controller: _searchController,
                      hintText: "Search Doctors...",
                    ),
                  ),
                  if (hasActiveFilters) ...[
                    SizedBox(width: 8.w),
                    GestureDetector(
                      onTap: _clearFilters,
                      child: Container(
                        padding: EdgeInsets.all(12.w),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(color: Colors.red.shade100),
                        ),
                        child: Icon(
                          Icons.filter_alt_off_rounded,
                          color: Colors.red.shade400,
                          size: 20.sp,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            SizedBox(height: 16.h),

            // Premium Date Selector Card & Slot Selector Slider Horizontal Row
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Row(
                children: [
                  // Premium Calendar Date Picker Trigger
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _selectDate(context),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
                        decoration: BoxDecoration(
                          color: _selectedDate != null
                              ? CustomColors.pinkColor
                              : CustomColors.lightPurpleColor.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.calendar_month_rounded,
                              color: _selectedDate != null ? Colors.white : Colors.black87,
                              size: 16.sp,
                            ),
                            SizedBox(width: 6.w),
                            Expanded(
                              child: Text(
                                _selectedDate != null
                                    ? DateFormat('MMM dd, yyyy').format(_selectedDate!)
                                    : "Select Date",
                                style: _selectedDate != null
                                    ? CustomFonts.white14w600.copyWith(fontSize: 13.sp)
                                    : CustomFonts.black14w600.copyWith(color: Colors.black87, fontSize: 13.sp),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 12.h),

            // Time Slots Header / Horizontal Scrolling List
            SizedBox(
              height: 38.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                itemCount: _slots.length,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  final slot = _slots[index];
                  final isSelected = _selectedSlot == slot;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        // Toggle logic: deselects if clicked again!
                        if (isSelected) {
                          _selectedSlot = null;
                        } else {
                          _selectedSlot = slot;
                        }
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.only(right: 8.w),
                      padding: EdgeInsets.symmetric(
                        horizontal: 14.w,
                        vertical: 8.h,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? CustomColors.purpleColor
                            : CustomColors.lightPurpleColor.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(
                          color: isSelected
                              ? CustomColors.purpleColor
                              : Colors.transparent,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.access_time_filled_rounded,
                            size: 12.sp,
                            color: isSelected ? Colors.white : Colors.grey.shade700,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            slot,
                            style: isSelected
                                ? CustomFonts.white12w600
                                : CustomFonts.black12w600.copyWith(
                                    color: Colors.grey.shade700,
                                  ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 16.h),

            // Tabs Header: In-Person vs Virtual
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: TabBar(
                controller: _tabController,
                indicatorColor: CustomColors.pinkColor,
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey.shade400,
                labelStyle: CustomFonts.black16w600,
                unselectedLabelStyle: CustomFonts.grey16w500,
                dividerColor: Colors.transparent,
                tabs: const [
                  Tab(text: "In-Person"),
                  Tab(text: "Virtual Consultation"),
                ],
              ),
            ),
            SizedBox(height: 12.h),

            // Tab Views Grid List
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildDoctorGrid(isVirtual: false),
                  _buildDoctorGrid(isVirtual: true),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDoctorGrid({required bool isVirtual}) {
    final doctors = _getFilteredDoctors(isVirtual);

    if (doctors.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 40.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.people_alt_rounded,
                size: 64.sp,
                color: Colors.grey.shade300,
              ),
              SizedBox(height: 16.h),
              Text(
                "No Doctors Found",
                style: CustomFonts.grey800_20w600,
              ),
              SizedBox(height: 6.h),
              Text(
                "Try modifying your filter selections, resetting parameters, or check back later.",
                textAlign: TextAlign.center,
                style: CustomFonts.textGrey14w400,
              ),
            ],
          ),
        ),
      );
    }

    return GridView.builder(
      itemCount: doctors.length,
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
      physics: const BouncingScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.76,
        crossAxisSpacing: 14.w,
        mainAxisSpacing: 14.h,
      ),
      itemBuilder: (context, index) {
        final doctor = doctors[index];

        return DoctorCard(
          doctor: doctor,
          width: double.infinity,
          margin: EdgeInsets.zero,
          onTap: () {
            Navigator.pushNamed(
              context,
              ClinicServiceScreen.routeName,
              arguments: widget.clinic,
            );
          },
        );
      },
    );
  }
}
