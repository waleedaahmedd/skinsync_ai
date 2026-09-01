import '../models/requests/get_clinic_request.dart';
import '../models/requests/invite_clinic_request.dart';
import '../models/responses/clinic_detail_response.dart';
import '../models/responses/get_clinic_response.dart';
import '../models/responses/payment_options_response.dart';
import '../models/responses/shared_clinic_response.dart';
import '../models/responses/treatment_pricing_response.dart';

abstract class ClinicRepository {
  Future<GetClinicResponse> getClinic({required GetClinicRequest request});

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

  Future<ClinicDetailResponse> getClinicDetail(int clinicId);
  Future<SharedClinicResponse> getSharedClinics({required int page,required String search});
}
