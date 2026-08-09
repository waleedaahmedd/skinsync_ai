import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:intl/intl.dart';

import '../../models/responses/get_clinic_response.dart';
import '../../models/responses/map_clinics_response.dart';
import '../../utills/color_constant.dart';
import '../../utills/custom_fonts.dart';
import '../../utills/date_time_utills.dart';
import '../custom_button.dart';
import '../time_container.dart';

class PreBookingBottomSheet extends StatefulWidget {
  final Clinic clinic;
  final VoidCallback onConfirm;

  const PreBookingBottomSheet({
    super.key,
    required this.clinic,
    required this.onConfirm,
  });

  static void show(
    BuildContext context, {
    required Clinic clinic,
    required VoidCallback onConfirm,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) =>
          PreBookingBottomSheet(clinic: clinic, onConfirm: onConfirm),
    );
  }

  @override
  State<PreBookingBottomSheet> createState() => _PreBookingBottomSheetState();
}

class _PreBookingBottomSheetState extends State<PreBookingBottomSheet> {
  DateTime? _selectedDate;
  int? _selectedSlotIndex;

  List<String> _generateSlots() {
    if (_selectedDate == null ||
        widget.clinic.place?.regularOpeningHours?.periods == null) {
      return [];
    }

    final targetDay = _selectedDate!.weekday == 7 ? 0 : _selectedDate!.weekday;
    final periods = widget.clinic.place?.regularOpeningHours?.periods;

    final period = periods?.firstWhere(
      (p) => p.open?.day == targetDay,
      orElse: () => CurrentOpeningHoursPeriod(),
    );

    if (period == null ||
        period.open == null ||
        period.open?.hour == null ||
        period.close == null ||
        period.close?.hour == null) {
      return [];
    }

    int startHour = period.open!.hour!;
    int startMinute = period.open!.minute!;
    int endHour = period.close!.hour!;
    int endMinute = period.close!.minute!;

    int startTotal = startHour * 60 + startMinute;
    int endTotal = endHour * 60 + endMinute;

    if (endTotal <= startTotal) endTotal += 24 * 60;

    List<String> slots = [];
    int currentTotal = startTotal;
    while (currentTotal + 180 <= endTotal) {
      int h = (currentTotal ~/ 60) % 24;
      int m = currentTotal % 60;

      int eh = ((currentTotal + 180) ~/ 60) % 24;
      int em = (currentTotal + 180) % 60;

      final startTimeStr = _formatTime(h, m);
      final endTimeStr = _formatTime(eh, em);

      slots.add("$startTimeStr - $endTimeStr");
      currentTotal += 180;
    }

    return slots;
  }

  String _formatTime(int hour, int minute) {
    final dt = DateTime(0, 0, 0, hour, minute);
    return DateFormat('hh:mm a').format(dt);
  }

  @override
  Widget build(BuildContext context) {
    final slots = _generateSlots();

    return Container(
      padding: EdgeInsets.fromLTRB(
        context.w(20),
        context.h(20),
        context.w(20),
        MediaQuery.of(context).viewInsets.bottom + context.h(20),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(context.r(20)),
          topRight: Radius.circular(context.r(20)),
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
          SizedBox(height: context.h(20)),
          _buildPickerTile(
            label: "Required Date",
            value: _selectedDate?.formattedDate ?? "Select Date",
            icon: Icons.calendar_today,
            onTap: _pickDate,
          ),
          if (_selectedDate != null) ...[
            SizedBox(height: context.h(25)),
            Text(
              "Available Time Slots (3-Hour Window)",
              style: CustomFonts.grey15w400.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: context.h(12)),
            if (slots.isEmpty)
              Padding(
                padding: EdgeInsets.symmetric(vertical: context.h(10)),
                child: Text(
                  "No slots available for this day.",
                  style: CustomFonts.black14w400,
                ),
              )
            else
              Wrap(
                spacing: context.w(12),
                runSpacing: context.h(12),
                children: List.generate(slots.length, (index) {
                  return TimeContainer(
                    onTap: () {
                      setState(() {
                        _selectedSlotIndex = index;
                      });
                    },
                    time: slots[index],
                    isAvailable: true,
                    isBooked: false,
                    isSelected: _selectedSlotIndex == index,
                  );
                }),
              ),
          ],
          SizedBox(height: context.h(30)),
          SizedBox(
            width: double.infinity,
            child: CustomButton(
              onPressed: _validate(slots)
                  ? () {
                      Navigator.pop(context);
                      widget.onConfirm();
                    }
                  : null,
              text: "Next",
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPickerTile({
    required String label,
    required String value,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: CustomFonts.grey15w400.copyWith(fontWeight: FontWeight.w600),
        ),
        SizedBox(height: context.h(8)),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(context.r(10)),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: context.w(15),
              vertical: context.h(12),
            ),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              border: Border.all(color: Colors.grey.shade200),
              borderRadius: BorderRadius.circular(context.r(10)),
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: context.sp(20),
                  color: CustomColors.darkPurple,
                ),
                SizedBox(width: context.w(10)),
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
      setState(() {
        _selectedDate = date;
        _selectedSlotIndex = null; // Reset slot selection when date changes
      });
    }
  }

  bool _validate(List<String> slots) {
    return _selectedDate != null &&
        _selectedSlotIndex != null &&
        _selectedSlotIndex! < slots.length;
  }
}
