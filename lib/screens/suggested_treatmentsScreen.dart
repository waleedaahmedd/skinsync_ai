import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'treatmentSelectionScreen.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_search_field.dart';


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
                const CustomSearchField(
                  hintText: "Search Treatment...",
                ),
              ],
            ),
          ),
          Expanded(
            child: Consumer(
              builder: (context, ref, _) {
                return const TreatmentSelectionScreen();
              },
            ),
          ),
        ],
      ),
    );
  }
}

