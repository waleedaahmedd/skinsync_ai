import 'package:skinsync_ai/models/requests/save_answer_request.dart';
import 'package:skinsync_ai/models/responses/base_response_model.dart';
import 'package:skinsync_ai/models/responses/on_boarding_question_response.dart';

abstract class OnBoardingRepository {
   Future<OnBoardingQuestionResponse> questionApi();
   Future<BaseResponseModel> saveAnswerApi({required SaveAnswerRequest saveAnswerRequest });
}