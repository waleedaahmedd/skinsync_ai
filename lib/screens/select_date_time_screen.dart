import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:skinsync_ai/utills/color_constant.dart';
import 'package:skinsync_ai/utills/custom_fonts.dart';
import 'package:skinsync_ai/widgets/custom_app_bar.dart';
import 'package:skinsync_ai/view_models/checkout_view_model.dart';
import 'consultation_review_screen.dart';

class SelectDateTimeScreen extends ConsumerStatefulWidget {
  static const routeName = '/select_date_time_screen';

  const SelectDateTimeScreen({super.key});

  @override
  ConsumerState<SelectDateTimeScreen> createState() => _SelectDateTimeScreenState();
}

class _SelectDateTimeScreenState extends ConsumerState<SelectDateTimeScreen> {
  DateTime? _selectedDate;
  String? _selectedSlot;

  final List<String> _slots = [
    "09:00 AM - 11:00 AM",
    "11:00 AM - 01:00 PM",
    "01:00 PM - 03:00 PM",
    "03:00 PM - 05:00 PM",
  ];

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

  @override
  Widget build(BuildContext context) {
    final bool canContinue = _selectedDate != null && _selectedSlot != null;

    return Scaffold(
      backgroundColor: CustomColors.whiteColor,
      appBar: const CustomAppBar(showTitle: true, title: "Select Date & Time"),
      body: Container(
        decoration: const BoxDecoration(
          gradient: CustomColors.whiteBlueGradient,
        ),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Select Booking Date", style: CustomFonts.black18w600),
                    SizedBox(height: 12.h),

                    // Beautiful Calendar picker trigger field
                    GestureDetector(
                      onTap: () => _selectDate(context),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 16.h),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16.r),
                          border: Border.all(
                            color: _selectedDate != null ? CustomColors.pinkColor : Colors.grey.shade200,
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.03),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.calendar_month_rounded,
                              color: _selectedDate != null ? CustomColors.pinkColor : Colors.grey,
                            ),
                            SizedBox(width: 14.w),
                            Expanded(
                              child: Text(
                                _selectedDate != null
                                    ? DateFormat('EEEE, MMMM dd, yyyy').format(_selectedDate!)
                                    : "Choose a consultation date",
                                style: _selectedDate != null
                                    ? CustomFonts.black14w600
                                    : CustomFonts.grey14w400,
                              ),
                            ),
                            const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.grey),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 32.h),

                    Text("Available Time Slots", style: CustomFonts.black18w600),
                    SizedBox(height: 6.h),
                    Text(
                      "Select an available 2-hour consultation slot below:",
                      style: CustomFonts.grey12w400,
                    ),
                    SizedBox(height: 16.h),

                    // Grid or list of 2-hour slots
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _slots.length,
                      itemBuilder: (context, index) {
                        final slot = _slots[index];
                        final isSelected = _selectedSlot == slot;

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedSlot = slot;
                            });
                          },
                          child: Container(
                            margin: EdgeInsets.only(bottom: 12.h),
                            padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 16.h),
                            decoration: BoxDecoration(
                              color: isSelected ? CustomColors.purpleColor.withValues(alpha: 0.08) : Colors.white,
                              borderRadius: BorderRadius.circular(16.r),
                              border: Border.all(
                                color: isSelected ? CustomColors.purpleColor : Colors.grey.shade100,
                                width: 1.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.02),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.access_time_filled_rounded,
                                  color: isSelected ? CustomColors.purpleColor : Colors.grey.shade400,
                                  size: 18.sp,
                                ),
                                SizedBox(width: 14.w),
                                Text(
                                  slot,
                                  style: isSelected
                                      ? CustomFonts.darkPurple12w600.copyWith(fontSize: 14.sp)
                                      : CustomFonts.black14w600.copyWith(color: Colors.grey.shade800),
                                ),
                                const Spacer(),
                                Container(
                                  height: 20.w,
                                  width: 20.w,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: isSelected ? CustomColors.purpleColor : Colors.grey.shade300,
                                      width: 2,
                                    ),
                                    color: isSelected ? CustomColors.purpleColor : Colors.transparent,
                                  ),
                                  child: isSelected
                                      ? const Center(
                                          child: Icon(Icons.check, size: 12, color: Colors.white),
                                        )
                                      : null,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            // Continuous Button to Review Checkout Screen
            Container(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 15,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: SizedBox(
                width: double.infinity,
                height: 52.h,
                child: ElevatedButton(
                  onPressed: canContinue
                      ? () {
                          // Save Selected parameters to checkout ViewModel
                          ref.read(checkoutViewModel.notifier).setSelectedDate(_selectedDate!);
                          ref.read(checkoutViewModel.notifier).setSelectedSlot(_selectedSlot!);

                          Navigator.pushNamed(
                            context,
                            ConsultationReviewScreen.routeName,
                          );
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    disabledBackgroundColor: Colors.grey.shade300,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(26.r),
                    ),
                    elevation: 2,
                  ),
                  child: Text(
                    "Continue to Review",
                    style: CustomFonts.white16w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
