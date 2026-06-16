import 'dart:convert';

import '../exceptions/app_exception.dart';
import '../models/requests/save_answer_request.dart';
import '../models/responses/base_response_model.dart';
import '../models/responses/on_boarding_question_response.dart';
import '../repositories/on_boarding_repository.dart';
import 'api_base_helper.dart';
import '../utills/enums.dart';

class OnBoardingService implements OnBoardingRepository {
  final ApiBaseHelper _apiClient;
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
