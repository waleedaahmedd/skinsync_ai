import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skinsync_ai/models/responses/treatment_area_response.dart';
import 'package:skinsync_ai/models/responses/treatment_sub_area_response.dart';
import 'package:skinsync_ai/services/api_base_helper.dart';

import '../models/base_state_model.dart';
import '../models/responses/treatment_response_model.dart';
import '../repositories/treatment_repository.dart';
import '../services/treatment_services.dart';
import 'base_view_model.dart';

final treatmentViewModel = NotifierProvider(
  () => TreatmentViewModel(
    treatmentRepository: TreatmentService(apiClient: ApiBaseHelper()),
  ),
);

class TreatmentViewModel extends BaseViewModel<TreatmentsState> {
  TreatmentViewModel({required TreatmentRepository treatmentRepository})
    : _treatmentRepository = treatmentRepository,
      super(initialState: TreatmentsState());

  // void setTreatmentMainScreen({required bool value}) {
  //   state = value;
  // }
  final TreatmentRepository _treatmentRepository;
  int? treatmentId;
  int? selectSectionId;
  int? subSectionId;

  Future<bool?> getTreatments() async {
    // Set loading state before async call so UI can show loader immediately
    state = state.copyWith(treatmentsLoading: true);
    return await runSafely(() async {
      final TreatmentResponse response = await _treatmentRepository
          .getTreatmentsApi();
      state = state.copyWith(
        treatmentsLoading: false,
        treatmentResponse: response,
      );
      return response.isSuccess == true;
    });
  }

  Future<bool?> getSelectSectionApi({required int sectionId}) async {
    return await runSafely(() async {
      state = state.copyWith(treatmentAreaLoading: true);
      final TreatmentAreaResponse response = await _treatmentRepository
          .getSelectSectionApi(sectionId: sectionId);
      state = state.copyWith(treatmentAreaLoading: false, selectSelectionResponse: response);
      return response.isSuccess == true;
    });
  }

  Future<bool?> getSubSectionApi({
    required int sectionId,
    required int subSectionId,
  }) async {
    return await runSafely(() async {
      state = state.copyWith(treatmentSubAreaLoading: true);
      final TreatmentSubAreaResponse response = await _treatmentRepository
          .getSubSectionApi(sectionId: sectionId, subSectionId: subSectionId);
      state = state.copyWith(treatmentSubAreaLoading: false, subSelectionResponse: response);
      return response.isSuccess == true;
    });
  }

  @override
  void onError(String message) {
    state = state.copyWith(treatmentAreaLoading: false, treatmentsLoading: false, treatmentSubAreaLoading: false);
    super.onError(message);
    EasyLoading.showError(message);
  }
}

@immutable
class TreatmentsState  {
  final TreatmentResponse? treatmentResponse;
  final TreatmentSubAreaResponse? treatmentsSubAreaResponse;
  final TreatmentAreaResponse? treatmentAreaResponse;
  final bool treatmentsLoading;

  final bool treatmentAreaLoading;
  final bool treatmentSubAreaLoading;

  const TreatmentsState({
    //super.loading = false,
    //super.errorMessage,
    this.treatmentResponse,
    this.treatmentAreaResponse,
    this.treatmentsSubAreaResponse,
    this.treatmentsLoading = false,
    this.treatmentAreaLoading = false,
    this.treatmentSubAreaLoading = false,
  });

  TreatmentsState copyWith({
     //bool? loading,
  //  String? errorMessage,
    TreatmentResponse? treatmentResponse,
    TreatmentSubAreaResponse? subSelectionResponse,
    TreatmentAreaResponse? selectSelectionResponse,
    bool? treatmentsLoading,
    bool? treatmentAreaLoading,
    bool? treatmentSubAreaLoading,
  }) {
    return TreatmentsState(
      // loading: loading ?? this.loading,
     // errorMessage: errorMessage ?? this.errorMessage,
      treatmentResponse: treatmentResponse ?? this.treatmentResponse,
      treatmentAreaResponse:
          selectSelectionResponse ?? treatmentAreaResponse,
      treatmentsSubAreaResponse:
          subSelectionResponse ?? treatmentsSubAreaResponse,
      treatmentsLoading: treatmentsLoading ?? this.treatmentsLoading,
      treatmentAreaLoading: treatmentAreaLoading ?? this.treatmentAreaLoading,
      treatmentSubAreaLoading: treatmentSubAreaLoading ?? this.treatmentSubAreaLoading,
    );
  }
}
