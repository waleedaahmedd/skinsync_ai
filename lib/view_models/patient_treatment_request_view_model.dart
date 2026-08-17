import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/base_state_model.dart';
import '../models/responses/patient_treatment_request_response.dart';
import '../repositories/patient_treatment_request_repository.dart';
import '../services/api_base_helper.dart';
import '../services/patient_treatment_request_service.dart';
import 'base_view_model.dart';

final patientTreatmentRequestProvider =
    NotifierProvider.autoDispose<PatientTreatmentRequestViewModel, PatientTreatmentRequestState>(() {
  final apiBaseHelper = ApiBaseHelper();
  final service = PatientTreatmentRequestService(apiClient: apiBaseHelper);
  return PatientTreatmentRequestViewModel(repository: service);
});

class PatientTreatmentRequestViewModel extends BaseViewModel<PatientTreatmentRequestState> {
  final PatientTreatmentRequestRepository _repository;
  PatientTreatmentRequestViewModel({required PatientTreatmentRequestRepository repository})
      : _repository = repository,
        super(initialState: const PatientTreatmentRequestState());

  Future<void> fetchRequests({required int clinicId, int page = 1}) async {
    return await runSafely(() async {
      state = state.copyWith(loading: true, errorMessage: null);
      final response = await _repository.getPatientTreatmentRequests(
        clinicId: clinicId,
        page: page,
      );
      if (!ref.mounted) return;
      state = state.copyWith(
        loading: false,
        requests: response.data ?? [],
      );
    });
  }
}

@immutable
class PatientTreatmentRequestState extends BaseStateModel {
  final List<PatientTreatmentRequest> requests;

  const PatientTreatmentRequestState({
    super.loading = false,
    super.errorMessage,
    this.requests = const [],
  });

  @override
  PatientTreatmentRequestState copyWith({
    bool? loading,
    String? errorMessage,
    List<PatientTreatmentRequest>? requests,
  }) {
    return PatientTreatmentRequestState(
      loading: loading ?? this.loading,
      errorMessage: errorMessage ?? this.errorMessage,
      requests: requests ?? this.requests,
    );
  }
}
