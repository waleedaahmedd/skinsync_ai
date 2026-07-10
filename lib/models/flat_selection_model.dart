import 'selected_treatment_and_areas_model.dart';

class FlatSelectionModel {
  final int treatmentId;
  final String treatmentName;
  final int areaId;
  final String areaName;
  final List<SelectedMaterialModel> materials;

  const FlatSelectionModel({
    required this.treatmentId,
    required this.treatmentName,
    required this.areaId,
    required this.areaName,
    required this.materials,
  });

  Map<String, dynamic> toJson() {
    return {
      'treatment_id': treatmentId,
      'treatment_name': treatmentName,
      'area_id': areaId,
      'area_name': areaName,
      'materials': materials.map((m) => m.toJson()).toList(),
    };
  }
}
