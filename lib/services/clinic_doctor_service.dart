import 'dart:convert';

import 'package:skinsync_ai/exceptions/app_exception.dart';

import 'package:skinsync_ai/models/responses/auth_response.dart';
import 'package:skinsync_ai/models/responses/get_clinic_response.dart';
import 'package:skinsync_ai/models/responses/treatment_area_response.dart';
import 'package:skinsync_ai/repositories/clinic_doctor_repository.dart';
import 'package:skinsync_ai/services/api_base_helper.dart';
import 'package:skinsync_ai/utills/enums.dart';

class ClinicDoctorService implements ClinicDoctorRepository {
  final ApiBaseHelper _apiClient;
 

  ClinicDoctorService({required ApiBaseHelper apiClient}) : _apiClient = apiClient;

  @override
  Future<GetClinicResponse> getClinic({required int treamentId,required int sideAreaID}) async{
  final response = await _apiClient.httpRequest(
      endPoint: EndPoints.getClinic,
      requestType: 'GET',
      params: 'treatment_id=$treamentId&side_area_id=$sideAreaID',
    );
    // Check HTTP status code
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final parsed = json.decode(response.body);
    GetClinicResponse   getClinicResponse = GetClinicResponse.fromJson(parsed);
      return getClinicResponse;
    } else {
      // Handle HTTP error status codes
      final parsed = json.decode(response.body);
      throw AppException(GetClinicResponse.fromJson(parsed).message as String);
    }

  }
}
