import '../models/responses/base_response_model.dart';
import '../models/responses/consent_form_response.dart';
import '../models/requests/sign_form_request.dart';

abstract class FormsRepository {
  Future<ConsentFormResponse> fetchConsentForm();
  Future<BaseResponseModel> signForm(SignFormRequest request);
}
