import 'dart:convert';

import '../exceptions/app_exception.dart';
import '../models/requests/create_group_request.dart';
import '../models/responses/auth_response.dart';
import '../models/responses/base_response_model.dart';
import '../models/responses/groups_list_response.dart';
import '../models/responses/tj_options_list_response.dart';
import '../repositories/treatment_journey_repository.dart';
import '../utills/enums.dart';
import 'api_base_helper.dart';

class TreatmentJourneyService implements TreatmentJourneyRepository {
  final ApiBaseHelper _apiClient;
  TreatmentJourneyService({required this._apiClient});

  @override
  Future<GroupsListResponse> getGroups() async {
    final response = await _apiClient.httpRequest(
      endPoint: EndPoints.treatmentJourneyGroups,
      requestType: RequestType.get,
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final parsed = json.decode(response.body);
      return GroupsListResponse.fromJson(parsed);
    } else {
      final parsed = json.decode(response.body);
      throw AppException(
        AuthResponse.fromJson(parsed).message ?? "Failed to fetch groups",
      );
    }
  }

  @override
  Future<BaseResponseModel> createGroup(CreateGroupRequest request) async {
    final response = await _apiClient.httpRequest(
      endPoint: EndPoints.treatmentJourneyGroups,
      requestType: RequestType.post,
      requestBody: request.toJson(),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final parsed = json.decode(response.body);
      return BaseResponseModel.fromJson(parsed);
    } else {
      final parsed = json.decode(response.body);
      throw AppException(
        AuthResponse.fromJson(parsed).message ?? "Failed to create group",
      );
    }
  }

  @override
  Future<TJOptionsListResponse> getOptions(int groupId) async {
    final response = await _apiClient.httpRequest(
      endPoint: EndPoints.treatmentJourneyOptions,
      requestType: RequestType.get,
      params: "?group_id=$groupId",
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final parsed = json.decode(response.body);
      return TJOptionsListResponse.fromJson(parsed);
    } else {
      final parsed = json.decode(response.body);
      throw AppException(
        AuthResponse.fromJson(parsed).message ?? "Failed to fetch options",
      );
    }
  }
}
