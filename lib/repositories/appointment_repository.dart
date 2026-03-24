import 'package:skinsync_ai/models/responses/get_appointment_response.dart';

abstract class AppointmentRepository {
  Future<GetAppointmentResponse> getAppointmentsApi({
    required int page,
    required int limit,
  });
}