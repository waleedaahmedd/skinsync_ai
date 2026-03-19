import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skinsync_ai/models/base_state_model.dart';
import 'package:skinsync_ai/models/responses/get_clinic_response.dart';
import 'package:skinsync_ai/models/responses/get_doctor_response.dart';
import 'package:skinsync_ai/repositories/clinic_doctor_repository.dart';
import 'package:skinsync_ai/services/api_base_helper.dart';
import 'package:skinsync_ai/services/clinic_doctor_service.dart';
import 'package:skinsync_ai/utills/enums.dart';
import 'package:skinsync_ai/view_models/base_view_model.dart';
import 'package:skinsync_ai/view_models/treatment_view_model.dart';

import '../models/responses/availability_response.dart';
import '../models/responses/payment_options_response.dart';

final clincDoctorProvider = NotifierProvider(() {
  final apiBaseHelper = ApiBaseHelper();
  final clinicService = ClinicDoctorService(apiClient: apiBaseHelper);
  return ClinicDoctorViewModel(clinicRepository: clinicService);
});

class ClinicDoctorViewModel extends BaseViewModel<ClinicDoctorState> {
  ClinicDoctorViewModel({required ClinicDoctorRepository clinicRepository})
    : _clinicRepository = clinicRepository,
      super(initialState: ClinicDoctorState());

  final ClinicDoctorRepository _clinicRepository;

  void setClinicId(int id) {
    state = state.copyWith(clinicId: id);
  }

  Future<bool?> getClinic({
    required int treatmentId,
    required List<int> sideAreaIds,
  }) async {
    state = state.copyWith(clinicLoading: true);
    final String sideAreas = sideAreaIds.join(',');
    return runSafely(() async {
      final response = await _clinicRepository.getClinic(
        treatmentId: treatmentId,
        sideAreaIdsList: sideAreas,
      );
      state = state.copyWith(clinicLoading: false, clinicResponse: response);
      return response.isSuccess == true;
    });
  }

  Future<bool?> getDoctors({
    required int treatmentId,
    required List<int> sideAreaIds,
    required int? clinicId,
    required DateTime date,
  }) async {
    state = state.copyWith(doctorLoading: true);
    final String sideAreas = sideAreaIds.join(',');
    return runSafely(() async {
      final response = await _clinicRepository.getDoctors(
        clinicId: state.clinicId ?? 0,

        treatmentId: treatmentId,
        sideAreaIdsList: sideAreas,
      );
      final doctor = response.data?.firstOrNull;
      List<Slot> availability = [];
      if (doctor != null && clinicId != null) {
        availability = await _clinicRepository.getAvailability(
          doctorId: doctor.id!,
          clinicId: clinicId,
          date: date,
        );
      }
      state = state.copyWith(
        doctorLoading: false,
        doctorResponse: response,
        selectedDoctor: response.data?.firstOrNull,
        slots: availability,
      );
      return response.isSuccess == true;
    });
  }

  Future<void> fetchAvailability({
    required DateTime date,
    required int clinicId,
  }) async {
    return await runSafely(() async {
      if (state.selectedDoctor == null) {
        return;
      }
      state = state.copyWith(loading: true);
      final availability = await _clinicRepository.getAvailability(
        doctorId: state.selectedDoctor!.id!,
        clinicId: state.clinicId!,
        date: date,
      );
      state = state.copyWith(
        doctorLoading: false,
        loading: false,
        slots: availability,
      );
    });
  }

  Future<void> getPaymentOptions({
    required int clinicId,
    required int doctorId,
  }) async {
    return await runSafely(() async {
      final treatmentState = ref.read(treatmentViewModel);
      if (treatmentState.selectedTreatment == null ||
          treatmentState.selectedSubAreasList.isEmpty) {
        return;
      }
      state = state.copyWith(loading: true);
      final pricing = await _clinicRepository.getTreatmentPricing(
        clinicId: clinicId,
        treatmentId: treatmentState.selectedTreatment!.id!,
        treatmentSubsectionIds: treatmentState.selectedSubAreasList
            .map((area) => area.id!)
            .toList(),
      );
      final amount = pricing.treatment!.price! * pricing.subSections!.length;
      final paymentOptions = await _clinicRepository.getPaymentOptions(
        clinicId: clinicId,
        doctorId: doctorId,
        amount: amount,
      );
      state = state.copyWith(loading: false, paymentOptions: paymentOptions);
    });
  }

  void toggleViewType() {
    state = state.copyWith(
      viewType: state.viewType == ViewType.grid ? ViewType.map : ViewType.grid,
    );
  }

  @override
  void onError(String message) {
    state = state.copyWith(
      clinicLoading: false,
      doctorLoading: false,
      loading: false,
    );
    super.onError(message);
    EasyLoading.showError(message);
  }
}

@immutable
class ClinicDoctorState extends BaseStateModel {
  final GetClinicResponse? clinicResponse;
  final bool clinicLoading;
  final GetDoctorResponse? doctorResponse;
  final bool doctorLoading;
  final int? clinicId;
  final ViewType viewType;
  final Doctor? selectedDoctor;
  final List<Slot> slots;
  final List<PaymentOption> paymentOptions;

  const ClinicDoctorState({
    super.loading = false,
    super.errorMessage,
    this.clinicResponse,
    this.clinicLoading = false,
    this.doctorResponse,
    this.doctorLoading = false,
    this.clinicId,
    this.viewType = ViewType.grid,
    this.selectedDoctor,
    this.slots = const [],
    this.paymentOptions = const [],
  });

  @override
  ClinicDoctorState copyWith({
    bool? loading,
    String? errorMessage,
    GetClinicResponse? clinicResponse,
    bool? clinicLoading,
    GetDoctorResponse? doctorResponse,
    bool? doctorLoading,
    int? clinicId,
    ViewType? viewType,
    Doctor? selectedDoctor,
    List<Slot>? slots,
    List<PaymentOption>? paymentOptions,
  }) {
    return ClinicDoctorState(
      loading: loading ?? this.loading,
      errorMessage: errorMessage ?? this.errorMessage,
      clinicLoading: clinicLoading ?? this.clinicLoading,
      clinicResponse: clinicResponse ?? this.clinicResponse,
      doctorResponse: doctorResponse ?? this.doctorResponse,
      doctorLoading: doctorLoading ?? this.doctorLoading,
      clinicId: clinicId ?? this.clinicId,
      viewType: viewType ?? this.viewType,
      selectedDoctor: selectedDoctor ?? this.selectedDoctor,
      slots: slots ?? this.slots,
      paymentOptions: paymentOptions ?? this.paymentOptions,
    );
  }
}
