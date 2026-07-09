import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:glow_container/glow_container.dart';
import 'package:before_after/before_after.dart';

import '../models/responses/simulation_history_response.dart';
import '../models/responses/treatment_area_list_response.dart';
import '../utills/assets.dart';
import '../utills/color_constant.dart';
import '../utills/custom_fonts.dart';
import '../view_models/checkout_view_model.dart';
import '../view_models/treatment_view_model.dart';
import '../widgets/bottom_sheets/syringe_level_sheet.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/service_type_button.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_bordered_button.dart';
import '../models/responses/treatment_area_list_response.dart';
import '../view_models/treatment_area_view_model.dart';
import 'explore_clinics_screen.dart';

class ArFaceModelPreviewScreen extends ConsumerStatefulWidget {
  const ArFaceModelPreviewScreen({super.key});

  static const String routeName = '/ArFaceModelPreviewScreen';

  @override
  ConsumerState<ArFaceModelPreviewScreen> createState() =>
      _ArFaceModelPreviewScreenState();
}

class _ArFaceModelPreviewScreenState
    extends ConsumerState<ArFaceModelPreviewScreen>
    with SingleTickerProviderStateMixin {
  bool _hasInitialized = false;
  double _sliderValue = 0.5;
  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnimation;
  final Set<int> _selectedAreaIds = {};
  late final ScrollController _treatmentScrollController;

  List<AreaData> _getSelectedAreasList(List<AreaData> rootAreas) {
    final List<AreaData> selected = [];
    void traverse(AreaData area) {
      if (_selectedAreaIds.contains(area.id)) {
        selected.add(area);
      }
      if (area.subAreas != null) {
        for (final sub in area.subAreas!) {
          traverse(sub);
        }
      }
    }

    for (final area in rootAreas) {
      traverse(area);
    }
    return selected;
  }

  Widget _buildAreasRecursively(
    List<AreaData> areas, {
    String title = "Area Selection",
  }) {
    if (areas.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title.isNotEmpty) ...[
          Text(title, style: CustomFonts.black18w600),
          SizedBox(height: 8.h),
        ],
        Wrap(
          direction: Axis.horizontal,
          spacing: 12.w,
          runSpacing: 12.h,
          children: areas.map((area) {
            final isSelected = _selectedAreaIds.contains(area.id);
            return ServiceTypeButton(
              icon: PngAssets.syringe,
              text: area.name ?? '-',
              selected: isSelected,
              onPressed: () {
                if (!isSelected) {
                  setState(() {
                    _selectedAreaIds.add(area.id!);
                    if (area.subAreas == null || area.subAreas!.isEmpty) {
                      ref
                          .read(checkoutViewModel.notifier)
                          .addSelectedArea(area);
                    }
                  });
                }
              },
            );
          }).toList(),
        ),
        SizedBox(height: 15.h),
        ...areas
            .where(
              (area) =>
                  _selectedAreaIds.contains(area.id) &&
                  area.subAreas != null &&
                  area.subAreas!.isNotEmpty,
            )
            .map((area) {
              return Padding(
                padding: EdgeInsets.only(left: 16.w, top: 10.h, bottom: 10.h),
                child: _buildAreasRecursively(
                  area.subAreas!,
                  title: "Sub Areas for ${area.name}",
                ),
              );
            }),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    _treatmentScrollController = ScrollController();
    _treatmentScrollController.addListener(() {
      if (_treatmentScrollController.position.pixels >=
          _treatmentScrollController.position.maxScrollExtent - 100.w) {
        ref.read(treatmentViewModel.notifier).loadMoreArTreatments();
      }
    });

    final checkoutState = ref.read(checkoutViewModel);
    final selectedArea = checkoutState.selectedAreas;
    if (selectedArea?.id != null) {
      _selectedAreaIds.add(selectedArea!.id!);
    }

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.04).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final lastCategoryId = ref.read(treatmentViewModel).categoryId;

      await ref
          .read(treatmentViewModel.notifier)
          .loadArTreatments(
            isSimulator: true,
            categoryId: lastCategoryId,
            clearSearch: true,
          );

      var selectedTreatment = ref.read(checkoutViewModel).selectedTreatments;
      if (selectedTreatment == null) {
        final loadedTreatments = ref.read(treatmentViewModel).arTreatments;
        if (loadedTreatments.isNotEmpty) {
          selectedTreatment = loadedTreatments.first;
        }
      }

      if (selectedTreatment != null) {
        ref
            .read(checkoutViewModel.notifier)
            .addSelectedTreatment(selectedTreatment);
        await ref
            .read(treatmentViewModel.notifier)
            .onTapTreatment(
              treatmentModel: selectedTreatment,
              isCallPredictAPI: false,
            );
      }

      final treatmentId = selectedTreatment?.id;
      if (treatmentId != null) {
        await ref
            .read(treatmentAreaProvider.notifier)
            .fetchAreasByTreatment(treatmentId);
      }
    });
  }

  @override
  void dispose() {
    _treatmentScrollController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _maybeShowSyringeBottomSheet(
    BuildContext context,
    TreatmentAreaModel subArea,
  ) {
    final minSyringe = 1; // Dummy min syringe
    final maxSyringe = 10; // Dummy max syringe
    final divisions = (maxSyringe - minSyringe);
    if (divisions <= 0) return;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (context) {
        return SyringeLevelSheet(subArea: subArea);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_hasInitialized) {
      _hasInitialized = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final state = ref.read(treatmentViewModel);
        if (!state.isBefore) {
          ref.read(treatmentViewModel.notifier).toggleIsBefore();
        }
      });
    }

    return Consumer(
      builder: (context, ref, _) {
        final isLoading = ref.watch(
          treatmentViewModel.select((state) => state.loading),
        );
        return PopScope(
          canPop: !isLoading,
          onPopInvokedWithResult: (didPop, result) {
            if (!isLoading) {
              ref.read(checkoutViewModel.notifier).clearState();
            }
          },
          child: AbsorbPointer(
            absorbing: isLoading,
            child: Scaffold(
              appBar: CustomAppBar(
                showTitle: true,
                title: "AR Face Model Preview",
              ),
              body: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20.h),
                    _facePreview(),

                    SizedBox(height: 10.h),
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.symmetric(horizontal: 20.w),
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 12.h,
                      ),
                      decoration: BoxDecoration(
                        color: CustomColors.purpleColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(
                          color: CustomColors.purpleColor.withValues(
                            alpha: 0.4,
                          ),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline_rounded,
                            color: CustomColors.darkPurple,
                            size: 20.sp,
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Text(
                              "This is an AI-generated Simulation for Visualization Purpose only. Actual results may vary.",
                              style: CustomFonts.black12w600.copyWith(
                                color: CustomColors.darkPurple,
                                fontSize: 11.sp,
                                height: 1.3,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // _accuracyRate(),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.0.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 30.h),

                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Treatment Selection',
                                    style: CustomFonts.black18w600,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      ref
                                          .read(treatmentViewModel.notifier)
                                          .clearAllSelectedTreatments();
                                    },
                                    child: Text(
                                      "Reset",
                                      style: CustomFonts.pinkunderlined20w600,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8.h),
                              Consumer(
                                builder: (context, ref, _) {
                                  final state = ref.watch(treatmentViewModel);
                                  final isLoading = state.isArLoading;
                                  final isLoadingMore = state.isArLoadingMore;
                                  final treatments = state.arTreatments;

                                  if (isLoading && treatments.isEmpty) {
                                    return SizedBox(
                                      height: 60.h,
                                      child: const Center(
                                        child: CircularProgressIndicator(
                                          color: CustomColors.purpleColor,
                                        ),
                                      ),
                                    );
                                  }

                                  if (treatments.isEmpty) {
                                    return SizedBox(
                                      height: 50.h,
                                      child: Center(
                                        child: Text(
                                          "No treatments available.",
                                          style: CustomFonts.grey14w400,
                                        ),
                                      ),
                                    );
                                  }

                                  return SizedBox(
                                    height: 50.h,
                                    child: AnimationLimiter(
                                      key: const ValueKey(
                                        'treatments_list_horizontal',
                                      ),
                                      child: ListView.builder(
                                        controller: _treatmentScrollController,
                                        scrollDirection: Axis.horizontal,
                                        physics: const BouncingScrollPhysics(),
                                        itemCount:
                                            treatments.length +
                                            (isLoadingMore ? 1 : 0),
                                        itemBuilder: (context, index) {
                                          if (index == treatments.length) {
                                            return Padding(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 16.w,
                                              ),
                                              child: const Center(
                                                child: SizedBox(
                                                  width: 20,
                                                  height: 20,
                                                  child:
                                                      CircularProgressIndicator(
                                                        strokeWidth: 2,
                                                        color: CustomColors
                                                            .purpleColor,
                                                      ),
                                                ),
                                              ),
                                            );
                                          }

                                          final treatment = treatments[index];
                                          final isSelected = ref
                                              .watch(checkoutViewModel)
                                              .selectedTreatmentsAndAreas
                                              .any(
                                                (item) =>
                                                    item.treatment.id ==
                                                    treatment.id,
                                              );

                                          return AnimationConfiguration.staggeredList(
                                            position: index,
                                            duration: const Duration(
                                              milliseconds: 600,
                                            ),
                                            child: SlideAnimation(
                                              horizontalOffset: 50.0,
                                              child: FadeInAnimation(
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                    right: 12.w,
                                                  ),
                                                  child: ServiceTypeButton(
                                                    icon: PngAssets.syringe,
                                                    text: treatment.name ?? '-',
                                                    selected: isSelected,
                                                    onPressed: () async {
                                                      ref
                                                          .read(
                                                            treatmentViewModel
                                                                .notifier,
                                                          )
                                                          .onTapTreatment(
                                                            treatmentModel:
                                                                treatment,
                                                            isCallPredictAPI:
                                                                true,
                                                          );
                                                      ref
                                                          .read(
                                                            checkoutViewModel
                                                                .notifier,
                                                          )
                                                          .addSelectedTreatment(
                                                            treatment,
                                                          );
                                                      await ref
                                                          .read(
                                                            treatmentAreaProvider
                                                                .notifier,
                                                          )
                                                          .fetchAreasByTreatment(
                                                            treatment.id ?? 0,
                                                          );
                                                    },
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
                              SizedBox(height: 30.h),
                              Consumer(
                                builder: (context, ref, _) {
                                  final selectedTreatment = ref
                                      .watch(treatmentViewModel)
                                      .selectedTreatment;
                                  if (selectedTreatment == null) {
                                    return const SizedBox.shrink();
                                  }

                                  final areaState = ref.watch(
                                    treatmentAreaProvider,
                                  );
                                  final isLoading = areaState.loading;
                                  final treatmentsArea = areaState.areas;

                                  if (isLoading) {
                                    return SizedBox(
                                      height: 200,
                                      child: const Center(
                                        child: CircularProgressIndicator(
                                          color: CustomColors.purpleColor,
                                        ),
                                      ),
                                    );
                                  }

                                  if (treatmentsArea.isEmpty) {
                                    return const SizedBox.shrink();
                                  }

                                  return _buildAreasRecursively(treatmentsArea);
                                },
                              ),
                              SizedBox(height: 20.h),
                              Consumer(
                                builder: (context, ref, _) {
                                  final selectedTreatmentsAndAreas = ref
                                      .watch(checkoutViewModel)
                                      .selectedTreatmentsAndAreas;

                                  if (selectedTreatmentsAndAreas.isEmpty) {
                                    return const SizedBox.shrink();
                                  }

                                  return SizedBox(
                                    height: 180.h,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      physics: const BouncingScrollPhysics(),
                                      itemCount:
                                          selectedTreatmentsAndAreas.length,
                                      itemBuilder: (context, index) {
                                        final item =
                                            selectedTreatmentsAndAreas[index];
                                        final treatment = item.treatment;
                                        final areas = item.selectedAreas;

                                        return Container(
                                          width: 260.w,
                                          margin: EdgeInsets.only(
                                            right: 16.w,
                                            bottom: 16.h,
                                          ),
                                          padding: EdgeInsets.all(16.w),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(
                                              24.r,
                                            ),
                                            border: Border.all(
                                              color: Colors.black.withValues(
                                                alpha: 0.12,
                                              ),
                                              width: 1.5,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withValues(
                                                  alpha: 0.015,
                                                ),
                                                blurRadius: 10,
                                                offset: const Offset(0, 4),
                                              ),
                                            ],
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          'Selected Treatment',
                                                          style: CustomFonts
                                                              .black10w600
                                                              .copyWith(
                                                                color: Colors
                                                                    .grey
                                                                    .shade500,
                                                              ),
                                                        ),
                                                        SizedBox(height: 2.h),
                                                        Text(
                                                          treatment.name ?? '-',
                                                          style: CustomFonts
                                                              .black16w600,
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        for (final a in areas) {
                                                          _selectedAreaIds
                                                              .remove(a.id);
                                                        }
                                                        ref
                                                            .read(
                                                              checkoutViewModel
                                                                  .notifier,
                                                            )
                                                            .removeTreatment(
                                                              treatment.id ?? 0,
                                                            );
                                                      });
                                                    },
                                                    child: Icon(
                                                      Icons.cancel_rounded,
                                                      size: 20,
                                                      color:
                                                          Colors.red.shade400,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const Divider(
                                                height: 16,
                                                color: Colors.black12,
                                              ),
                                              Text(
                                                'Selected Areas',
                                                style: CustomFonts.black10w600
                                                    .copyWith(
                                                      color:
                                                          Colors.grey.shade500,
                                                    ),
                                              ),
                                              SizedBox(height: 6.h),
                                              Expanded(
                                                child: areas.isEmpty
                                                    ? Center(
                                                        child: Text(
                                                          "No areas selected",
                                                          style: CustomFonts
                                                              .grey12w400,
                                                        ),
                                                      )
                                                    : SingleChildScrollView(
                                                        child: Wrap(
                                                          spacing: 6.w,
                                                          runSpacing: 6.h,
                                                          children: areas.map((
                                                            area,
                                                          ) {
                                                            return Chip(
                                                              visualDensity:
                                                                  VisualDensity
                                                                      .compact,
                                                              label: Text(
                                                                area.name ??
                                                                    '-',
                                                                style: CustomFonts
                                                                    .black10w600,
                                                              ),
                                                              onDeleted: () {
                                                                setState(() {
                                                                  _selectedAreaIds
                                                                      .remove(
                                                                        area.id,
                                                                      );
                                                                  ref
                                                                      .read(
                                                                        checkoutViewModel
                                                                            .notifier,
                                                                      )
                                                                      .removeArea(
                                                                        area.id ??
                                                                            0,
                                                                      );
                                                                });
                                                              },
                                                              deleteIconColor:
                                                                  Colors
                                                                      .red
                                                                      .shade300,
                                                            );
                                                          }).toList(),
                                                        ),
                                                      ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                },
                              ),
                              if (_selectedAreaIds.isNotEmpty)
                                _bottomButtons(context),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _facePreview() {
    const cardRadius = 20.0;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Card(
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(cardRadius.r),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(cardRadius.r),
              child: Consumer(
                builder: (context, ref, _) {
                  final beforeImage = ref.watch(
                    treatmentViewModel.select((state) => state.capturedImage),
                  );
                  final afterImage = ref.watch(
                    treatmentViewModel.select((state) => state.aiImage),
                  );

                  final errorMessage = ref.watch(
                    treatmentViewModel.select((state) => state.errorMessage),
                  );

                  if (errorMessage != null && beforeImage == null) {
                    return Container(
                      width: double.infinity,
                      height: 326.h,
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: Colors.red.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(cardRadius.r),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error_outline,
                              color: Colors.red,
                              size: 48.sp,
                            ),
                            SizedBox(height: 16.h),
                            Text('Error', style: CustomFonts.red20w600),
                            SizedBox(height: 8.h),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.w),
                              child: Text(
                                errorMessage,
                                textAlign: TextAlign.center,
                                style: CustomFonts.red16w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  // If both images are available, show the interactive sliding slider!
                  if (beforeImage != null && afterImage != null) {
                    return BeforeAfter(
                      value: _sliderValue,
                      onValueChanged: (value) {
                        setState(() {
                          _sliderValue = value;
                        });
                      },
                      before: Image.file(
                        File(beforeImage.path),
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 326.h,
                      ),
                      after: Image.file(
                        File(afterImage.path),
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 326.h,
                      ),
                    );
                  }

                  // Fallback: If only before image is available, show it alone
                  if (beforeImage != null) {
                    return Image.file(
                      File(beforeImage.path),
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 326.h,
                    );
                  }

                  return Container(
                    width: double.infinity,
                    height: 326.h,
                    color: CustomColors.greyColor.withValues(alpha: 0.3),
                    child: Center(
                      child: Text(
                        'No image available',
                        style: CustomFonts.black16w400,
                      ),
                    ),
                  );
                },
              ),
            ),
            Positioned(
              top: 10.h,
              left: 10.w,
              child: Consumer(
                builder: (context, ref, _) {
                  final afterImage = ref.watch(
                    treatmentViewModel.select((state) => state.aiImage),
                  );
                  final isBefore = ref.watch(
                    treatmentViewModel.select((state) => state.isBefore),
                  );

                  // Show stylish merged "Before | After" indicator if slider is active
                  if (afterImage != null) {
                    return Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 14.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.65),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Text(
                        'Before ❘ After',
                        style: CustomFonts.white14w600,
                      ),
                    );
                  }

                  return Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 14.w,
                      vertical: 2.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.8),
                      borderRadius: BorderRadius.circular(20.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.06),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      isBefore ? 'Before' : 'After',
                      style: CustomFonts.black20w600,
                    ),
                  );
                },
              ),
            ),
            Positioned(
              top: 10.h,
              right: 10.w,
              child: Consumer(
                builder: (context, ref, _) {
                  final afterImage = ref.watch(
                    treatmentViewModel.select((state) => state.aiImage),
                  );
                  if (afterImage == null) {
                    return const SizedBox.shrink();
                  }
                  return GestureDetector(
                    onTap: () {
                      ref.read(treatmentViewModel.notifier).saveAiImage();
                    },
                    child: CircleAvatar(
                      backgroundColor: CustomColors.greyColor,
                      child: const Icon(Icons.download_outlined),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget _accuracyRate() {
  //   return Row(
  //     children: [
  //       SvgPicture.asset(SvgAssets.dail),
  //       SizedBox(width: 5.w),
  //       Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Text('Accuracy Rate', style: CustomFonts.black20w600),
  //           Text(
  //             'This score is based on your Face analysis',
  //             style: CustomFonts.black16w400,
  //           ),
  //         ],
  //       ),
  //     ],
  //   );
  // }

  Widget _bottomButtons(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final isAiImageGenerated = ref.watch(
          treatmentViewModel.select((s) => s.isAiImageGenerated),
        );
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.paddingOf(context).bottom + 20.0.h,
          ),
          child: Row(
            children: [
              Expanded(
                child: ScaleTransition(
                  scale: _pulseAnimation,
                  child: isAiImageGenerated
                      ? CustomBorderedButton(
                          text: "Generate Ai Image",
                          borderColor: Colors.black,
                          textColor: Colors.black,
                          borderRadius: 30.r,
                          height: 58.h,
                          onPressed: () {
                            ref
                                .read(treatmentViewModel.notifier)
                                .callPredictAPI();
                          },
                        )
                      : GlowContainer(
                          gradientColors: const [
                            CustomColors.pinkColor,
                            CustomColors.darkPurple,
                          ],
                          containerOptions: ContainerOptions(
                            borderRadius: 30.r,
                            width: 2.r,
                          ),
                          child: CustomButton(
                            text: "Generate Ai Image",
                            backgroundColor: Colors.transparent,
                            textColor: CustomColors.darkPurple,
                            borderRadius: 30.r,
                            height: 54.h,
                            onPressed: () {
                              ref
                                  .read(treatmentViewModel.notifier)
                                  .callPredictAPI();
                            },
                          ),
                        ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: CustomButton(
                  text: 'Explore Clinics',
                  borderRadius: 30.r,
                  height: 58.h,
                  onPressed: () {
                    final treatment = ref.read(
                      treatmentViewModel.select(
                        (state) => state.selectedTreatment,
                      ),
                    );
                    final rootAreas = ref.read(treatmentAreaProvider).areas;
                    final selectedAreas = _getSelectedAreasList(rootAreas);

                    final treatmentId = treatment?.id;
                    final subAreaIds = selectedAreas
                        .map((e) => e.id)
                        .whereType<int>()
                        .toList();

                    Navigator.pushNamed(
                      context,
                      ExploreClinicsScreen.routeName,
                      arguments: {
                        'treatmentId': treatmentId,
                        'sideAreaIds': subAreaIds,
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
