import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skinsync_ai/models/responses/select_section_response.dart';
import 'package:skinsync_ai/models/responses/sub_section_response.dart';
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
    return await runSafely(() async {
      state = state.copyWith(loading: true);
      final TreatmentResponse response = await _treatmentRepository
          .getTreatmentsApi();
      state = state.copyWith(loading: false, treatmentResponse: response);
      return response.isSuccess == true;
    });
  }
  Future<bool?> getSelectSectionApi({required int sectionId}) async {
    return await runSafely(() async {
      state = state.copyWith(loading: true);
      final SelectSelectionResponse response = await _treatmentRepository
          .getSelectSectionApi(sectionId: sectionId);
      state = state.copyWith(loading: false, selectSelectionResponse: response);
      return response.isSuccess == true;
    });
  }
  Future<bool?> getSubSectionApi({required int sectionId, required int subSectionId}) async {
    return await runSafely(() async {
      state = state.copyWith(loading: true);
      final SubSelectionResponse response = await _treatmentRepository
          .getSubSectionApi(sectionId: sectionId, subSectionId: subSectionId);
      state = state.copyWith(loading: false, subSelectionResponse: response);
      return response.isSuccess == true;
    });
  }
  @override
  void onError(String message) {
    state = state.copyWith(loading: false);
    super.onError(message);
    EasyLoading.showError(message);
  }
}

@immutable
class TreatmentsState extends BaseStateModel {
  final TreatmentResponse? treatmentResponse;
  final SubSelectionResponse? subSelectionResponse;
  final SelectSelectionResponse? selectSelectionResponse;

  const TreatmentsState({
    super.loading = false,
    super.errorMessage,
    this.treatmentResponse,
    this.selectSelectionResponse,
    this.subSelectionResponse
  });
  @override
  TreatmentsState copyWith({
    bool? loading,
    String? errorMessage,
    TreatmentResponse? treatmentResponse,
    SubSelectionResponse? subSelectionResponse,
    SelectSelectionResponse? selectSelectionResponse

  }) {
    return TreatmentsState(
      loading: loading ?? this.loading,
      errorMessage: errorMessage ?? this.errorMessage,
      treatmentResponse: treatmentResponse ?? this.treatmentResponse,
      selectSelectionResponse: selectSelectionResponse ?? this.selectSelectionResponse,
      subSelectionResponse: subSelectionResponse ?? this.subSelectionResponse
    );
  }
}
