import '../models/requests/appointment_request.dart';
import '../models/responses/appointment_detail_response.dart';
import '../models/responses/appointment_response.dart';
import '../models/responses/appointment_type_list_response.dart';
import '../models/responses/appointments_list_response.dart';
import '../models/responses/simulation_history_response.dart';

abstract class AppointmentRepository {
  Future<AppointmentsListResponse> getAppointmentsApi({
    required int page,
    required int limit,
  });
  Future<AppointmentDetailResponse> getAppointmentDetail({
    required int appointmentId,
  });
  Future<List<SimulationData>> getSimulationHistory();
  Future<AppointmentTypeListResponse> getAppointmentTypes();
  Future<AppointmentData> createAppointment({
    required AppointmentRequest request,
  });
}
