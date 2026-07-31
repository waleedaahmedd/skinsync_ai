import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/base_state_model.dart';
import '../models/responses/appointment_type_list_response.dart';
import '../models/responses/get_appointment_response.dart';
import '../repositories/appointment_repository.dart';
import '../services/api_base_helper.dart';
import '../services/appointment_service.dart';
import 'base_view_model.dart';

import '../models/responses/simulation_history_response.dart';

final appointmentProvider = NotifierProvider(
  () => AppointmentViewModel(
    repo: AppointmentService(apiClient: ApiBaseHelper()),
  ),
);

class AppointmentViewModel extends BaseViewModel<AppointmentState> {
  AppointmentViewModel({required AppointmentRepository repo})
      : _repo = repo,
        super(initialState: const AppointmentState());

  final AppointmentRepository _repo;

  Future<List<AppointmentTypeData>?> getAppointmentTypes() async {
    return await runSafely(() async {
      state = state.copyWith(loading: true, errorMessage: null);
      final response = await _repo.getAppointmentTypes();
      state = state.copyWith(
        loading: false,
        appointmentTypes: response.data ?? [],
      );
      return response.data ?? [];
    });
  }

  Future<void> fetchSimulationHistory() async {
    await runSafely(() async {
      state = state.copyWith(loading: true, errorMessage: null);
      final data = await _repo.getSimulationHistory();
      state = state.copyWith(loading: false, simulations: data);
    });
  }

  Future<void> getAppointments({int page = 1, int limit = 10}) async {
    await runSafely(() async {
      state = state.copyWith(loading: true, errorMessage: null);
      final response = await _repo.getAppointmentsApi(page: page, limit: limit);
      state = state.copyWith(
        loading: false,
        appointmentsResponse: response,
      );
    });
  }

  @override
  void onError(String message) {
    state = state.copyWith(loading: false, errorMessage: message);
    super.onError(message);
  }
}

@immutable
class AppointmentState extends BaseStateModel {
  final List<AppointmentTypeData> appointmentTypes;
  final List<SimulationData> simulations;
  final GetAppointmentResponse? appointmentsResponse;

  const AppointmentState({
    super.loading = false,
    super.errorMessage,
    this.appointmentTypes = const [],
    this.simulations = const [],
    this.appointmentsResponse,
  });

  @override
  AppointmentState copyWith({
    bool? loading,
    String? errorMessage,
    List<AppointmentTypeData>? appointmentTypes,
    List<SimulationData>? simulations,
    GetAppointmentResponse? appointmentsResponse,
  }) {
    return AppointmentState(
      loading: loading ?? this.loading,
      errorMessage: errorMessage ?? this.errorMessage,
      appointmentTypes: appointmentTypes ?? this.appointmentTypes,
      simulations: simulations ?? this.simulations,
      appointmentsResponse: appointmentsResponse ?? this.appointmentsResponse,
    );
  }
}
