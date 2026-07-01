import 'package:camera/camera.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/responses/treatment_list_response.dart';
import '../models/responses/treatment_category_list_response.dart';
import '../models/responses/treatment_area_list_response.dart';
import '../models/selected_treatment_and_areas_model.dart';

import 'base_view_model.dart';

final checkoutViewModel = NotifierProvider(() => CheckoutViewModel());

class CheckoutViewModel extends BaseViewModel<CheckoutState> {
  CheckoutViewModel() : super(initialState: const CheckoutState());

  @override
  CheckoutState build() {
    // Keep the provider alive to prevent disposal during navigation
    ref.keepAlive();
    return super.build();
  }

  void updateState({
    String? clinicId,
    String? drId,
    String? appointmentDate,
    String? appointmentTime,
    XFile? capturedImage,
  }) {
    print("state updated");
    state = CheckoutState(
      clinicId: clinicId ?? state.clinicId,
      drId: drId ?? state.drId,
      appointmentDate: appointmentDate ?? state.appointmentDate,
      appointmentTime: appointmentTime ?? state.appointmentTime,
      capturedImage: capturedImage ?? state.capturedImage,
      selectedTreatmentsAndAreas: state.selectedTreatmentsAndAreas,
      selectedCategories: state.selectedCategories,
      selectedTreatments: state.selectedTreatments,
      selectedAreas: state.selectedAreas,
    );
  }

  void clearState() {
    print("state Cleared");
    state = const CheckoutState(
      clinicId: null,
      drId: null,
      appointmentDate: null,
      appointmentTime: null,
      capturedImage: null,
      selectedCategories: [],
      selectedTreatments: null,
      selectedAreas: null,
      selectedTreatmentsAndAreas: [],
    );
  }

  void setSelectedTreatments(TreatmentData? treatment) {
    state = state.copyWith(selectedTreatments: treatment);
  }

  void addSelectedTreatment(TreatmentData treatment) {
    // 1. Set currently selected treatment
    final activeTreatment = treatment;

    // 2. Build the SelectedTreatmentAndAreasModel
    final currentTreatmentsAndAreas =
        List<SelectedTreatmentAndAreasModel>.from(state.selectedTreatmentsAndAreas);

    final existingIndex = currentTreatmentsAndAreas
        .indexWhere((item) => item.treatment.id == treatment.id);

    if (state.selectedAreas != null) {
      final area = state.selectedAreas!;
      if (existingIndex != -1) {
        final existingItem = currentTreatmentsAndAreas[existingIndex];
        if (!existingItem.selectedAreas.any((a) => a.id == area.id)) {
          currentTreatmentsAndAreas[existingIndex] = existingItem.copyWith(
            selectedAreas: [...existingItem.selectedAreas, area],
          );
        }
      } else {
        currentTreatmentsAndAreas.add(
          SelectedTreatmentAndAreasModel(
            treatment: treatment,
            selectedAreas: [area],
          ),
        );
      }
    } else {
      if (existingIndex == -1) {
        currentTreatmentsAndAreas.add(
          SelectedTreatmentAndAreasModel(
            treatment: treatment,
            selectedAreas: const [],
          ),
        );
      }
    }

    state = state.copyWith(
      selectedTreatments: activeTreatment,
      selectedTreatmentsAndAreas: currentTreatmentsAndAreas,
    );
    _printSelectedTreatmentsAndAreas();
  }

  void addSelectedCategory(TreatmentCategoryModel category) {
    final currentList = state.selectedCategories ?? [];
    if (!currentList.any((c) => c.id == category.id)) {
      state = state.copyWith(selectedCategories: [...currentList, category]);
    }
  }

  void setSelectedAreas(TreatmentAreaModel? area) {
    final currentTreatmentsAndAreas =
        List<SelectedTreatmentAndAreasModel>.from(state.selectedTreatmentsAndAreas);
    if (area != null && currentTreatmentsAndAreas.isNotEmpty) {
      final lastIndex = currentTreatmentsAndAreas.length - 1;
      currentTreatmentsAndAreas[lastIndex] =
          currentTreatmentsAndAreas[lastIndex].copyWith(selectedAreas: [area]);
    }

    state = state.copyWith(
      selectedAreas: area,
      selectedTreatmentsAndAreas: currentTreatmentsAndAreas,
    );
    _printSelectedTreatmentsAndAreas();
  }

