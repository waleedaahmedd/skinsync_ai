import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/base_state_model.dart';
import '../models/responses/treatment_area_list_response.dart';
import '../repositories/treatment_area_repository.dart';
import '../services/api_base_helper.dart';
import '../services/treatment_area_service.dart';
import 'base_view_model.dart';

final treatmentAreaProvider = NotifierProvider<TreatmentAreaViewModel, TreatmentAreaState>(
  () => TreatmentAreaViewModel(
    treatmentAreaRepository: TreatmentAreaService(apiClient: ApiBaseHelper()),
  ),
);

class TreatmentAreaViewModel extends BaseViewModel<TreatmentAreaState> {
  TreatmentAreaViewModel({required TreatmentAreaRepository treatmentAreaRepository})
    : _repo = treatmentAreaRepository,
      super(initialState: const TreatmentAreaState());

  final TreatmentAreaRepository _repo;

  // Direct getters to maintain properties
  List<TreatmentAreaModel> get areas => state.areas;
  bool get isLoading => state.loading;
  String? get errorMessage => state.errorMessage;

  Future<void> fetchAreas() async {
    await runSafely(() async {
      state = state.copyWith(loading: true, errorMessage: null);
      final response = await _repo.getAreasApi();
      state = state.copyWith(
        loading: false,
        areas: response.data ?? [],
        errorMessage: null,
      );
    });
  }

  Future<void> fetchAreasByTreatment(int treatmentId) async {
    await runSafely(() async {
      state = state.copyWith(loading: true, errorMessage: null);
      final response = await _repo.getAreasByTreatment(treatmentId);
      state = state.copyWith(
        loading: false,
        areas: response.data ?? [],
        errorMessage: null,
      );
    });
  }

  @override
  void onError(String message) {
    state = state.copyWith(loading: false, errorMessage: message);
    super.onError(message);
  }
}

class TreatmentAreaState extends BaseStateModel {
  final List<TreatmentAreaModel> areas;

  const TreatmentAreaState({
    this.areas = const [],
    super.loading = false,
    super.errorMessage,
  });

  @override
  TreatmentAreaState copyWith({
    List<TreatmentAreaModel>? areas,
    bool? loading,
    String? errorMessage,
  }) {
    return TreatmentAreaState(
      areas: areas ?? this.areas,
      loading: loading ?? this.loading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
