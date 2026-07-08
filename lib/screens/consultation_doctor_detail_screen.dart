import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skinsync_ai/models/dummy_list_model.dart';
import 'package:skinsync_ai/utills/color_constant.dart';
import 'package:skinsync_ai/utills/custom_fonts.dart';
import 'package:skinsync_ai/widgets/custom_app_bar.dart';
import 'package:skinsync_ai/view_models/checkout_view_model.dart';
import 'select_date_time_screen.dart';
import 'consultation_review_screen.dart';

class ConsultationDoctorDetailScreen extends ConsumerWidget {
  static const routeName = '/consultation_doctor_detail_screen';
  final DummyDoctor doctor;

  const ConsultationDoctorDetailScreen({
    super.key,
    required this.doctor,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final checkoutState = ref.watch(checkoutViewModel);
    final bool hasDateTime = checkoutState.selectedDate != null && checkoutState.selectedSlot != null;

    return Scaffold(
      backgroundColor: CustomColors.whiteColor,
      appBar: const CustomAppBar(showTitle: true, title: "Specialist Profile"),
      body: Container(
        decoration: const BoxDecoration(
          gradient: CustomColors.whiteBlueGradient,
        ),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Doctor Profile Card with large image
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 15,
                            offset: const Offset(0, 6),
                          ),
                        ],
                        border: Border.all(
                          color: CustomColors.greyColor.withValues(alpha: 0.5),
                        ),
                      ),
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
                            child: CachedNetworkImage(
                              imageUrl: doctor.image,
                              height: 200.h,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(
                                color: Colors.grey.shade50,
                                child: const Center(child: CupertinoActivityIndicator()),
                              ),
                              errorWidget: (context, url, error) => Container(
                                color: Colors.grey.shade50,
                                child: const Icon(Icons.person, size: 50, color: Colors.grey),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(18.w),
                            child: Column(
                              children: [
                                Text(
                                  doctor.name,
                                  style: CustomFonts.black22w600,
                                ),
                                SizedBox(height: 6.h),
                                Text(
                                  doctor.specialization,
                                  style: CustomFonts.grey14w400.copyWith(color: CustomColors.pinkColor, fontWeight: FontWeight.w600),
                                ),
                                SizedBox(height: 10.h),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.star_rounded, color: Colors.amber, size: 20),
                                    SizedBox(width: 4.w),
                                    Text(
                                      doctor.rating.toString(),
                                      style: CustomFonts.black14w600,
                                    ),
                                    SizedBox(width: 16.w),
                                    Container(
                                      width: 1.w,
                                      height: 16.h,
                                      color: Colors.grey.shade300,
                                    ),
                                    SizedBox(width: 16.w),
                                    const Icon(Icons.verified_user_rounded, color: CustomColors.blueColor, size: 18),
                                    SizedBox(width: 4.w),
                                    Text(
                                      "Board Certified",
                                      style: CustomFonts.grey12w400.copyWith(fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24.h),

                    // Biography Section
                    Text("About Specialist", style: CustomFonts.black18w600),
                    SizedBox(height: 10.h),
                    Text(
                      "${doctor.name} is a highly qualified specialist in clinical dermatology and non-surgical facial enhancements. With over 12 years of hands-on experience and continuous contribution to aesthetic research, they provide bespoke luxury care using state-of-the-art diagnostic algorithms and premium injection materials.",
                      style: CustomFonts.textGrey14w400,
                    ),
                    SizedBox(height: 20.h),

                    // Professional Qualifications Card
                    Text("Qualifications", style: CustomFonts.black18w600),
                    SizedBox(height: 10.h),
                    _buildQualificationItem(Icons.school_rounded, "MD in Aesthetic & Clinical Dermatology", "Stanford University School of Medicine"),
                    _buildQualificationItem(Icons.workspace_premium_rounded, "Board of Facial Plastic & Reconstructive Surgery", "Active Premium Member"),
                    _buildQualificationItem(Icons.business_center_rounded, "Resident MedSpa Physician Specialist", doctor.clinicName),
                  ],
                ),
              ),
            ),

            // Premium Floating Booking Button Container
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
                  onPressed: () {
                    if (hasDateTime) {
                      Navigator.pushNamed(
                        context,
                        ConsultationReviewScreen.routeName,
                      );
                    } else {
                      Navigator.pushNamed(
                        context,
                        SelectDateTimeScreen.routeName,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(26.r),
                    ),
                    elevation: 2,
                  ),
                  child: Text(
                    hasDateTime ? "Review Consultation Booking" : "Select Date & Time Slot",
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

  Widget _buildQualificationItem(IconData icon, String title, String subtitle) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: CustomColors.lightPurpleColor.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: CustomColors.purpleColor, size: 20.sp),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: CustomFonts.black13w600),
                SizedBox(height: 2.h),
                Text(subtitle, style: CustomFonts.grey12w400),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
