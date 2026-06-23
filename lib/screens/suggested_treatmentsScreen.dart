import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../utills/custom_fonts.dart';
import '../view_models/treatment_view_model.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/treatment_container.dart';

import '../../utills/color_constant.dart';

class SuggestedTreatmentScreen extends ConsumerWidget {
  const SuggestedTreatmentScreen({super.key});
  static const routeName = "/suggested_treatments_screen";

  @override
  Widget build(BuildContext context, ref) {
    return Scaffold(
      appBar: const CustomAppBar(showTitle: true, title: "Suggested Treatments"),
      body: Column(
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

                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    hintText: "Search treatment",
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Consumer(
              builder: (context, ref, _) {
                return const TreatmentMainScreen();
              },
            ),
          ),
        ],
      ),
    );
  }
}

class TreatmentMainScreen extends StatefulWidget {
  const TreatmentMainScreen({super.key});

  @override
  State<TreatmentMainScreen> createState() => _TreatmentMainScreenState();
}

class _TreatmentMainScreenState extends State<TreatmentMainScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (_, ref, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 32.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.0.w),
              child: Text("Select Treatment", style: CustomFonts.black24w600),
            ),
            SizedBox(height: 25.h),
            Expanded(
              child: Consumer(
                builder: (context, ref, _) {
                  final state = ref.watch(treatmentViewModel);
                  final isLoading = state
                      .treatmentsLoading; // Use separate loading for treatments
                  final treatments = state.treatments;

                  // Fetch treatments if not already loaded and not currently loading
                  if (!isLoading && state.treatments.isEmpty) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      ref.read(treatmentViewModel.notifier).getTreatments();
                    });
                  }

                  // Show loading indicator
                  if (isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: CustomColors.purpleColor,
                      ),
                    );
                  }

                  return AnimationLimiter(
                    key: const ValueKey('treatments_list'),
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: treatments.length + 1,
                      itemBuilder: (context, index) {
                        if (index == treatments.length) {
                          return SizedBox(height: 60.h);
                        }
                        return AnimationConfiguration.staggeredList(
                          position: index,
                          duration: const Duration(milliseconds: 800),
                          child: SlideAnimation(
                            horizontalOffset: 100.0,
                            child: FadeInAnimation(
                              child: Padding(
                                padding: EdgeInsets.only(
                                  left: 12.w,
                                  right: 12.w,
                                ),
                                child: TreatmentContainer(
                                  treatments: treatments[index],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
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
