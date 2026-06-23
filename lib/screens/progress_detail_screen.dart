import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'bottom_nav_page.dart';
import '../utills/assets.dart';
import '../utills/color_constant.dart';
import '../utills/custom_fonts.dart';


final selectedFilterProvider = StateProvider<int?>((ref) => 0);

class ProgressDetailScreen extends ConsumerWidget {
  ProgressDetailScreen({super.key});
  static const String routeName = '/progress_detail_screen';

  List<FilterModel> filter = [
    FilterModel(assetIcon: PngAssets.syringe, name: "Sessions"),
    FilterModel(assetIcon: PngAssets.beforeAfter, name: "Skin Comparision"),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      extendBody: true,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              alignment: Alignment.topLeft,
              height: 293.h,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(DummyAssets.treatmentimage),
                  fit: BoxFit.cover,
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 55.h),
                child: InkWell(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey.withValues(alpha: 0.7),
                    ),
                    child: Icon(
                      CupertinoIcons.arrow_left,
                      size: 20.sp,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 15.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Derma Fillers - Cheeks",
                    style: CustomFonts.black30w600,
                  ),
                  SizedBox(height: 2.h),
                  Text("Glow Skin Clinic", style: CustomFonts.black18w400),

                  SizedBox(height: 14.h),

                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 18.w,
                      vertical: 11.h,
                    ),
                    decoration: BoxDecoration(
                      color: CustomColors.lightBlueColor.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 59.r, // radius * 2
                          height: 59.r, // radius * 2
                          child: CircularPercentIndicator(
                            radius: 29.5.r,
                            lineWidth: 6.7.w,
                            animation: true,
                            percent: 0.72,
                            center: Text("72%", style: CustomFonts.black16w600),
                            circularStrokeCap: CircularStrokeCap.round,
                            progressColor: const Color(0xffEEA1F0),
                            backgroundColor: Colors.white,
                          ),
                        ),
                        SizedBox(width: 16.w),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Progress Complete!",
                              style: CustomFonts.black22w600,
                            ),
                            SizedBox(height: 9.w),
                            Text(
                              "Almost there! Keep going!",
                              style: CustomFonts.black16w400,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 14.h),
                  Text(
                    "Enhance your natural beauty by adding volume, smoothing wrinkles, and contouring areas like cheeks, lips, and under-eyes for a youthful, refreshed look.",
                    style: CustomFonts.black16w400,
                  ),
                  SizedBox(height: 29.h),
                  Divider(color: Colors.grey.shade300, height: 0),
                  SizedBox(height: 22.h),
                  Row(
                    children: List.generate(filter.length, (index) {
                      final selectedIndex = ref.watch(selectedFilterProvider);
                      final isSelected = selectedIndex == index;
                      return Padding(
                        padding: EdgeInsets.only(right: 10.w),
                        child: GestureDetector(
                          onTap: () {
                            ref.read(selectedFilterProvider.notifier).state =
                                index;
                          },
                          child: Chip(
                            side: const BorderSide(color: Colors.transparent),
                            backgroundColor: isSelected
                                ? Colors.black
                                : Colors.grey.shade100,
                            label: Row(
                              children: [
                                Image.asset(
                                  filter[index].assetIcon,
                                  height: 16.h,
                                  width: 16.w,
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.black,
                                ),
                                const SizedBox(width: 7),
                                Text(
                                  filter[index].name,
                                  style: isSelected
                                      ? CustomFonts.white18w500
                                      : CustomFonts.black18w500,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    "Your Treatment Journey",
                    style: CustomFonts.black22w600,
                  ),
                  SizedBox(height: 20.h),

                  TreatmentJourneyStepper(steps: _getTreatmentSteps()),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        padding: EdgeInsets.only(
          bottom: MediaQuery.paddingOf(context).bottom + 20.h,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min, // 👈 add this
          children: [
            Padding(
              padding: EdgeInsets.only(top: 20.h, left: 30.w, right: 30.w),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      BottomNavPage.routeName,
                      (_) => false,
                    );
                  },
                  child: const Text("Post a Review"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

List<TreatmentStep> _getTreatmentSteps() {
  return [
    TreatmentStep(
      title: "Botox Treatment",
      description:
          "Mild swelling or redness is normal. Follow aftercare tips for best results.",
      date: "02 Feb 2025",
      imageAsset: DummyAssets.treatmentimage,
      isCompleted: true,
    ),
    TreatmentStep(
      title: "Botox Treatment",
      description:
          "Mild swelling or redness is normal. Follow aftercare tips for best results.",
      date: "02 Feb 2025",
      imageAsset: DummyAssets.treatmentimage,
      isCompleted: true,
    ),
    TreatmentStep(
      title: "Botox Treatment",
      description:
          "Mild swelling or redness is normal. Follow aftercare tips for best results.",
      date: "02 Feb 2025",
      imageAsset: DummyAssets.treatmentimage,
      isCompleted: true,
    ),
    TreatmentStep(
      title: "Botox Treatment",
      description:
          "Mild swelling or redness is normal. Follow aftercare tips for best results.",
      date: "02 Feb 2025",
      imageAsset: DummyAssets.treatmentimage,
      isCompleted: true,
    ),
  ];
}

class TreatmentStep {
  final String title;
  final String description;
  final String date;
  final String imageAsset;
  final bool isCompleted;

  TreatmentStep({
    required this.title,
    required this.description,
    required this.date,
    required this.imageAsset,
    this.isCompleted = true,
  });
}

// Stepper Widget
class TreatmentJourneyStepper extends StatelessWidget {
  final List<TreatmentStep> steps;

  const TreatmentJourneyStepper({super.key, required this.steps});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: steps.length,
          itemBuilder: (context, index) {
            final isLast = index == steps.length - 1;
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Stepper indicator column
                Column(
                  children: [
                    Container(
                      width: 27.w,
                      height: 27.h,
                      decoration: BoxDecoration(
                        color: steps[index].isCompleted
                            ? CustomColors.purpleColor
                            : Colors.grey.shade300,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.check, size: 14.w, color: Colors.white),
                    ),
                    if (!isLast)
                      Container(
                        height: 148.h,
                        width: 1.w,
                        color: Colors.grey.shade400,
                      ),
                  ],
                ),
                SizedBox(width: 16.w),
                // Content
                Expanded(
                  child: Column(
                    children: [
                      TreatmentCard(step: steps[index]),
                      if (!isLast) SizedBox(height: 18.h),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}

// Treatment Card Widget
class TreatmentCard extends StatelessWidget {
  final TreatmentStep step;

  const TreatmentCard({super.key, required this.step});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xffDEF8FF),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 14.h),
                  Text(step.title, style: CustomFonts.black18w600),
                  SizedBox(height: 11.h),
                  Text(step.description, style: CustomFonts.black16w400),
                  SizedBox(height: 34.h),
                  Text(step.date, style: CustomFonts.black16w500),
                  SizedBox(height: 14.h),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(6.0),
            child: Container(
              height: 144.h,
              width: 122.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.r),
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage(step.imageAsset),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FilterModel {
  String assetIcon;
  String name;

  FilterModel({required this.assetIcon, required this.name});
}
