import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:skinsync_ai/screens/explore_clinics_screen.dart';
import 'package:skinsync_ai/utills/assets.dart';
import 'package:skinsync_ai/utills/color_constant.dart';
import 'package:skinsync_ai/utills/custom_fonts.dart';
import 'package:skinsync_ai/view_models/face_scan_provider.dart';
import 'package:skinsync_ai/widgets/grey_container.dart';
import 'package:skinsync_ai/widgets/service_type_button.dart';

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
  final List<int> _sliderValues = [1, 2, 3, 4];
  int _currentSliderIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if(ref.watch(treatmentViewModel).treatmentId != null){
        ref.read(treatmentViewModel.notifier).callPredictAPI();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_hasInitialized) {
      _hasInitialized = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final state = ref.read(faceScanProvider);
        if (!state.isBefore) {
          ref.read(faceScanProvider.notifier).toggleIsBefore();
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
          title: Text("AR Face Model Preview", style: CustomFonts.black26w600),
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 13.w),
              child: Text("Reset", style: CustomFonts.pinkunderlined20w600),
            ),
          ],
        ),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _facePreview(),
              SizedBox(height: 18.h),
              _accuracyRate(),

              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding:  EdgeInsets.symmetric(horizontal: 20.0.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 36.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Adjustable Parameters:', style: CustomFonts.black18w600),
                            Text(
                              '${_sliderValues[_currentSliderIndex]} Syringe${_sliderValues[_currentSliderIndex] > 1 ? 's' : ''}',
                              style: CustomFonts.black14w500,
                            ),
                          ],
                        ),
                        Consumer(
                          builder: (context, ref, _) {
                            return Slider(
                              activeColor: CustomColors.lightBlueColor,
                              value: _currentSliderIndex.toDouble(),
                              min: 0,
                              max: _sliderValues.length - 1,
                              divisions: _sliderValues.length - 1,
                              label: '${_sliderValues[_currentSliderIndex]}',
                              onChanged: (double value) {
                                setState(() {
                                  _currentSliderIndex = value.round();
                                });
                                final syringeLevel = _sliderValues[_currentSliderIndex];
                                ref.read(treatmentViewModel.notifier).updateSyringeLevel(syringeLevel);
                                ref.read(treatmentViewModel.notifier).callPredictAPI(syringeLevel: syringeLevel);
                              },
                            );
                          },
                        ),
                        Text('Treatment Selection', style: CustomFonts.black18w600),
                        SizedBox(height: 8.h),
                        Consumer(
                          builder: (context, ref, _) {
                            // Use select to watch only specific parts of the state
                            final isLoading = ref.watch(
                              treatmentViewModel.select((state) => state.treatmentsLoading),
                            );
                            final treatments = ref.watch(
                              treatmentViewModel.select((state) => state.treatmentResponse?.data ?? []),
                            );
                            final treatmentId = ref.watch(
                              treatmentViewModel.select((state) => state.treatmentId),
                            );
                            final treatmentResponse = ref.watch(
                              treatmentViewModel.select((state) => state.treatmentResponse),
                            );

                            if (!isLoading && treatmentResponse == null) {
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                ref.read(treatmentViewModel.notifier).getTreatments();
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
                                children: List.generate(treatments.length, (index) {
                                  return AnimationConfiguration.staggeredList(
                                    position: index,
                                    duration: const Duration(milliseconds: 800),
                                    child: SlideAnimation(
                                      horizontalOffset: 100.0,
                                      child: FadeInAnimation(
                                        child: ServiceTypeButton(
                                          icon: PngAssets.syringe,
                                          text: treatments[index].name!,
                                          selected: treatmentId == treatments[index].id,
                                          onPressed: () {
                                            ref
                                                .read(treatmentViewModel.notifier)
                                                .onTapTreatment(
                                                  treatmentModel: treatments[index], isCallPredictAPI: true,
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
                        SizedBox(height: 50.h),
                        Consumer(
                          builder: (context, ref, _) {
                            final isLoading = ref.watch(
                              treatmentViewModel.select((state) => state.treatmentAreaLoading),
                            );
                            final treatmentsArea = ref.watch(
                              treatmentViewModel.select((state) => state.treatmentAreaResponse?.data ?? []),
                            );
                            final selectSectionId = ref.watch(
                              treatmentViewModel.select((state) => state.selectSectionId),
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
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                      children: List.generate(treatmentsArea.length, (
                                        index,
                                      ) {
                                        return AnimationConfiguration.staggeredList(
                                          position: index,
                                          duration: const Duration(milliseconds: 800),
                                          child: SlideAnimation(
                                            horizontalOffset: 100.0,
                                            child: FadeInAnimation(
                                              child: ServiceTypeButton(
                                                icon: PngAssets.syringe,
                                                text: treatmentsArea[index].name!,
                                                selected: selectSectionId == treatmentsArea[index].id,
                                                onPressed: () {
                                                  ref
                                                      .read(treatmentViewModel.notifier)
                                                      .onTapTreatmentArea(
                                                        treatmentArea: treatmentsArea[index], isCallPredictAPI: true,
                                                      );
                                                },
                                              ),
                                            ),
                                          ),
                                        );
                                      }),
                                    ),
                                  ),
                                  SizedBox(height: 50.h),
                                ],
                              );
                            }
                            return SizedBox();
                          },
                        ),
                        Consumer(
                          builder: (context, ref, _) {
                            final isLoading = ref.watch(
                              treatmentViewModel.select((state) => state.treatmentSubAreaLoading),
                            );
                            final treatmentsSubArea = ref.watch(
                              treatmentViewModel.select((state) => state.treatmentsSubAreaResponse?.data ?? []),
                            );
                            final subSectionId = ref.watch(
                              treatmentViewModel.select((state) => state.subSectionId),
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
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                      children: List.generate(
                                        treatmentsSubArea.length,
                                        (index) {
                                          return AnimationConfiguration.staggeredList(
                                            position: index,
                                            duration: const Duration(milliseconds: 800),
                                            child: SlideAnimation(
                                              horizontalOffset: 100.0,
                                              child: FadeInAnimation(
                                                child: ServiceTypeButton(
                                                  icon: PngAssets.syringe,
                                                  text: treatmentsSubArea[index].name!,
                                                  selected: subSectionId == treatmentsSubArea[index].id,
                                                  onPressed: () {
                                                    ref
                                                        .read(treatmentViewModel.notifier)
                                                        .onTapTreatmentSubArea(
                                                          treatmentSubArea: treatmentsSubArea[index], isCallPredictAPI: true,
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
                                  SizedBox(height: 50.h),
                                ],
                              );
                            }
                            return SizedBox();
                          },
                        ),
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
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(20.r),
          child: Consumer(
            builder: (context, ref, _) {
              final image = ref.watch(
                faceScanProvider.select(
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
                    borderRadius: BorderRadius.circular(20.r),
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
                  fit: BoxFit.fitHeight,
                  width: double.infinity,
                  height: 326.h,
                );
              }

              return Container(
                width: double.infinity,
                height: 326.h,
                color: CustomColors.greyColor.withValues(alpha:0.3),
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
          top: 13.h,
          left: 23.w,
          child: Consumer(
            builder: (context, ref, _) {
              final isBefore = ref.watch(
                faceScanProvider.select((state) => state.isBefore),
              );
              return Text(
                isBefore ? 'Before' : 'After',
                style: CustomFonts.black20w600,
              );
            },
          ),
        ),
        Positioned(
          top: 13.h,
          right: 23.w,
          child: Consumer(
            builder: (context, ref, _) {
              return GestureDetector(
                onTap: () {
                  ref.read(faceScanProvider.notifier).toggleIsBefore();
                },
                child: CircleAvatar(
                  backgroundColor: CustomColors.greyColor,
                  child: Image.asset(PngAssets.beforeAfter, width: 18.w),
                ),
              );
            },
          ),
        ),

        Positioned(
          bottom: 16.h,
          left: 16.w,
          right: 16.w,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 8.w),
            decoration: BoxDecoration(
              color: CustomColors.blackColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'See How 2 Syringes Will Look On Your Under Eyes',
              textAlign: TextAlign.center,
              style: CustomFonts.white14w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _accuracyRate() {
    return Row(
      children: [
        SvgPicture.asset(SvgAssets.dail),
        SizedBox(width: 5.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Accuracy Rate', style: CustomFonts.black20w600),
            Text(
              'This score is based on your Face analysis',
              style: CustomFonts.black16w400,
            ),
          ],
        ),
      ],
    );
  }


  Widget _bottomButtons(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        return Row(
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
                  final treatmentId = ref.read(
                    treatmentViewModel.select((state) => state.treatmentId),
                  );
                  final selectSectionId = ref.read(
                    treatmentViewModel.select((state) => state.selectSectionId),
                  );
                  final subSectionId = ref.read(
                    treatmentViewModel.select((state) => state.subSectionId),
                  );

                  ref
                      .read(checkoutViewModel.notifier)
                      .updateState(treatmentId: treatmentId);
                  ref
                      .read(checkoutViewModel.notifier)
                      .updateState(treatmentAreaId: selectSectionId);
                  ref
                      .read(checkoutViewModel.notifier)
                      .updateState(treatmentSubAreaId: subSectionId);
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
        );
      },
    );
  }
}
