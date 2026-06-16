import '../models/responses/get_appointment_response.dart';
import '../models/responses/simulation_history_response.dart';

abstract class AppointmentRepository {
  Future<GetAppointmentResponse> getAppointmentsApi({
    required int page,
    required int limit,
  });
  Future<List<SimulationData>> getSimulationHistory();
}
