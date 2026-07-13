import 'package:camera/camera.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/base_state_model.dart';
import '../models/dummy_list_model.dart';
import '../models/flat_selection_model.dart';
import '../models/requests/appointment_request.dart';
import '../models/responses/appointment_response.dart';
import '../models/responses/availability_response.dart';
import '../models/responses/get_clinic_response.dart';
import '../models/responses/get_doctor_response.dart';
import '../models/responses/payment_options_response.dart';
import '../models/responses/treatment_area_list_response.dart';
import '../models/responses/treatment_category_list_response.dart';
import '../models/responses/treatment_list_response.dart';
import '../models/selected_treatment_and_areas_model.dart';
import '../repositories/clinic_doctor_repository.dart';
import '../services/api_base_helper.dart';
import '../services/clinic_doctor_service.dart';
import '../services/media_service.dart';
import '../utills/date_time_utills.dart';
import '../utills/enums.dart';
import 'auth_view_model.dart';
import 'base_view_model.dart';
import 'doctor_view_model.dart';
import 'treatment_view_model.dart';

final checkoutViewModel = NotifierProvider(() => CheckoutViewModel());

class CheckoutViewModel extends BaseViewModel<CheckoutState> {
  CheckoutViewModel({ClinicDoctorRepository? clinicRepository})
    : _clinicRepository =
          clinicRepository ?? ClinicDoctorService(apiClient: ApiBaseHelper()),
      super(initialState: const CheckoutState());

  final ClinicDoctorRepository _clinicRepository;
  final _mediaService = MediaService();

  @override
  CheckoutState build() {
    // Keep the provider alive to prevent disposal during navigation
    ref.keepAlive();
    return super.build();
  }

  void setSelectedClinic(Clinic clinic) {
    state = state.copyWith(
      selectedClinic: clinic,
      clinicId: clinic.clinicId.toString(),
    );
    print("Selected clinic saved to CheckoutState: ${clinic.clinicName}");
  }

  void setSelectedAppointmentType(AppointmentType type) {
    state = state.copyWith(selectedAppointmentType: type);
    print("Selected appointment type saved to CheckoutState: ${type.typeText}");
  }

  void setSelectedDoctor(DummyDoctor doctor) {
    state = state.copyWith(selectedDoctor: doctor, drId: doctor.id);
    print("Selected doctor saved to CheckoutState: ${doctor.name}");
  }

  void setSelectedDate(DateTime? date) {
    state = state.copyWith(
      selectedDate: date,
      appointmentDate: date?.toIso8601String(),
    );
    print("Selected Date saved to CheckoutState: $date");
  }

