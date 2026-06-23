import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/base_state_model.dart';
import '../models/responses/appointment_response.dart';
import '../models/responses/get_clinic_response.dart';
import '../models/responses/get_doctor_response.dart';
import '../repositories/clinic_doctor_repository.dart';
import '../services/api_base_helper.dart';
import '../services/clinic_doctor_service.dart';
import '../services/location_service.dart';
import '../services/media_service.dart';
import '../utills/enums.dart';
import 'auth_view_model.dart';
import 'base_view_model.dart';
import 'treatment_view_model.dart';

import '../models/requests/appointment_request.dart';
import '../models/responses/availability_response.dart';
import '../models/responses/payment_options_response.dart';
import '../models/responses/treatment_pricing_response.dart' hide Treatment;
import '../utills/date_time_utills.dart';

final clinicDoctorProvider = NotifierProvider(() {
  final apiBaseHelper = ApiBaseHelper();
  final clinicService = ClinicDoctorService(apiClient: apiBaseHelper);
  return ClinicDoctorViewModel(clinicRepository: clinicService);
});

class ClinicDoctorViewModel extends BaseViewModel<ClinicDoctorState> {
  ClinicDoctorViewModel({required ClinicDoctorRepository clinicRepository})
    : _clinicRepository = clinicRepository,
      super(initialState: const ClinicDoctorState());
  final List<Clinic> _allClinics = <Clinic>[];

  final ClinicDoctorRepository _clinicRepository;
  final _mediaService = MediaService();
  PricingData? pricingData;

  void setClinicId(int id) {
    state = state.copyWith(clinicId: id);
  }

  void setSelectedDoctor(Doctor doctor) {
    state = state.copyWith(selectedDoctor: doctor);
  }

  Future<bool?> getClinic({int? treatmentId, List<int>? sideAreaIds}) async {
    return runSafely(() async {
      state = state.copyWith(clinicLoading: true);
      final String? sideAreas = sideAreaIds?.join(',');
      final response = await _clinicRepository.getClinic(
        treatmentId: treatmentId,
        sideAreaIdsList: sideAreas,
      );
      state = state.copyWith(clinicLoading: false, clinics: response.data);
      return response.status == true;
    });
  }

  Future<void> fetchClinicsFromMap() async {
    return await runSafely(() async {
      state = state.copyWith(clinicLoading: true);
      final location = ref.read(authViewModel).addressData!.latLng;
      final places = await LocationService().fetchNearbyClinics(
        location: location,
      );
      final List<Clinic> clinics = [];
      for (final place in places) {
        clinics.add(
          Clinic(
            clinicId: 29,
            phone: place.internationalPhoneNumber,
            description: place.primaryTypeDisplayName?.text,
            address: place.shortFormattedAddress,
            clinicName: place.displayName?.text,
            logo: place.photos?.firstOrNull?.name,
            location: place.location != null
                ? LatLng(place.location!.latitude!, place.location!.longitude!)
                : null,
            place: place,
          ),
        );
      }
      _allClinics.clear();
      _allClinics.addAll(clinics);
      state = state.copyWith(clinicLoading: false, clinicsToInvite: clinics);
    });
  }

  Future<bool?> getDoctors({
    required int treatmentId,
    required List<int> sideAreaIds,
    required int? clinicId,
    required DateTime date,
  }) async {
    return runSafely(() async {
      state = state.copyWith(doctorLoading: true);
      final String sideAreas = sideAreaIds.join(',');
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
      return response.status == true;
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
      EasyLoading.show(status: 'Loading...');
      state = state.copyWith(loading: true);
      final availability = await _clinicRepository.getAvailability(
        doctorId: state.selectedDoctor!.id!,
        clinicId: clinicId,
        date: date,
      );
      state = state.copyWith(
        doctorLoading: false,
        loading: false,
        slots: availability,
      );
      EasyLoading.dismiss();
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
      pricingData = pricing;
      final amount = pricing.treatment!.price! * pricing.subSections!.length;
      final paymentOptions = await _clinicRepository.getPaymentOptions(
        clinicId: clinicId,
        doctorId: doctorId,
        amount: amount,
      );
      state = state.copyWith(loading: false, paymentOptions: paymentOptions);
    });
  }

