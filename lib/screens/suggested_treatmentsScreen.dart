import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:skinsync_ai/screens/treatmentSelectionScreen.dart';
import 'package:skinsync_ai/utills/custom_fonts.dart';
import 'package:skinsync_ai/view_models/treatment_view_model.dart';
import 'package:skinsync_ai/widgets/custom_app_bar.dart';
import 'package:skinsync_ai/widgets/treatment_container.dart';
import 'package:skinsync_ai/widgets/custom_search_field.dart';

import '../../utills/color_constant.dart';

class SuggestedTreatmentScreen extends ConsumerWidget {
  const SuggestedTreatmentScreen({super.key});
  static const routeName = "/suggested_treatments_screen";

  @override
  Widget build(BuildContext context, ref) {
    return Scaffold(
      appBar: CustomAppBar(showTitle: true, title: "Suggested Treatments"),
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
                return TreatmentSelectionScreen();
              },
            ),
          ),
        ],
      ),
    );
  }
}

