class SaveHistoryRequest {
  final String beforeImage;
  final String afterImage;
  final List<HistoryTreatmentRequest> treatments;

  const SaveHistoryRequest({
    required this.beforeImage,
    required this.afterImage,
    required this.treatments,
  });

  Map<String, dynamic> toJson() {
    return {
      'before_image': beforeImage,
      'after_image': afterImage,
      'treatments': treatments.map((e) => e.toJson()).toList(),
    };
  }
}

class HistoryTreatmentRequest {
  final int treatmentId;
  final String treatmentName;
  final List<HistoryAreaRequest> areas;

  const HistoryTreatmentRequest({
    required this.treatmentId,
    required this.treatmentName,
    required this.areas,
  });

  Map<String, dynamic> toJson() {
    return {
      'treatment_id': treatmentId,
      'treatment_name': treatmentName,
      'areas': areas.map((e) => e.toJson()).toList(),
    };
  }
}

class HistoryAreaRequest {
  final String areaId;
  final String areaName;
  final List<HistoryMaterialRequest> materials;

  const HistoryAreaRequest({
    required this.areaId,
    required this.areaName,
    required this.materials,
  });

  Map<String, dynamic> toJson() {
    return {
      'area_id': areaId,
      'area_name': areaName,
      'materials': materials.map((e) => e.toJson()).toList(),
    };
  }
}

class HistoryMaterialRequest {
  final int id;
  final String name;
  final int selectedQuantity;

  const HistoryMaterialRequest({
    required this.id,
    required this.name,
    required this.selectedQuantity,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'selected_quantity': selectedQuantity,
    };
  }
}
