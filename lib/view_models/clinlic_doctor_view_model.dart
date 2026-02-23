import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skinsync_ai/models/base_state_model.dart';
import 'package:skinsync_ai/models/responses/get_clinic_response.dart';
import 'package:skinsync_ai/repositories/auth_repository.dart'
    show AuthRepository;
import 'package:skinsync_ai/repositories/clinic_doctor_repository.dart';
import 'package:skinsync_ai/services/api_base_helper.dart';
import 'package:skinsync_ai/services/auth_service.dart';
import 'package:skinsync_ai/services/clinic_doctor_service.dart';
import 'package:skinsync_ai/view_models/auth_view_model.dart';
import 'package:skinsync_ai/view_models/base_view_model.dart';

final clincDoctorProvider = NotifierProvider(() {
  final apiBaseHelper = ApiBaseHelper();
  final clinicService = ClinicDoctorService(apiClient: apiBaseHelper);
  return ClinicDoctorViewModel(clinicRepository: clinicService);
});

class ClinicDoctorViewModel extends BaseViewModel<ClinlicDoctorState> {
  ClinicDoctorViewModel({required ClinicDoctorRepository clinicRepository})
    : _clinicRepository = clinicRepository,
      super(initialState: ClinlicDoctorState());

  final ClinicDoctorRepository _clinicRepository;

  Future<bool?> getClinic({
    required int treatmentId,
    required int sideAreaId,
  }) async {
    state = state.copyWith(clinicLoading: true);
    return runSafely(() async {
      final response = await _clinicRepository.getClinic(
        treamentId: treatmentId,
        sideAreaID: sideAreaId,
      );
      state = state.copyWith(clinicLoading: false, clinicResponse: response);
      return response.isSuccess == true;
    });
  }
}

@immutable
class ClinlicDoctorState extends BaseStateModel {
  final GetClinicResponse? clinicResponse;
  final bool clinicLoading;

  const ClinlicDoctorState({
    super.loading = false,
    super.errorMessage,
    this.clinicResponse,
    this.clinicLoading = false,
  });

  @override
  ClinlicDoctorState copyWith({
    bool? loading,
    String? errorMessage,
    GetClinicResponse? clinicResponse,
    bool? clinicLoading,
  }) {
    return ClinlicDoctorState(
      loading: loading ?? this.loading,
      errorMessage: errorMessage ?? this.errorMessage,
      clinicLoading: clinicLoading ?? this.clinicLoading,
      clinicResponse: clinicResponse ?? this.clinicResponse,
    );
  }
}
