import '../models/requests/get_clinic_request.dart';
import '../models/requests/get_practitioners_request.dart';
import '../models/requests/invite_clinic_request.dart';
import '../models/responses/availability_response.dart';
import '../models/responses/get_clinic_response.dart';
import '../models/responses/practitioner_list_response.dart';
import '../models/responses/payment_options_response.dart';
import '../models/responses/treatment_pricing_response.dart';

abstract class ClinicDoctorRepository {
  Future<GetClinicResponse> getClinic({required GetClinicRequest request});

  Future<PractitionerListResponse> getPractitioners({
    required GetPractitionersRequest request,
  });

  Future<PractitionerListResponse> getDoctors({
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

  Future<void> inviteClinic(InviteClinicRequest request);
}
