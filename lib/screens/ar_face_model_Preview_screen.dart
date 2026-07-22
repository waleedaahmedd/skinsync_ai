import 'dart:io';

import 'package:before_after/before_after.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../models/responses/materials_response.dart';
import '../models/responses/treatment_area_list_response.dart';
import '../models/responses/treatment_list_response.dart';
import '../models/selected_treatment_and_areas_model.dart';
import '../utills/assets.dart';
import '../utills/color_constant.dart';
import '../utills/custom_fonts.dart';
import '../view_models/checkout_view_model.dart';
import '../view_models/treatment_area_view_model.dart';
import '../view_models/treatment_view_model.dart';
import '../widgets/app_loader.dart';
import '../widgets/bottom_sheets/material_level_sheet.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_bordered_button.dart';
import '../widgets/custom_button.dart';
import '../widgets/selected_treatments_summary_card.dart';
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
  // ---------------------------------------------------------------------------
  // State Variables & Controllers
  // ---------------------------------------------------------------------------

  bool _hasInitialized = false;
  double _sliderValue = 0.5;

  late final ScrollController _scrollController;
  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnimation;

  late final PagingController<int, TreatmentData> _pagingController =
      PagingController<int, TreatmentData>(
        getNextPageKey: (state) {
          if (state.items == null) return 1;
          return state.items!.length < 10 ? null : state.nextIntPageKey;
        },
        fetchPage: (nextPage) async {
          final data = await ref
              .read(treatmentViewModel.notifier)
              .loadTreatments(page: nextPage, isSimulator: true);
          return data ?? [];
        },
      );

  // ---------------------------------------------------------------------------
  // Lifecycle Methods
  // ---------------------------------------------------------------------------

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController();

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
        await ref.read(treatmentViewModel.notifier).onTapTreatment(
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
    _scrollController.dispose();
    _pagingController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  // ---------------------------------------------------------------------------
  // Build Method
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    _handleInitialState();

    ref.listen(treatmentViewModel.select((s) => s.isAiImageGenerated), (prev, next) {
      if (next == true && prev != true) {
        _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });

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
                Expanded(
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20.h),
                        _buildFacePreview(),
                        SizedBox(height: 10.h),
                        _buildSimulationBanner(),
                        SizedBox(height: 30.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: _buildTreatmentHeader(),
                        ),
                        SizedBox(height: 8.h),
                        _buildTreatmentsList(),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 30.h),
                              _buildAreaSelectionSection(),
                              SizedBox(height: 20.h),
                              _buildSummarySection(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                _buildBottomActions(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Initialization Logic
  // ---------------------------------------------------------------------------

  void _handleInitialState() {
    if (!_hasInitialized) {
      _hasInitialized = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final state = ref.read(treatmentViewModel);
        if (!state.isBefore) {
          ref.read(treatmentViewModel.notifier).toggleIsBefore();
        }
      });
    }
  }

  // ---------------------------------------------------------------------------
  // Widget Builders
  // ---------------------------------------------------------------------------

  Widget _buildSimulationBanner() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: CustomColors.greyColor.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: CustomColors.textFeildBoaderColor.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline_rounded,
            color: CustomColors.textGreyColor,
            size: 20.sp,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              "This is an AI-generated Simulation for Visualization Purpose only. Actual results may vary.",
              style: CustomFonts.black12w600.copyWith(
                color: CustomColors.textGreyColor,
                fontSize: 11.sp,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTreatmentHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Treatment Selection', style: CustomFonts.black16w600),
        InkWell(
          onTap: () {
            ref.read(checkoutViewModel.notifier).clearState();
            ref.read(treatmentViewModel.notifier).clearAiImage();
            ref.read(treatmentViewModel.notifier).clearAllSelectedTreatments();
          },
          child: Text(
            "Reset",
            style: CustomFonts.black14w500Underline.copyWith(
              color: CustomColors.textGreyColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTreatmentsList() {
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
              padding: EdgeInsets.symmetric(horizontal: 20.w),
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
                              ref
                                  .read(treatmentViewModel.notifier)
                                  .onTapTreatment(
                                    treatmentModel: treatment,
                                    isCallPredictAPI: !isSelected,
                                  );
                              ref
                                  .read(checkoutViewModel.notifier)
                                  .addSelectedTreatment(treatment);
                              await ref
                                  .read(treatmentAreaProvider.notifier)
                                  .fetchAreasByTreatment(treatment.id ?? 0);
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

  Widget _buildAreaSelectionSection() {
    return Consumer(
      builder: (context, ref, _) {
        final checkoutState = ref.watch(checkoutViewModel);
        final selectedTreatment = checkoutState.selectedTreatments;

        if (selectedTreatment == null) return const SizedBox.shrink();

        final areaState = ref.watch(treatmentAreaProvider);
        if (areaState.loading) {
          return const SizedBox(
            height: 200,
            child: Center(
              child: CircularProgressIndicator(color: CustomColors.purpleColor),
            ),
          );
        }

        final treatmentsArea = areaState.areas;
        if (treatmentsArea.isEmpty) return const SizedBox.shrink();

        final currentEntry = _entryForTreatment(
          checkoutState.selectedTreatmentsAndAreas,
          selectedTreatment.id,
        );

        final selectedAreaIds =
            currentEntry?.selectedAreas.map((e) => e.target.id ?? 0).toSet() ??
            <int>{};

        return _buildFlatAreas(
          rootAreas: treatmentsArea,
          selectedAreaIds: selectedAreaIds,
          treatment: selectedTreatment,
        );
      },
    );
  }

  Widget _buildSummarySection() {
    return Consumer(
      builder: (context, ref, _) {
        final selectedTreatmentsAndAreas =
            ref.watch(checkoutViewModel).selectedTreatmentsAndAreas;

        return SelectedTreatmentsSummaryCard(
          selectedTreatmentsAndAreas: selectedTreatmentsAndAreas,
          onRemoveTreatment: (item) {
            ref
                .read(checkoutViewModel.notifier)
                .removeTreatment(item.treatment.id ?? 0);
          },
          onRemoveArea: (item, areaItem) {
            ref
                .read(checkoutViewModel.notifier)
                .removeArea(areaItem.target.id ?? 0);
          },
        );
      },
    );
  }

  Widget _buildBottomActions() {
    return Consumer(
      builder: (context, ref, _) {
        final selectedTreatmentsAndAreas =
            ref.watch(checkoutViewModel).selectedTreatmentsAndAreas;
        final hasAnySelectedArea = selectedTreatmentsAndAreas.any(
          (item) => item.selectedAreas.isNotEmpty,
        );

        if (!hasAnySelectedArea) return const SizedBox.shrink();

        return Container(
          padding: EdgeInsets.fromLTRB(
            20.w,
            16.h,
            20.w,
            MediaQuery.paddingOf(context).bottom + 16.h,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: ScaleTransition(
                  scale: _pulseAnimation,
                  child: CustomBorderedButton(
                    text: "Generate Ai Image",
                    borderRadius: 30.r,
                    borderColor: CustomColors.blackColor,
                    textColor: CustomColors.blackColor,
                    height: 58.h,
                    onPressed: () {
                      ref.read(treatmentViewModel.notifier).callPredictAPI();
                    },
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
                    final checkoutState = ref.read(checkoutViewModel);
                    final treatment = checkoutState.selectedTreatments;
                    final treatmentId = treatment?.id;

                    final currentEntry = _entryForTreatment(
                      checkoutState.selectedTreatmentsAndAreas,
                      treatmentId,
                    );
                    final subAreaIds =
                        currentEntry?.selectedAreas
                            .map((e) => e.target.id)
                            .whereType<int>()
                            .toList() ??
                        <int>[];

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

  Widget _buildFacePreview() {
    const cardRadius = 20.0;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
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
                  final state = ref.watch(treatmentViewModel);
                  final beforeImage = state.capturedImage;
                  final afterImage = state.aiImage;
                  final errorMessage = state.errorMessage;

                  if (errorMessage != null && beforeImage == null) {
                    return _buildErrorState(errorMessage, cardRadius);
                  }

                  if (beforeImage != null && afterImage != null) {
                    return BeforeAfter(
                      value: _sliderValue,
                      onValueChanged: (value) => setState(() => _sliderValue = value),
                      before: _buildPreviewImage(beforeImage.path),
                      after: _buildPreviewImage(afterImage.path),
                      trackColor: Colors.white,
                      trackWidth: 2.w,
                      thumbDecoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(PngAssets.customMarker),
                          fit: BoxFit.contain,
                        ),
                      ),
                      thumbWidth: 32.w,
                      thumbHeight: 32.w,
                    );
                  }

                  if (beforeImage != null) {
                    return _buildPreviewImage(beforeImage.path);
                  }

                  return _buildNoImageState();
                },
              ),
            ),
            _buildAfterLabel(),
            _buildBeforeLabel(),
            _buildDownloadButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildPreviewImage(String path) {
    return Image.file(
      File(path),
      fit: BoxFit.cover,
      width: double.infinity,
      height: 326.h,
    );
  }

  Widget _buildErrorState(String message, double radius) {
    return Container(
      width: double.infinity,
      height: 326.h,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.red.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(radius.r),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, color: Colors.red, size: 48.sp),
            SizedBox(height: 16.h),
            Text('Error', style: CustomFonts.red20w600),
            SizedBox(height: 8.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Text(
                message,
                textAlign: TextAlign.center,
                style: CustomFonts.red16w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoImageState() {
    return Container(
      width: double.infinity,
      height: 326.h,
      color: CustomColors.greyColor.withValues(alpha: 0.3),
      child: Center(
        child: Text('No image available', style: CustomFonts.black16w400),
      ),
    );
  }

  Widget _buildAfterLabel() {
    return Consumer(
      builder: (context, ref, _) {
        final state = ref.watch(treatmentViewModel);
        final hasAfterImage = state.aiImage != null;

        if (!hasAfterImage) return const SizedBox.shrink();

        return Positioned(
          top: 12.h,
          right: 12.w,
          child: _buildBadge("AFTER", Colors.black.withValues(alpha: 0.6)),
        );
      },
    );
  }

  Widget _buildBeforeLabel() {
    return Consumer(
      builder: (context, ref, _) {
        final state = ref.watch(treatmentViewModel);
        final hasBeforeImage = state.capturedImage != null;

        if (!hasBeforeImage) return const SizedBox.shrink();

        return Positioned(
          top: 12.h,
          left: 12.w,
          child: _buildBadge("BEFORE", Colors.black.withValues(alpha: 0.6)),
        );
      },
    );
  }

  Widget _buildBadge(String text, Color bgColor) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Text(
        text,
        style: CustomFonts.white12w600.copyWith(
          letterSpacing: 0.8,
          fontSize: 10.sp,
        ),
      ),
    );
  }

  Widget _buildDownloadButton() {
    return Positioned(
      bottom: 12.h,
      right: 12.w,
      child: Consumer(
        builder: (context, ref, _) {
          final afterImage = ref.watch(
            treatmentViewModel.select((state) => state.aiImage),
          );
          if (afterImage == null) return const SizedBox.shrink();

          return GestureDetector(
            onTap: () => ref.read(treatmentViewModel.notifier).saveAiImage(),
            child: Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.9),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                Icons.file_download_outlined,
                color: Colors.black,
                size: 20.sp,
              ),
            ),
          );
        },
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Helper Methods
  // ---------------------------------------------------------------------------

  SelectedTreatmentAndAreasModel? _entryForTreatment(
    List<SelectedTreatmentAndAreasModel> list,
    int? treatmentId,
  ) {
    if (treatmentId == null) return null;
    return list.cast<SelectedTreatmentAndAreasModel?>().firstWhere(
          (e) => e?.treatment.id == treatmentId,
          orElse: () => null,
        );
  }

  Map<String, List<AreaData>> _getGroupedLeafAreas(List<AreaData> rootAreas) {
    final Map<String, List<AreaData>> groups = {};

    void traverse(AreaData area, String parentPath) {
      if (area.subAreas == null || area.subAreas!.isEmpty) {
        final groupName = parentPath.isEmpty ? "General Selection" : parentPath;
        groups.putIfAbsent(groupName, () => []).add(area);
      } else {
        String newPath =
            parentPath.isEmpty ? (area.name ?? '') : "$parentPath > ${area.name}";
        for (final sub in area.subAreas!) {
          traverse(sub, newPath);
        }
      }
    }

    for (final area in rootAreas) {
      traverse(area, "");
    }
    return groups;
  }

  Widget _buildFlatAreas({
    required List<AreaData> rootAreas,
    required Set<int> selectedAreaIds,
    required TreatmentData treatment,
  }) {
    final groupedLeafs = _getGroupedLeafAreas(rootAreas);
    if (groupedLeafs.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Select Treatment Area", style: CustomFonts.black16w600),
        ...groupedLeafs.entries.map((entry) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 24.h),
              Text(
                entry.key.toUpperCase(),
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: CustomColors.textGreyColor,
                  letterSpacing: 1.2,
                  fontFamily: 'Degular',
                ),
              ),
              SizedBox(height: 12.h),
              Wrap(
                direction: Axis.horizontal,
                spacing: 12.w,
                runSpacing: 12.h,
                children: entry.value.map((area) {
                  final isSelected = selectedAreaIds.contains(area.id);
                  return ServiceTypeButton(
                    imageUrl: area.image,
                    icon: area.icon,
                    text: area.name ?? '-',
                    selected: isSelected,
                    onPressed: () => _onAreaPressed(area, isSelected, treatment),
                  );
                }).toList(),
              ),
            ],
          );
        }),
      ],
    );
  }

  void _onAreaPressed(AreaData area, bool isSelected, TreatmentData treatment) {
    if (isSelected) {
      ref.read(checkoutViewModel.notifier).removeArea(area.id ?? 0);
    } else {
      final treatmentSku = treatment.globalSku ?? '';
      final areaSku = area.globalSku ?? '';

      EasyLoading.show(status: 'Fetching materials...');
      ref
          .read(treatmentViewModel.notifier)
          .getMaterials(treatmentSku: treatmentSku, areaSku: areaSku)
          .then((res) {
            EasyLoading.dismiss();
            if (res != null && res.isSuccess == true) {
              bool canAutoSelectAll = true;
              if (res.data != null) {
                final m = res.data!;
                final min = m.minQty ?? 0;
                final max = m.maxQty ?? 0;
                canAutoSelectAll = (min == max) || (max == 0);
              }

              if (canAutoSelectAll || res.data == null) {
                SelectedMaterialModel? selectedMaterial;
                if (res.data != null) {
                  final m = res.data!;
                  final max = m.maxQty ?? 0;
                  selectedMaterial = SelectedMaterialModel(
                    id: m.id ?? 0,
                    name: m.unitType ?? '',
                    selectedQuantity: max,
                    minQty: m.minQty ?? 0,
                    maxQty: max,
                  );
                }
                ref.read(checkoutViewModel.notifier).saveMaterialForArea(
                      treatment: treatment,
                      area: area,
                      material: selectedMaterial,
                    );
              } else {
                if (!context.mounted) return;
                _showMaterialBottomSheet(context, area, res.data!);
              }
            } else {
              ref.read(checkoutViewModel.notifier).addSelectedArea(area);
            }
          })
          .catchError((e) {
            EasyLoading.dismiss();
            ref.read(checkoutViewModel.notifier).addSelectedArea(area);
          });
    }
  }

  void _showMaterialBottomSheet(
    BuildContext context,
    TreatmentAreaModel area,
    MaterialData material,
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
          material: material,
          treatment: treatment,
        );
      },
    );
  }
}
