import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../models/responses/treatment_sub_area_response.dart';

import '../../utills/color_constant.dart';
import '../../utills/custom_fonts.dart';
import '../../view_models/treatment_view_model.dart';

class SyringeLevelSheet extends StatefulWidget {
  final TreatmentSubAreaModel subArea;
  const SyringeLevelSheet({super.key, required this.subArea});

  @override
  State<SyringeLevelSheet> createState() => _SyringeLevelSheetState();
}

class _SyringeLevelSheetState extends State<SyringeLevelSheet> {
  bool _ignoreSlider = false;

  @override
  void initState() {
    super.initState();
    EasyLoading.addStatusCallback(_callback);
  }

  void _callback(EasyLoadingStatus status) {
    if (status == EasyLoadingStatus.show) {
      setState(() {
        _ignoreSlider = true;
      });
    } else {
      setState(() {
        _ignoreSlider = false;
      });
    }
  }

  @override
  void dispose() {
    EasyLoading.removeCallback(_callback);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final minSyringe = widget.subArea.minSyringe ?? 0;
    final maxSyringe = widget.subArea.maxSyringe ?? 0;

    final minValue = minSyringe.toDouble();
    final maxValue = maxSyringe.toDouble();
    final divisions = (maxSyringe - minSyringe);
    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 20.h),
        child: Consumer(
          builder: (context, ref, _) {
            final subArea = ref.watch(
              treatmentViewModel.select((s) {
                for (final subArea in s.selectedSubAreasList) {
                  if (subArea.id == widget.subArea.id) return subArea;
                }
                return null;
              }),
            );
            final level =
                subArea?.currentSyringe ?? widget.subArea.currentSyringe;
            log('MIN: $minValue MAX: $maxValue CURRENT: $level');
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
                IgnorePointer(
                  ignoring: _ignoreSlider,
                  child: Slider(
                    activeColor: CustomColors.lightBlueColor,
                    value: level.toDouble(),
                    min: minValue,
                    max: maxValue,
                    divisions: divisions,
                    label: '$level',
                    onChanged: (v) {
                      final next = v.round().clamp(minSyringe, maxSyringe);
                      log('CHANGED: $v $next');
                      final updatedSubArea = widget.subArea.copyWith(
                        currentSyringe: next,
                      );
                      ref
                          .read(treatmentViewModel.notifier)
                          .updateSyringeLevel(subArea: updatedSubArea);
                      // ref
                      //     .read(treatmentViewModel.notifier)
                      //     .callPredictAPI();
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
