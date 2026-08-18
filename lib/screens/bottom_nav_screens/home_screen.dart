import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../../main.dart';
import '../../models/responses/auth_response.dart';
import '../../utils/color_constant.dart';
import '../../utils/custom_fonts.dart';
import '../../view_models/auth_view_model.dart';
import '../../view_models/bottom_nav_view_model.dart';
import '../../widgets/app_bar_with_action_icon.dart';
import '../../widgets/appointment_card.dart';
import '../../widgets/discount_card.dart';
import '../../widgets/grey_container.dart';
import '../../widgets/heading_with_right_arrow.dart';
import '../../widgets/home_horizontal_sections.dart';
import '../../widgets/points_earn_card.dart';
import '../../widgets/requested_clinic_treatment_widget.dart';
import '../../widgets/treatment_container.dart';
import '../appointment_detail_screen.dart';
import '../journey_clinics_screen.dart';
import '../patient_treatment_requests_screen.dart';
import 'appointments_screen.dart';
import '../doctors_screen.dart';
import '../notification_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});
  static const String routeName = "HomeScreen";
  static final List<RequestClinicTreatmentModel> dummyTreatmentRequests = [
    RequestClinicTreatmentModel(
      id: 1,
      clinicName: 'Skin Care Clinic',
      clinicEmail: 'skincare@gmail.com',
      address: 'Beverly Hills, California',
      image: 'https://i.pravatar.cc/150?img=32',
      totalTreatmentCount: 5,
    ),
    RequestClinicTreatmentModel(
      id: 2,
      clinicName: 'Glow Aesthetic Center',
      clinicEmail: 'glowaesthetic@gmail.com',
      address: 'Beverly Hills, California',
      image: 'https://i.pravatar.cc/150?img=44',
      totalTreatmentCount: 3,
    ),
    RequestClinicTreatmentModel(
      id: 3,
      clinicName: 'Derma Wellness Clinic',
      clinicEmail: 'dermawellness@gmail.com',
      image: 'https://i.pravatar.cc/150?img=47',
      totalTreatmentCount: 8,
    ),
    RequestClinicTreatmentModel(
      id: 4,
      clinicName: 'Elite Skin & Laser',
      clinicEmail: 'eliteskin@gmail.com',
      address: '123 Wilshire Blvd, Beverly Hills, CA 90210',
      image: 'https://i.pravatar.cc/150?img=49',
      totalTreatmentCount: 2,
    ),
    RequestClinicTreatmentModel(
      id: 5,
      clinicName: 'Perfect Skin Clinic',
      clinicEmail: 'perfectskin@gmail.com',
      address: '123 Wilshire Blvd, Beverly Hills, CA 90210',
      image: 'https://i.pravatar.cc/150?img=12',
      totalTreatmentCount: 6,
    ),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Promotions are still static as no API endpoint provides them yet
    const int promotionsCount =
        0; // Set to 0 to show empty state if not available

    final authData = ref.watch(authViewModel).authData;
    final dashboard = authData?.dashboard;
    final appointments = dashboard?.appointments ?? [];

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBarWithActionIcon(
        action:
        !isDeploymentMode?
         GreyContainer(
          icon: Icons.notifications_none_outlined,
          onTap: () {
            Navigator.of(context).pushNamed(NotificationScreen.routeName);
          },
        ):null,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: context.h(22)),
              if (!isDeploymentMode)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: context.w(24)),
                  child: Column(
                    children: [
                      const PointsEarnCard(),
                      SizedBox(height: context.h(28)),
                      HeadingWithRightArrow(
                        title: "Upcoming Appointments",
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            AppointmentsScreen.routeName,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              if (!isDeploymentMode) SizedBox(height: context.h(16)),
              if (!isDeploymentMode)
                appointments.isEmpty
                    ? _buildHorizontalEmptyState(
                        context: context,
                        height: context.h(100),
                        icon: Icons.calendar_today_rounded,
                        title: "No Upcoming Appointments",
                        subtitle:
                            "Your scheduled clinical treatments and session details will appear here.",
                      )
                    : SizedBox(
                        height: context.h(300),
                        child: ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          padding: EdgeInsets.symmetric(
                            horizontal: context.w(24),
                          ),
                          scrollDirection: Axis.horizontal,
                          itemCount: appointments.length,
                          itemBuilder: (context, index) {
                            final appointment = appointments[index];

                            return Container(
                              width: 0.8.sw,
                              padding: EdgeInsets.only(
                                right: index == appointments.length - 1
                                    ? 0
                                    : context.w(12),
                              ),
                              child: AppointmentCard(
                                isTreatmentListHorizontal: true,
                                appointment: appointment,
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    AppointmentDetailScreen.routeName,
                                    arguments: appointment,
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      ),
              if (!isDeploymentMode) SizedBox(height: context.h(28)),

              // Suggested Treatments Section
              Padding(
                padding: EdgeInsets.symmetric(horizontal: context.w(24)),
                child: HeadingWithRightArrow(
                  title: "Suggested Treatments",
                  onTap: () {
                    ref.read(bottomNavViewModel.notifier).changePage(1);
                  },
                ),
              ),

              SizedBox(height: context.h(16)),

              SizedBox(
                height: context.h(180),
                child: Consumer(
                  builder: (context, ref, _) {
                    final suggestedTreatments =
                        dashboard?.suggestedTreatments ?? [];

                    if (suggestedTreatments.isEmpty) {
                      return _buildHorizontalEmptyState(
                        context: context,
                        height: context.h(100),
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
                            left: index == 0 ? context.w(24) : context.w(16),
                            right: index == suggestedTreatments.length - 1
                                ? context.w(24)
                                : context.w(0),
                          ),
                          child: TreatmentContainer(
                            imageHeight: context.h(145),
                            width: context.w(310),
                            treatments: suggestedTreatments[index],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              if (!isDeploymentMode) SizedBox(height: context.h(28)),

              // Top Doctors Section
              if (!isDeploymentMode)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: context.w(24)),
                  child: HeadingWithRightArrow(
                    title: "Top Doctors",
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        DoctorsScreen.routeName,
                        arguments: {'isFromHome': true},
                      );
                    },
                  ),
                ),
              if (!isDeploymentMode) SizedBox(height: context.h(16)),

              // Top Doctors Empty State Check
              if (!isDeploymentMode)
                (dashboard?.topDoctors?.isEmpty ?? true)
                    ? _buildHorizontalEmptyState(
                        context: context,
                        height: context.h(100),
                        icon: Icons.badge_outlined,
                        title: "No Specialists Available",
                        subtitle:
                            "Specialist dermatologists and clinical practitioners will be listed here soon.",
                      )
                    : SizedBox(
                        height: context.h(220),
                        child: ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          padding: EdgeInsets.symmetric(
                            horizontal: context.w(24),
                          ),
                          scrollDirection: Axis.horizontal,
                          itemCount: dashboard!.topDoctors!.length,
                          itemBuilder: (context, index) =>
                              DashboardDoctorHomeCard(
                                doctor: dashboard.topDoctors![index],
                              ),
                        ),
                      ),
              SizedBox(height: context.h(28)),

              // Top Clinics Section
              Padding(
                padding: EdgeInsets.symmetric(horizontal: context.w(24)),
                child: HeadingWithRightArrow(
                  title: "Top Clinics",
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      JourneyClinicsScreen.routeName,
                    );
                  },
                ),
              ),

              SizedBox(height: context.h(16)),

              // Top Clinics Empty State Check
              (dashboard?.topClinics?.isEmpty ?? true)
                  ? _buildHorizontalEmptyState(
                      context: context,
                      height: context.h(100),
                      icon: Icons.storefront_rounded,
                      title: "No Clinics Available",
                      subtitle:
                          "Top-rated aesthetic clinics and wellness spas will be listed here soon.",
                    )
                  : SizedBox(
                      height: context.h(200),
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        padding: EdgeInsets.symmetric(
                          horizontal: context.w(24),
                        ),
                        scrollDirection: Axis.horizontal,
                        itemCount: dashboard!.topClinics!.length,
                        itemBuilder: (context, index) =>
                            DashboardClinicHomeCard(
                              clinic: dashboard.topClinics![index],
                            ),
                      ),
                    ),
              SizedBox(height: context.h(28)),
            
             
              // Shared Treatment Requests Section
              Padding(
                padding: EdgeInsets.symmetric(horizontal: context.w(24)),
                child: HeadingWithRightArrow(
                  title: "Shared Treatment Requests",
                  onTap: () {
                    final clinicId = dashboard?.requestTreatmentClinic?.firstOrNull?.id;
                    if (clinicId != null) {
                      Navigator.pushNamed(
                        context,
                        PatientTreatmentRequestsScreen.routeName,
                        arguments: clinicId,
                      );
                    }
                  },
                ),
              ),

              SizedBox(height: context.h(16)),

              // Shared Treatment Requests Empty State Check
              (dashboard?.requestTreatmentClinic?.isEmpty ?? true)
                  ? _buildHorizontalEmptyState(
                      context: context,
                      height: context.h(100),
                      icon: Icons.request_page_outlined,
                      title: "No Shared Treatment Requests",
                      subtitle:
                          "Shared treatment requests will appear here.",
                    )
                  : SizedBox(
                      height: context.h(150),
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        padding: EdgeInsets.symmetric(horizontal: context.w(24)),
                        scrollDirection: Axis.horizontal,
                        itemCount: dashboard!.requestTreatmentClinic!.length,
                        itemBuilder: (context, index) {
                          final request = dashboard.requestTreatmentClinic![index];

                          return Padding(
                            padding: EdgeInsets.only(
                              right: index == dashboard.requestTreatmentClinic!.length - 1
                                  ? 0
                                  : context.w(12),
                            ),
                            child: RequestClinicTreatmentCard(
                              data: request,
                              onTap: () {
                                if (request.id != null) {
                                  Navigator.pushNamed(
                                    context,
                                    PatientTreatmentRequestsScreen.routeName,
                                    arguments: request.id,
                                  );
                                }
                              },
                            ),
                          );
                        },
                      ),
                    ),
              SizedBox(height: context.h(28)),
              SizedBox(height: context.h(28)),

              // Promotions & Discounts Section
              if (!isDeploymentMode)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: context.w(24)),
                  child: Text(
                    "Promotions & Discounts",
                    style: CustomFonts.black22w600,
                  ),
                ),
              if (!isDeploymentMode) SizedBox(height: context.h(16)),

              // Promotions Empty State Check
              if (!isDeploymentMode)
                promotionsCount == 0
                    ? _buildHorizontalEmptyState(
                        context: context,
                        height: context.h(100),
                        icon: Icons.local_offer_outlined,
                        title: "No Promotions Available",
                        subtitle:
                            "Exclusive clinical deals, seasonal discounts, and special offers are on their way.",
                      )
                    : SizedBox(
                        height: context.h(144),
                        child: ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: promotionsCount,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.only(
                                left: index == 0
                                    ? context.w(24)
                                    : context.w(16),
                                right: index == promotionsCount - 1
                                    ? context.w(24)
                                    : context.w(0),
                              ),
                              child: const DiscountCard(),
                            );
                          },
                        ),
                      ),
              SizedBox(height: context.h(100)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHorizontalEmptyState({
    required BuildContext context,
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
      padding: EdgeInsets.symmetric(horizontal: context.w(24)),
      child: Container(
        height: height,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(context.r(24)),
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
          borderRadius: BorderRadius.circular(context.r(22)),
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
                padding: EdgeInsets.symmetric(
                  horizontal: context.w(16),
                  vertical: context.h(12),
                ),
                child: Row(
                  children: [
                    // Glowing semi-transparent white circular badge icon
                    Container(
                      height: context.w(48),
                      width: context.w(48),
                      decoration: BoxDecoration(
                        color: CustomColors.purpleColor.withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: CustomColors.purpleColor.withValues(
                            alpha: 0.15,
                          ),
                          width: context.w(1),
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          icon,
                          color: CustomColors.purpleColor,
                          size: context.sp(22),
                        ),
                      ),
                    ),
                    SizedBox(width: context.w(14)),
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
                          SizedBox(height: context.h(4)),
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
