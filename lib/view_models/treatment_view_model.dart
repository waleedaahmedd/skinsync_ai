import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

  Future<bool?> getTreatments() async {
    return await runSafely(() async {
      state = state.copyWith(loading: true);
      final TreatmentResponse response = await _treatmentRepository
          .getTreatmentsApi();
      state = state.copyWith(loading: false, treatmentResponse: response);
      return response.isSuccess == true;
    });
  }
}

@immutable
class TreatmentsState extends BaseStateModel {
  final TreatmentResponse? treatmentResponse;

  const TreatmentsState({
    super.loading = false,
    super.errorMessage,
    this.treatmentResponse,
  });
  @override
  TreatmentsState copyWith({
    bool? loading,
    String? errorMessage,
    TreatmentResponse? treatmentResponse,
  }) {
    return TreatmentsState(
      loading: loading ?? this.loading,
      errorMessage: errorMessage ?? this.errorMessage,
      treatmentResponse: treatmentResponse ?? this.treatmentResponse,
    );
  }
}
