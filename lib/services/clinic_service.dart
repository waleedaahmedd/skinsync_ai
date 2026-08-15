import 'dart:convert';

import '../exceptions/app_exception.dart';
import '../models/requests/get_clinic_request.dart';
import '../models/requests/invite_clinic_request.dart';
import '../models/responses/auth_response.dart';
import '../models/responses/base_response_model.dart';
import '../models/responses/clinic_detail_response.dart';
import '../models/responses/get_clinic_response.dart';
import '../models/responses/payment_options_response.dart';
import '../models/responses/treatment_pricing_response.dart';
import '../repositories/clinic_repository.dart';
import '../utills/enums.dart';
import 'api_base_helper.dart';

class ClinicService implements ClinicRepository {
  final ApiBaseHelper _apiClient;

  ClinicService({required this._apiClient});

  @override
  Future<GetClinicResponse> getClinic({
    required GetClinicRequest request,
  }) async {
    final response = await _apiClient.httpRequest(
      endPoint: EndPoints.getClinic,
      requestType: .post,
      requestBody: request.toJson(),
    );
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final parsed = json.decode(response.body);
      return GetClinicResponse.fromJson(parsed);
    } else {
      final parsed = json.decode(response.body);
      throw AppException(GetClinicResponse.fromJson(parsed).message as String);
    }
  }

  @override
  Future<List<PaymentOption>> getPaymentOptions({
    required int clinicId,
    required int doctorId,
    required int amount,
  }) async {
    final response = await _apiClient.httpRequest(
      endPoint: EndPoints.paymentOptions,
      requestType: .get,
      params:
          '?clinic_id=$clinicId&doctor_id=$doctorId&treatment_amount=$amount',
    );
    final data = PaymentOptionsResponse.fromJson(jsonDecode(response.body));
    if (response.statusCode < 200 && response.statusCode >= 300) {
      throw Exception(data.message ?? 'Something went wrong!');
    }
    return data.data ?? [];
  }

  @override
  Future<PricingData> getTreatmentPricing({
    required int clinicId,
    required int treatmentId,
    required List<int> treatmentSubsectionIds,
  }) async {
    final response = await _apiClient.httpRequest(
      endPoint: EndPoints.treatmentPricing,
      requestType: .get,
      params:
          '?clinic_id=$clinicId&treatment_id=$treatmentId&treatment_subsection_ids=${treatmentSubsectionIds.join(',')}',
    );
    final data = TreatmentPricingResponse.fromJson(jsonDecode(response.body));
    if (response.statusCode < 200 && response.statusCode >= 300) {
      throw Exception(data.message ?? 'Something went wrong!');
    }
    return data.data!;
  }

  @override
  Future<void> inviteClinic(InviteClinicRequest request) async {
    final response = await _apiClient.httpRequest(
      endPoint: EndPoints.inviteClinic,
      requestType: .post,
      requestBody: request.toJson(),
      params: '',
    );
    final data = BaseResponseModel.fromJson(jsonDecode(response.body));
    if (!(data.status ?? false)) {
      throw AppException(data.message ?? 'Something went wrong!');
    }
  }

  @override
  Future<ClinicDetailResponse> getClinicDetail(int clinicId) async {
    final response = await _apiClient.httpRequest(
      endPoint: EndPoints.clinic,
      requestType: RequestType.get,
      params: "/$clinicId",
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final parsed = json.decode(response.body);
      return ClinicDetailResponse.fromJson(parsed);
    } else {
      final parsed = json.decode(response.body);
      throw AppException(
        AuthResponse.fromJson(parsed).message ??
            "Failed to fetch clinic detail",
      );
    }
  }
}
