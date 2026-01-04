import 'package:skinsync_ai/models/responses/base_response_model.dart';
import 'package:skinsync_ai/models/responses/on_boarding_question_response.dart';

import '../models/requests/sign_in_request.dart';
import '../models/responses/auth_response.dart';

abstract class AuthRepository {
  Future<AuthResponse> signInApi({required BaseSignInRequest signInRequest});
 
}
