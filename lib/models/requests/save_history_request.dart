class SaveHistoryRequest {
  final int treatmentId;
  final String beforeImage;
  final String afterImage;
  final List<SubSectionRequest> subSections;

  const SaveHistoryRequest({
    required this.treatmentId,
    required this.beforeImage,
    required this.afterImage,
    required this.subSections,
  });

  Map<String, dynamic> toJson() {
    return {
      'treatment_id': treatmentId,
      'before_image': beforeImage,
      'after_image': afterImage,
      'subsections': subSections.map((e) => e.toJson()).toList(),
    };
  }
}

class SubSectionRequest {
  final int areaId;
  final int sectionId;
  final int syringesQuantity;

  const SubSectionRequest({
    required this.areaId,
    required this.sectionId,
    required this.syringesQuantity,
  });

  Map<String, dynamic> toJson() {
    return {
      'area_id': areaId,
      'section_id': sectionId,
      'syringes_quantity': syringesQuantity,
    };
  }
}
