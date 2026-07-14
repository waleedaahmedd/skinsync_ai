import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../models/base_state_model.dart';
import '../models/dummy_list_model.dart';
import '../models/responses/get_clinic_response.dart';
import '../repositories/clinic_doctor_repository.dart';
import '../services/api_base_helper.dart';
import '../services/clinic_doctor_service.dart';
import '../services/location_service.dart';
import '../utills/enums.dart';
import 'auth_view_model.dart';
import 'base_view_model.dart';

final clinicProvider = NotifierProvider(() {
  final apiBaseHelper = ApiBaseHelper();
  final clinicService = ClinicDoctorService(apiClient: apiBaseHelper);
  return ClinicViewModel(clinicRepository: clinicService);
});

class ClinicViewModel extends BaseViewModel<ClinicState> {
  ClinicViewModel({ClinicDoctorRepository? clinicRepository})
    : super(initialState: const ClinicState());

  final List<Clinic> _allClinics = <Clinic>[];

  void setClinicId(int id) {
    state = state.copyWith(clinicId: id);
  }

  Future<bool?> getClinic({int? treatmentId, List<int>? sideAreaIds}) async {
    return runSafely(() async {
      state = state.copyWith(clinicLoading: true);
      // Simulate network delay of 500ms
      await Future.delayed(const Duration(milliseconds: 500));
      state = state.copyWith(
        clinicLoading: false,
        clinics: dummyClinicsForService,
      );
      return true;
    });
  }

  Future<void> fetchClinicsFromMap() async {
    return await runSafely(() async {
      state = state.copyWith(clinicLoading: true);
      await ref.read(authViewModel.notifier).fetchLocation();
      LatLng? location = ref.read(authViewModel).addressData?.latLng;
      if (location == null) {
        ref.read(authViewModel.notifier).fetchLocation();
      }
      location = ref.read(authViewModel).addressData!.latLng;
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

  void toggleViewType() {
    state = state.copyWith(
      viewType: state.viewType == ViewType.grid ? ViewType.map : ViewType.grid,
    );
  }

  void clearState() {
    state = const ClinicState();
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
    state = state.copyWith(clinicLoading: false);
    super.onError(message);
    EasyLoading.showError(message);
  }
}

@immutable
class ClinicState extends BaseStateModel {
  final List<Clinic> clinicsToInvite;
  final List<Clinic> clinics;
  final bool clinicLoading;
  final int? clinicId;
  final ViewType viewType;

  const ClinicState({
    super.loading = false,
    super.errorMessage,
    this.clinicsToInvite = const [],
    this.clinics = const [],
    this.clinicLoading = false,
    this.clinicId,
    this.viewType = ViewType.grid,
  });

  @override
  ClinicState copyWith({
    bool? loading,
    String? errorMessage,
    List<Clinic>? clinicsToInvite,
    List<Clinic>? clinics,
    bool? clinicLoading,
    int? clinicId,
    ViewType? viewType,
  }) {
    return ClinicState(
      loading: loading ?? this.loading,
      errorMessage: errorMessage ?? this.errorMessage,
      clinicLoading: clinicLoading ?? this.clinicLoading,
      clinicsToInvite: clinicsToInvite ?? this.clinicsToInvite,
      clinics: clinics ?? this.clinics,
      clinicId: clinicId ?? this.clinicId,
      viewType: viewType ?? this.viewType,
    );
  }
}
