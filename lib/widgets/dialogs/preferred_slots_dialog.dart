import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:iconsax/iconsax.dart';
import '../../models/requests/preferred_slot.dart';
import '../../utils/color_constant.dart';
import '../../utils/custom_fonts.dart';
import '../../utils/date_time_utils.dart';
import '../custom_button.dart';

void showPreferredSlotsDialog({
  required BuildContext context,
  required Function(List<PreferredSlot>) onConfirm,
}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => PreferredSlotsDialog(onConfirm: onConfirm),
  );
}

class PreferredSlotsDialog extends StatefulWidget {
  final Function(List<PreferredSlot>) onConfirm;

  const PreferredSlotsDialog({super.key, required this.onConfirm});

  @override
  State<PreferredSlotsDialog> createState() => _PreferredSlotsDialogState();
}

class _PreferredSlotsDialogState extends State<PreferredSlotsDialog> {
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
    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: EdgeInsets.symmetric(horizontal: context.w(20)),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(context.r(24)),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: context.w(20),
          vertical: context.h(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    "Preferred Appointment Slots",
                    style: CustomFonts.black20w600,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Iconsax.close_circle, color: Colors.grey),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            SizedBox(height: context.h(12)),
            Text(
              "Please select 3 preferred dates and times for your appointment.",
              style: CustomFonts.grey14w400,
            ),
            SizedBox(height: context.h(20)),
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  children: List.generate(3, (index) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: context.h(16)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Option ${index + 1}",
                            style: CustomFonts.black14w600.copyWith(
                              color: CustomColors.purpleColor,
                            ),
                          ),
                          SizedBox(height: context.h(8)),
                          Row(
                            children: [
                              Expanded(
                                child: InkWell(
                                  onTap: () => _selectDate(index),
                                  borderRadius: BorderRadius.circular(context.r(12)),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: context.w(12),
                                      vertical: context.h(12),
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey.shade300),
                                      borderRadius: BorderRadius.circular(context.r(12)),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Iconsax.calendar,
                                          size: 18,
                                          color: Colors.grey,
                                        ),
                                        SizedBox(width: context.w(8)),
                                        Expanded(
                                          child: Text(
                                            _selectedDates[index]?.formattedDate ??
                                                "Select Date",
                                            style: _selectedDates[index] != null
                                                ? CustomFonts.black12w600
                                                : CustomFonts.grey12w400,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: context.w(10)),
                              Expanded(
                                child: InkWell(
                                  onTap: () => _selectTime(index),
                                  borderRadius: BorderRadius.circular(context.r(12)),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: context.w(12),
                                      vertical: context.h(12),
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey.shade300),
                                      borderRadius: BorderRadius.circular(context.r(12)),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Iconsax.clock,
                                          size: 18,
                                          color: Colors.grey,
                                        ),
                                        SizedBox(width: context.w(8)),
                                        Expanded(
                                          child: Text(
                                            _selectedTimes[index]?.format(context) ??
                                                "Select Time",
                                            style: _selectedTimes[index] != null
                                                ? CustomFonts.black12w600
                                                : CustomFonts.grey12w400,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
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
            SizedBox(height: context.h(24)),
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
      ),
    );
  }
}
