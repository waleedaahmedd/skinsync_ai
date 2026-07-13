import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skinsync_ai/screens/bottom_nav_screens/treatments_screen.dart';
import 'package:skinsync_ai/screens/treatment_category_screen.dart';
import 'package:skinsync_ai/utills/custom_fonts.dart';
import 'package:skinsync_ai/view_models/checkout_view_model.dart';
import 'package:skinsync_ai/view_models/treatment_view_model.dart';
import 'package:skinsync_ai/widgets/treatment_container.dart';

class TreatmentExploreScreen extends ConsumerWidget {
  const TreatmentExploreScreen({super.key});
  static const String routeName = '/TreatmentSelectionScreen';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 25.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Skinsync AI", style: CustomFonts.grey20w500),
              SizedBox(height: 6.h),
              Text(
                "Explore Treatments",
                style: CustomFonts.black30w600.copyWith(fontSize: 28.sp),
              ),
              SizedBox(height: 8.h),
              Text(
                "Select how you would like to browse our elite clinical skin and body therapies.",
                style: CustomFonts.grey14w400.copyWith(height: 1.3),
              ),
              SizedBox(height: 25.h),

              // CARD 1: ALL TREATMENTS (Reusing TreatmentContainer adaptively!)
              TreatmentContainer(
                customTitle: "All Treatments",
                customSubtitle:
                    "Browse our complete catalog of professional aesthetic solutions.",
                customImageUrl:
                    "https://images.unsplash.com/photo-1512290923902-8a9f81dc236c?auto=format&fit=crop&q=80&w=600",
                customOnTap: () {
                  ref.read(checkoutViewModel.notifier).clearState();
                  ref
                      .read(treatmentViewModel.notifier)
                      .clearAllSelectedTreatments();
                  ref.read(treatmentViewModel.notifier).clearAiImage();
                  Navigator.pushNamed(
                    context,
                    TreatmentsScreen.routeName,
                    arguments: 'all',
                  );
                },
              ),
              SizedBox(
                height: 4.h,
              ), // Tightened margin spacing as the container itself provides internal margin
              // CARD 2: CATEGORIES (Reusing TreatmentContainer adaptively!)
              TreatmentContainer(
                customTitle: "By Category",
                customSubtitle:
                    "Explore injectables, laser resurfacing, body contouring & facials.",
                customImageUrl:
                    "https://images.unsplash.com/photo-1629909613654-28e377c37b09?auto=format&fit=crop&q=80&w=600",
                customOnTap: () {
                  ref.read(checkoutViewModel.notifier).clearState();
                  ref
                      .read(treatmentViewModel.notifier)
                      .clearAllSelectedTreatments();
                  ref.read(treatmentViewModel.notifier).clearAiImage();
                  Navigator.pushNamed(
                    context,
                    TreatmentCategoryScreen.routeName,
                  );
                },
              ),
              //  SizedBox(height: 4.h),

              // CARD 3: AREAS (Reusing TreatmentContainer adaptively!)
              // TreatmentContainer(
              //   customTitle: "Focus Areas",
              //   customSubtitle: "Target forehead, eyes, cheeks, lips, neck or body zones.",
              //   customImageUrl: "https://images.unsplash.com/photo-1522337360788-8b13edd793be?auto=format&fit=crop&q=80&w=600",
              //   customOnTap: () {
              //     ref.read(checkoutViewModel.notifier).clearState();
              //     ref.read(treatmentViewModel.notifier).clearAllSelectedTreatments();
              //     ref.read(treatmentViewModel.notifier).clearAiImage();
              //     Navigator.pushNamed(
              //       context,
              //       TreatmentAreaScreen.routeName,
              //     );
              //   },
              // ),
              SizedBox(
                height: 110.h,
              ), // Padding so bottom floating navigation doesn't overlap
            ],
          ),
        ),
      ),
    );
  }
}
