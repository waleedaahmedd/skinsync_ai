import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:skinsync_ai/models/responses/treatment_list_response.dart';
import 'package:skinsync_ai/utills/custom_fonts.dart';
import 'package:skinsync_ai/view_models/treatment_view_model.dart';
import 'package:skinsync_ai/widgets/custom_search_field.dart';

import '../../view_models/checkout_view_model.dart';
import '../../widgets/app_loader.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/treatment_container.dart';

class TreatmentsScreen extends ConsumerStatefulWidget {
  const TreatmentsScreen({super.key});
  static const routeName = "TreatmentsScreen";

  @override
  ConsumerState<TreatmentsScreen> createState() => _TreatmentsScreenState();
}

class _TreatmentsScreenState extends ConsumerState<TreatmentsScreen> {
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
              padding: EdgeInsets.symmetric(horizontal: 30.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 8.h),
                  Text(
                    "Explore and select from our complete clinical suite of advanced aesthetic therapies.",
                    style: CustomFonts.textGrey14w400,
                  ),
                ],
              ),
            ),
            // Dynamic Treatments List
            Expanded(
              child: TreatmentMainScreen(
                categoryId: ref
                    .read(checkoutViewModel)
                    .selectedCategories
                    ?.lastOrNull
                    ?.id,
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

  const TreatmentMainScreen({super.key, this.categoryId, this.areaId});

  @override
  ConsumerState<TreatmentMainScreen> createState() =>
      _TreatmentMainScreenState();
}

class _TreatmentMainScreenState extends ConsumerState<TreatmentMainScreen> {
  Timer? _debounce;
  final TextEditingController _searchController = TextEditingController();
  late final _pagingController = PagingController<int, TreatmentData>(
    getNextPageKey: (state) {
      if (state.items == null) {
        return 1;
      }
      return state.items!.length < 10 ? null : state.nextIntPageKey;
      // final length = state.pages?.lastOrNull?.length ?? 0;
      // return length < 10 ? 0 : state.nextIntPageKey;
    },
    fetchPage: (nextPage) async {
      final search = _searchController.text.trim();
      final data = await ref
          .read(treatmentViewModel.notifier)
          .loadTreatments(
            page: nextPage,
            categoryId: widget.categoryId,
            search: search,
          );
      return data ?? [];
    },
  );

  @override
  void dispose() {
    _pagingController.dispose();
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final state = ref.watch(treatmentViewModel);
    // final isLoading = state.isLoading;
    // final isLoadingMore = state.isLoadingMore;
    // final treatments = state.treatments;
    //
    // // Show loading indicator on initial load
    // if (isLoading && treatments.isEmpty) {
    //   return const Center(child: AppLoader());
    // }

    // Empty State Placeholder
    // if (treatments.isEmpty) {
    //   return _buildEmpty();
    // }

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 20.h),
          child: CustomSearchField(
            controller: _searchController,
            hintText: "Search Treatments...",
            onChanged: (_) {
              _debounce?.cancel();
              _debounce = Timer(const Duration(milliseconds: 500), () {
                _pagingController.refresh();
              });
            },
          ),
        ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async => _pagingController.refresh(),
            // onRefresh: () =>
            //     ref.read(treatmentViewModel.notifier).refreshTreatments(),
            child: PagingListener(
              controller: _pagingController,
              builder: (context, state, fetchNextPage) {
                return AnimationLimiter(
                  key: const ValueKey('treatments_list_main'),
                  child: PagedListView<int, TreatmentData>(
                    state: state,
                    fetchNextPage: fetchNextPage,
                    scrollDirection: Axis.vertical,
                    padding: EdgeInsets.symmetric(horizontal: 30.w),
                    physics: const AlwaysScrollableScrollPhysics(
                      parent: BouncingScrollPhysics(),
                    ),
                    builderDelegate: PagedChildBuilderDelegate(
                      noItemsFoundIndicatorBuilder: (_) => _buildEmpty(),
                      firstPageProgressIndicatorBuilder: (_) => Padding(
                        padding: EdgeInsets.symmetric(vertical: 20.h),
                        child: const Center(child: AppLoader()),
                      ),
                      newPageProgressIndicatorBuilder: (_) => Padding(
                        padding: EdgeInsets.symmetric(vertical: 20.h),
                        child: const Center(child: AppLoader()),
                      ),
                      itemBuilder: (context, treatment, index) {
                        return AnimationConfiguration.staggeredList(
                          position: index,
                          duration: const Duration(milliseconds: 600),
                          child: SlideAnimation(
                            verticalOffset: 50.0,
                            child: FadeInAnimation(
                              child: Padding(
                                padding: EdgeInsets.only(bottom: 16.h),
                                child: TreatmentContainer(
                                  treatments: treatment,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Center _buildEmpty() {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 40.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off_rounded,
              size: 70.sp,
              color: Colors.grey.shade400,
            ),
            SizedBox(height: 15.h),
            Text("No treatments found.", style: CustomFonts.grey800_20w600),
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
}
