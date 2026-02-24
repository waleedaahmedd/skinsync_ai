import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skinsync_ai/models/base_state_model.dart';
import 'package:skinsync_ai/models/responses/get_clinic_response.dart';
import 'package:skinsync_ai/models/responses/get_doctor_response.dart';
import 'package:skinsync_ai/repositories/clinic_doctor_repository.dart';
import 'package:skinsync_ai/services/api_base_helper.dart';
import 'package:skinsync_ai/services/clinic_doctor_service.dart';
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
   void setClinicId(int id) {
  state = state.copyWith(clinicId: id);
}
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
   Future<bool?> getDoctors({
    required int treatmentId,
    required int sideAreaId,
  }) async {
     
    state = state.copyWith(doctorLoading: true);
    return runSafely(() async {
      final response = await _clinicRepository.getDoctors(
        clinicId: state.clinicId ?? 0,
       
        treamentId: treatmentId,
        sideAreaID: sideAreaId,
      );
      state = state.copyWith(doctorLoading: false, doctorResponse: response);
      return response.isSuccess == true;
    });
  }
}

@immutable
class ClinlicDoctorState extends BaseStateModel {
  final GetClinicResponse? clinicResponse;
  final bool clinicLoading;
  final GetDoctorResponse? doctorResponse;
  final bool doctorLoading;
  final int? clinicId;

  const ClinlicDoctorState({
    super.loading = false,
    super.errorMessage,
    this.clinicResponse,
    this.clinicLoading = false,
    this.doctorResponse,
    this.doctorLoading = false,
    this.clinicId,
  });

  @override
  ClinlicDoctorState copyWith({
    bool? loading,
    String? errorMessage,
    GetClinicResponse? clinicResponse,
    bool? clinicLoading,
    GetDoctorResponse? doctorResponse,
    bool? doctorLoading,
    int? clinicId,
  }) {
    return ClinlicDoctorState(
      loading: loading ?? this.loading,
      errorMessage: errorMessage ?? this.errorMessage,
      clinicLoading: clinicLoading ?? this.clinicLoading,
      clinicResponse: clinicResponse ?? this.clinicResponse,
      doctorResponse: doctorResponse ?? this.doctorResponse,
      doctorLoading: doctorLoading ?? this.doctorLoading,
      clinicId: clinicId ?? this.clinicId,
    );
  }
}
