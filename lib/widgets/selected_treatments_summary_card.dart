import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../models/selected_treatment_and_areas_model.dart';
import '../utills/custom_fonts.dart';

class SelectedTreatmentsSummaryCard extends StatelessWidget {
  final List<SelectedTreatmentAndAreasModel> selectedTreatmentsAndAreas;
  final void Function(SelectedTreatmentAndAreasModel item)? onRemoveTreatment;
  final void Function(
    SelectedTreatmentAndAreasModel item,
    SelectedAreaModel areaItem,
  )?
  onRemoveArea;

  const SelectedTreatmentsSummaryCard({
    super.key,
    required this.selectedTreatmentsAndAreas,
    this.onRemoveTreatment,
    this.onRemoveArea,
  });

  @override
  Widget build(BuildContext context) {
    if (selectedTreatmentsAndAreas.isEmpty) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: 230.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: selectedTreatmentsAndAreas.length,
        itemBuilder: (context, index) {
          final item = selectedTreatmentsAndAreas[index];
          final treatment = item.treatment;
          final areas = item.selectedAreas;

          // Group and sum materials by ID/name for aggregate view under this treatment
          final Map<int, SelectedMaterialModel> groupedMaterials = {};
          for (final areaItem in areas) {
            for (final m in areaItem.materials) {
              if (groupedMaterials.containsKey(m.id)) {
                groupedMaterials[m.id] = groupedMaterials[m.id]!.copyWith(
                  selectedQuantity:
                      groupedMaterials[m.id]!.selectedQuantity +
                      m.selectedQuantity,
                );
              } else {
                groupedMaterials[m.id] = m;
              }
            }
          }
          // final materialsList = groupedMaterials.values.toList();

          return Container(
            width: 260.w,
            margin: EdgeInsets.only(right: 16.w, bottom: 16.h),
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24.r),
              border: Border.all(
                color: Colors.black.withValues(alpha: 0.12),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.015),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Selected Treatment',
                            style: CustomFonts.black10w600.copyWith(
                              color: Colors.grey.shade500,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            treatment.name ?? '-',
                            style: CustomFonts.black16w600,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    if (onRemoveTreatment != null)
                      GestureDetector(
                        onTap: () => onRemoveTreatment!(item),
                        child: Icon(
                          Icons.cancel_rounded,
                          size: 20,
                          color: Colors.red.shade400,
                        ),
                      ),
                  ],
                ),
                const Divider(height: 16, color: Colors.black12),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Selected Areas',
                          style: CustomFonts.black10w600.copyWith(
                            color: Colors.grey.shade500,
                          ),
                        ),
                        SizedBox(height: 6.h),
                        areas.isEmpty
                            ? Center(
                                child: Text(
                                  "No areas selected",
                                  style: CustomFonts.grey12w400,
                                ),
                              )
                            : Wrap(
                                spacing: 6.w,
                                runSpacing: 6.h,
                                children: areas.map((areaItem) {
                                  final materialInfo =
                                      areaItem.materials.isNotEmpty
                                      ? " (${areaItem.materials.map((m) => '${m.selectedQuantity} ${m.name}').join(', ')})"
                                      : "";

                                  return Chip(
                                    visualDensity: VisualDensity.compact,
                                    label: Text(
                                      "${areaItem.target.name ?? '-'}$materialInfo",
                                      style: CustomFonts.black10w600,
                                    ),
                                    onDeleted: onRemoveArea != null
                                        ? () => onRemoveArea!(item, areaItem)
                                        : null,
                                    deleteIconColor: Colors.red.shade300,
                                  );
                                }).toList(),
                              ),
                        // Removed redundant materials section as requested
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
