import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/base_state_model.dart';
import '../models/responses/get_appointment_response.dart';
import '../models/responses/simulation_history_response.dart';
import '../repositories/appointment_repository.dart';
import '../services/api_base_helper.dart';
import '../services/appointment_service.dart';
import 'base_view_model.dart';

final appointmentProvider = NotifierProvider(
  () => AppointmentViewModel(
    appointmentRepository: AppointmentService(apiClient: ApiBaseHelper()),
  ),
);

class AppointmentViewModel extends BaseViewModel<AppointmentState> {
  AppointmentViewModel({required AppointmentRepository appointmentRepository})
    : _repo = appointmentRepository,
      super(initialState: const AppointmentState());
  final AppointmentRepository _repo;

  Future<List<Appointment>?> getAppointment({required int page}) async {
    return runSafely(() async {
      state = state.copyWith(loading: true);
      final response = await _repo.getAppointmentsApi(page: page, limit: 10);
      state = state.copyWith(loading: false, appointments: response.data);
      return response.data ?? [];
    });
  }

  Future<void> fetchSimulationHistory() async {
    return await runSafely(() async {
      state = state.copyWith(loading: true);
      final data = await _repo.getSimulationHistory();
      state = state.copyWith(loading: false, simulations: data);
    });
  }

  @override
  void onError(String message) {
    state = state.copyWith(loading: false);
    super.onError(message);
  }
}

class AppointmentState extends BaseStateModel {
  final List<SimulationData> simulations;
  final List<Appointment>? appointments;

  const AppointmentState({
    this.simulations = const [],
    this.appointments,
    super.loading = false,
    super.errorMessage,
  });
  @override
  AppointmentState copyWith({
    List<SimulationData>? simulations,
    List<Appointment>? appointments,
    bool? loading,
    String? errorMessage,
  }) {
    return AppointmentState(
      simulations: simulations ?? this.simulations,
      appointments: appointments ?? this.appointments,
      loading: loading ?? this.loading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
