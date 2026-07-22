import 'package:camera/camera.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/base_state_model.dart';
import '../models/dummy_list_model.dart';
import '../models/flat_selection_model.dart';
import '../models/requests/appointment_request.dart';
import '../models/requests/invite_clinic_request.dart';
import '../models/responses/appointment_response.dart';
import '../models/responses/appointment_type_list_response.dart';
import '../models/responses/availability_response.dart';
import '../models/responses/get_clinic_response.dart';
import '../models/responses/get_doctor_response.dart';
import '../models/responses/payment_options_response.dart';
import '../models/responses/treatment_area_list_response.dart';
import '../models/responses/treatment_category_list_response.dart';
import '../models/responses/treatment_list_response.dart';
import '../models/selected_treatment_and_areas_model.dart';
import '../repositories/appointment_repository.dart';
import '../repositories/clinic_doctor_repository.dart';
import '../services/api_base_helper.dart';
import '../services/appointment_service.dart';
import '../services/clinic_doctor_service.dart';
import '../services/media_service.dart';
import '../utills/date_time_utills.dart';
import 'auth_view_model.dart';
import 'base_view_model.dart';
import 'doctor_view_model.dart';
import 'treatment_view_model.dart';

final checkoutViewModel = NotifierProvider(() => CheckoutViewModel());

class CheckoutViewModel extends BaseViewModel<CheckoutState> {
  CheckoutViewModel({
    ClinicDoctorRepository? clinicRepository,
    AppointmentRepository? appointmentRepository,
  }) : _clinicRepository = clinicRepository ??
            ClinicDoctorService(apiClient: ApiBaseHelper()),
        _appointmentRepository = appointmentRepository ??
            AppointmentService(apiClient: ApiBaseHelper()),
        super(initialState: const CheckoutState());

  final ClinicDoctorRepository _clinicRepository;
  final AppointmentRepository _appointmentRepository;
  final _mediaService = MediaService();

  // ---------------------------------------------------------------------------
  // Initialization & Lifecycle
  // ---------------------------------------------------------------------------

  @override
  CheckoutState build() {
    ref.keepAlive();
    return super.build();
  }

  // ---------------------------------------------------------------------------
  // Selection Setters (Session Tracking)
  // ---------------------------------------------------------------------------

  void setSelectedClinic(Clinic clinic) {
    state = state.copyWith(
      selectedClinic: clinic,
      clinicId: clinic.id.toString(),
    );
    _log("Selected clinic saved: ${clinic.name}");
  }

  void setSelectedAppointmentType(AppointmentTypeData type) {
    state = state.copyWith(selectedAppointmentType: type);
    _log("Selected appointment type saved: ${type.title}");
  }

  void setSelectedDoctor(DummyDoctor doctor) {
    state = state.copyWith(selectedDoctor: doctor, drId: doctor.id);
    _log("Selected doctor saved: ${doctor.name}");
  }

  void setSelectedDate(DateTime? date) {
    state = state.copyWith(
      selectedDate: date,
      appointmentDate: date?.toIso8601String(),
    );
    _log("Selected Date saved: $date");
  }

  void setSelectedSlot(String? slot) {
    state = state.copyWith(selectedSlot: slot, appointmentTime: slot);
    _log("Selected Slot saved: $slot");
  }

  void setInviteClinic(bool value) {
    if (state.isInviteClinic == value) return;
    state = state.copyWith(isInviteClinic: value);
    _log("isInviteClinic set to: $value");
  }

  // ---------------------------------------------------------------------------
  // Treatment Selection Logic
  // ---------------------------------------------------------------------------

  void setSelectedTreatments(TreatmentData? treatment) {
    state = state.copyWith(selectedTreatments: treatment);
  }

