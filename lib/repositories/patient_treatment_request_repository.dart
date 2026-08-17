import '../models/responses/patient_treatment_request_response.dart';

abstract class PatientTreatmentRequestRepository {
  Future<PatientTreatmentRequestResponse> getPatientTreatmentRequests({
    required int clinicId,
    int page = 1,
    int limit = 10,
  });
}
