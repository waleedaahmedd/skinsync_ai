import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../models/responses/treatment_category_list_response.dart';
import 'treatments_screen.dart';
import '../utils/color_constant.dart';
import '../utils/custom_fonts.dart';
import '../view_models/checkout_view_model.dart';
import '../view_models/treatment_category_view_model.dart';
import '../widgets/app_loader.dart';
import '../widgets/custom_app_bar.dart';
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
            CustomAppBar(title: widget.title),
            SizedBox(height: context.h(10)),
            // Premium Breadcrumb Selection Path Container
            Padding(
              padding: EdgeInsets.symmetric(horizontal: context.w(30)),
              child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: context.w(16),
                      vertical: context.h(12),
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(context.r(15)),
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
                          size: context.sp(14),
                          color: CustomColors.purpleColor,
                        ),
                        SizedBox(width: context.w(8)),
                        Expanded(
                          child: Text(
                            widget.selectionPath,
                            style: TextStyle(
                              fontSize: context.sp(12),
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
                        padding: EdgeInsets.only(
                          left: context.w(30),
                          right: context.w(30),
                          top: context.h(20),
                        ),
                        physics: const BouncingScrollPhysics(),
                        itemCount: displayedCategories.length + 1,
                        itemBuilder: (context, index) {
                          if (index == displayedCategories.length) {
                            return SizedBox(
                              height: context.h(110),
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
                                  padding: EdgeInsets.only(bottom: context.h(16)),
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
        padding: EdgeInsets.symmetric(horizontal: context.w(40)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.category_outlined,
              size: context.sp(70),
              color: Colors.grey.shade400,
            ),
            SizedBox(height: context.h(15)),
            Text(
              "No Categories Found",
              style: CustomFonts.black20w600.copyWith(
                color: Colors.grey.shade700,
              ),
            ),
            SizedBox(height: context.h(5)),
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