  void addSelectedTreatment(TreatmentData treatment) {
    // Cleanup: Remove treatments with no areas, keeping only the active one
    final updatedList = state.selectedTreatmentsAndAreas
        .where((item) =>
            item.selectedAreas.isNotEmpty || item.treatment.id == treatment.id)
        .toList();

    final exists = updatedList.any((item) => item.treatment.id == treatment.id);
    if (!exists) {
      updatedList.add(
        SelectedTreatmentAndAreasModel(
          treatment: treatment,
          selectedAreas: const [],
        ),
      );
    }

    state = state.copyWith(
      selectedTreatments: treatment,
      selectedTreatmentsAndAreas: updatedList,
    );
    flatSelections();
    _printSelectedTreatmentsAndAreas();
  }

  void addSelectedCategory(TreatmentCategoryModel category) {
    final currentList = state.selectedCategories ?? [];
    if (!currentList.any((c) => c.id == category.id)) {
      state = state.copyWith(selectedCategories: [...currentList, category]);
    }
  }

  void removeTreatment(int treatmentId) {
    final currentList = List<SelectedTreatmentAndAreasModel>.from(
      state.selectedTreatmentsAndAreas,
    );
    currentList.removeWhere((item) => item.treatment.id == treatmentId);

    final activeTreatment = state.selectedTreatments;
    final updatedActive =
        activeTreatment?.id == treatmentId ? null : activeTreatment;

    state = state.copyWith(
      selectedTreatmentsAndAreas: currentList,
      selectedTreatments: updatedActive,
    );
    flatSelections();
    _printSelectedTreatmentsAndAreas();
  }

  void clearSelectedTreatments() {
    state = state.copyWith(selectedTreatmentsAndAreas: []);
    flatSelections();
  }

  // ---------------------------------------------------------------------------
  // Area Selection Logic
  // ---------------------------------------------------------------------------

  void setSelectedAreas(TreatmentAreaModel? area) {
    state = state.copyWith(selectedAreas: area);
  }

  void addSelectedArea(TreatmentAreaModel area) {
    final activeTreatment = state.selectedTreatments;
    if (activeTreatment == null) {
      _log("Warning: No active treatment found. Area not added.");
      return;
    }

    _updateTreatmentAreaSelection(
      treatment: activeTreatment,
      area: area,
      updateAction: (existingAreas) {
        if (!existingAreas.any((a) => a.target.id == area.id)) {
          return [
            ...existingAreas,
            SelectedAreaModel(target: area, material: null),
          ];
        }
        return existingAreas;
      },
    );
  }

  void saveMaterialForArea({
    required TreatmentData treatment,
    required TreatmentAreaModel area,
    required SelectedMaterialModel? material,
  }) {
    _updateTreatmentAreaSelection(
      treatment: treatment,
      area: area,
      updateAction: (existingAreas) {
        final areaIndex = existingAreas.indexWhere((a) => a.target.id == area.id);
        final updatedAreas = List<SelectedAreaModel>.from(existingAreas);

        if (areaIndex != -1) {
          updatedAreas[areaIndex] =
              updatedAreas[areaIndex].copyWith(material: material);
        } else {
          updatedAreas.add(SelectedAreaModel(target: area, material: material));
        }
        return updatedAreas;
      },
    );
  }

  void removeArea(int areaId) {
    final updatedList = state.selectedTreatmentsAndAreas
        .map((item) {
          final filteredAreas =
              item.selectedAreas.where((a) => a.target.id != areaId).toList();
          return item.copyWith(selectedAreas: filteredAreas);
        })
        .where((item) => item.selectedAreas.isNotEmpty)
        .toList();

    final activeArea = state.selectedAreas;
    final updatedActive = activeArea?.id == areaId ? null : activeArea;

    state = state.copyWith(
      selectedAreas: updatedActive,
      selectedTreatmentsAndAreas: updatedList,
    );
    flatSelections();
    ref.read(treatmentViewModel.notifier).removeSubArea(areaId);
    _printSelectedTreatmentsAndAreas();
  }

  void removeSubArea(int subAreaId) {
    state = state.copyWith(
      selectedAreas: state.selectedAreas?.copyWith(
        subAreas: state.selectedAreas?.subAreas
            ?.where((element) => element.id != subAreaId)
            .toList(),
      ),
    );
  }

