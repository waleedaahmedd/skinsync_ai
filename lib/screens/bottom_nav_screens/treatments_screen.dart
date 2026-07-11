import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:skinsync_ai/utills/custom_fonts.dart';
import 'package:skinsync_ai/view_models/treatment_view_model.dart';
import 'package:skinsync_ai/widgets/app_loader.dart';
import 'package:skinsync_ai/widgets/treatment_container.dart';
import 'package:skinsync_ai/widgets/custom_search_field.dart';
import '../../view_models/checkout_view_model.dart';

import '../../widgets/custom_app_bar.dart';

class TreatmentsScreen extends ConsumerStatefulWidget {


  const TreatmentsScreen({super.key});
  static const routeName = "TreatmentsScreen";

  @override
  ConsumerState<TreatmentsScreen> createState() => _TreatmentsScreenState();
}

class _TreatmentsScreenState extends ConsumerState<TreatmentsScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      final query = _searchController.text.trim();
      ref.read(treatmentViewModel.notifier).searchTreatments(query);
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
              child: TreatmentMainScreen(
                categoryId:  ref.read(checkoutViewModel).selectedCategories?.lastOrNull?.id,
                areaId: ref.read(checkoutViewModel).selectedAreas?.id,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TreatmentMainScreen extends ConsumerStatefulWidget {
  final int? categoryId;
  final int? areaId;
  const TreatmentMainScreen({
    super.key,
    this.categoryId,
    this.areaId,
  });

  @override
  ConsumerState<TreatmentMainScreen> createState() => _TreatmentMainScreenState();
}

class _TreatmentMainScreenState extends ConsumerState<TreatmentMainScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200.h) {
      ref.read(treatmentViewModel.notifier).loadMoreTreatments();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(treatmentViewModel);
    final isLoading = state.isLoading;
    final isLoadingMore = state.isLoadingMore;
    final treatments = state.treatments;

    // Show loading indicator on initial load
    if (isLoading && treatments.isEmpty) {
      return const Center(child: AppLoader());
    }

    // Empty State Placeholder
    if (treatments.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 40.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.search_off_rounded, size: 70.sp, color: Colors.grey.shade400),
              SizedBox(height: 15.h),
              Text(
                "No treatments found.",
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

    return RefreshIndicator(
      onRefresh: () => ref.read(treatmentViewModel.notifier).refreshTreatments(),
      child: AnimationLimiter(
        key: const ValueKey('treatments_list_main'),
        child: ListView.builder(
          controller: _scrollController,
          scrollDirection: Axis.vertical,
          padding: EdgeInsets.symmetric(horizontal: 30.w),
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          itemCount: treatments.length + 1,
          itemBuilder: (context, index) {
            if (index == treatments.length) {
              if (isLoadingMore) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 20.h),
                  child: const Center(child: AppLoader()),
                );
              }
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
                      treatments: treatments[index],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
