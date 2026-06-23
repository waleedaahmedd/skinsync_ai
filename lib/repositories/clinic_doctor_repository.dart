import '../models/responses/appointment_response.dart';
import '../models/responses/get_clinic_response.dart';
import '../models/responses/get_doctor_response.dart';
import '../models/responses/payment_options_response.dart';
import '../models/responses/treatment_pricing_response.dart';

import '../models/requests/appointment_request.dart';
import '../models/responses/availability_response.dart';

abstract class ClinicDoctorRepository {
  Future<GetClinicResponse> getClinic({
    int? treatmentId,
    String? sideAreaIdsList,
  });

  Future<GetDoctorResponse> getDoctors({
    required int clinicId,
    required int treatmentId,
    required String sideAreaIdsList,
  });

  Future<List<Slot>> getAvailability({
    required int doctorId,
    required int clinicId,
    required DateTime date,
  });

  Future<List<PaymentOption>> getPaymentOptions({
    required int clinicId,
    required int doctorId,
    required int amount,
  });

  Future<PricingData> getTreatmentPricing({
    required int clinicId,
    required int treatmentId,
    required List<int> treatmentSubsectionIds,
  });

  Future<AppointmentData> createAppointment({
    required AppointmentRequest request,
  });
}