  void removeFlatSelection({required int treatmentId, required int areaId}) {
    final updatedList = state.selectedTreatmentsAndAreas
        .map((item) {
          if (item.treatment.id != treatmentId) return item;

          final updatedAreas = item.selectedAreas
              .where((areaItem) => (areaItem.target.id ?? 0) != areaId)
              .toList();
          return item.copyWith(selectedAreas: updatedAreas);
        })
        .where((item) => item.selectedAreas.isNotEmpty)
        .toList();

    state = state.copyWith(selectedTreatmentsAndAreas: updatedList);
    flatSelections();
  }

  void clearAreaSelection() {
    state = state.copyWithNull(selectedAreas: true);
  }

  void onTapTreatmentSubArea({required TreatmentAreaModel subArea}) {
    final activeArea = state.selectedAreas;
    final parentId = activeArea?.id ?? subArea.areaId ?? subArea.id ?? 0;
    final treatmentSubArea = subArea.copyWith(areaId: parentId);

    final alreadySelected =
        treatmentSubArea.id != null &&
        (activeArea?.subAreas?.any((e) => e.id == treatmentSubArea.id) ?? false);

    final updatedSubAreas = alreadySelected
        ? activeArea?.subAreas ?? <TreatmentAreaModel>[]
        : <TreatmentAreaModel>[...activeArea?.subAreas ?? [], treatmentSubArea];

    state = state.copyWith(
      selectedAreas: treatmentSubArea.copyWith(subAreas: updatedSubAreas),
    );
    ref.read(treatmentViewModel.notifier).clearAiImage();
  }

  void flatSelections() {
    final List<FlatSelectionModel> list = [];
    for (final item in state.selectedTreatmentsAndAreas) {
      final tId = item.treatment.id ?? 0;
      final tName = item.treatment.name ?? '';
      for (final areaItem in item.selectedAreas) {
        list.add(
          FlatSelectionModel(
            treatmentId: tId,
            treatmentName: tName,
            areaId: areaItem.target.id ?? 0,
            areaName: areaItem.target.name ?? '',
            treatmentCost: 120, // Static cost as requested
            material: areaItem.material,
          ),
        );
      }
    }
    state = state.copyWith(checkoutTreatmentsList: list);
  }

  // ---------------------------------------------------------------------------
  // State Management Helpers
  // ---------------------------------------------------------------------------

  void updateState({
    String? clinicId,
    String? drId,
    String? appointmentDate,
    String? appointmentTime,
    XFile? capturedImage,
  }) {
    _log("state updated");
    state = state.copyWith(
      clinicId: clinicId,
      drId: drId,
      appointmentDate: appointmentDate,
      appointmentTime: appointmentTime,
      capturedImage: capturedImage,
    );
  }

  void clearState() {
    _log("state Cleared");
    state = const CheckoutState();
  }

  // ---------------------------------------------------------------------------
  // API Methods
  // ---------------------------------------------------------------------------

