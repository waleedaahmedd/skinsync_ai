import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skinsync_ai/utills/color_constant.dart';
import 'package:skinsync_ai/utills/custom_fonts.dart';
import 'package:skinsync_ai/utills/date_time_utills.dart';

class PreBookingBottomSheet extends StatefulWidget {
  final VoidCallback onConfirm;

  const PreBookingBottomSheet({super.key, required this.onConfirm});

  static void show(BuildContext context, {required VoidCallback onConfirm}) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => PreBookingBottomSheet(onConfirm: onConfirm),
    );
  }

  @override
  State<PreBookingBottomSheet> createState() => _PreBookingBottomSheetState();
}

class _PreBookingBottomSheetState extends State<PreBookingBottomSheet> {
  DateTime? _selectedDate;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, MediaQuery.of(context).viewInsets.bottom + 20.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Pre-Booking Details", style: CustomFonts.black20w600),
              IconButton(
                icon: const Icon(Icons.close, color: CustomColors.blackColor),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          _buildPickerTile(
            label: "Required Date",
            value: _selectedDate?.formattedDate ?? "Select Date",
            icon: Icons.calendar_today,
            onTap: _pickDate,
          ),
          SizedBox(height: 15.h),
          Row(
            children: [
              Expanded(
                child: _buildPickerTile(
                  label: "Start Time",
                  value: _startTime?.format(context) ?? "Select Time",
                  icon: Icons.access_time,
                  onTap: _pickStartTime,
                ),
              ),
              SizedBox(width: 15.w),
              Expanded(
                child: _buildPickerTile(
                  label: "End Time",
                  value: _endTime?.format(context) ?? "Select Time",
                  icon: Icons.access_time,
                  onTap: _pickEndTime,
                ),
              ),
            ],
          ),
          SizedBox(height: 30.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _validate() ? () {
                Navigator.pop(context);
                widget.onConfirm();
              } : null,
              child: const Text("Next"),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPickerTile({required String label, required String value, required IconData icon, required VoidCallback onTap}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: CustomFonts.grey15w400.copyWith(fontWeight: FontWeight.w600)),
        SizedBox(height: 8.h),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10.r),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              border: Border.all(color: Colors.grey.shade200),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Row(
              children: [
                Icon(icon, size: 20.sp, color: CustomColors.darkPurple),
                SizedBox(width: 10.w),
                Text(value, style: CustomFonts.black16w400),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final firstDate = now.add(const Duration(days: 3));
    final date = await showDatePicker(
      context: context,
      initialDate: firstDate,
      firstDate: firstDate,
      lastDate: now.add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: CustomColors.darkPurple,
            ),
          ),
          child: child!,
        );
      },
    );
    if (date != null) {
      setState(() => _selectedDate = date);
    }
  }

  Future<void> _pickStartTime() async {
    final time = await showTimePicker(
      context: context, 
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: CustomColors.darkPurple,
            ),
          ),
          child: child!,
        );
      },
    );
    if (time != null) {
      setState(() => _startTime = time);
    }
  }

  Future<void> _pickEndTime() async {
    final time = await showTimePicker(
      context: context, 
      initialTime: _startTime ?? TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: CustomColors.darkPurple,
            ),
          ),
          child: child!,
        );
      },
    );
    if (time != null) {
      setState(() => _endTime = time);
    }
  }

  bool _validate() {
    return _selectedDate != null && _startTime != null && _endTime != null;
  }
}
