import 'responses/treatment_list_response.dart';
import 'responses/treatment_area_list_response.dart';

class SelectedMaterialModel {
  final int id;
  final String name;
  final int selectedQuantity;
  final int minQty;
  final int maxQty;

  const SelectedMaterialModel({
    required this.id,
    required this.name,
    required this.selectedQuantity,
    required this.minQty,
    required this.maxQty,
  });

  SelectedMaterialModel copyWith({
    int? id,
    String? name,
    int? selectedQuantity,
    int? minQty,
    int? maxQty,
  }) {
    return SelectedMaterialModel(
      id: id ?? this.id,
      name: name ?? this.name,
      selectedQuantity: selectedQuantity ?? this.selectedQuantity,
      minQty: minQty ?? this.minQty,
      maxQty: maxQty ?? this.maxQty,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'selected_quantity': selectedQuantity,
      'min_qty': minQty,
      'max_qty': maxQty,
    };
  }
}

class SelectedAreaModel {
  final TreatmentAreaModel target;
  final List<SelectedMaterialModel> materials;

  const SelectedAreaModel({
    required this.target,
    this.materials = const [],
  });

  SelectedAreaModel copyWith({
    TreatmentAreaModel? target,
    List<SelectedMaterialModel>? materials,
  }) {
    return SelectedAreaModel(
      target: target ?? this.target,
      materials: materials ?? this.materials,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'areas_sku': target.globalSku ?? '',
      'materials': materials.map((item) => item.toJson()).toList(),
    };
  }
}

class SelectedTreatmentAndAreasModel {
  final TreatmentData treatment;
  final List<SelectedAreaModel> selectedAreas;

  const SelectedTreatmentAndAreasModel({
    required this.treatment,
    this.selectedAreas = const [],
  });

  SelectedTreatmentAndAreasModel copyWith({
    TreatmentData? treatment,
    List<SelectedAreaModel>? selectedAreas,
  }) {
    return SelectedTreatmentAndAreasModel(
      treatment: treatment ?? this.treatment,
      selectedAreas: selectedAreas ?? this.selectedAreas,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'treatment_sku': treatment.globalSku ?? '',
      'areas': selectedAreas.map((item) => item.toJson()).toList(),
    };
  }
}