  void setSelectedSlot(String? slot) {
    state = state.copyWith(selectedSlot: slot, appointmentTime: slot);
    print("Selected Slot saved to CheckoutState: $slot");
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

  void clearSelectedTreatments() {
    state = state.copyWith(selectedTreatmentsAndAreas: []);
  }

  void clearAreaSelection() {
    state = state.copyWithNull(selectedAreas: true);
  }

  void onTapTreatmentSubArea({required TreatmentAreaModel subArea}) {
    final parentId =
        state.selectedAreas?.id ?? subArea.areaId ?? subArea.id ?? 0;
    final treatmentSubArea = subArea.copyWith(areaId: parentId);
    final id = treatmentSubArea.id;
    final alreadySelected =
        id != null &&
        (state.selectedAreas?.subAreas?.any((e) => e.id == id) ?? false);
    final updatedList = alreadySelected
        ? state.selectedAreas?.subAreas ?? <TreatmentAreaModel>[]
        : <TreatmentAreaModel>[...state.selectedAreas?.subAreas ?? [], treatmentSubArea];
    state = state.copyWith(
      selectedAreas: treatmentSubArea.copyWith(subAreas: updatedList),
    );
    ref.read(treatmentViewModel.notifier).clearAiImage();
  }

  void addSelectedTreatment(TreatmentData treatment) {
    final currentTreatmentsAndAreas = List<SelectedTreatmentAndAreasModel>.from(
      state.selectedTreatmentsAndAreas,
    );

    final existingIndex = currentTreatmentsAndAreas.indexWhere(
      (item) => item.treatment.id == treatment.id,
    );

    if (existingIndex == -1) {
      currentTreatmentsAndAreas.add(
        SelectedTreatmentAndAreasModel(
          treatment: treatment,
          selectedAreas: const [],
        ),
      );
    }

    state = state.copyWith(
      selectedTreatments: treatment,
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
    state = state.copyWith(selectedAreas: area);
  }

  void addSelectedArea(TreatmentAreaModel area) {
    final currentTreatmentsAndAreas = List<SelectedTreatmentAndAreasModel>.from(
      state.selectedTreatmentsAndAreas,
    );

    if (state.selectedTreatments != null) {
      final activeTreatment = state.selectedTreatments!;
      final existingIndex = currentTreatmentsAndAreas.indexWhere(
        (item) => item.treatment.id == activeTreatment.id,
      );

      if (existingIndex != -1) {
        final existingItem = currentTreatmentsAndAreas[existingIndex];
        if (!existingItem.selectedAreas.any((a) => a.target.id == area.id)) {
          currentTreatmentsAndAreas[existingIndex] = existingItem.copyWith(
            selectedAreas: [
              ...existingItem.selectedAreas,
              SelectedAreaModel(target: area, materials: const []),
            ],
          );
        }
      } else {
        currentTreatmentsAndAreas.add(
          SelectedTreatmentAndAreasModel(
            treatment: activeTreatment,
            selectedAreas: [
              SelectedAreaModel(target: area, materials: const []),
            ],
          ),
        );
      }
    } else {
      print(
        "No active selectedTreatments found in state. Area not added to SelectedTreatmentAndAreasModel.",
      );
    }

    state = state.copyWith(
      selectedAreas: area,
      selectedTreatmentsAndAreas: currentTreatmentsAndAreas,
    );
    onTapTreatmentSubArea(subArea: area);
    _printSelectedTreatmentsAndAreas();
  }

  void saveMaterialsForArea({
    required TreatmentData treatment,
    required TreatmentAreaModel area,
    required List<SelectedMaterialModel> materials,
  }) {
    final currentTreatmentsAndAreas = List<SelectedTreatmentAndAreasModel>.from(
      state.selectedTreatmentsAndAreas,
    );

    final existingIndex = currentTreatmentsAndAreas.indexWhere(
      (item) => item.treatment.id == treatment.id,
    );

    if (existingIndex != -1) {
      final existingItem = currentTreatmentsAndAreas[existingIndex];
      final areaIndex = existingItem.selectedAreas.indexWhere(
        (a) => a.target.id == area.id,
      );

      if (areaIndex != -1) {
        final existingArea = existingItem.selectedAreas[areaIndex];
        final updatedAreas = List<SelectedAreaModel>.from(
          existingItem.selectedAreas,
        );
        updatedAreas[areaIndex] = existingArea.copyWith(materials: materials);
        currentTreatmentsAndAreas[existingIndex] = existingItem.copyWith(
          selectedAreas: updatedAreas,
        );
      } else {
        final updatedAreas = List<SelectedAreaModel>.from(
          existingItem.selectedAreas,
        );
        updatedAreas.add(SelectedAreaModel(target: area, materials: materials));
        currentTreatmentsAndAreas[existingIndex] = existingItem.copyWith(
          selectedAreas: updatedAreas,
        );
      }
    } else {
      currentTreatmentsAndAreas.add(
        SelectedTreatmentAndAreasModel(
          treatment: treatment,
          selectedAreas: [
            SelectedAreaModel(target: area, materials: materials),
          ],
        ),
      );
    }

    state = state.copyWith(
      selectedAreas: area,
      selectedTreatments: treatment,
      selectedTreatmentsAndAreas: currentTreatmentsAndAreas,
    );
    onTapTreatmentSubArea(subArea: area);
    _printSelectedTreatmentsAndAreas();
  }

  void removeTreatment(int treatmentId) {
    final currentList = List<SelectedTreatmentAndAreasModel>.from(
      state.selectedTreatmentsAndAreas,
    );
    currentList.removeWhere((item) => item.treatment.id == treatmentId);

    final activeTreatment = state.selectedTreatments;
    final updatedActiveTreatment = activeTreatment?.id == treatmentId
        ? null
        : activeTreatment;

    state = state.copyWith(
      selectedTreatmentsAndAreas: currentList,
      selectedTreatments: updatedActiveTreatment,
    );
    _printSelectedTreatmentsAndAreas();
  }

  void removeArea(int areaId) {
    final currentList = state.selectedTreatmentsAndAreas
        .map((item) {
          final updatedAreas = item.selectedAreas
              .where((a) => a.target.id != areaId)
              .toList();
          return item.copyWith(selectedAreas: updatedAreas);
        })
        .where((item) => item.selectedAreas.isNotEmpty)
        .toList();

    final activeArea = state.selectedAreas;
    final updatedActiveArea = activeArea?.id == areaId ? null : activeArea;

    state = state.copyWith(
      selectedAreas: updatedActiveArea,
      selectedTreatmentsAndAreas: currentList,
    );
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
      final treatment = state.selectedTreatments!;
      final subAreas = state.selectedAreas?.subAreas ?? [];
      final treatmentPrice = pricingData.treatment!.price! * subAreas.length;
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
              syringesQuantity: 0,
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
      print(
        "  Areas: ${item.selectedAreas.map((e) => '${e.target.name} (ID: ${e.target.id})').toList()}",
      );
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

  // Selected entities for checkout session tracking
  final Clinic? selectedClinic;
  final AppointmentType? selectedAppointmentType;
  final DummyDoctor? selectedDoctor;
  final DateTime? selectedDate;
  final String? selectedSlot;

  List<FlatSelectionModel> get flatSelections {
    final List<FlatSelectionModel> list = [];
    for (final item in selectedTreatmentsAndAreas) {
      final treatmentId = item.treatment.id ?? 0;
      final treatmentName = item.treatment.name ?? '';
      for (final areaItem in item.selectedAreas) {
        list.add(
          FlatSelectionModel(
            treatmentId: treatmentId,
            treatmentName: treatmentName,
            areaId: areaItem.target.id ?? 0,
            areaName: areaItem.target.name ?? '',
            materials: areaItem.materials,
          ),
        );
      }
    }
    return list;
  }

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
    this.selectedClinic,
    this.selectedAppointmentType,
    this.selectedDoctor,
    this.selectedDate,
    this.selectedSlot,
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
    Clinic? selectedClinic,
    AppointmentType? selectedAppointmentType,
    DummyDoctor? selectedDoctor,
    DateTime? selectedDate,
    String? selectedSlot,
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
      selectedClinic: selectedClinic ?? this.selectedClinic,
      selectedAppointmentType:
          selectedAppointmentType ?? this.selectedAppointmentType,
      selectedDoctor: selectedDoctor ?? this.selectedDoctor,
      selectedDate: selectedDate ?? this.selectedDate,
      selectedSlot: selectedSlot ?? this.selectedSlot,
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
      loading: this.loading,
      errorMessage: this.errorMessage,
      clinicId: clinicId ? null : this.clinicId,
      drId: drId ? null : this.drId,
      appointmentDate: appointmentDate ? null : this.appointmentDate,
      appointmentTime: appointmentTime ? null : this.appointmentTime,
      capturedImage: capturedImage ? null : this.capturedImage,
      selectedTreatmentsAndAreas: this.selectedTreatmentsAndAreas,
      selectedCategories: this.selectedCategories,
      selectedTreatments: selectedTreatments ? null : this.selectedTreatments,
      selectedAreas: selectedAreas ? null : this.selectedAreas,
      appointment: appointment ? null : this.appointment,
      selectedClinic: selectedClinic ? null : this.selectedClinic,
      selectedAppointmentType: selectedAppointmentType
          ? null
          : this.selectedAppointmentType,
      selectedDoctor: selectedDoctor ? null : this.selectedDoctor,
      selectedDate: selectedDate ? null : this.selectedDate,
      selectedSlot: selectedSlot ? null : this.selectedSlot,
    );
  }
}