  Future<bool?> inviteClinic({
    required Clinic clinic,
    required num consultationFees,
    required num initialDeposit,
    required List<AvailabilityModel> availability,
  }) async {
    return await runSafely(() async {
      EasyLoading.show(status: 'Loading...');
      final request = await clinic.toInviteRequest(
        consultationFees: consultationFees,
        initialDeposit: initialDeposit,
        availability: availability,
      );
      await _clinicRepository.inviteClinic(request);
      EasyLoading.dismiss();
      return true;
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

      final pricingData = ref.read(doctorProvider.notifier).pricingData;
      if (pricingData == null) throw Exception('Pricing data not found');

      final paymentOptions = ref.read(doctorProvider).paymentOptions;
      final actualAmount = paymentOptions
          .where((option) => option.title?.contains('Full Payment') ?? false)
          .firstOrNull
          ?.amount;

      if (actualAmount == null) throw Exception('No full payment option found');

      final treatmentState = ref.read(treatmentViewModel);
      final beforeImg = treatmentState.capturedImage;
      final afterImg = treatmentState.aiImage;

      if (beforeImg == null || afterImg == null) {
        throw Exception('No image captured');
      }

      final userId = ref.read(authViewModel).authData!.user!.id!;
      final uploadedBefore = await _uploadMedia(userId, beforeImg, 'before');
      final uploadedAfter = await _uploadMedia(userId, afterImg, 'after');

      final treatment = state.selectedTreatments!;
      final subAreas = state.selectedAreas?.subAreas ?? [];
      final treatmentPrice = pricingData.treatment!.price! * subAreas.length;

      final request = AppointmentRequest(
        date: slot.startTime.secondsSinceEpoch,
        startTime: slot.startTime.secondsSinceEpoch,
        endTime: slot.endTime.secondsSinceEpoch,
        clinicId: clinic.id!,
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
          final price = pricingData.subSections!
              .firstWhere((ss) => ss.name == subArea.name);
          return TreatmentSubsectionRequest(
            sectionId: subArea.id!,
            syringesQuantity: 0,
            perSyringePrice: price.perSyringePrice!,
          );
        }).toList(),
        treatmentTotal: treatmentPrice.toInt(),
      );

      final data = await _appointmentRepository.createAppointment(request: request);
      state = state.copyWith(loading: false, appointment: data);
    });
  }

  // ---------------------------------------------------------------------------
  // Private Helpers
  // ---------------------------------------------------------------------------

  Future<String> _uploadMedia(int userId, XFile file, String type) async {
    final path = '$userId/appointments/$type/';
    final result = await _mediaService.uploadImage(path, file);
    if (result == null) throw Exception('Failed to upload $type image');
    return result;
  }

  void _updateTreatmentAreaSelection({
    required TreatmentData treatment,
    required TreatmentAreaModel area,
    required List<SelectedAreaModel> Function(List<SelectedAreaModel>) updateAction,
  }) {
    final currentList = List<SelectedTreatmentAndAreasModel>.from(
      state.selectedTreatmentsAndAreas,
    );

    final index = currentList.indexWhere((item) => item.treatment.id == treatment.id);

    if (index != -1) {
      final existingItem = currentList[index];
      currentList[index] = existingItem.copyWith(
        selectedAreas: updateAction(existingItem.selectedAreas),
      );
    } else {
      currentList.add(
        SelectedTreatmentAndAreasModel(
          treatment: treatment,
          selectedAreas: updateAction(const []),
        ),
      );
    }

    state = state.copyWith(
      selectedAreas: area,
      selectedTreatments: treatment,
      selectedTreatmentsAndAreas: currentList,
    );

    flatSelections();
    onTapTreatmentSubArea(subArea: area);
    _printSelectedTreatmentsAndAreas();
  }

  void _printSelectedTreatmentsAndAreas() {
    _log("--- Selected Treatments and Areas ---");
    for (final item in state.selectedTreatmentsAndAreas) {
      _log("Treatment: ${item.treatment.name} (ID: ${item.treatment.id})");
      final areaNames = item.selectedAreas.map((e) => e.target.name).toList();
      _log("  Areas: $areaNames");
    }
    _log("-------------------------------------");
  }

  void _log(String message) => print(message);
}

// ---------------------------------------------------------------------------
// State Class
// ---------------------------------------------------------------------------

class CheckoutState extends BaseStateModel {
  final List<SelectedTreatmentAndAreasModel> selectedTreatmentsAndAreas;
  final List<FlatSelectionModel> checkoutTreatmentsList;
  final List<int> selectedAreaIds;
  final List<TreatmentCategoryModel>? selectedCategories;
  final TreatmentData? selectedTreatments;
  final TreatmentAreaModel? selectedAreas;
  final String? clinicId;
  final String? drId;
  final String? appointmentDate;
  final String? appointmentTime;
  final XFile? capturedImage;
  final AppointmentData? appointment;

