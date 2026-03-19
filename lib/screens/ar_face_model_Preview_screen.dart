import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:skinsync_ai/screens/explore_clinics_screen.dart';
import 'package:skinsync_ai/utills/assets.dart';
import 'package:skinsync_ai/utills/color_constant.dart';
import 'package:skinsync_ai/utills/custom_fonts.dart';
import 'package:skinsync_ai/view_models/clinlic_doctor_view_model.dart';
import 'package:skinsync_ai/widgets/grey_container.dart';
import 'package:skinsync_ai/widgets/service_type_button.dart';

import '../models/responses/treatment_sub_area_response.dart';
import '../view_models/checkout_view_model.dart';
import '../view_models/treatment_view_model.dart';

class ArFaceModelPreviewScreen extends ConsumerStatefulWidget {
  const ArFaceModelPreviewScreen({super.key});

  static const String routeName = '/ArFaceModelPreviewScreen';

  @override
  ConsumerState<ArFaceModelPreviewScreen> createState() =>
      _ArFaceModelPreviewScreenState();
}

class _ArFaceModelPreviewScreenState
    extends ConsumerState<ArFaceModelPreviewScreen> {
  bool _hasInitialized = false;

  void _maybeShowSyringeBottomSheet(
    BuildContext context,
    TreatmentSubAreaModel subArea,
  ) {
    final minSyringe = subArea.minSyringe ?? 0;
    final maxSyringe = subArea.maxSyringe ?? 0;

    final minValue = minSyringe.toDouble();
    final maxValue = maxSyringe.toDouble();
    final divisions = (maxSyringe - minSyringe);
    if (divisions <= 0) return;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (context) {
        return SafeArea(
          top: false,
          child: Padding(
            padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 20.h),
            child: Consumer(
              builder: (context, ref, _) {
                final current =
                    ref.watch(treatmentViewModel.select((s) => s.syringeLevel));
                final level = (current ?? minSyringe).clamp(minSyringe, maxSyringe);

                WidgetsBinding.instance.addPostFrameCallback((_) {
                  final latest = ref.read(treatmentViewModel).syringeLevel;
                  if (latest == null || latest != level) {
                    ref
                        .read(treatmentViewModel.notifier)
                        .updateSyringeLevel(level);
                  }
                });

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 44.w,
                        height: 5.h,
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(100.r),
                        ),
                      ),
                    ),
                    SizedBox(height: 14.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Adjustable Parameters',
                          style: CustomFonts.black18w600,
                        ),
                        Text(
                          '$level Syringe${level > 1 ? 's' : ''}',
                          style: CustomFonts.black14w500,
                        ),
                      ],
                    ),
                    Slider(
                      activeColor: CustomColors.lightBlueColor,
                      value: level.toDouble(),
                      min: minValue,
                      max: maxValue,
                      divisions: divisions,
                      label: '$level',
                      onChanged: (v) {
                        final next = v.round().clamp(minSyringe, maxSyringe);
                        ref
                            .read(treatmentViewModel.notifier)
                            .updateSyringeLevel(next);
                        ref
                            .read(treatmentViewModel.notifier)
                            .callPredictAPI(syringeLevel: next);
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   if(ref.watch(treatmentViewModel).treatmentId != null){
    //     ref.read(treatmentViewModel.notifier).callPredictAPI();
    //   }
    // });
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
              appBar: AppBar(
                leadingWidth: 80.w,
                centerTitle: false,
                leading: Padding(
                  padding: EdgeInsets.only(left: 10.w),
                  child: InkWell(
                    onTap: () => Navigator.pop(context),
                    child: GreyContainer(
                      icon: Icons.arrow_back,
                      shape: BoxShape.circle,
                      onTap: () => Navigator.pop(context),
                    ),
                  ),
                ),
                title: Text(
                  "AR Face Model Preview",
                  style: CustomFonts.black26w600,
                ),
                actions: [
                  Padding(
                    padding: EdgeInsets.only(right: 13.w),
                    child: InkWell(
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
                  ),
                ],
              ),
              body: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20.h),
                    _facePreview(),

                    // SizedBox(height: 18.h),
                    // _accuracyRate(),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.0.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 36.h),
                              Text(
                                'Treatment Selection',
                                style: CustomFonts.black18w600,
                              ),
                              SizedBox(height: 8.h),
                              Consumer(
                                builder: (context, ref, _) {
                                  // Use select to watch only specific parts of the state
                                  final isLoading = ref.watch(
                                    treatmentViewModel.select(
                                      (state) => state.treatmentsLoading,
                                    ),
                                  );
                                  final treatments = ref.watch(
                                    treatmentViewModel.select(
                                      (state) =>
                                          state.treatmentResponse?.data ?? [],
                                    ),
                                  );
                                  final selectedTreatment = ref.watch(
                                    treatmentViewModel.select(
                                      (state) => state.selectedTreatment,
                                    ),
                                  );
                                  final treatmentResponse = ref.watch(
                                    treatmentViewModel.select(
                                      (state) => state.treatmentResponse,
                                    ),
                                  );

                                  if (!isLoading && treatmentResponse == null) {
                                    WidgetsBinding.instance
                                        .addPostFrameCallback((_) {
                                          ref
                                              .read(treatmentViewModel.notifier)
                                              .getTreatments();
                                        });
                                  }

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

                                  return AnimationLimiter(
                                    key: const ValueKey('treatments_list'),
                                    child: Wrap(
                                      direction: Axis.horizontal,
                                      spacing: 12.w,
                                      runSpacing: 12.h,
                                      children: List.generate(treatments.length, (
                                        index,
                                      ) {
                                        return AnimationConfiguration.staggeredList(
                                          position: index,
                                          duration: const Duration(
                                            milliseconds: 800,
                                          ),
                                          child: SlideAnimation(
                                            horizontalOffset: 100.0,
                                            child: FadeInAnimation(
                                              child: ServiceTypeButton(
                                                icon: PngAssets.syringe,
                                                text: treatments[index].name!,
                                                selected:
                                                    selectedTreatment?.id ==
                                                    treatments[index].id,
                                                onPressed: () {
                                                  ref
                                                      .read(
                                                        treatmentViewModel
                                                            .notifier,
                                                      )
                                                      .onTapTreatment(
                                                        treatmentModel:
                                                            treatments[index],
                                                        isCallPredictAPI: true,
                                                      );
                                                },
                                              ),
                                            ),
                                          ),
                                        );
                                      }),
                                    ),
                                  );
                                },
                              ),
                              SizedBox(height: 30.h),
                              Consumer(
                                builder: (context, ref, _) {
                                  final isLoading = ref.watch(
                                    treatmentViewModel.select(
                                      (state) => state.treatmentAreaLoading,
                                    ),
                                  );
                                  final treatmentsArea = ref.watch(
                                    treatmentViewModel.select(
                                      (state) =>
                                          state.treatmentAreaResponse?.data ??
                                          [],
                                    ),
                                  );
                                  final selectedArea = ref.watch(
                                    treatmentViewModel.select(
                                      (state) => state.selectTreatmentArea,
                                    ),
                                  );

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
                                  if (treatmentsArea.isNotEmpty) {
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Area Selection',
                                          style: CustomFonts.black18w600,
                                        ),
                                        SizedBox(height: 8.h),
                                        AnimationLimiter(
                                          key: const ValueKey('area_list'),
                                          child: Wrap(
                                            direction: Axis.horizontal,
                                            spacing: 12.w,
                                            runSpacing: 12.h,
                                            children: List.generate(
                                              treatmentsArea.length,
                                              (index) {
                                                return AnimationConfiguration.staggeredList(
                                                  position: index,
                                                  duration: const Duration(
                                                    milliseconds: 800,
                                                  ),
                                                  child: SlideAnimation(
                                                    horizontalOffset: 100.0,
                                                    child: FadeInAnimation(
                                                      child: ServiceTypeButton(
                                                        icon: PngAssets.syringe,
                                                        text:
                                                            treatmentsArea[index]
                                                                .name!,
                                                        selected:
                                                            selectedArea?.id ==
                                                            treatmentsArea[index]
                                                                .id,
                                                        onPressed: () {
                                                          ref
                                                              .read(
                                                                treatmentViewModel
                                                                    .notifier,
                                                              )
                                                              .onTapTreatmentArea(
                                                                treatmentArea:
                                                                    treatmentsArea[index],
                                                                isCallPredictAPI:
                                                                    true,
                                                              );
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 30.h),
                                      ],
                                    );
                                  }
                                  return SizedBox();
                                },
                              ),
                              Consumer(
                                builder: (context, ref, _) {
                                  final isLoading = ref.watch(
                                    treatmentViewModel.select(
                                      (state) => state.treatmentSubAreaLoading,
                                    ),
                                  );
                                  final treatmentsSubArea = ref.watch(
                                    treatmentViewModel.select(
                                      (state) =>
                                          state
                                              .treatmentsSubAreaResponse
                                              ?.data ??
                                          [],
                                    ),
                                  );
                                  final List<TreatmentSubAreaModel>
                                  selectedSubAreas = ref.watch(
                                    treatmentViewModel.select(
                                      (state) => state.selectedSubAreasList,
                                    ),
                                  );

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
                                  if (treatmentsSubArea.isNotEmpty) {
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Sub Area Selection',
                                          style: CustomFonts.black18w600,
                                        ),
                                        SizedBox(height: 8.h),
                                        AnimationLimiter(
                                          key: const ValueKey('sub_area_list'),
                                          child: Wrap(
                                            direction: Axis.horizontal,
                                            spacing: 12.w,
                                            runSpacing: 12.h,
                                            children: List.generate(treatmentsSubArea.length, (
                                              index,
                                            ) {
                                              return AnimationConfiguration.staggeredList(
                                                position: index,
                                                duration: const Duration(
                                                  milliseconds: 800,
                                                ),
                                                child: SlideAnimation(
                                                  horizontalOffset: 100.0,
                                                  child: FadeInAnimation(
                                                    child: ServiceTypeButton(
                                                      icon: PngAssets.syringe,
                                                      text:
                                                          treatmentsSubArea[index]
                                                              .name!,
                                                      selected: selectedSubAreas.any(
                                                        (e) =>
                                                            e.id ==
                                                            treatmentsSubArea[index]
                                                                .id,
                                                      ),
                                                      onPressed: () {
                                                        final subArea =
                                                            treatmentsSubArea[index];
                                                        final options =
                                                            subArea.syringeOptions ??
                                                            const <int>[];
                                                        final minSyringe =
                                                            subArea.minSyringe ??
                                                            0;
                                                        final maxSyringe =
                                                            subArea.maxSyringe ??
                                                            0;

                                                        ref
                                                            .read(
                                                              treatmentViewModel
                                                                  .notifier,
                                                            )
                                                            .onTapTreatmentSubArea(
                                                              treatmentSubArea:
                                                                  subArea,
                                                              isCallPredictAPI:
                                                                  false,
                                                            );

                                                        int initialLevel = 0;
                                                        if (minSyringe == 0 &&
                                                            maxSyringe == 0) {
                                                          initialLevel = 0;
                                                        } else if (options.length ==
                                                            1) {
                                                          initialLevel =
                                                              options.first;
                                                        } else {
                                                          initialLevel =
                                                              minSyringe;
                                                        }

                                                        ref
                                                            .read(
                                                              treatmentViewModel
                                                                  .notifier,
                                                            )
                                                            .updateSyringeLevel(
                                                              initialLevel,
                                                            );
                                                        ref
                                                            .read(
                                                              treatmentViewModel
                                                                  .notifier,
                                                            )
                                                            .callPredictAPI(
                                                              syringeLevel:
                                                                  initialLevel,
                                                            );

                                                        if (!(minSyringe == 0 &&
                                                                maxSyringe ==
                                                                    0) &&
                                                            options.length >
                                                                1) {
                                                          _maybeShowSyringeBottomSheet(
                                                            context,
                                                            subArea,
                                                          );
                                                        }
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }),
                                          ),
                                        ),
                                        SizedBox(height: 20.h),
                                      ],
                                    );
                                  }
                                  return SizedBox();
                                },
                              ),
                              Consumer(
                                builder: (context, ref, _) {
                                  final treatment = ref.watch(
                                    treatmentViewModel.select(
                                      (s) => s.selectedTreatment,
                                    ),
                                  );
                                  final selectedSubAreas = ref.watch(
                                    treatmentViewModel.select(
                                      (s) => s.selectedSubAreasList,
                                    ),
                                  );

                                  if (selectedSubAreas.isEmpty) {
                                    return const SizedBox.shrink();
                                  }

                                  return Container(
                                    width: double.infinity,
                                    padding: EdgeInsets.all(14.w),
                                    margin: EdgeInsets.only(bottom: 16.h),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(alpha: 0.85),
                                      borderRadius: BorderRadius.circular(16.r),
                                      border: Border.all(
                                        color: Colors.black.withValues(alpha: 0.06),
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Selected Treatment',
                                          style: CustomFonts.black14w500,
                                        ),
                                        SizedBox(height: 4.h),
                                        Text(
                                          treatment?.name ?? '-',
                                          style: CustomFonts.black18w600,
                                        ),
                                        SizedBox(height: 12.h),
                                        Text(
                                          'Selected Sub Areas',
                                          style: CustomFonts.black14w500,
                                        ),
                                        SizedBox(height: 8.h),
                                        Wrap(
                                          spacing: 8.w,
                                          runSpacing: 8.h,
                                          children: selectedSubAreas.map((e) {
                                            final name = e.name ?? '-';
                                            return Container(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 12.w,
                                                vertical: 8.h,
                                              ),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(999.r),
                                                border: Border.all(
                                                  color: Colors.black.withValues(
                                                    alpha: 0.08,
                                                  ),
                                                ),
                                              ),
                                              child: Text(
                                                name,
                                                style: CustomFonts.black14w500,
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                              if (ref
                                  .watch(treatmentViewModel)
                                  .selectedSubAreasList
                                  .isNotEmpty)
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
                  final image = ref.watch(
                    treatmentViewModel.select(
                      (state) =>
                          state.isBefore ? state.capturedImage : state.aiImage,
                    ),
                  );

                  final errorMessage = ref.watch(
                    treatmentViewModel.select((state) => state.errorMessage),
                  );

                  if (errorMessage != null && image == null) {
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
                            Text(
                              'Error',
                              style: CustomFonts.black20w600.copyWith(
                                color: Colors.red,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.w),
                              child: Text(
                                errorMessage,
                                textAlign: TextAlign.center,
                                style: CustomFonts.black16w400.copyWith(
                                  color: Colors.red.shade700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  if (image != null) {
                    return Image.file(
                      File(image.path),
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
                  final isBefore = ref.watch(
                    treatmentViewModel.select((state) => state.isBefore),
                  );
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
                  return GestureDetector(
                    onTap: () {
                      ref.read(treatmentViewModel.notifier).toggleIsBefore();
                    },
                    child: CircleAvatar(
                      backgroundColor: CustomColors.greyColor,
                      child: Image.asset(PngAssets.beforeAfter, width: 18.w),
                    ),
                  );
                },
              ),
            ),

            // Positioned(
            //   bottom: 16.h,
            //   left: 16.w,
            //   right: 16.w,
            //   child: Container(
            //     padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 8.w),
            //     decoration: BoxDecoration(
            //       color: CustomColors.blackColor,
            //       borderRadius: BorderRadius.circular(20),
            //     ),
            //     child: Text(
            //       'See How 2 Syringes Will Look On Your Under Eyes',
            //       textAlign: TextAlign.center,
            //       style: CustomFonts.white14w600,
            //     ),
            //   ),
            // ),
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
        return Padding(
          padding:  EdgeInsets.only(bottom: MediaQuery.paddingOf(context).bottom + 20.0.h),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 19.h),
                  ),
                  child: Text('Save', style: CustomFonts.black22w600),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    final treatment = ref.read(
                      treatmentViewModel.select(
                        (state) => state.selectedTreatment,
                      ),
                    );
                    final area = ref.read(
                      treatmentViewModel.select(
                        (state) => state.selectTreatmentArea,
                      ),
                    );
                    final subAreas = ref.read(
                      treatmentViewModel.select(
                        (state) => state.selectedSubAreasList,
                      ),
                    );

                    final treatmentId = treatment?.id;
                    final areaId = area?.id;
                    final subAreaIds = subAreas
                        .map((e) => e.id)
                        .whereType<int>()
                        .toList();

                    ref
                        .read(checkoutViewModel.notifier)
                        .updateState(treatmentId: treatmentId);
                    ref
                        .read(checkoutViewModel.notifier)
                        .updateState(treatmentAreaId: areaId);
                    ref
                        .read(checkoutViewModel.notifier)
                        .updateState(treatmentSubAreaId: subAreaIds);
                    ref
                        .read(clincDoctorProvider.notifier)
                        .getClinic(
                          treatmentId: treatmentId ?? 0,
                          sideAreaIds: subAreaIds,
                        );
                        ref.read(checkoutViewModel.notifier).setSelectedTreamtment(treatment: treatment!, selectedSubAreasList: subAreas);
                    Navigator.pushNamed(context, ExploreClinicsScreen.routeName);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 19.h),
                  ),
                  child: Text('Explore Clinics', style: CustomFonts.white22w600),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
