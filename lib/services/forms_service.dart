import 'dart:convert';

import '../exceptions/app_exception.dart';
import '../models/responses/base_response_model.dart';
import '../models/requests/sign_form_request.dart';
import '../models/responses/consent_form_response.dart';
import '../repositories/forms_repository.dart';
import '../utils/enums.dart';
import 'api_base_helper.dart';

class FormsService implements FormsRepository {
  final ApiBaseHelper _apiClient;
  FormsService({required this._apiClient});
  @override
  Future<ConsentFormResponse> fetchConsentForm() async {
    final response = await _apiClient.httpRequest(
      endPoint: EndPoints.forms,
      requestType: .get,
      //params:"?type="
    );
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final parsed = json.decode(response.body);
      ConsentFormResponse formResponse = ConsentFormResponse.fromJson(parsed);
      return formResponse;
    } else {
      final parsed = json.decode(response.body);
      throw AppException(
        ConsentFormResponse.fromJson(parsed).message as String,
      );
    }
  }

  @override
  Future<BaseResponseModel> signForm(SignFormRequest request) async {
    final response = await _apiClient.httpRequest(
      endPoint: EndPoints.signForm,
      requestType: .post,
      requestBody: request.toJson(),
    );
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return BaseResponseModel.fromJson(json.decode(response.body));
    } else {
      throw AppException(
        BaseResponseModel.fromJson(json.decode(response.body)).message
            as String,
      );
    }
  }
}