  void addSelectedArea(TreatmentAreaModel area) {
    // 1. Save area in selectedAreas
    final activeArea = area;

    // 2. Sync with selectedTreatmentsAndAreas
    final currentTreatmentsAndAreas =
        List<SelectedTreatmentAndAreasModel>.from(state.selectedTreatmentsAndAreas);

    if (state.selectedTreatments != null) {
      final activeTreatment = state.selectedTreatments!;
      final existingIndex = currentTreatmentsAndAreas
          .indexWhere((item) => item.treatment.id == activeTreatment.id);

      if (existingIndex != -1) {
        final existingItem = currentTreatmentsAndAreas[existingIndex];
        if (!existingItem.selectedAreas.any((a) => a.id == area.id)) {
          currentTreatmentsAndAreas[existingIndex] = existingItem.copyWith(
            selectedAreas: [...existingItem.selectedAreas, area],
          );
        }
      } else {
        currentTreatmentsAndAreas.add(
          SelectedTreatmentAndAreasModel(
            treatment: activeTreatment,
            selectedAreas: [area],
          ),
        );
      }
    } else {
      print(
          "No active selectedTreatments found in state. Area not added to SelectedTreatmentAndAreasModel.");
    }

    state = state.copyWith(
      selectedAreas: activeArea,
      selectedTreatmentsAndAreas: currentTreatmentsAndAreas,
    );
    _printSelectedTreatmentsAndAreas();
  }

  void removeTreatment(int treatmentId) {
    final currentList =
        List<SelectedTreatmentAndAreasModel>.from(state.selectedTreatmentsAndAreas);
    currentList.removeWhere((item) => item.treatment.id == treatmentId);

    final activeTreatment = state.selectedTreatments;
    final updatedActiveTreatment =
        activeTreatment?.id == treatmentId ? null : activeTreatment;

    state = state.copyWith(
      selectedTreatmentsAndAreas: currentList,
      selectedTreatments: updatedActiveTreatment,
    );
    _printSelectedTreatmentsAndAreas();
  }

  void removeArea(int areaId) {
    final currentList = state.selectedTreatmentsAndAreas.map((item) {
      final updatedAreas =
          item.selectedAreas.where((a) => a.id != areaId).toList();
      return item.copyWith(selectedAreas: updatedAreas);
    }).toList();

    final activeArea = state.selectedAreas;
    final updatedActiveArea = activeArea?.id == areaId ? null : activeArea;

    state = state.copyWith(
      selectedAreas: updatedActiveArea,
      selectedTreatmentsAndAreas: currentList,
    );
    _printSelectedTreatmentsAndAreas();
  }

  void _printSelectedTreatmentsAndAreas() {
    print("--- Selected Treatments and Areas ---");
    for (final item in state.selectedTreatmentsAndAreas) {
      print("Treatment: ${item.treatment.name} (ID: ${item.treatment.id})");
      print("  Areas: ${item.selectedAreas.map((e) => '${e.name} (ID: ${e.id})').toList()}");
    }
    print("-------------------------------------");
  }
}

class CheckoutState {
  final List<SelectedTreatmentAndAreasModel> selectedTreatmentsAndAreas;
  final List<TreatmentCategoryModel>? selectedCategories;
  final TreatmentData? selectedTreatments;
  final TreatmentAreaModel? selectedAreas;
  final String? clinicId;
  final String? drId;
  final String? appointmentDate;
  final String? appointmentTime;
  final XFile? capturedImage;

  const CheckoutState({
    this.clinicId,
    this.drId,
    this.appointmentDate,
    this.appointmentTime,
    this.capturedImage,
    this.selectedTreatmentsAndAreas = const [],
    this.selectedCategories = const [],
    this.selectedTreatments,
    this.selectedAreas,
  });

  CheckoutState copyWith({
    String? clinicId,
    String? drId,
    String? appointmentDate,
    String? appointmentTime,
    XFile? capturedImage,
    List<SelectedTreatmentAndAreasModel>? selectedTreatmentsAndAreas,
    List<TreatmentCategoryModel>? selectedCategories,
    TreatmentData? selectedTreatments,
    TreatmentAreaModel? selectedAreas,
  }) {
    return CheckoutState(
      clinicId: clinicId ?? this.clinicId,
      drId: drId ?? this.drId,
      appointmentDate: appointmentDate ?? this.appointmentDate,
      appointmentTime: appointmentTime ?? this.appointmentTime,
      capturedImage: capturedImage ?? this.capturedImage,
      selectedTreatmentsAndAreas:
          selectedTreatmentsAndAreas ?? this.selectedTreatmentsAndAreas,
      selectedCategories: selectedCategories ?? this.selectedCategories,
      selectedTreatments: selectedTreatments ?? this.selectedTreatments,
      selectedAreas: selectedAreas ?? this.selectedAreas,
    );
  }
}
