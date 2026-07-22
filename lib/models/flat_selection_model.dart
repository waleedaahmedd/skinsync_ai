import 'selected_treatment_and_areas_model.dart';

class FlatSelectionModel {
  final int treatmentId;
  final String treatmentName;
  final int areaId;
  final String areaName;
  final int treatmentCost;
  final SelectedMaterialModel? material;

  const FlatSelectionModel({
    required this.treatmentId,
    required this.treatmentName,
    required this.areaId,
    required this.areaName,
    required this.treatmentCost,
    this.material,
  });

  Map<String, dynamic> toJson() {
    return {
      'treatment_id': treatmentId,
      'treatment_name': treatmentName,
      'area_id': areaId,
      'area_name': areaName,
      'treatment_cost': treatmentCost,
      'material': material?.toJson(),
    };
  }
}
