import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../utills/assets.dart';
import '../utills/custom_fonts.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/treatment_journey_stepper.dart';

class TreatmentJourneyScreen extends ConsumerWidget {
  const TreatmentJourneyScreen({super.key});
  static const String routeName = '/TreatmentJourneyScreen';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(showTitle: true, title: 'Treatment Journey'),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.fromLTRB(
          context.w(24),
          context.h(20),
          context.w(24),
          context.h(20),
        ),
        children: [
          Text(
            "Your Treatment Journey",
            style: CustomFonts.black22w600,
          ),
          SizedBox(height: context.h(20)),
          TreatmentJourneyStepper(
            steps: [
              TreatmentStep(
                title: "Consultation",
                description:
                    "Initial consultation with Dr. Sarah Smith at Glow Skin Clinic.",
                date: "15 Jan 2025",
                imageAsset: DummyAssets.treatmentimage,
                isCompleted: true,
              ),
              TreatmentStep(
                title: "First Session",
                description:
                    "Laser hair removal session 1. Mild redness observed.",
                date: "02 Feb 2025",
                imageAsset: DummyAssets.treatmentimage,
                isCompleted: true,
              ),
              TreatmentStep(
                title: "Follow-up",
                description: "Check-up and planning for the second session.",
                date: "10 Feb 2025",
                imageAsset: DummyAssets.treatmentimage,
                isCompleted: false,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
