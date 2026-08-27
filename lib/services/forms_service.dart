import 'dart:convert';

import '../exceptions/app_exception.dart';

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
      endPoint: EndPoints.notification,
      requestType: .get,
    );
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final parsed = json.decode(response.body);
      ConsentFormResponse formResponse =
          ConsentFormResponse.fromJson(parsed);
      return formResponse;
    } else {
      final parsed = json.decode(response.body);
      throw AppException(
        ConsentFormResponse.fromJson(parsed).message as String,
      );
    }
  }
  

}