  Future<void> createAppointment({
    required Clinic clinic,
    required Doctor doctor,
    required Slot slot,
    required PaymentOption paymentOption,
  }) async {
    return await runSafely(() async {
      state = state.copyWith(loading: true);

      final actualAmount = state.paymentOptions
          .where((option) => option.title?.contains('Full Payment') ?? false)
          .firstOrNull
          ?.amount;
      if (actualAmount == null) {
        throw Exception('No full payment option found');
      }
      if (pricingData == null) {
        throw Exception('Pricing data not found');
      }
      final treatmentState = ref.read(treatmentViewModel);
      final beforeImage = treatmentState.capturedImage;
      final afterImage = treatmentState.aiImage;
      if (beforeImage == null || afterImage == null) {
        throw Exception('No image captured');
      }
      final treatment = treatmentState.selectedTreatment!;
      final subAreas = treatmentState.selectedSubAreasList;
      final treatmentPrice =
          pricingData!.treatment!.price! *
          subAreas.fold(0, (prev, next) {
            return prev + next.currentSyringe + 1;
          });
      final userId = ref.read(authViewModel).authResponse!.data!.user!.id!;
      final uploadedBefore = await _mediaService.uploadImage(
        '$userId/appointments/before/',
        beforeImage,
      );
      if (uploadedBefore == null) {
        throw Exception('Failed to upload before image');
      }
      final uploadedAfter = await _mediaService.uploadImage(
        '$userId/appointments/after/',
        afterImage,
      );
      if (uploadedAfter == null) {
        throw Exception('Failed to upload after image');
      }
      final data = await _clinicRepository.createAppointment(
        request: AppointmentRequest(
          date: slot.startTime.secondsSinceEpoch,
          startTime: slot.startTime.secondsSinceEpoch,
          endTime: slot.endTime.secondsSinceEpoch,
          clinicId: clinic.clinicId!,
          paymentType: PaymentTypeRequest(
            id: paymentOption.id!,
            amount: paymentOption.amount!,
          ),
          actualAmount: actualAmount,
          doctorId: doctor.id!,
          amountPaid: paymentOption.amount!,
          amountPayable: actualAmount - paymentOption.amount!,
          discount: 0,
          discountType: 'Flat',
          loyalityPoints: 0,
          treatment: AppointmentTreatmentRequest(
            treatmentId: treatment.id!,
            treatmentPrice: treatmentPrice.toInt(),
            treatmentQuantity: subAreas.length,
            beforeImage: uploadedBefore,
            afterImage: uploadedAfter,
          ),
          treatmentSubsection: subAreas.map((subArea) {
            final price = pricingData!.subSections!.where((subSection) {
              return subSection.name == subArea.name;
            }).first;
            return TreatmentSubsectionRequest(
              sectionId: subArea.id!,
              syringesQuantity: subArea.currentSyringe,
              perSyringePrice: price.perSyringePrice!,
            );
          }).toList(),
          treatmentTotal: treatmentPrice.toInt(),
        ),
      );
      state = state.copyWith(loading: false, appointment: data);
    });
  }

  void toggleViewType() {
    state = state.copyWith(
      viewType: state.viewType == ViewType.grid ? ViewType.map : ViewType.grid,
    );
  }

  void clearState() {
    state = const ClinicDoctorState();
  }

  void onSearchChanged(String search) {
    if (search.trim().isEmpty) {
      state = state.copyWith(clinics: _allClinics);
      return;
    }
    final searchedClinics = <Clinic>[];
    for (final clinic in _allClinics) {
      if (clinic.clinicName?.toLowerCase().contains(search.toLowerCase()) ??
          false) {
        searchedClinics.add(clinic);
      } else if (clinic.address?.toLowerCase().contains(search.toLowerCase()) ??
          false) {
        searchedClinics.add(clinic);
      } else if (clinic.phone?.toLowerCase().contains(search.toLowerCase()) ??
          false) {
        searchedClinics.add(clinic);
      }
    }
    state = state.copyWith(clinics: searchedClinics);
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
  final List<Clinic> clinicsToInvite;
  final List<Clinic> clinics;
  final bool clinicLoading;
  final GetDoctorResponse? doctorResponse;
  final bool doctorLoading;
  final int? clinicId;
  final ViewType viewType;
  final Doctor? selectedDoctor;
  final List<Slot> slots;
  final List<PaymentOption> paymentOptions;
  final AppointmentData? appointment;

  const ClinicDoctorState({
    super.loading = false,
    super.errorMessage,
    this.clinicsToInvite = const [],
    this.clinics = const [],
    this.clinicLoading = false,
    this.doctorResponse,
    this.doctorLoading = false,
    this.clinicId,
    this.viewType = ViewType.grid,
    this.selectedDoctor,
    this.slots = const [],
    this.paymentOptions = const [],
    this.appointment,
  });

  @override
  ClinicDoctorState copyWith({
    bool? loading,
    String? errorMessage,
    List<Clinic>? clinicsToInvite,
    List<Clinic>? clinics,
    bool? clinicLoading,
    GetDoctorResponse? doctorResponse,
    bool? doctorLoading,
    int? clinicId,
    ViewType? viewType,
    Doctor? selectedDoctor,
    List<Slot>? slots,
    List<PaymentOption>? paymentOptions,
    AppointmentData? appointment,
  }) {
    return ClinicDoctorState(
      loading: loading ?? this.loading,
      errorMessage: errorMessage ?? this.errorMessage,
      clinicLoading: clinicLoading ?? this.clinicLoading,
      clinicsToInvite: clinicsToInvite ?? this.clinicsToInvite,
      clinics: clinics ?? this.clinics,
      doctorResponse: doctorResponse ?? this.doctorResponse,
      doctorLoading: doctorLoading ?? this.doctorLoading,
      clinicId: clinicId ?? this.clinicId,
      viewType: viewType ?? this.viewType,
      selectedDoctor: selectedDoctor ?? this.selectedDoctor,
      slots: slots ?? this.slots,
      paymentOptions: paymentOptions ?? this.paymentOptions,
      appointment: appointment ?? this.appointment,
    );
  }
}
