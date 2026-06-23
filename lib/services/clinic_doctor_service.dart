import 'dart:convert';

import '../exceptions/app_exception.dart';
import '../models/responses/get_clinic_response.dart';
import '../models/responses/get_doctor_response.dart';
import '../repositories/clinic_doctor_repository.dart';
import 'api_base_helper.dart';
import '../utills/enums.dart';

import '../models/requests/appointment_request.dart';
import '../models/responses/appointment_response.dart';
import '../models/responses/availability_response.dart';
import '../models/responses/payment_options_response.dart';
import '../models/responses/treatment_pricing_response.dart';

class ClinicDoctorService implements ClinicDoctorRepository {
  final ApiBaseHelper _apiClient;

  ClinicDoctorService({required ApiBaseHelper apiClient})
    : _apiClient = apiClient;

  @override
  Future<GetClinicResponse> getClinic({
    int? treatmentId,
    String? sideAreaIdsList,
  }) async {
    final response = await _apiClient.httpRequest(
      endPoint: EndPoints.getClinic,
      requestType: 'GET',
      params: 'treatment_id=$treatmentId&side_area_ids=$sideAreaIdsList',
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
          '?doctor_id=$doctorId&clinic_id=$clinicId&date=${date.millisecondsSinceEpoch ~/ 1000}',
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
  Future<AppointmentData> createAppointment({
    required AppointmentRequest request,
  }) async {
    final response = await _apiClient.httpRequest(
      endPoint: EndPoints.appointments,
      requestType: 'POST',
      requestBody: request.toJson(),
      params: '',
    );
    final data = AppointmentResponse.fromJson(jsonDecode(response.body));
    if (!(data.status ?? false)) {
      throw AppException(data.message ?? 'Something went wrong!');
    }
    return data.data!;
  }
}
