import 'dart:io';

import 'package:before_after/before_after.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:glow_container/glow_container.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import '../models/responses/materials_response.dart';
import '../models/responses/treatment_area_list_response.dart';
import '../models/selected_treatment_and_areas_model.dart';
import '../widgets/bottom_sheets/material_level_sheet.dart';
import '../widgets/selected_treatments_summary_card.dart';

import '../models/responses/treatment_list_response.dart';
import '../utills/assets.dart';
import '../utills/color_constant.dart';
import '../utills/custom_fonts.dart';
import '../view_models/checkout_view_model.dart';
import '../view_models/treatment_area_view_model.dart';
import '../view_models/treatment_view_model.dart';
import '../widgets/app_loader.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_bordered_button.dart';
import '../widgets/custom_button.dart';
import '../widgets/service_type_button.dart';
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
  late final _pagingController = PagingController<int, TreatmentData>(
    getNextPageKey: (state) {
      if (state.items == null) {
        return 1;
      }
      return state.items!.length < 10 ? null : state.nextIntPageKey;
    },
    fetchPage: (nextPage) async {
      final data = await ref
          .read(treatmentViewModel.notifier)
          .loadTreatments(page: nextPage, isSimulator: true);
      return data ?? [];
    },
  );

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

  List<AreaData> _getLeafAreas(List<AreaData> rootAreas) {
    final List<AreaData> leafs = [];
    void traverse(AreaData area) {
      if (area.subAreas == null || area.subAreas!.isEmpty) {
        leafs.add(area);
      } else {
        for (final sub in area.subAreas!) {
          traverse(sub);
        }
      }
    }

    for (final area in rootAreas) {
      traverse(area);
    }
    return leafs;
  }

  Widget _buildFlatAreas(List<AreaData> rootAreas) {
    final leafAreas = _getLeafAreas(rootAreas);
    if (leafAreas.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Area Selection", style: CustomFonts.black18w600),
        SizedBox(height: 12.h),
        Wrap(
          direction: Axis.horizontal,
          spacing: 12.w,
          runSpacing: 12.h,
          children: leafAreas.map((area) {
            final isSelected = _selectedAreaIds.contains(area.id);
            return ServiceTypeButton(
              imageUrl: area.image,
              icon: area.icon,
              text: area.name ?? '-',
              selected: isSelected,
              onPressed: () {
                if (isSelected) {
                  setState(() {
                    _selectedAreaIds.remove(area.id);
                  });
                  ref.read(checkoutViewModel.notifier).removeArea(area.id ?? 0);
                } else {
                  final treatment = ref
                      .read(checkoutViewModel)
                      .selectedTreatments;
                  final treatmentSku = treatment?.globalSku ?? '';
                  final areaSku = area.globalSku ?? '';

                  EasyLoading.show(status: 'Fetching materials...');
                  ref
                      .read(treatmentViewModel.notifier)
                      .getMaterials(
                        treatmentSku: treatmentSku,
                        areaSku: areaSku,
                      )
                      .then((res) {
                        EasyLoading.dismiss();
                        if (res != null &&
                            res.isSuccess == true &&
                            res.data != null) {
                          final materials = res.data ?? [];

                          // Check if ALL materials returned satisfy the auto-selection criteria
                          bool canAutoSelectAll =
                              materials.isNotEmpty &&
                              materials.every((m) {
                                final min = m.minQty ?? 0;
                                final max = m.maxQty ?? 0;
                                return (min == max) || (max == 0);
                              });

                          if (canAutoSelectAll) {
                            final List<SelectedMaterialModel>
                            selectedMaterials = [];
                            for (final m in materials) {
                              final min = m.minQty ?? 0;
                              final max = m.maxQty ?? 0;
                              final qty = (min == max) ? min : 0;
                              selectedMaterials.add(
                                SelectedMaterialModel(
                                  id: m.id ?? 0,
                                  name: m.name ?? '',
                                  selectedQuantity: qty,
                                  minQty: min,
                                  maxQty: max,
                                ),
                              );
                            }
                            if (treatment != null) {
                              ref
                                  .read(checkoutViewModel.notifier)
                                  .saveMaterialsForArea(
                                    treatment: treatment,
                                    area: area,
                                    materials: selectedMaterials,
                                  );
                            }
                            setState(() {
                              _selectedAreaIds.add(area.id!);
                            });
                          } else {
                            setState(() {
                              _selectedAreaIds.add(area.id!);
                            });
                            if (!context.mounted) return;
                            _showMaterialBottomSheet(context, area, materials);
                          }
                        } else {
                          // Fallback to existing flow if API returns empty or fails
                          ref
                              .read(checkoutViewModel.notifier)
                              .addSelectedArea(area);
                          setState(() {
                            _selectedAreaIds.add(area.id!);
                          });
                        }
                      })
                      .catchError((e) {
                        EasyLoading.dismiss();
                        // Fallback to existing flow if API fails
                        ref
                            .read(checkoutViewModel.notifier)
                            .addSelectedArea(area);
                        setState(() {
                          _selectedAreaIds.add(area.id!);
                        });
                      });
                }
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  void _showMaterialBottomSheet(
    BuildContext context,
    TreatmentAreaModel area,
    List<MaterialData> materials,
  ) {
    final treatment = ref.read(checkoutViewModel).selectedTreatments;
    if (treatment == null) return;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (context) {
        return MaterialLevelSheet(
          area: area,
          materials: materials,
          treatment: treatment,
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    // _treatmentScrollController = ScrollController();
    // _treatmentScrollController.addListener(() {
    //   if (_treatmentScrollController.position.pixels >=
    //       _treatmentScrollController.position.maxScrollExtent - 100.w) {
    //     ref.read(treatmentViewModel.notifier).loadMoreArTreatments();
    //   }
    // });

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
      final selectedTreatment = ref.read(checkoutViewModel).selectedTreatments;

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
        await ref
            .read(treatmentAreaProvider.notifier)
            .fetchAreasByTreatment(selectedTreatment.id ?? 0);
      }
    });
  }

  @override
  void dispose() {
    _pagingController.dispose();
    _pulseController.dispose();
    super.dispose();
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
              appBar: const CustomAppBar(
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
                                    onTap: () async {
                                      setState(() {
                                        _selectedAreaIds.clear();
                                      });
                                      ref
                                          .read(checkoutViewModel.notifier)
                                          .clearState();
                                      ref
                                          .read(treatmentViewModel.notifier)
                                          .clearAiImage();
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
                              _buildTreatmentsList(ref),
                              SizedBox(height: 30.h),
                              Consumer(
                                builder: (context, ref, _) {
                                  final selectedTreatment = ref
                                      .watch(checkoutViewModel)
                                      .selectedTreatments;
                                  if (selectedTreatment == null) {
                                    return const SizedBox.shrink();
                                  }

                                  final areaState = ref.watch(
                                    treatmentAreaProvider,
                                  );
                                  final isLoading = areaState.loading;
                                  final treatmentsArea = areaState.areas;

                                  if (isLoading) {
                                    return const SizedBox(
                                      height: 200,
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          color: CustomColors.purpleColor,
                                        ),
                                      ),
                                    );
                                  }

                                  if (treatmentsArea.isEmpty) {
                                    return const SizedBox.shrink();
                                  }

                                  return _buildFlatAreas(treatmentsArea);
                                },
                              ),
                              SizedBox(height: 20.h),
                              Consumer(
                                builder: (context, ref, _) {
                                  final selectedTreatmentsAndAreas = ref
                                      .watch(checkoutViewModel)
                                      .selectedTreatmentsAndAreas;

                                  return SelectedTreatmentsSummaryCard(
                                    selectedTreatmentsAndAreas:
                                        selectedTreatmentsAndAreas,
                                    onRemoveTreatment: (item) {
                                      setState(() {
                                        for (final a in item.selectedAreas) {
                                          _selectedAreaIds.remove(a.target.id);
                                        }
                                        ref
                                            .read(checkoutViewModel.notifier)
                                            .removeTreatment(
                                              item.treatment.id ?? 0,
                                            );
                                      });
                                    },
                                    onRemoveArea: (item, areaItem) {
                                      setState(() {
                                        _selectedAreaIds.remove(
                                          areaItem.target.id,
                                        );
                                        ref
                                            .read(checkoutViewModel.notifier)
                                            .removeArea(
                                              areaItem.target.id ?? 0,
                                            );
                                      });
                                    },
                                  );
                                },
                              ),
                              Consumer(
                                builder: (context, ref, _) {
                                  final selectedTreatmentsAndAreas = ref
                                      .watch(checkoutViewModel)
                                      .selectedTreatmentsAndAreas;
                                  final hasAnySelectedArea =
                                      selectedTreatmentsAndAreas.any(
                                        (item) => item.selectedAreas.isNotEmpty,
                                      );

                                  if (hasAnySelectedArea) {
                                    return _bottomButtons(context);
                                  }
                                  return const SizedBox.shrink();
                                },
                              ),
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

  Widget _buildTreatmentsList(WidgetRef ref) {
    return SizedBox(
      height: 50.h,
      child: PagingListener(
        controller: _pagingController,
        builder: (context, state, fetchNextPage) {
          return AnimationLimiter(
            key: const ValueKey('treatments_list_horizontal'),
            child: PagedListView<int, TreatmentData>(
              state: state,
              fetchNextPage: fetchNextPage,
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              builderDelegate: PagedChildBuilderDelegate(
                newPageProgressIndicatorBuilder: (_) => AppLoader(size: 50.h),
                firstPageProgressIndicatorBuilder: (_) => AppLoader(size: 40.h),
                itemBuilder: (context, treatment, index) {
                  final isSelected = ref
                      .watch(checkoutViewModel)
                      .selectedTreatmentsAndAreas
                      .any((item) => item.treatment.id == treatment.id);
                  return AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(milliseconds: 600),
                    child: SlideAnimation(
                      horizontalOffset: 50.0,
                      child: FadeInAnimation(
                        child: Padding(
                          padding: EdgeInsets.only(right: 12.w),
                          child: ServiceTypeButton(
                            imageUrl: treatment.image ?? treatment.imageUrl,
                            icon: treatment.icon ?? PngAssets.syringe,
                            text: treatment.name ?? '-',
                            selected: isSelected,
                            onPressed: () async {
                              if (isSelected) {
                                // Keep it selected, do not remove/deselect.
                                // Just switch the active selection to show its areas below!
                                ref
                                    .read(treatmentViewModel.notifier)
                                    .onTapTreatment(
                                      treatmentModel: treatment,
                                      isCallPredictAPI: false,
                                    );
                                await ref
                                    .read(treatmentAreaProvider.notifier)
                                    .fetchAreasByTreatment(treatment.id ?? 0);
                              } else {
                                ref
                                    .read(treatmentViewModel.notifier)
                                    .onTapTreatment(
                                      treatmentModel: treatment,
                                      isCallPredictAPI: true,
                                    );
                                ref
                                    .read(checkoutViewModel.notifier)
                                    .addSelectedTreatment(treatment);
                                await ref
                                    .read(treatmentAreaProvider.notifier)
                                    .fetchAreasByTreatment(treatment.id ?? 0);
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
          );
        },
      ),
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
                    child: const CircleAvatar(
                      backgroundColor: CustomColors.greyColor,
                      child: Icon(Icons.download_outlined),
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
                      checkoutViewModel.select(
                        (state) => state.selectedTreatments,
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
