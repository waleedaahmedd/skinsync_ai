import 'dart:convert';

import '../exceptions/app_exception.dart';
import '../models/requests/get_clinic_request.dart';
import '../models/requests/get_practitioners_request.dart';
import '../models/requests/invite_clinic_request.dart';
import '../models/responses/availability_response.dart';
import '../models/responses/base_response_model.dart';
import '../models/responses/get_clinic_response.dart';
import '../models/responses/get_doctor_response.dart';
import '../models/responses/payment_options_response.dart';
import '../models/responses/treatment_pricing_response.dart';
import '../repositories/clinic_doctor_repository.dart';
import '../utills/date_time_utills.dart';
import '../utills/enums.dart';
import 'api_base_helper.dart';

class ClinicDoctorService implements ClinicDoctorRepository {
  final ApiBaseHelper _apiClient;

  ClinicDoctorService({required this._apiClient});

  @override
  Future<GetClinicResponse> getClinic({
    required GetClinicRequest request,
  }) async {
    final response = await _apiClient.httpRequest(
      endPoint: EndPoints.getClinic,
      requestType: 'POST',
      requestBody: request.toJson(),
    );
    // Check HTTP status code
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final parsed = json.decode(response.body);
      GetClinicResponse getClinicResponse = GetClinicResponse.fromJson(parsed);
      return getClinicResponse;
    } else {
      // Handle HTTP error status codes
      final parsed = json.decode(response.body);
      throw AppException(GetClinicResponse.fromJson(parsed).message as String);
    }
  }

  @override
  Future<GetDoctorResponse> getPractitioners({
    required GetPractitionersRequest request,
  }) async {
    final response = await _apiClient.httpRequest(
      endPoint: EndPoints.practitionersList,
      requestType: 'GET', // Following curl but ApiBaseHelper might need a fix if body is required for GET
      requestBody: request.toJson(),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final parsed = json.decode(response.body);
      return GetDoctorResponse.fromJson(parsed);
    } else {
      final parsed = json.decode(response.body);
      throw AppException(GetDoctorResponse.fromJson(parsed).message ?? 'Error fetching practitioners');
    }
  }

  @override
  Future<GetDoctorResponse> getDoctors({
    required int clinicId,
    required int treatmentId,
    required String sideAreaIdsList,
  }) async {
    final response = await _apiClient.httpRequest(
      endPoint: EndPoints.getDoctor,
      requestType: 'GET',
      params:
          'clinic_id=$clinicId&treatment_id=$treatmentId&side_area_ids=$sideAreaIdsList',
    );
    // Check HTTP status code
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final parsed = json.decode(response.body);
      GetDoctorResponse getDoctorResponse = GetDoctorResponse.fromJson(parsed);
      return getDoctorResponse;
    } else {
      // Handle HTTP error status codes
      final parsed = json.decode(response.body);
      throw AppException(GetDoctorResponse.fromJson(parsed).message as String);
    }
  }

  @override
  Future<List<Slot>> getAvailability({
    required int doctorId,
    required int clinicId,
    required DateTime date,
  }) async {
    final response = await _apiClient.httpRequest(
      endPoint: EndPoints.getAvailability,
      requestType: 'GET',
      params:
          '?doctor_id=$doctorId&clinic_id=$clinicId&date=${date.secondsSinceEpoch}',
    );
    final data = AvailabilityResponse.fromJson(jsonDecode(response.body));
    if (data.status == false) {
      throw Exception(data.message ?? 'Something went wrong!');
    }
    return data.slots;
  }

  @override
  Future<List<PaymentOption>> getPaymentOptions({
    required int clinicId,
    required int doctorId,
    required int amount,
  }) async {
    final response = await _apiClient.httpRequest(
      endPoint: EndPoints.paymentOptions,
      requestType: 'GET',
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
      requestType: 'GET',
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
      requestType: 'POST',
      requestBody: request.toJson(),
      params: '',
    );
    final data = BaseResponseModel.fromJson(jsonDecode(response.body));
    if (!(data.status ?? false)) {
      throw AppException(data.message ?? 'Something went wrong!');
    }
  }
}
