import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../models/responses/auth_response.dart';
import '../../utills/color_constant.dart';
import '../../utills/custom_fonts.dart';
import '../../utills/date_time_utills.dart';
import '../../view_models/auth_view_model.dart';
import '../../view_models/bottom_nav_view_model.dart';
import '../../widgets/app_bar_with_action_icon.dart';
import '../../widgets/discount_card.dart';
import '../../widgets/grey_container.dart';
import '../../widgets/heading_with_right_arrow.dart';
import '../../widgets/home_horizontal_sections.dart';
import '../../widgets/points_earn_card.dart';
import '../../widgets/treatment_container.dart';
import '../doctors_listing_screen.dart';
import '../explore_clinics_screen.dart';
import '../notification_screen.dart';
import '../suggested_treatmentsScreen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});
  static const String routeName = "HomeScreen";

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Promotions are still static as no API endpoint provides them yet
    const int promotionsCount = 0; // Set to 0 to show empty state if not available

    final authData = ref.watch(authViewModel).authData;
    final dashboard = authData?.dashboard;
    final appointments = dashboard?.appointments ?? [];

    // Group appointments by date
    final Map<String, List<DashboardAppointment>> groupedAppointments = {};
    for (var appt in appointments) {
      if (appt.date != null) {
        final dateKey = DateTimeUtils.formatTimestamp(appt.date!);
        groupedAppointments.putIfAbsent(dateKey, () => []).add(appt);
      }
    }
    final sortedDateKeys = groupedAppointments.keys.toList();

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBarWithActionIcon(
        action: GreyContainer(
          icon: Icons.notifications_none_outlined,
          onTap: () {
            Navigator.of(context).pushNamed(NotificationScreen.routeName);
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 22.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  children: [
                    const PointsEarnCard(),
                    SizedBox(height: 28.h),
                    HeadingWithRightArrow(
                      title: "Upcoming Appointments",
                      onTap: () {
                        ref.read(bottomNavViewModel.notifier).changePage(2);
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.h),

              // Upcoming Appointments Empty State Check
              appointments.isEmpty
                  ? _buildHorizontalEmptyState(
                      height: 100.h,
                      icon: Icons.calendar_today_rounded,
                      title: "No Upcoming Appointments",
                      subtitle:
                          "Your scheduled clinical treatments and session details will appear here.",
                    )
                  : SizedBox(
                      height: 195.h,
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        padding: EdgeInsets.symmetric(horizontal: 24.w),
                        scrollDirection: Axis.horizontal,
                        itemCount: sortedDateKeys.length,
                        itemBuilder: (context, dateIndex) {
                          final dateTitle = sortedDateKeys[dateIndex];
                          final dateAppointments =
                              groupedAppointments[dateTitle]!;

                          return DashboardAppointmentDateSection(
                            dateTitle: dateTitle,
                            appointments: dateAppointments,
                          );
                        },
                      ),
                    ),
              SizedBox(height: 28.h),

              // Suggested Treatments Section
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: HeadingWithRightArrow(
                  title: "Suggested Treatments",
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      SuggestedTreatmentScreen.routeName,
                    );
                  },
                ),
              ),
              SizedBox(height: 16.h),
              SizedBox(
                height: 180.h,
                child: Consumer(
                  builder: (context, ref, _) {
                    final suggestedTreatments =
                        dashboard?.suggestedTreatments ?? [];

                    if (suggestedTreatments.isEmpty) {
                      return _buildHorizontalEmptyState(
                        height: 100.h,
                        icon: Icons.auto_awesome_rounded,
                        title: "No Suggested Treatments",
                        subtitle:
                            "Complete your facial AI scan to receive personalized clinical suggestions.",
                      );
                    }

                    return ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: suggestedTreatments.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.only(
                            left: index == 0 ? 24.w : 16.w,
                            right:
                                index == suggestedTreatments.length - 1
                                    ? 24.w
                                    : 0.w,
                          ),
                          child: TreatmentContainer(
                            imageHeight: 145.h,
                            width: 310.w,
                            treatments: suggestedTreatments[index],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              SizedBox(height: 28.h),

              // Top Doctors Section
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: HeadingWithRightArrow(
                  title: "Top Doctors",
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      DoctorsListingScreen.routeName,
                    );
                  },
                ),
              ),
              SizedBox(height: 16.h),

              // Top Doctors Empty State Check
              (dashboard?.topDoctors?.isEmpty ?? true)
                  ? _buildHorizontalEmptyState(
                      height: 100.h,
                      icon: Icons.badge_outlined,
                      title: "No Specialists Available",
                      subtitle:
                          "Specialist dermatologists and clinical practitioners will be listed here soon.",
                    )
                  : SizedBox(
                      height: 190.h,
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        padding: EdgeInsets.symmetric(horizontal: 24.w),
                        scrollDirection: Axis.horizontal,
                        itemCount: dashboard!.topDoctors!.length,
                        itemBuilder: (context, index) => DashboardDoctorHomeCard(
                          doctor: dashboard.topDoctors![index],
                        ),
                      ),
                    ),
              SizedBox(height: 28.h),

              // Top Clinics Section
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: HeadingWithRightArrow(
                  title: "Top Clinics",
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      ExploreClinicsScreen.routeName,
                    );
                  },
                ),
              ),
              SizedBox(height: 16.h),

              // Top Clinics Empty State Check
              (dashboard?.topClinics?.isEmpty ?? true)
                  ? _buildHorizontalEmptyState(
                      height: 100.h,
                      icon: Icons.storefront_rounded,
                      title: "No Clinics Available",
                      subtitle:
                          "Top-rated aesthetic clinics and wellness spas will be listed here soon.",
                    )
                  : SizedBox(
                      height: 180.h,
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        padding: EdgeInsets.symmetric(horizontal: 24.w),
                        scrollDirection: Axis.horizontal,
                        itemCount: dashboard!.topClinics!.length,
                        itemBuilder: (context, index) => DashboardClinicHomeCard(
                          clinic: dashboard.topClinics![index],
                        ),
                      ),
                    ),
              SizedBox(height: 28.h),

              // Promotions & Discounts Section
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Text(
                  "Promotions & Discounts",
                  style: CustomFonts.black22w600,
                ),
              ),
              SizedBox(height: 16.h),

              // Promotions Empty State Check
              promotionsCount == 0
                  ? _buildHorizontalEmptyState(
                      height: 100.h,
                      icon: Icons.local_offer_outlined,
                      title: "No Promotions Available",
                      subtitle:
                          "Exclusive clinical deals, seasonal discounts, and special offers are on their way.",
                    )
                  : SizedBox(
                      height: 144.h,
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: promotionsCount,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.only(
                              left: index == 0 ? 24.w : 16.w,
                              right: index == promotionsCount - 1 ? 24.w : 0.w,
                            ),
                            child: const DiscountCard(),
                          );
                        },
                      ),
                    ),
              SizedBox(height: 100.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHorizontalEmptyState({
    required double height,
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    const myLocalGradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [CustomColors.lightPurpleColor, CustomColors.purpleColor],
    );

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Container(
        height: height,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24.r),
          gradient: myLocalGradient, // Solid brand gradient background
          border: Border.all(
            color: CustomColors.lightPurpleColor.withValues(alpha: 0.4),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22.r),
          child: Stack(
            children: [
              // 1. Translucent White Mask Tint Overlay
              Positioned.fill(
                child: Container(
                  color: Colors.white.withValues(
                    alpha: 0.85,
                  ), // Translucent premium white mask
                ),
              ),

              // 2. High-Contrast Content Layer (Sizes the parent container)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                child: Row(
                  children: [
                    // Glowing semi-transparent white circular badge icon
                    Container(
                      height: 48.w,
                      width: 48.w,
                      decoration: BoxDecoration(
                        color: CustomColors.purpleColor.withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: CustomColors.purpleColor.withValues(
                            alpha: 0.15,
                          ),
                          width: 1.w,
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          icon,
                          color: CustomColors.purpleColor,
                          size: 22.sp,
                        ),
                      ),
                    ),
                    SizedBox(width: 14.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            title,
                            style: CustomFonts.black14w700,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            subtitle,
                            style: CustomFonts.textGrey13w400,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
