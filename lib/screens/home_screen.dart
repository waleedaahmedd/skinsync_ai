import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skinsync_ai/widgets/app_bar_with_action_icon.dart';
import 'package:skinsync_ai/utills/custom_fonts.dart';
import 'package:skinsync_ai/widgets/appointment_card.dart';
import 'package:skinsync_ai/widgets/discount_card.dart';
import 'package:skinsync_ai/widgets/grey_container.dart';
import 'package:skinsync_ai/widgets/heading_with_right_arrow.dart';
import 'package:skinsync_ai/widgets/home_treament_card.dart';
import 'package:skinsync_ai/widgets/points_earn_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  static const String routeName = "HomeScreen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWithActionIcon(
        title: Text("Hello, Burak!", style: CustomFonts.black30w600),
        subTitle: Text(
          "Your journey to radiant skin starts now.",
          style: CustomFonts.grey18w400,
        ),
        action: GreyContainer(
          icon: Icons.notifications_none_outlined,
          onTap: () {},
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
                        onTap: () {},
                      ),
                      SizedBox(height: 18.h),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 200.h,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: 4,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(left: index == 0 ? 30.w : 17.w),
                    child: HomeTreamentCard(),
                  );
                },
              ),
            ),
            SizedBox(height: 18.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.w),
              child: Text(
                "promotions & discounts",
                style: CustomFonts.black22w600,
              ),
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
                    child: DiscountCard(),
                  );
                },
              ),
            ),
            SizedBox(height: 185.h),
          ],
        ),
      ),
    );
  }
}
