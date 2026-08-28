import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:iconsax/iconsax.dart';
import '../../models/requests/preferred_slot.dart';
import '../../utils/color_constant.dart';
import '../../utils/custom_fonts.dart';
import '../../utils/date_time_utils.dart';
import '../custom_button.dart';

class PreferredSlotsBottomSheet extends StatefulWidget {
  final Function(List<PreferredSlot>) onConfirm;

  const PreferredSlotsBottomSheet({super.key, required this.onConfirm});

  static void show({
    required BuildContext context,
    required Function(List<PreferredSlot>) onConfirm,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => PreferredSlotsBottomSheet(onConfirm: onConfirm),
    );
  }

  @override
  State<PreferredSlotsBottomSheet> createState() => _PreferredSlotsBottomSheetState();
}

class _PreferredSlotsBottomSheetState extends State<PreferredSlotsBottomSheet> {
  final List<DateTime?> _selectedDates = [null, null, null];
  final List<TimeOfDay?> _selectedTimes = [null, null, null];

  Future<void> _selectDate(int index) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDates[index] ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: CustomColors.purpleColor,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _selectedDates[index] = picked;
      });
    }
  }

  Future<void> _selectTime(int index) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTimes[index] ?? TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: CustomColors.purpleColor,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _selectedTimes[index] = picked;
      });
    }
  }

  bool get _canConfirm =>
      _selectedDates.every((d) => d != null) &&
      _selectedTimes.every((t) => t != null);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(context.r(32))),
      ),
      padding: EdgeInsets.fromLTRB(
        context.w(24),
        context.h(16),
        context.w(24),
        context.h(32) + MediaQuery.paddingOf(context).bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: context.w(44),
              height: context.h(5),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(context.r(100)),
              ),
            ),
          ),
          SizedBox(height: context.h(24)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Preferred Appointment Slots", style: CustomFonts.black20w600),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(Iconsax.close_circle, color: Colors.grey),
              ),
            ],
          ),
          SizedBox(height: context.h(12)),
          Text(
            "Please select 3 preferred dates and times for your appointment.",
            style: CustomFonts.grey14w400,
          ),
          SizedBox(height: context.h(24)),
          Flexible(
            child: SingleChildScrollView(
              child: Column(
                children: List.generate(3, (index) {
                  return Container(
                    margin: EdgeInsets.only(bottom: context.h(20)),
                    padding: EdgeInsets.all(context.w(16)),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(context.r(20)),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(context.w(8)),
                              decoration: BoxDecoration(
                                color: CustomColors.purpleColor.withValues(alpha: 0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                "${index + 1}",
                                style: CustomFonts.black14w600.copyWith(
                                  color: CustomColors.purpleColor,
                                ),
                              ),
                            ),
                            SizedBox(width: context.w(12)),
                            Text(
                              "Option ${index + 1}",
                              style: CustomFonts.black16w600,
                            ),
                          ],
                        ),
                        SizedBox(height: context.h(16)),
                        Row(
                          children: [
                            Expanded(
                              child: _buildPickerButton(
                                icon: Iconsax.calendar,
                                label: _selectedDates[index]?.formattedDate ?? "Select Date",
                                isSelected: _selectedDates[index] != null,
                                onTap: () => _selectDate(index),
                              ),
                            ),
                            SizedBox(width: context.w(12)),
                            Expanded(
                              child: _buildPickerButton(
                                icon: Iconsax.clock,
                                label: _selectedTimes[index]?.format(context) ?? "Select Time",
                                isSelected: _selectedTimes[index] != null,
                                onTap: () => _selectTime(index),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
          ),
          SizedBox(height: context.h(12)),
          CustomButton(
            text: "Continue",
            onPressed: _canConfirm
                ? () {
                    final slots = List.generate(3, (index) {
                      final date = _selectedDates[index]!;
                      final time = _selectedTimes[index]!;
                      return PreferredSlot(
                        date: date.formattedDate,
                        time: time.format(context),
                      );
                    });
                    Navigator.pop(context);
                    widget.onConfirm(slots);
                  }
                : null,
          ),
        ],
      ),
    );
  }

  Widget _buildPickerButton({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(context.r(12)),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: context.w(12),
          vertical: context.h(12),
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: isSelected ? CustomColors.purpleColor : Colors.grey.shade300,
          ),
          borderRadius: BorderRadius.circular(context.r(12)),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected ? CustomColors.purpleColor : Colors.grey,
            ),
            SizedBox(width: context.w(8)),
            Expanded(
              child: Text(
                label,
                style: isSelected ? CustomFonts.black12w600 : CustomFonts.grey12w400,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
