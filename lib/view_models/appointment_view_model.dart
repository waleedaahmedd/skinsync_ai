import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skinsync_ai/models/base_state_model.dart';
import 'package:skinsync_ai/models/responses/get_appointment_response.dart';
import 'package:skinsync_ai/repositories/appointment_repository.dart';
import 'package:skinsync_ai/services/api_base_helper.dart';
import 'package:skinsync_ai/services/appointment_service.dart';
import 'package:skinsync_ai/view_models/base_view_model.dart';

final appointmentProvider = NotifierProvider(
  () => AppointmentViewModel(
    appointmentRepository: AppointmentService(apiClient: ApiBaseHelper()),
  ),
);

class AppointmentViewModel extends BaseViewModel<AppointmentState> {
  AppointmentViewModel({required AppointmentRepository appointmentRepository})
    : _repo = appointmentRepository,
      super(initialState: AppointmentState());
  final AppointmentRepository _repo;

  Future<List<Appointment>?> getAppointment({required int page,}) async {
    state = state.copyWith(loading: true);
    return runSafely(() async {
      final response = await _repo.getAppointmentsApi(page: page, limit: 10);
      state = state.copyWith(loading: false, appointments: response.data);
      return response.data ?? [];
    });
  }
}

class AppointmentState extends BaseStateModel {
  final List<Appointment>? appointments;

  AppointmentState({
    this.appointments,
    super.loading = false,
    super.errorMessage,
  });
  @override
  AppointmentState copyWith({
    List<Appointment>? appointments,
    bool? loading,
    String? errorMessage,
  }) {
    return AppointmentState(
      appointments: appointments ?? this.appointments,
      loading: loading ?? this.loading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}