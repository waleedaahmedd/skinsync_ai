import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../models/dummy_list_model.dart';
import 'doctors_listing_screen.dart';
import 'explore_clinics_screen.dart';
import '../view_models/bottom_nav_view_model.dart';
import '../widgets/home_horizontal_sections.dart';

import '../utills/custom_fonts.dart';
import '../view_models/auth_view_model.dart';
import '../widgets/app_bar_with_action_icon.dart';
import '../widgets/discount_card.dart';
import '../widgets/grey_container.dart';
import '../widgets/heading_with_right_arrow.dart';
import '../widgets/points_earn_card.dart';
import '../widgets/treatment_container.dart';
import 'notification_screen.dart';
import 'suggested_treatmentsScreen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});
  static const String routeName = "HomeScreen";

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 22.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.w),
              child: Column(
                children: [
                  const PointsEarnCard(),
                  SizedBox(height: 30.h),
                  HeadingWithRightArrow(
                    title: "Upcoming Appointments",
                    onTap: () {
                      ref.read(bottomNavViewModel.notifier).changePage(2);
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 18.h),
            SizedBox(
              height: 185.h,
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 30.w),
                scrollDirection: Axis.horizontal,
                itemCount: 3, // 3 Date Sections
                itemBuilder: (context, dateIndex) {
                  // Mock grouping logic for the demo
                  final dates = ["12 May 2026", "15 May 2026", "20 May 2026"];
                  final startIndex = dateIndex * 2;
                  final dateAppointments = dummyAppointments.skip(startIndex).take(2).toList();

                  return UpcomingAppointmentDateSection(
                    dateTitle: dates[dateIndex],
                    appointments: dateAppointments,
                  );
                },
              ),
            ),
            SizedBox(height: 30.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.w),
              child: HeadingWithRightArrow(
                title: "Suggested Treatments",
                onTap: () {
                  Navigator.pushNamed(context, SuggestedTreatmentScreen.routeName);
                },
              ),
            ),
            SizedBox(height: 18.h),
            SizedBox(
              height: 270.w,
              child: Consumer(
                builder: (context, ref, _) {
                  final treatment = ref.watch(authViewModel).authResponse?.data?.treatment;
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: treatment?.length ?? 0,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.only(
                          left: index == 0 ? 30.w : 17.w,
                          right: index == (treatment?.length ?? 0) - 1 ? 30.w : 0.w,
                        ),
                        child: TreatmentContainer(
                          imageHeight: 150.h,
                          width: 313.w,
                          treatments: treatment![index],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            SizedBox(height: 30.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.w),
              child: HeadingWithRightArrow(
                title: "Top Doctors",
                onTap: () {
                  Navigator.pushNamed(context, DoctorsListingScreen.routeName);
                },
              ),
            ),
            SizedBox(height: 18.h),
            SizedBox(
              height: 200.h,
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 30.w),
                scrollDirection: Axis.horizontal,
                itemCount: dummyDoctors.length,
                itemBuilder: (context, index) => DoctorHomeCard(doctor: dummyDoctors[index]),
              ),
            ),
            SizedBox(height: 30.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.w),
              child: HeadingWithRightArrow(
                title: "Top Clinics",
                onTap: () {
                  Navigator.pushNamed(context, ExploreClinicsScreen.routeName);
                },
              ),
            ),
            SizedBox(height: 18.h),
            SizedBox(
              height: 190.h,
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 30.w),
                scrollDirection: Axis.horizontal,
                itemCount: topClinics.length,
                itemBuilder: (context, index) => ClinicHomeCard(clinic: topClinics[index]),
              ),
            ),
            SizedBox(height: 30.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.w),
              child: Text("Promotions & Discounts", style: CustomFonts.black22w600),
            ),
            SizedBox(height: 18.h),
            SizedBox(
              height: 144.h,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: 4,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(left: index == 0 ? 30.w : 17.w),
                    child: const DiscountCard(),
                  );
                },
              ),
            ),
            SizedBox(height: 120.h),
          ],
        ),
      ),
    );
  }
}