  final Clinic? selectedClinic;
  final AppointmentTypeData? selectedAppointmentType;
  final DummyDoctor? selectedDoctor;
  final DateTime? selectedDate;
  final String? selectedSlot;
  final bool isInviteClinic;

  const CheckoutState({
    super.loading = false,
    super.errorMessage,
    this.clinicId,
    this.drId,
    this.appointmentDate,
    this.appointmentTime,
    this.capturedImage,
    this.selectedTreatmentsAndAreas = const [],
    this.checkoutTreatmentsList = const [],
    this.selectedAreaIds = const [],
    this.selectedCategories = const [],
    this.selectedTreatments,
    this.selectedAreas,
    this.appointment,
    this.selectedClinic,
    this.selectedAppointmentType,
    this.selectedDoctor,
    this.selectedDate,
    this.selectedSlot,
    this.isInviteClinic = false,
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
    List<FlatSelectionModel>? checkoutTreatmentsList,
    List<int>? selectedAreaIds,
    List<TreatmentCategoryModel>? selectedCategories,
    TreatmentData? selectedTreatments,
    TreatmentAreaModel? selectedAreas,
    AppointmentData? appointment,
    Clinic? selectedClinic,
    AppointmentTypeData? selectedAppointmentType,
    DummyDoctor? selectedDoctor,
    DateTime? selectedDate,
    String? selectedSlot,
    bool? isInviteClinic,
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
      checkoutTreatmentsList:
          checkoutTreatmentsList ?? this.checkoutTreatmentsList,
      selectedAreaIds: selectedAreaIds ?? this.selectedAreaIds,
      selectedCategories: selectedCategories ?? this.selectedCategories,
      selectedTreatments: selectedTreatments ?? this.selectedTreatments,
      selectedAreas: selectedAreas ?? this.selectedAreas,
      appointment: appointment ?? this.appointment,
      selectedClinic: selectedClinic ?? this.selectedClinic,
      selectedAppointmentType:
          selectedAppointmentType ?? this.selectedAppointmentType,
      selectedDoctor: selectedDoctor ?? this.selectedDoctor,
      selectedDate: selectedDate ?? this.selectedDate,
      selectedSlot: selectedSlot ?? this.selectedSlot,
      isInviteClinic: isInviteClinic ?? this.isInviteClinic,
    );
  }

  CheckoutState copyWithNull({
    bool clinicId = false,
    bool drId = false,
    bool appointmentDate = false,
    bool appointmentTime = false,
    bool capturedImage = false,
    bool selectedTreatments = false,
    bool selectedAreas = false,
    bool appointment = false,
    bool selectedClinic = false,
    bool selectedAppointmentType = false,
    bool selectedDoctor = false,
    bool selectedDate = false,
    bool selectedSlot = false,
  }) {
    return CheckoutState(
      loading: loading,
      errorMessage: errorMessage,
      clinicId: clinicId ? null : this.clinicId,
      drId: drId ? null : this.drId,
      appointmentDate: appointmentDate ? null : this.appointmentDate,
      appointmentTime: appointmentTime ? null : this.appointmentTime,
      capturedImage: capturedImage ? null : this.capturedImage,
      selectedTreatmentsAndAreas: selectedTreatmentsAndAreas,
      checkoutTreatmentsList: checkoutTreatmentsList,
      selectedCategories: selectedCategories,
      selectedTreatments: selectedTreatments ? null : this.selectedTreatments,
      selectedAreas: selectedAreas ? null : this.selectedAreas,
      appointment: appointment ? null : this.appointment,
      selectedClinic: selectedClinic ? null : this.selectedClinic,
      selectedAppointmentType:
          selectedAppointmentType ? null : this.selectedAppointmentType,
      selectedDoctor: selectedDoctor ? null : this.selectedDoctor,
      selectedDate: selectedDate ? null : this.selectedDate,
      selectedSlot: selectedSlot ? null : this.selectedSlot,
      isInviteClinic: isInviteClinic,
    );
  }
}
