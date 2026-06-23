import 'package:camera/camera.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/responses/treatment_response_model.dart';
import '../models/responses/treatment_sub_area_response.dart';

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
    );
  }

  void setSelectedTreatment({
    required TreatmentsModel treatment,
    required List<TreatmentSubAreaModel> selectedSubAreasList,
  }) {
    state = state.copyWith(
      selectedTreatment: treatment,
      selectedSubAreasList: selectedSubAreasList,
    );
  }
}

class CheckoutState {
  final List<TreatmentSubAreaModel>? selectedSubAreasList;
  final TreatmentsModel? selectedTreatment;
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
    this.selectedSubAreasList,
    this.selectedTreatment,
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
    List<TreatmentSubAreaModel>? selectedSubAreasList,
    TreatmentsModel? selectedTreatment,
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
      selectedTreatment: selectedTreatment ?? this.selectedTreatment,
    );
  }
}
