import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/base_state_model.dart';
import '../models/requests/medical_history_request.dart';
import '../models/responses/medical_history_response.dart';
import '../repositories/medical_history_repository.dart';
import '../services/api_base_helper.dart';
import '../services/medical_history_service.dart';
import 'base_view_model.dart';

final medicalHistoryProvider =
    NotifierProvider<MedicalHistoryViewModel, MedicalHistoryState>(
      () => MedicalHistoryViewModel(
        medicalHistoryRepository: MedicalHistoryService(
          apiClient: ApiBaseHelper(),
        ),
      ),
    );

class MedicalHistoryViewModel extends BaseViewModel<MedicalHistoryState> {
  MedicalHistoryViewModel({
    required MedicalHistoryRepository medicalHistoryRepository,
  }) : _repo = medicalHistoryRepository,
       super(initialState: const MedicalHistoryState());

  final MedicalHistoryRepository _repo;

  MedicalHistory? get areas => state.medicalHistory;
  bool get isLoading => state.loading;
  String? get errorMessage => state.errorMessage;

  Future<bool> fetchPatientMedicalHistory() async {
    final result = await runSafely(() async {
      state = state.copyWith(loading: true, errorMessage: null);
      final response = await _repo.getPatientMedicalHistory();
      state = state.copyWith(
        loading: false,
        medicalHistory: response.data,
        errorMessage: null,
      );
      return true;
    });
    return result ?? false;
  }

  Future<bool> updateMedicalHistory(
    int? patientId,
    MedicalHistoryRequest request,
  ) async {
    final result = await runSafely(() async {
      state = state.copyWith(loading: true, errorMessage: null);
      final response = await _repo.updateAlleryAndMedical(patientId, request);
      if (response.isSuccess == true) {
        await fetchPatientMedicalHistory();
      }

      return true;
    });
    return result ?? false;
  }

  @override
  void onError(String message) {
    state = state.copyWith(loading: false, errorMessage: message);
    super.onError(message);
  }
}

class MedicalHistoryState extends BaseStateModel {
  final MedicalHistory? medicalHistory;

  const MedicalHistoryState({
    this.medicalHistory,
    super.loading = false,
    super.errorMessage,
  });

  @override
  MedicalHistoryState copyWith({
    MedicalHistory? medicalHistory,
    bool? loading,
    String? errorMessage,
  }) {
    return MedicalHistoryState(
      medicalHistory: medicalHistory ?? this.medicalHistory,
      loading: loading ?? this.loading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
