import 'package:camera/camera.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/base_state_model.dart';
import '../models/requests/appointment_request.dart';
import '../models/responses/appointment_response.dart';
import '../models/responses/availability_response.dart';
import '../models/responses/get_clinic_response.dart';
import '../models/responses/get_doctor_response.dart';
import '../models/responses/payment_options_response.dart';
import '../models/responses/treatment_list_response.dart';
import '../models/responses/treatment_category_list_response.dart';
import '../models/responses/treatment_area_list_response.dart';
import '../models/selected_treatment_and_areas_model.dart';
import '../repositories/clinic_doctor_repository.dart';
import '../services/api_base_helper.dart';
import '../services/clinic_doctor_service.dart';
import '../services/media_service.dart';
import '../utills/date_time_utills.dart';
import 'auth_view_model.dart';
import 'doctor_view_model.dart';
import 'treatment_view_model.dart';

import 'base_view_model.dart';

final checkoutViewModel = NotifierProvider(() => CheckoutViewModel());

class CheckoutViewModel extends BaseViewModel<CheckoutState> {
  CheckoutViewModel({ClinicDoctorRepository? clinicRepository})
    : _clinicRepository = clinicRepository ?? ClinicDoctorService(apiClient: ApiBaseHelper()),
      super(initialState: const CheckoutState());

  final ClinicDoctorRepository _clinicRepository;
  final _mediaService = MediaService();

  @override
  CheckoutState build() {
    // Keep the provider alive to prevent disposal during navigation
    ref.keepAlive();
    return super.build();
  }

  void updateState({
    String? clinicId,
    String? drId,
    String? appointmentDate,
    String? appointmentTime,
    XFile? capturedImage,
  }) {
    print("state updated");
    state = CheckoutState(
      clinicId: clinicId ?? state.clinicId,
      drId: drId ?? state.drId,
      appointmentDate: appointmentDate ?? state.appointmentDate,
      appointmentTime: appointmentTime ?? state.appointmentTime,
      capturedImage: capturedImage ?? state.capturedImage,
      selectedTreatmentsAndAreas: state.selectedTreatmentsAndAreas,
      selectedCategories: state.selectedCategories,
      selectedTreatments: state.selectedTreatments,
      selectedAreas: state.selectedAreas,
      appointment: state.appointment,
    );
  }

  void clearState() {
    print("state Cleared");
    state = const CheckoutState(
      clinicId: null,
      drId: null,
      appointmentDate: null,
      appointmentTime: null,
      capturedImage: null,
      selectedCategories: [],
      selectedTreatments: null,
      selectedAreas: null,
      selectedTreatmentsAndAreas: [],
      appointment: null,
    );
  }

  void setSelectedTreatments(TreatmentData? treatment) {
    state = state.copyWith(selectedTreatments: treatment);
  }

  void addSelectedTreatment(TreatmentData treatment) {
    // 1. Set currently selected treatment
    final activeTreatment = treatment;

    // 2. Build the SelectedTreatmentAndAreasModel
    final currentTreatmentsAndAreas =
        List<SelectedTreatmentAndAreasModel>.from(state.selectedTreatmentsAndAreas);

    final existingIndex = currentTreatmentsAndAreas
        .indexWhere((item) => item.treatment.id == treatment.id);

    if (state.selectedAreas != null) {
      final area = state.selectedAreas!;
      if (existingIndex != -1) {
        final existingItem = currentTreatmentsAndAreas[existingIndex];
        if (!existingItem.selectedAreas.any((a) => a.id == area.id)) {
          currentTreatmentsAndAreas[existingIndex] = existingItem.copyWith(
            selectedAreas: [...existingItem.selectedAreas, area],
          );
        }
      } else {
        currentTreatmentsAndAreas.add(
          SelectedTreatmentAndAreasModel(
            treatment: treatment,
            selectedAreas: [area],
          ),
        );
      }
    } else {
      if (existingIndex == -1) {
        currentTreatmentsAndAreas.add(
          SelectedTreatmentAndAreasModel(
            treatment: treatment,
            selectedAreas: const [],
          ),
        );
      }
    }

    state = state.copyWith(
      selectedTreatments: activeTreatment,
      selectedTreatmentsAndAreas: currentTreatmentsAndAreas,
    );
    _printSelectedTreatmentsAndAreas();
  }

  void addSelectedCategory(TreatmentCategoryModel category) {
    final currentList = state.selectedCategories ?? [];
    if (!currentList.any((c) => c.id == category.id)) {
      state = state.copyWith(selectedCategories: [...currentList, category]);
    }
  }

  void setSelectedAreas(TreatmentAreaModel? area) {
    final currentTreatmentsAndAreas =
        List<SelectedTreatmentAndAreasModel>.from(state.selectedTreatmentsAndAreas);
    if (area != null && currentTreatmentsAndAreas.isNotEmpty) {
      final lastIndex = currentTreatmentsAndAreas.length - 1;
      currentTreatmentsAndAreas[lastIndex] =
          currentTreatmentsAndAreas[lastIndex].copyWith(selectedAreas: [area]);
    }

    state = state.copyWith(
      selectedAreas: area,
      selectedTreatmentsAndAreas: currentTreatmentsAndAreas,
    );
    _printSelectedTreatmentsAndAreas();
  }

