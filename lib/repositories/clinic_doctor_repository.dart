import 'package:skinsync_ai/models/requests/onboarding_profile_request.dart';
import 'package:skinsync_ai/models/requests/otp_request.dart';
import 'package:skinsync_ai/models/responses/base_response_model.dart';
import 'package:skinsync_ai/models/responses/get_clinic_response.dart';
import 'package:skinsync_ai/models/responses/get_doctor_response.dart';

import '../models/requests/sign_in_request.dart';
import '../models/responses/auth_response.dart';

abstract class ClinicDoctorRepository {
  Future<GetClinicResponse> getClinic({required int treamentId,required int sideAreaID});
   Future<GetDoctorResponse> getDoctors({required int clinicId, required int treamentId,required int sideAreaID});
}
