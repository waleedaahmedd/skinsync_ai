import 'package:camera/camera.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/responses/treatment_list_response.dart';
import '../models/responses/treatment_category_list_response.dart';
import '../models/responses/treatment_area_list_response.dart';

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
    int? treatmentId,
    int? treatmentAreaId,
    List<int>? treatmentSubAreaId,
    String? clinicId,
    String? drId,
    String? appointmentDate,
    String? appointmentTime,
    XFile? capturedImage,
  }) {
    print("state updated");
    state = CheckoutState(
      treatmentId: treatmentId ?? state.treatmentId,
      treatmentAreaId: treatmentAreaId ?? state.treatmentAreaId,
      treatmentSubAreaId: treatmentSubAreaId ?? state.treatmentSubAreaId,
      clinicId: clinicId ?? state.clinicId,
      drId: drId ?? state.drId,
      appointmentDate: appointmentDate ?? state.appointmentDate,
      appointmentTime: appointmentTime ?? state.appointmentTime,
      capturedImage: capturedImage ?? state.capturedImage,
      selectedSubAreasList: state.selectedSubAreasList,
      selectedTreatments: state.selectedTreatments,
      selectedCategories: state.selectedCategories,
      selectedAreas: state.selectedAreas,
    );
  }

  void clearState() {
    print("state Cleared");
    state = const CheckoutState(
      treatmentId: null,
      treatmentAreaId: null,
      treatmentSubAreaId: null,
      clinicId: null,
      drId: null,
      appointmentDate: null,
      appointmentTime: null,
      capturedImage: null,
      selectedCategories: [],
      selectedTreatments: [],
      selectedAreas: [],
      selectedSubAreasList: [],
    );
  }

  void setSelectedTreatments(List<TreatmentData> treatments) {
    state = state.copyWith(selectedTreatments: treatments);
  }

  void addSelectedTreatment(TreatmentData treatment) {
    final currentList = state.selectedTreatments ?? [];
    if (!currentList.any((t) => t.id == treatment.id)) {
      state = state.copyWith(selectedTreatments: [...currentList, treatment]);
    }
  }

  void setSelectedCategories(List<TreatmentCategoryModel> categories) {
    state = state.copyWith(selectedCategories: categories);
  }

  void addSelectedCategory(TreatmentCategoryModel category) {
    final currentList = state.selectedCategories ?? [];
    if (!currentList.any((c) => c.id == category.id)) {
      state = state.copyWith(selectedCategories: [...currentList, category]);
    }
  }

  void setSelectedAreas(List<TreatmentAreaModel> areas) {
    state = state.copyWith(selectedAreas: areas);
  }

  void addSelectedArea(TreatmentAreaModel area) {
    final currentList = state.selectedAreas ?? [];
    if (!currentList.any((a) => a.id == area.id)) {
      state = state.copyWith(selectedAreas: [...currentList, area]);
    }
  }

  void setSelectedSubAreasList(List<TreatmentAreaModel> subAreas) {
    state = state.copyWith(selectedSubAreasList: subAreas);
  }
}

class CheckoutState {
  final List<TreatmentAreaModel>? selectedSubAreasList;
  final List<TreatmentData>? selectedTreatments;
  final List<TreatmentCategoryModel>? selectedCategories;
  final List<TreatmentAreaModel>? selectedAreas;
  final int? treatmentId;
  final int? treatmentAreaId;
  final List<int>? treatmentSubAreaId;
  final String? clinicId;
  final String? drId;
  final String? appointmentDate;
  final String? appointmentTime;
  final XFile? capturedImage;

  const CheckoutState({
    this.treatmentId,
    this.treatmentAreaId,
    this.treatmentSubAreaId,
    this.clinicId,
    this.drId,
    this.appointmentDate,
    this.appointmentTime,
    this.capturedImage,
    this.selectedSubAreasList = const [],
    this.selectedTreatments = const [],
    this.selectedCategories = const [],
    this.selectedAreas = const [],
  });

  CheckoutState copyWith({
    int? treatmentId,
    int? treatmentAreaId,
    List<int>? treatmentSubAreaId,
    String? clinicId,
    String? drId,
    String? appointmentDate,
    String? appointmentTime,
    XFile? capturedImage,
    List<TreatmentAreaModel>? selectedSubAreasList,
    List<TreatmentData>? selectedTreatments,
    List<TreatmentCategoryModel>? selectedCategories,
    List<TreatmentAreaModel>? selectedAreas,
  }) {
    return CheckoutState(
      treatmentId: treatmentId ?? this.treatmentId,
      treatmentAreaId: treatmentAreaId ?? this.treatmentAreaId,
      treatmentSubAreaId: treatmentSubAreaId ?? this.treatmentSubAreaId,
      clinicId: clinicId ?? this.clinicId,
      drId: drId ?? this.drId,
      appointmentDate: appointmentDate ?? this.appointmentDate,
      appointmentTime: appointmentTime ?? this.appointmentTime,
      capturedImage: capturedImage ?? this.capturedImage,
      selectedSubAreasList: selectedSubAreasList ?? this.selectedSubAreasList,
      selectedTreatments: selectedTreatments ?? this.selectedTreatments,
      selectedCategories: selectedCategories ?? this.selectedCategories,
      selectedAreas: selectedAreas ?? this.selectedAreas,
    );
  }
}