  void addSelectedArea(TreatmentAreaModel area) {
    // 1. Save area in selectedAreas
    final activeArea = area;

    // 2. Sync with selectedTreatmentsAndAreas
    final currentTreatmentsAndAreas =
        List<SelectedTreatmentAndAreasModel>.from(state.selectedTreatmentsAndAreas);

    if (state.selectedTreatments != null) {
      final activeTreatment = state.selectedTreatments!;
      final existingIndex = currentTreatmentsAndAreas
          .indexWhere((item) => item.treatment.id == activeTreatment.id);

      if (existingIndex != -1) {
        final existingItem = currentTreatmentsAndAreas[existingIndex];
        if (!existingItem.selectedAreas.any((a) => a.id == area.id)) {
          currentTreatmentsAndAreas[existingIndex] = existingItem.copyWith(
            selectedAreas: [...existingItem.selectedAreas, area],
          );
        }
      } else {
        currentTreatmentsAndAreas.add(
          SelectedTreatmentAndAreasModel(
            treatment: activeTreatment,
            selectedAreas: [area],
          ),
        );
      }
    } else {
      print(
          "No active selectedTreatments found in state. Area not added to SelectedTreatmentAndAreasModel.");
    }

    state = state.copyWith(
      selectedAreas: activeArea,
      selectedTreatmentsAndAreas: currentTreatmentsAndAreas,
    );
    _printSelectedTreatmentsAndAreas();
  }

  void removeTreatment(int treatmentId) {
    final currentList =
        List<SelectedTreatmentAndAreasModel>.from(state.selectedTreatmentsAndAreas);
    currentList.removeWhere((item) => item.treatment.id == treatmentId);

    final activeTreatment = state.selectedTreatments;
    final updatedActiveTreatment =
        activeTreatment?.id == treatmentId ? null : activeTreatment;

    state = state.copyWith(
      selectedTreatmentsAndAreas: currentList,
      selectedTreatments: updatedActiveTreatment,
    );
    _printSelectedTreatmentsAndAreas();
  }

  void removeArea(int areaId) {
    final currentList = state.selectedTreatmentsAndAreas.map((item) {
      final updatedAreas =
          item.selectedAreas.where((a) => a.id != areaId).toList();
      return item.copyWith(selectedAreas: updatedAreas);
    }).toList();

    final activeArea = state.selectedAreas;
    final updatedActiveArea = activeArea?.id == areaId ? null : activeArea;

    state = state.copyWith(
      selectedAreas: updatedActiveArea,
      selectedTreatmentsAndAreas: currentList,
    );
    _printSelectedTreatmentsAndAreas();
  }

  Future<void> createAppointment({
    required Clinic clinic,
    required Doctor doctor,
    required Slot slot,
    required PaymentOption paymentOption,
  }) async {
    return await runSafely(() async {
      state = state.copyWith(loading: true);

      final doctorState = ref.read(doctorProvider);
      final pricingData = ref.read(doctorProvider.notifier).pricingData;

      final actualAmount = doctorState.paymentOptions
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
          pricingData.treatment!.price! *
          subAreas.fold(0, (prev, next) {
            return prev + next.currentSyringe + 1;
          });
      final userId = ref.read(authViewModel).authData!.user!.id!;
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
            final price = pricingData.subSections!.where((subSection) {
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

  void _printSelectedTreatmentsAndAreas() {
    print("--- Selected Treatments and Areas ---");
    for (final item in state.selectedTreatmentsAndAreas) {
      print("Treatment: ${item.treatment.name} (ID: ${item.treatment.id})");
      print("  Areas: ${item.selectedAreas.map((e) => '${e.name} (ID: ${e.id})').toList()}");
    }
    print("-------------------------------------");
  }
}

class CheckoutState extends BaseStateModel {
  final List<SelectedTreatmentAndAreasModel> selectedTreatmentsAndAreas;
  final List<TreatmentCategoryModel>? selectedCategories;
  final TreatmentData? selectedTreatments;
  final TreatmentAreaModel? selectedAreas;
  final String? clinicId;
  final String? drId;
  final String? appointmentDate;
  final String? appointmentTime;
  final XFile? capturedImage;
  final AppointmentData? appointment;

  const CheckoutState({
    super.loading = false,
    super.errorMessage,
    this.clinicId,
    this.drId,
    this.appointmentDate,
    this.appointmentTime,
    this.capturedImage,
    this.selectedTreatmentsAndAreas = const [],
    this.selectedCategories = const [],
    this.selectedTreatments,
    this.selectedAreas,
    this.appointment,
  });

  @override
  CheckoutState copyWith({
    bool? loading,
    String? errorMessage,
    String? clinicId,
    String? drId,
    String? appointmentDate,
    String? appointmentTime,
    XFile? capturedImage,
    List<SelectedTreatmentAndAreasModel>? selectedTreatmentsAndAreas,
    List<TreatmentCategoryModel>? selectedCategories,
    TreatmentData? selectedTreatments,
    TreatmentAreaModel? selectedAreas,
    AppointmentData? appointment,
  }) {
    return CheckoutState(
      loading: loading ?? this.loading,
      errorMessage: errorMessage ?? this.errorMessage,
      clinicId: clinicId ?? this.clinicId,
      drId: drId ?? this.drId,
      appointmentDate: appointmentDate ?? this.appointmentDate,
      appointmentTime: appointmentTime ?? this.appointmentTime,
      capturedImage: capturedImage ?? this.capturedImage,
      selectedTreatmentsAndAreas:
          selectedTreatmentsAndAreas ?? this.selectedTreatmentsAndAreas,
      selectedCategories: selectedCategories ?? this.selectedCategories,
      selectedTreatments: selectedTreatments ?? this.selectedTreatments,
      selectedAreas: selectedAreas ?? this.selectedAreas,
      appointment: appointment ?? this.appointment,
    );
  }
}
