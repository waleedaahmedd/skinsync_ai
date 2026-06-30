import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:skinsync_ai/models/responses/treatment_area_list_response.dart';
import 'package:skinsync_ai/screens/bottom_nav_screens/treatments_screen.dart';
import 'package:skinsync_ai/utills/color_constant.dart';
import 'package:skinsync_ai/utills/custom_fonts.dart';
import 'package:skinsync_ai/view_models/treatment_area_view_model.dart';
import 'package:skinsync_ai/view_models/checkout_view_model.dart';
import 'package:skinsync_ai/widgets/app_loader.dart';
import 'package:skinsync_ai/widgets/treatment_container.dart';

class TreatmentAreaScreen extends ConsumerStatefulWidget {
  final List<TreatmentAreaModel>? areas;
  final String title;
  final String selectionPath; // Path of selected focus areas

  const TreatmentAreaScreen({
    super.key,
    this.areas,
    required this.title,
    this.selectionPath = "Focus Areas", // Defaults to root path
  });

  static const String routeName = '/TreatmentAreaScreen';

  @override
  ConsumerState<TreatmentAreaScreen> createState() => _TreatmentAreaScreenState();
}

class _TreatmentAreaScreenState extends ConsumerState<TreatmentAreaScreen> {
  @override
  void initState() {
    super.initState();
    // Only fetch if we are at the root level / no areas were passed
    if (widget.areas == null || widget.areas!.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(treatmentAreaProvider.notifier).fetchAreas();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(treatmentAreaProvider);
    final displayedAreas = (widget.areas != null && widget.areas!.isNotEmpty)
        ? widget.areas!
        : viewModel.areas;

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
                            border: Border.all(color: Colors.grey.shade300, width: 1),
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
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15.r),
                      border: Border.all(
                        color: CustomColors.lightPurpleColor.withValues(alpha: 0.3),
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
                          Icons.radar_rounded,
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

            // Focus Area Listing using Reusable Adaptive TreatmentContainer
            Expanded(
              child: viewModel.loading && displayedAreas.isEmpty
                  ? const AppLoader()
                  : displayedAreas.isEmpty
                      ? _buildEmptyResultsPlaceholder()
                      : AnimationLimiter(
                          key: ValueKey('area_list_${widget.title}'),
                          child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            padding: EdgeInsets.symmetric(horizontal: 30.w),
                            physics: const BouncingScrollPhysics(),
                            itemCount: displayedAreas.length + 1,
                            itemBuilder: (context, index) {
                              if (index == displayedAreas.length) {
                                return SizedBox(height: 110.h); // Provide padding for floating items
                              }

                              final area = displayedAreas[index];

                              return AnimationConfiguration.staggeredList(
                                position: index,
                                duration: const Duration(milliseconds: 600),
                                child: SlideAnimation(
                                  verticalOffset: 50.0,
                                  child: FadeInAnimation(
                                    child: Padding(
                                      padding: EdgeInsets.only(bottom: 16.h),
                                      child: TreatmentContainer(
                                        customTitle: area.name,
                                        customSubtitle: area.globalSku ?? "",
                                        customImageUrl: area.image ?? "",
                                        customIcon: area.icon ?? "",
                                        customOnTap: () {
                                          ref.read(checkoutViewModel.notifier).addSelectedArea(area);

                                          if (area.subAreas != null && area.subAreas!.isNotEmpty) {
                                            // Recursively open another area screen with appended path
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => TreatmentAreaScreen(
                                                  areas: area.subAreas,
                                                  title: area.name ?? "",
                                                  selectionPath: "${widget.selectionPath}  ▸  ${area.name}",
                                                ),
                                              ),
                                            );
                                          } else {
                                            // Add selected area in checkoutViewModel list
                                            // If no children (leaf node), open the Treatments Screen!
                                            Navigator.pushNamed(
                                              context,
                                              TreatmentsScreen.routeName,
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
            Icon(Icons.crop_free_rounded, size: 70.sp, color: Colors.grey.shade400),
            SizedBox(height: 15.h),
            Text(
              "No Areas Found",
              style: CustomFonts.black20w600.copyWith(color: Colors.grey.shade700),
            ),
            SizedBox(height: 5.h),
            Text(
              "We couldn't find any target areas under this section.",
              textAlign: TextAlign.center,
              style: CustomFonts.grey14w400,
            ),
          ],
        ),
      ),
    );
  }
}
