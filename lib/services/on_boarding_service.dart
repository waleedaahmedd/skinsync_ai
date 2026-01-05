import 'dart:convert';

import 'package:skinsync_ai/exceptions/app_exception.dart';
import 'package:skinsync_ai/models/requests/save_answer_request.dart';
import 'package:skinsync_ai/models/responses/base_response_model.dart';
import 'package:skinsync_ai/models/responses/on_boarding_question_response.dart';
import 'package:skinsync_ai/repositories/on_boarding_repository.dart';
import 'package:skinsync_ai/services/api_base_helper.dart';
import 'package:skinsync_ai/utills/enums.dart';
import 'package:skinsync_ai/utills/secure_storage_service.dart';

class OnBoardingService implements OnBoardingRepository {
  final ApiBaseHelper _apiClient;
  final SecureStorage _secureStorage = SecureStorage();
  OnBoardingService({required ApiBaseHelper apiClient})
    : _apiClient = apiClient;
  @override
  Future<OnBoardingQuestionResponse> questionApi() async {
    final response = await _apiClient.httpRequest(
      endPoint: EndPoints.onBoardingQues,
      requestType: 'GET',
      params: '',
    );

    // Check HTTP status code
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final parsed = json.decode(response.body);
      OnBoardingQuestionResponse questionResponse =
          OnBoardingQuestionResponse.fromJson(parsed);
      return questionResponse;
    } else {
      // Handle HTTP error status codes
      final parsed = json.decode(response.body);
      throw AppException(
        OnBoardingQuestionResponse.fromJson(parsed).message as String,
      );
    }
  }

  @override
  Future<BaseResponseModel> saveAnswerApi({
    required SaveAnswerRequest saveAnswerRequest,
  }) async {
    final response = await _apiClient.httpRequest(
      endPoint: EndPoints.saveAnswer,
      requestType:'PATCH',
      params: '',
      requestBody: saveAnswerRequest,
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final parsed = json.decode(response.body);
      return BaseResponseModel.fromJson(parsed);
    } else {
      final parsed = json.decode(response.body);
      throw AppException(
        BaseResponseModel.fromJson(parsed).message ?? 'Something went wrong',
      );
    }
  }
}
