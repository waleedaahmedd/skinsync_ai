import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../models/responses/get_clinic_response.dart';
import '../utills/color_constant.dart';
import '../utills/custom_fonts.dart';
import '../view_models/checkout_view_model.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_button.dart';
import 'payment_screen.dart';

class ReviewScreen extends ConsumerWidget {
  static const routeName = '/review_screen';
  final Clinic clinic;

  const ReviewScreen({super.key, required this.clinic});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final checkoutState = ref.watch(checkoutViewModel);

    // final clinic = checkoutState.selectedClinic;
    final doctor = checkoutState.selectedDoctor;
    final date = checkoutState.selectedDate;
    final slot = checkoutState.selectedSlot;

    // Standard high-end mock consultation price
    const double consultationFee = 150.00;

    return Scaffold(
      backgroundColor: CustomColors.whiteColor,
      appBar: const CustomAppBar(showTitle: true, title: "Review Booking"),
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
                    Text("Appointment Summary", style: CustomFonts.black16w600),
                    SizedBox(height: 16.h),

                    // 1. Doctor & Specialization Details
                    if (doctor != null) ...[
                      Container(
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20.r),
                          border: Border.all(color: Colors.grey.shade100),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.02),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12.r),
                              child: CachedNetworkImage(
                                imageUrl: doctor.image,
                                height: 60.w,
                                width: 60.w,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Container(
                                  color: Colors.grey.shade50,
                                  child: const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                ),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.person),
                              ),
                            ),
                            SizedBox(width: 16.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    doctor.name,
                                    style: CustomFonts.black14w600,
                                  ),
                                  SizedBox(height: 4.h),
                                  Text(
                                    doctor.specialization,
                                    style: CustomFonts.grey12w400,
                                  ),
                                  SizedBox(height: 4.h),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.star_rounded,
                                        color: Colors.amber,
                                        size: 14,
                                      ),
                                      SizedBox(width: 2.w),
                                      Text(
                                        doctor.rating.toString(),
                                        style: CustomFonts.black10w600,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16.h),
                    ],

                    // 2. Clinic Details
                    Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(color: Colors.grey.shade100),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(8.w),
                            decoration: BoxDecoration(
                              color: CustomColors.lightPurpleColor.withValues(
                                alpha: 0.1,
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.business_rounded,
                              color: CustomColors.purpleColor,
                            ),
                          ),
                          SizedBox(width: 16.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  clinic.name ?? "Standard Clinic Name",
                                  style: CustomFonts.black14w600,
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  clinic.address ?? "Standard Clinic Location",
                                  style: CustomFonts.grey12w400,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16.h),

                    // 3. Appointment Date & Slot
                    Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(color: Colors.grey.shade100),
                      ),
                      child: Column(
                        children: [
                          _buildSummaryRow(
                            Icons.calendar_today_rounded,
                            "Date",
                            date != null
                                ? DateFormat('EEEE, MMM dd, yyyy').format(date)
                                : "Not Selected",
                          ),
                          const Divider(height: 24),
                          _buildSummaryRow(
                            Icons.access_time_rounded,
                            "Time Slot",
                            slot ?? "Not Selected",
                          ),
                          const Divider(height: 24),
                          _buildSummaryRow(
                            Icons.medical_services_outlined,
                            "Appointment Type",
                            checkoutState.selectedAppointmentType?.title ??
                                "Not Selected",
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24.h),

                    // Selected Treatments & Areas Section
                    if (checkoutState.checkoutTreatmentsList.isNotEmpty) ...[
                      Text(
                        "Selected Treatments & Areas",
                        style: CustomFonts.black16w600,
                      ),
                      SizedBox(height: 16.h),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24.r),
                          border: Border.all(color: Colors.grey.shade100),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.02),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ...checkoutState.checkoutTreatmentsList.asMap().entries.map((entry) {
                              final index = entry.key;
                              final selection = entry.value;
                              final isLast = index == checkoutState.checkoutTreatmentsList.length - 1;

                              final materialInfo = selection.materials.isNotEmpty
                                  ? " (${selection.materials.map((m) => '${m.selectedQuantity} ${m.name}').join(', ')})"
                                  : "";

                              return Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(vertical: 4.h),
                                    child: Row(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.all(10.w),
                                          decoration: BoxDecoration(
                                            color: CustomColors.purpleColor.withValues(alpha: 0.08),
                                            borderRadius: BorderRadius.circular(14.r),
                                          ),
                                          child: Icon(
                                            Icons.auto_awesome_rounded,
                                            color: CustomColors.purpleColor,
                                            size: 18.sp,
                                          ),
                                        ),
                                        SizedBox(width: 16.w),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                selection.treatmentName ?? "Treatment",
                                                style: CustomFonts.black14w600,
                                              ),
                                              SizedBox(height: 2.h),
                                              Text(
                                                "${selection.areaName ?? "Target Area"}$materialInfo",
                                                style: CustomFonts.grey12w400.copyWith(
                                                  color: CustomColors.darkPurple,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (!isLast)
                                    Padding(
                                      padding: EdgeInsets.only(left: 52.w),
                                      child: Divider(
                                        height: 20.h,
                                        thickness: 1,
                                        color: Colors.grey.shade50,
                                      ),
                                    ),
                                ],
                              );
                            }),
                          ],
                        ),
                      ),
                      SizedBox(height: 24.h),
                    ],

                    // 4. Pricing Details Section
                    Text("Payment Summary", style: CustomFonts.black16w600),
                    SizedBox(height: 16.h),
                    Container(
                      padding: EdgeInsets.all(18.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(color: Colors.grey.shade100),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Consultation standard fee",
                                style: CustomFonts.grey14w400,
                              ),
                              Text(
                                "\$${consultationFee.toStringAsFixed(2)}",
                                style: CustomFonts.black14w600,
                              ),
                            ],
                          ),
                          const Divider(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Total booking price",
                                style: CustomFonts.black16w600,
                              ),
                              Text(
                                "\$${consultationFee.toStringAsFixed(2)}",
                                style: CustomFonts.black16w600.copyWith(
                                  color: CustomColors.pinkColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Continuous to payments selection screen using CustomButton
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
              child: CustomButton(
                text: "Proceed to Payment",
                borderRadius: 26.r,
                backgroundColor: Colors.black,
                textColor: Colors.white,
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    PaymentScreen.routeName,
                    arguments: clinic,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey.shade400, size: 20.sp),
        SizedBox(width: 12.w),
        Text(label, style: CustomFonts.grey13w400),
        const Spacer(),
        Text(value, style: CustomFonts.black14w600),
      ],
    );
  }
}
