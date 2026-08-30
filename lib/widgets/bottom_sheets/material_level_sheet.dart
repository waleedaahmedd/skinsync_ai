import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../../models/responses/materials_response.dart';
import '../../models/responses/treatment_area_list_response.dart';
import '../../models/responses/treatment_list_response.dart';
import '../../models/selected_treatment_and_areas_model.dart';
import '../../utils/color_constant.dart';
import '../../utils/custom_fonts.dart';
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

    final existingMaterial = existingArea?.material?.id == widget.material.id
        ? existingArea?.material
        : null;

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
        padding: EdgeInsets.fromLTRB(
          context.w(24),
          context.h(16),
          context.w(24),
          context.h(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: context.w(44),
                height: context.h(5),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(context.r(100)),
                ),
              ),
            ),
            SizedBox(height: context.h(16)),
            Text("Adjust Material", style: CustomFonts.black18w600),
            SizedBox(height: context.h(4)),
            Text(
              "Select quantity for ${widget.area.name ?? 'this area'}",
              style: CustomFonts.grey12w400,
            ),
            SizedBox(height: context.h(20)),
            Container(
              padding: EdgeInsets.all(context.w(16)),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(context.r(16)),
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
                          horizontal: context.w(12),
                          vertical: context.h(4),
                        ),
                        decoration: BoxDecoration(
                          color: CustomColors.purpleColor.withValues(
                            alpha: 0.1,
                          ),
                          borderRadius: BorderRadius.circular(context.r(12)),
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
                    SizedBox(height: context.h(8)),
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        trackHeight: context.h(4),
                        thumbShape: RoundSliderThumbShape(
                          enabledThumbRadius: context.w(8),
                        ),
                        overlayShape: RoundSliderOverlayShape(
                          overlayRadius: context.w(16),
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
                      padding: EdgeInsets.symmetric(horizontal: context.w(8)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Min: $min", style: CustomFonts.grey12w400),
                          Text("Max: $max", style: CustomFonts.grey12w400),
                        ],
                      ),
                    ),
                  ] else ...[
                    SizedBox(height: context.h(8)),
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
            SizedBox(height: context.h(24)),
            CustomButton(
              text: "Apply Selection",
              borderRadius: context.r(26),
              onPressed: () {
                final selectedMaterial = SelectedMaterialModel(
                  id: material.id ?? 0,
                  name: material.unitType ?? "Material",
                  selectedQuantity: _selectedQuantity,
                  minQty: material.minQty ?? 0,
                  maxQty: material.maxQty ?? 0,
                );

                ref
                    .read(checkoutViewModel.notifier)
                    .saveMaterialForArea(
                      treatment: widget.treatment,
                      area: widget.area,
                      material: selectedMaterial,
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
