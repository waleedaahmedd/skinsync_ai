enum SharedPreferencesKeys {
  themeModeKey("theme-mode"),
  biometricAuthKey("biometric-auth"),
  accessTokenKey("access-token"),
  homeSectionsOrder("home-sections-order");

  const SharedPreferencesKeys(this.keyText);

  final String keyText;
}

enum LoginProviders {
  phone('phone'),
  email('email'),
  google('google'),
  apple('apple');

  final String name;

  const LoginProviders(this.name);
}

enum AppointmentType {
  consultation('consultation'),
  treatment('Treatment session');

  final String typeText;

  const AppointmentType(this.typeText);
}

enum EndPoints {
  treatmentList('treatments/list'),
  treatments("v1/treatment"),
  signIn('login'),
  socialLogin("social-login"),
  biometricRegister('v1/biometric/register'),
  biometricLogin('biometric/login'),
  biometricUnregister('biometric/unregister'),
  onBoardingQues("onboarding/masters"),
  saveAnswer("v1/onboarding/answer"),

  verifyOtp("verify-otp"),
  onBoardingProfile("v1/onboarding/profile"),
  getClinic("clinics/filter"),
  getDoctor("doctors/by-side-area?"),
  practitionersList("practitioners/list"),
  getMe("v1/me"),
  refreshToken('v1/auth/refresh'),
  getAvailability('v1/appointments/availability'),
  paymentOptions('v1/appointments/payment-options'),
  treatmentPricing('v1/treatments/pricing'),
  appointments('v1/appointments'),
  inviteClinic('v1/invite-clinic'),
  categories('categories'),
  areas('areas'),
  materials('materials'),
  simulationHistory('v1/simulation-history'),
  explorerReels('v1/reels?'),
  explorerCommunity('v1/community-posts?'),
  appointmentTypes('v1/appointment-types'),
  treatmentJourneyGroups('v1/treatment-journey-groups'),
  updateTreatmentJourneyGroups('v1/treatment-journey-group'),
  shareTreatmentRequest('v1/share-treatment-request'),
  shareMapTreatmentRequest('v1/invite-map-treatment-request'),
  treatmentJourneyOptions('v1/treatment-journey-options'),
  deleteTreatmentJourneyOptions('v1/treatment-journey-option'),
  patientTreatmentRequest('v1/patient-treatment-request'),
  patientCurrentPlan('v1/patient-current-plan'),
  notification('v1/notifications'),
  forms('v1/forms'),
  signForm('v1/forms/sign'),
  notificationstatus('v1/pushnotification-status'),
  subscribe('v1/subscribe/'),
  clinic('v1/clinic');

  final String path;

  const EndPoints(this.path);
}

enum Status { active, inactive }

enum BaseUrls {
  api('https://api.skinsyncai.com/api/'),
   apiQa('https://api-dev.skinsyncai.com/api/');
 // apiQa('https://bgzh46mj-8084.inc1.devtunnels.ms/api/');


  final String url;
  const BaseUrls(this.url);
}

enum ViewType { grid, map }

enum ApplicationType { clinic, patient }

enum RequestType {
  get('GET'),
  post('POST'),
  put('PUT'),
  patch('PATCH'),
  delete('DELETE'),
  multipartPost('POST'),
  multipartPatch('PATCH');

  final String method;

  const RequestType(this.method);
}

enum Store {
  play(
    'https://play.google.com/store/apps/details?id=com.skinsyncaiinc.skinsyncai',
  ),
  appstore(
    'https://apps.apple.com/us/app/skinsync-ai-botox-filler/id6761345816',
  );

  final String link;

  const Store(this.link);
}

enum HomeSection {
  points,
  recentSimulations,
  sharedTreatmentRequests,
  upcomingAppointments,
  suggestedTreatments,
  topDoctors,
  topClinics,
  promotions;

  String get displayName {
    switch (this) {
      case HomeSection.points:
        return "Points & Rewards";
      case HomeSection.recentSimulations:
        return "Recent Simulations";
      case HomeSection.sharedTreatmentRequests:
        return "Shared Treatment Requests";
      case HomeSection.upcomingAppointments:
        return "Upcoming Appointments";
      case HomeSection.suggestedTreatments:
        return "Suggested Treatments";
      case HomeSection.topDoctors:
        return "Top Doctors";
      case HomeSection.topClinics:
        return "Top Clinics";
      case HomeSection.promotions:
        return "Promotions & Discounts";
    }
  }
}
