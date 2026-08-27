
import '../models/responses/consent_form_response.dart';

abstract class FormsRepository {

   Future<ConsentFormResponse> fetchConsentForm();
  
}