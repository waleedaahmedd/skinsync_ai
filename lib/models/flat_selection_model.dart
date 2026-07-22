import 'selected_treatment_and_areas_model.dart';

class FlatSelectionModel {
  final int treatmentId;
  final String treatmentName;
  final int areaId;
  final String areaName;
  final SelectedMaterialModel? material;

  const FlatSelectionModel({
    required this.treatmentId,
    required this.treatmentName,
    required this.areaId,
    required this.areaName,
    this.material,
  });

  Map<String, dynamic> toJson() {
    return {
      'treatment_id': treatmentId,
      'treatment_name': treatmentName,
      'area_id': areaId,
      'area_name': areaName,
      'material': material?.toJson(),
    };
  }
}
