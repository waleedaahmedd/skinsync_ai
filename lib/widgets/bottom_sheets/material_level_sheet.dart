import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../models/responses/materials_response.dart';
import '../../models/responses/treatment_area_list_response.dart';
import '../../models/responses/treatment_list_response.dart';
import '../../models/selected_treatment_and_areas_model.dart';
import '../../utills/color_constant.dart';
import '../../utills/custom_fonts.dart';
import '../../view_models/checkout_view_model.dart';
import '../custom_button.dart';

class MaterialLevelSheet extends ConsumerStatefulWidget {
  final TreatmentAreaModel area;
  final MaterialData material;
  final TreatmentData treatment;

  const MaterialLevelSheet({
    super.key,
    required this.area,
    required this.material,
    required this.treatment,
  });

  @override
  ConsumerState<MaterialLevelSheet> createState() => _MaterialLevelSheetState();
}

class _MaterialLevelSheetState extends ConsumerState<MaterialLevelSheet> {
  int _selectedQuantity = 0;

  @override
  void initState() {
    super.initState();
    _initializeQuantity();
  }

  void _initializeQuantity() {
    final checkoutState = ref.read(checkoutViewModel);
    final existingTreatment = checkoutState.selectedTreatmentsAndAreas
        .where((item) => item.treatment.id == widget.treatment.id)
        .firstOrNull;

    final existingArea = existingTreatment?.selectedAreas
        .where((a) => a.target.id == widget.area.id)
        .firstOrNull;

    final existingMaterial = existingArea?.materials
        .where((m) => m.id == widget.material.id)
        .firstOrNull;

    if (existingMaterial != null) {
      _selectedQuantity = existingMaterial.selectedQuantity;
    } else {
      _selectedQuantity = widget.material.minQty ?? 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final material = widget.material;
    final min = material.minQty ?? 0;
    final max = material.maxQty ?? 0;
    final isFixed = min == max || max == 0;

    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 24.h),
        child: Column(
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
            SizedBox(height: 16.h),
            Text("Adjust Material", style: CustomFonts.black18w600),
            SizedBox(height: 4.h),
            Text(
              "Select quantity for ${widget.area.name ?? 'this area'}",
              style: CustomFonts.grey12w400,
            ),
            SizedBox(height: 20.h),
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          material.unitType ?? "Material",
                          style: CustomFonts.black14w600,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: CustomColors.purpleColor.withValues(
                            alpha: 0.1,
                          ),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Text(
                          "Qty: $_selectedQuantity",
                          style: CustomFonts.black12w600.copyWith(
                            color: CustomColors.purpleColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (!isFixed) ...[
                    SizedBox(height: 8.h),
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        trackHeight: 4.h,
                        thumbShape: RoundSliderThumbShape(
                          enabledThumbRadius: 8.w,
                        ),
                        overlayShape: RoundSliderOverlayShape(
                          overlayRadius: 16.w,
                        ),
                      ),
                      child: Slider(
                        activeColor: CustomColors.purpleColor,
                        inactiveColor: Colors.grey.shade300,
                        value: _selectedQuantity.toDouble(),
                        min: min.toDouble(),
                        max: max.toDouble(),
                        divisions: max - min > 0 ? max - min : 1,
                        label: "$_selectedQuantity",
                        onChanged: (value) {
                          setState(() {
                            _selectedQuantity = value.round();
                          });
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Min: $min", style: CustomFonts.grey12w400),
                          Text("Max: $max", style: CustomFonts.grey12w400),
                        ],
                      ),
                    ),
                  ] else ...[
                    SizedBox(height: 8.h),
                    Text(
                      "Fixed quantity requirement",
                      style: CustomFonts.grey12w400.copyWith(
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            SizedBox(height: 24.h),
            CustomButton(
              text: "Apply Selection",
              borderRadius: 26.r,
              backgroundColor: Colors.black,
              textColor: Colors.white,
              onPressed: () {
                final selectedMaterial = SelectedMaterialModel(
                  id: material.id ?? 0,
                  name: material.unitType ?? "Material",
                  selectedQuantity: _selectedQuantity,
                  minQty: material.minQty ?? 0,
                  maxQty: material.maxQty ?? 0,
                );

                ref.read(checkoutViewModel.notifier).saveMaterialsForArea(
                  treatment: widget.treatment,
                  area: widget.area,
                  materials: [selectedMaterial],
                );

                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
