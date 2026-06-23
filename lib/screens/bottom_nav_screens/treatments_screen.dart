import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:skinsync_ai/utills/custom_fonts.dart';
import 'package:skinsync_ai/view_models/treatment_view_model.dart';
import 'package:skinsync_ai/widgets/app_loader.dart';
import 'package:skinsync_ai/widgets/treatment_container.dart';
import 'package:skinsync_ai/widgets/custom_search_field.dart';

import '../../widgets/custom_app_bar.dart';

class TreatmentsScreen extends ConsumerStatefulWidget {
  const TreatmentsScreen({super.key});
  static const routeName = "TreatmentsScreen";

  @override
  ConsumerState<TreatmentsScreen> createState() => _TreatmentsScreenState();
}

class _TreatmentsScreenState extends ConsumerState<TreatmentsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.trim().toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(showTitle: true, title: "Select Treatments"),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Premium MedSpa Header
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 20.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 8.h),
                  Text(
                    "Explore and select from our complete clinical suite of advanced aesthetic therapies.",
                    style: CustomFonts.textGrey14w400,
                  ),
                  SizedBox(height: 20.h),

                  // Search Field with Premium Design matching TreatmentSelectionScreen
                  CustomSearchField(
                    controller: _searchController,
                    hintText: "Search Treatments...",
                  ),
                ],
              ),
            ),

            // Dynamic Treatments List
            Expanded(
              child: TreatmentMainScreen(searchQuery: _searchQuery),
            ),
          ],
        ),
      ),
    );
  }
}

class TreatmentMainScreen extends StatefulWidget {
  final String searchQuery;
  const TreatmentMainScreen({super.key, required this.searchQuery});

  @override
  State<TreatmentMainScreen> createState() => _TreatmentMainScreenState();
}

class _TreatmentMainScreenState extends State<TreatmentMainScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (_, ref, __) {
        final state = ref.watch(treatmentViewModel);
        final isLoading = state.treatmentsLoading;
        final treatments = state.treatments;

        if (!isLoading && treatments.isEmpty) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ref.read(treatmentViewModel.notifier).getTreatments();
          });
        }

        // Show loading indicator
        if (isLoading) {
          return const Center(child: AppLoader());
        }

        // Apply real-time search filtering
        final filteredTreatments = treatments.where((treatment) {
          final name = (treatment.name ?? "").toLowerCase();
          final desc = (treatment.description ?? "").toLowerCase();
          return name.contains(widget.searchQuery) || desc.contains(widget.searchQuery);
        }).toList();

        // Empty Search Results Placeholder
        if (filteredTreatments.isEmpty) {
          return Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 40.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search_off_rounded, size: 70.sp, color: Colors.grey.shade400),
                  SizedBox(height: 15.h),
                  Text(
                    "No Treatments Found",
                    style: CustomFonts.grey800_20w600,
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    "Try refining your search keyword or checking back later.",
                    textAlign: TextAlign.center,
                    style: CustomFonts.textGrey14w400,
                  ),
                ],
              ),
            ),
          );
        }

        return AnimationLimiter(
          key: const ValueKey('treatments_list_main'),
          child: ListView.builder(
            scrollDirection: Axis.vertical,
            padding: EdgeInsets.symmetric(horizontal: 30.w),
            physics: const BouncingScrollPhysics(),
            itemCount: filteredTreatments.length + 1,
            itemBuilder: (context, index) {
              if (index == filteredTreatments.length) {
                return SizedBox(height: 120.h); // Provide padding for floating scan button
              }
              return AnimationConfiguration.staggeredList(
                position: index,
                duration: const Duration(milliseconds: 600),
                child: SlideAnimation(
                  verticalOffset: 50.0,
                  child: FadeInAnimation(
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 16.h),
                      child: TreatmentContainer(
                        treatments: filteredTreatments[index],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
