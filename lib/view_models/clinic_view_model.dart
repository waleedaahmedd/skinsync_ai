import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../models/base_state_model.dart';
import '../models/requests/get_clinic_request.dart';
import '../models/responses/auth_response.dart';
import '../models/responses/clinic_detail_response.dart';
import '../models/responses/get_clinic_response.dart';
import '../repositories/clinic_repository.dart';
import '../services/api_base_helper.dart';
import '../services/clinic_service.dart';
import '../services/location_service.dart';
import '../utils/enums.dart';
import 'auth_view_model.dart';
import 'base_view_model.dart';
import 'checkout_view_model.dart';

final clinicProvider =
    NotifierProvider.autoDispose<ClinicViewModel, ClinicState>(() {
      final apiBaseHelper = ApiBaseHelper();
      final clinicService = ClinicService(apiClient: apiBaseHelper);
      return ClinicViewModel(repository: clinicService);
    });

class ClinicViewModel extends BaseViewModel<ClinicState> {
  final ClinicRepository _repository;
  ClinicViewModel({required this._repository})
    : super(initialState: const ClinicState());

  final TextEditingController searchController = TextEditingController();

  void setClinic(Clinic? clinic) {
    state = state.copyWith(clinic: clinic);
  }

  Future<void> fetchClinicDetail(int? clinicId) async {
    return await runSafely(() async {
      if (clinicId == null) {
        return;
      }
      state = state.copyWith(loading: true, errorMessage: null);
      final response = await _repository.getClinicDetail(clinicId);
      if (!ref.mounted) return;
      state = state.copyWith(
        loading: false,
        clinicDetail: response.data,
        clinic: Clinic(
          id: response.data?.id,
          name: response.data?.name,
          email: response.data?.email,
          phone: response.data?.phone,
          description: response.data?.description,
          address: response.data?.address,
          logo: response.data?.logo,
          banner: response.data?.banner,
          status: response.data?.status,
          location:
              response.data?.latitude != null &&
                  response.data?.longitude != null
              ? LatLng(response.data!.latitude!, response.data!.longitude!)
              : null,
        ),
      );
    });
  }

  Future<List<Clinic>?> getClinic({int? page, String? search}) async {
    return runSafely(() async {
      // state = state.copyWith(clinicLoading: true);
      final treatments = ref.read(
        checkoutViewModel.select((s) {
          return s.selectedTreatmentsAndAreas;
        }),
      );
      final request = GetClinicRequest(
        search: search,
        page: page ?? 1,
        treatments: treatments.map((t) {
          return GetClinicTreatmentRequest(
            treatmentId: t.treatment.id!,
            areaIds: t.selectedAreas.map((a) => a.target.id).nonNulls.toList(),
          );
        }).toList(),
      );
      final response = await _repository.getClinic(request: request);
      if (!ref.mounted) return null;
      state = state.copyWith(
        clinicLoading: false,
        clinics: response.data ?? [],
      );
      return response.data ?? [];
    });
  }

  Future<void> fetchClinicsFromMap({String? search}) async {
    return await runSafely(() async {
      state = state.copyWith(clinicLoading: true);
      LatLng? location = ref.read(authViewModel).addressData?.latLng;
      if (location == null) {
        await ref.read(authViewModel.notifier).fetchLocation(true);
      }
      location = ref.read(authViewModel).addressData!.latLng;
      final places = await LocationService().fetchNearbyClinics(
        location: location,
        search: search,
      );
      if (!ref.mounted) return;
      final List<Clinic> clinics = [];
      for (final place in places) {
        clinics.add(
          Clinic(
            id: 29,
            phone: place.internationalPhoneNumber,
            description: place.primaryTypeDisplayName?.text,
            address: place.shortFormattedAddress,
            name: place.displayName?.text,
            logo: place.photos?.firstOrNull?.name,
            banner: place.photos?.firstOrNull?.name,
            location: place.location != null
                ? LatLng(place.location!.latitude!, place.location!.longitude!)
                : null,
            place: place,
          ),
        );
      }
      if (!ref.mounted) return;
      state = state.copyWith(clinicLoading: false, clinicsToInvite: clinics);
    });
  }

  Future<List<RequestClinicTreatmentModel>?> fetchSharedClinic(
    int pageKey, {
    String? search,
  }) async {
    state = state.copyWith(loading: true);
    return runSafely(() async {
      final response = await _repository.getSharedClinics(
        page: pageKey,
        search: (search ?? '').trim(),
      );

      final newItems = response.data ?? [];
      final totalPages = response.totalPages ?? 1;

      if (!ref.mounted) return newItems;

      final updatedList = pageKey == 1
          ? newItems
          : [...state.sharedClinics, ...newItems];

      state = state.copyWith(
        totalPages: totalPages,
        sharedClinics: updatedList,
        loading: false,
      );

      return newItems;
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

  @override
  void onError(String message) {
    state = state.copyWith(clinicLoading: false, loading: false);
    super.onError(message);
    EasyLoading.showError(message);
  }
}

@immutable
class ClinicState extends BaseStateModel {
  final List<Clinic> clinicsToInvite;
  final List<Clinic> clinics;
  final bool clinicLoading;
  final Clinic? clinic;
  final ClinicDetailData? clinicDetail;
  final ViewType viewType;
  final int? totalPages;
  final List<RequestClinicTreatmentModel> sharedClinics;

  const ClinicState({
    super.loading = false,
    super.errorMessage,
    this.clinicsToInvite = const [],
    this.clinics = const [],
    this.clinicLoading = false,
    this.clinic,
    this.clinicDetail,
    this.viewType = ViewType.grid,
    this.totalPages,
    this.sharedClinics = const [],
  });

  @override
  ClinicState copyWith({
    bool? loading,
    String? errorMessage,
    List<Clinic>? clinicsToInvite,
    List<Clinic>? clinics,
    bool? clinicLoading,
    Clinic? clinic,
    ClinicDetailData? clinicDetail,
    ViewType? viewType,
    int? totalPages,
    List<RequestClinicTreatmentModel>? sharedClinics,
  }) {
    return ClinicState(
      loading: loading ?? this.loading,
      errorMessage: errorMessage ?? this.errorMessage,
      clinicLoading: clinicLoading ?? this.clinicLoading,
      clinicsToInvite: clinicsToInvite ?? this.clinicsToInvite,
      clinics: clinics ?? this.clinics,
      clinic: clinic ?? this.clinic,
      clinicDetail: clinicDetail ?? this.clinicDetail,
      viewType: viewType ?? this.viewType,
      totalPages: totalPages ?? this.totalPages,
      sharedClinics: sharedClinics ?? this.sharedClinics,
    );
  }
}
