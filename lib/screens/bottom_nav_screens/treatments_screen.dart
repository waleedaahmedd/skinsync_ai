import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:skinsync_ai/screens/treament_list_screen.dart';
import 'package:skinsync_ai/utills/assets.dart';
import 'package:skinsync_ai/utills/custom_fonts.dart';
import 'package:skinsync_ai/view_models/treatment_view_model.dart';
import 'package:skinsync_ai/widgets/app_bar_with_action_icon.dart';
import 'package:skinsync_ai/widgets/fillter_container.dart';
import 'package:skinsync_ai/widgets/heading_with_right_arrow.dart';
import 'package:skinsync_ai/widgets/recommended_treatment_container.dart';
import 'package:skinsync_ai/widgets/treatment_container.dart';

import '../../widgets/grey_container.dart';

class TreatmentsScreen extends StatelessWidget {
  const TreatmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWithActionIcon(
        title: Row(
          children: [
            Icon(Iconsax.location, size: 20.sp, color: Colors.black),
            SizedBox(width: 6.w),
            Text("Hello, Burak!", style: CustomFonts.black30w600),
          ],
        ),
        subTitle: Text(
          "195 Karlie Brooks, Anderson",
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
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 15.h),
                  TextField(
                    style: CustomFonts.black18w400,

                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      hintText: "Search  doctor, injector, treatment & clinic",
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 15.h),
            Consumer(
              builder: (context, ref, _) {
                return ref.watch(treatmentViewModel)
                    ? TreatmentMainScreen()
                    : TreamentListScreen();
              },
            ),
            SizedBox(height: 170.h),
          ],
        ),
      ),
    );
  }
}

class TreatmentMainScreen extends StatefulWidget {
  const TreatmentMainScreen({super.key});

  @override
  State<TreatmentMainScreen> createState() => _TreatmentMainScreenState();
}

int selectedFilterIndex = 0;
List<Fillter> fillter = [
  Fillter(title: "All Treatment"),
  Fillter(title: "Injectables & Fillers ", svg: SvgAssets.treatment),
  Fillter(title: "Laser Treatments", svg: SvgAssets.treatment),
  Fillter(title: "Sculpting & Contouring", svg: SvgAssets.treatment),
];

class _TreatmentMainScreenState extends State<TreatmentMainScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (_, ref, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 50.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: fillter.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(
                      left: index == 0 ? 30.w : 0,
                      right: 10.w,
                    ),
                    child: FillterContainer(
                      isSelected: selectedFilterIndex == index,
                      title: fillter[index].title,
                      svgImage: fillter[index].svg,
                      onTap: () {
                        setState(() {
                          selectedFilterIndex = index;
                        });
                      },
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 32.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.0.w),
              child: Text(
                "Recommended Treatments",
                style: CustomFonts.black24w600,
              ),
            ),
            SizedBox(
              height: 352.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: fillter.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(
                      left: index == 0 ? 30.w : 0,
                      right: 20.w,
                      top: 28.h,
                      bottom: 25.h,
                    ),
                    child: RecommendedTreatmentContainer(
                      treatmentImage: PngAssets.laserTreatment,
                      treatmentName: "Laser Treatment",
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 25.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.w),
              child: HeadingWithRightArrow(
                title: "Skincare & Facial Treatments",
                onTap: () {
                  ref
                      .read(treatmentViewModel.notifier)
                      .setTreatmentMainScreen(value: false);
                },
              ),
            ),
            SizedBox(height: 13.h),
            SizedBox(
              height: 221.h,

              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 4,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(
                      left: index == 0 ? 30.w : 0,
                      right: 12.w,
                    ),
                    child: TreatmentContainer(
                      treatmentName: "Botox Treatment",
                      clinicName: "Glow Skin Clinic",
                      dateTime: "October 20, 3:00 PM",
                      treatmentimage: DummyAssets.treatmentimage,
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 25.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.w),
              child: HeadingWithRightArrow(
                title: "Injectables & Fillers ",
                onTap: () {
                  ref
                      .read(treatmentViewModel.notifier)
                      .setTreatmentMainScreen(value: false);
                },
              ),
            ),
            SizedBox(height: 13.h),
            SizedBox(
              height: 221.h,

              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 4,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(
                      left: index == 0 ? 30.w : 0,
                      right: 12.w,
                    ),
                    child: TreatmentContainer(
                      treatmentName: "Botox Treatment",
                      clinicName: "Glow Skin Clinic",
                      dateTime: "October 20, 3:00 PM",
                      treatmentimage: DummyAssets.treatmentimage,
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 25.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.w),
              child: HeadingWithRightArrow(
                title: "Laser Treatments",
                onTap: () {
                  ref
                      .read(treatmentViewModel.notifier)
                      .setTreatmentMainScreen(value: false);
                },
              ),
            ),
            SizedBox(height: 13.h),
            SizedBox(
              height: 221.h,

              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 4,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(
                      left: index == 0 ? 30.w : 0,
                      right: 12.w,
                    ),
                    child: TreatmentContainer(
                      treatmentName: "Botox Treatment",
                      clinicName: "Glow Skin Clinic",
                      dateTime: "October 20, 3:00 PM",
                      treatmentimage: DummyAssets.treatmentimage,
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 25.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.w),
              child: HeadingWithRightArrow(
                title: "Sculpting & Contouring",
                onTap: () {
                  ref
                      .read(treatmentViewModel.notifier)
                      .setTreatmentMainScreen(value: false);
                },
              ),
            ),
            SizedBox(height: 13.h),
            SizedBox(
              height: 221.h,

              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 4,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(
                      left: index == 0 ? 30.w : 0,
                      right: 12.w,
                    ),
                    child: TreatmentContainer(
                      treatmentName: "Botox Treatment",
                      clinicName: "Glow Skin Clinic",
                      dateTime: "October 20, 3:00 PM",
                      treatmentimage: DummyAssets.treatmentimage,
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class Fillter {
  final String? svg;
  final String title;
  Fillter({required this.title, this.svg});
}
