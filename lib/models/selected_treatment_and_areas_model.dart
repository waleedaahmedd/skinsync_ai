import 'responses/treatment_list_response.dart';
import 'responses/treatment_area_list_response.dart';

class SelectedTreatmentAndAreasModel {
  final TreatmentData treatment;
  final List<TreatmentAreaModel> selectedAreas;

  const SelectedTreatmentAndAreasModel({
    required this.treatment,
    this.selectedAreas = const [],
  });

  SelectedTreatmentAndAreasModel copyWith({
    TreatmentData? treatment,
    List<TreatmentAreaModel>? selectedAreas,
  }) {
    return SelectedTreatmentAndAreasModel(
      treatment: treatment ?? this.treatment,
      selectedAreas: selectedAreas ?? this.selectedAreas,
    );
  }
}
