import '../models/requests/medical_history_request.dart';
import '../models/responses/medical_history_response.dart';
import '../models/responses/base_response_model.dart';

abstract class MedicalHistoryRepository {
  Future<MedicalHistoryResponse> getPatientMedicalHistory();
  Future<BaseResponseModel> updateAlleryAndMedical(int? patientId,MedicalHistoryRequest request);
}
