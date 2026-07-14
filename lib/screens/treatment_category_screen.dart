import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../models/responses/treatment_category_list_response.dart';
import 'bottom_nav_screens/treatments_screen.dart';
import '../utills/color_constant.dart';
import '../utills/custom_fonts.dart';
import '../view_models/checkout_view_model.dart';
import '../view_models/treatment_category_view_model.dart';
import '../widgets/app_loader.dart';
import '../widgets/treatment_container.dart';

class TreatmentCategoryScreen extends ConsumerStatefulWidget {
  final List<TreatmentCategoryModel>? categories;
  final String title;
  final String selectionPath; // Path of selected categories

  const TreatmentCategoryScreen({
    super.key,
    this.categories,
    required this.title,
    this.selectionPath = "Categories", // Defaults to root path
  });

  static const String routeName = '/TreatmentCategoryScreen';

  @override
  ConsumerState<TreatmentCategoryScreen> createState() =>
      _TreatmentCategoryScreenState();
}

class _TreatmentCategoryScreenState
    extends ConsumerState<TreatmentCategoryScreen> {
  @override
  void initState() {
    super.initState();
    // Only fetch if we are at the root level / no categories were passed
    if (widget.categories == null || widget.categories!.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(treatmentCategoryProvider.notifier).fetchCategories();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(treatmentCategoryProvider);
    final displayedCategories =
        (widget.categories != null && widget.categories!.isNotEmpty)
        ? widget.categories!
        : viewModel.categories;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Professional MedSpa Header
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 20.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: EdgeInsets.all(8.w),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.grey.shade300,
                              width: 1,
                            ),
                          ),
                          child: Icon(
                            Icons.arrow_back_ios_new_rounded,
                            size: 16.sp,
                            color: CustomColors.blackColor,
                          ),
                        ),
                      ),
                      SizedBox(width: 15.w),
                      Expanded(
                        child: Text(
                          widget.title,
                          style: CustomFonts.black24w600,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15.h),

                  // Premium Breadcrumb Selection Path Container
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 12.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15.r),
                      border: Border.all(
                        color: CustomColors.lightPurpleColor.withValues(
                          alpha: 0.3,
                        ),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.02),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.insights_rounded,
                          size: 14.sp,
                          color: CustomColors.purpleColor,
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Text(
                            widget.selectionPath,
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                              color: CustomColors.textGreyColor,
                              fontFamily: 'Degular',
                              letterSpacing: 0.3,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Category Listing using Reusable Adaptive TreatmentContainer
            Expanded(
              child: viewModel.loading && displayedCategories.isEmpty
                  ? const AppLoader()
                  : displayedCategories.isEmpty
                  ? _buildEmptyResultsPlaceholder()
                  : AnimationLimiter(
                      key: ValueKey('category_list_${widget.title}'),
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        padding: EdgeInsets.symmetric(horizontal: 30.w),
                        physics: const BouncingScrollPhysics(),
                        itemCount: displayedCategories.length + 1,
                        itemBuilder: (context, index) {
                          if (index == displayedCategories.length) {
                            return SizedBox(
                              height: 110.h,
                            ); // Provide padding for floating items
                          }

                          final category = displayedCategories[index];

                          return AnimationConfiguration.staggeredList(
                            position: index,
                            duration: const Duration(milliseconds: 600),
                            child: SlideAnimation(
                              verticalOffset: 50.0,
                              child: FadeInAnimation(
                                child: Padding(
                                  padding: EdgeInsets.only(bottom: 16.h),
                                  child: TreatmentContainer(
                                    customTitle: category.name,
                                    customSubtitle:
                                        category.shortDescription ?? "",
                                    customImageUrl: category.image ?? "",
                                    customIcon: category.icon ?? "",
                                    customOnTap: () {
                                      ref
                                          .read(checkoutViewModel.notifier)
                                          .addSelectedCategory(category);

                                      if (category.subCategories != null &&
                                          category.subCategories!.isNotEmpty) {
                                        // Recursively open another category screen with appended path
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                TreatmentCategoryScreen(
                                                  categories:
                                                      category.subCategories,
                                                  title: category.name ?? "",
                                                  selectionPath:
                                                      "${widget.selectionPath}  ▸  ${category.name}",
                                                ),
                                          ),
                                        );
                                      } else {
                                        Navigator.pushNamed(
                                          context,
                                          TreatmentsScreen.routeName,
                                          arguments: {
                                            'categoryId': category.id,
                                          },
                                        );
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyResultsPlaceholder() {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 40.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.category_outlined,
              size: 70.sp,
              color: Colors.grey.shade400,
            ),
            SizedBox(height: 15.h),
            Text(
              "No Categories Found",
              style: CustomFonts.black20w600.copyWith(
                color: Colors.grey.shade700,
              ),
            ),
            SizedBox(height: 5.h),
            Text(
              "We couldn't find any categories under this section.",
              textAlign: TextAlign.center,
              style: CustomFonts.grey14w400,
            ),
          ],
        ),
      ),
    );
  }
}
