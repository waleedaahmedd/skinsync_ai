import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import '../treatments_screen.dart';
import '../treatment_category_screen.dart';
import '../../utils/custom_fonts.dart';
import '../../view_models/checkout_view_model.dart';
import '../../view_models/treatment_view_model.dart';
import '../../widgets/treatment_container.dart';

class TreatmentExploreScreen extends ConsumerWidget {
  const TreatmentExploreScreen({super.key});

  static const String routeName = '/TreatmentSelectionScreen';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: context.w(20)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Text("Skinsync AI", style: CustomFonts.grey20w500),
                  // SizedBox(height: context.h(6)),
                  Text(
                    "Explore Treatments",
                    style: CustomFonts.black30w600.copyWith(fontSize: context.sp(28)),
                  ),
                  SizedBox(height: context.h(8)),
                  Text(
                    "Choose how you’d like to explore aesthetic treatments.",
                    style: CustomFonts.grey14w400.copyWith(height: 1.3),
                  ),
                ],
              ),
            ),
            SizedBox(height: context.h(25)),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.fromLTRB(context.w(20), 0, context.w(20), context.h(80)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                    SizedBox(height: context.h(4)),
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
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
