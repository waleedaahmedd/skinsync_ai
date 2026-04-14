import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../view_models/auth_view_model.dart';
import '../widgets/app_bar_with_action_icon.dart';
import '../widgets/appointment_card.dart';
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
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30.w),
                  child: Column(
                    children: [
                      PointsEarnCard(),
                      SizedBox(height: 30.h),
                      HeadingWithRightArrow(
                        title: "Your Next Appointment",
                        onTap: () {},
                      ),
                      SizedBox(height: 18.h),
                      AppointmentCard(),
                      SizedBox(height: 25.h),
                      HeadingWithRightArrow(
                        title: "Suggested Treatments",
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            SuggestedTreatmentScreen.routeName,
                          );
                        },
                      ),
                      SizedBox(height: 18.h),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 300.h,

              child: Consumer(
                builder: (context, ref, _) {
                  final treatment = ref
                      .watch(authViewModel)
                      .authResponse
                      ?.data
                      ?.treatment;
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: treatment?.length ?? 0,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.only(
                          left: index == 0 ? 30.w : 17.w,
                          right: index == treatment!.length - 1 ? 30.w : 0.w,
                        ),
                        child: TreatmentContainer(
                          imageHeight: 150,
                          width: 313.w,
                          treatments: treatment[index],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            // SizedBox(height: 18.h),
            // Padding(
            //   padding: EdgeInsets.symmetric(horizontal: 30.w),
            //   child: Text(
            //     "promotions & discounts",
            //     style: CustomFonts.black22w600,
            //   ),
            // ),
            // SizedBox(height: 18.h),
            // SizedBox(
            //   height: 144.h,
            //   child: ListView.builder(
            //     shrinkWrap: true,
            //     itemCount: 4,
            //     scrollDirection: Axis.horizontal,
            //     itemBuilder: (context, index) {
            //       return Padding(
            //         padding: EdgeInsets.only(left: index == 0 ? 30.w : 17.w),
            //         child: DiscountCard(),
            //       );
            //     },
            //   ),
            // ),
            SizedBox(height: 185.h),
          ],
        ),
      ),
    );
  }
}
