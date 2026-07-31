import 'base_response_model.dart';
import 'appointments_list_response.dart';
import 'treatment_list_response.dart';

class AuthResponse extends BaseResponseModel {
  final AuthData? data;

  AuthResponse({super.isSuccess, super.message, this.data});

  factory AuthResponse.fromJson(Map<String, dynamic> json) => AuthResponse(
    isSuccess: json["is_success"],
    message: json["message"],
    data: json["data"] == null ? null : AuthData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "is_success": isSuccess,
    "message": message,
    "data": data?.toJson(),
  };
}

class AuthData {
  final bool? isFirstLogin;
  final bool? isActive;
  final String? accessToken;
  final String? refreshToken;
  final int? isActiveExpiry;
  final int? refreshTokenExpiry;
  final List<TreatmentData>? treatment;
  final User? user;
  final DashboardData? dashboard;

  AuthData({
    this.isFirstLogin,
    this.isActive,
    this.accessToken,
    this.refreshToken,
    this.isActiveExpiry,
    this.refreshTokenExpiry,
    this.user,
    this.dashboard,
    this.treatment,
  });

  factory AuthData.fromJson(Map<String, dynamic> json) => AuthData(
    isFirstLogin: json["is_first_login"],
    isActive: json["is_active"],
    accessToken: json["access_token"],
    refreshToken: json["refresh_token"],
    isActiveExpiry: json["is_active_expiry"],
    refreshTokenExpiry: json["refresh_token_expiry"],
    treatment: json["treatment"] == null
        ? []
        : List<TreatmentData>.from(
            json["treatment"]!.map((x) => TreatmentData.fromJson(x)),
          ),
    user: json["user"] == null ? null : User.fromJson(json["user"]),
    dashboard: json["dashboard"] == null || json["dashboard"] is String
        ? null
        : DashboardData.fromJson(json["dashboard"]),
  );

  Map<String, dynamic> toJson() => {
    "is_first_login": isFirstLogin,
    "is_active": isActive,
    "access_token": accessToken,
    "refresh_token": refreshToken,
    "is_active_expiry": isActiveExpiry,
    "refresh_token_expiry": refreshTokenExpiry,
    "treatment": treatment == null
        ? []
        : List<dynamic>.from(treatment!.map((x) => x.toJson())),
    "user": user?.toJson(),
    "dashboard": dashboard?.toJson(),
  };
}

class User {
  final int? id;
  final String? name;
  final String? email;
  final String? role;
  final String? profileImageUrl;
  final String? primaryEmail;
  final String? phoneNumber;
  final String? location;
  final String? bio;

  User({
    this.id,
    this.name,
    this.email,
    this.role,
    this.profileImageUrl,
    this.primaryEmail,
    this.phoneNumber,
    this.location,
    this.bio,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    role: json["role"],
    profileImageUrl: json["profile_image_url"],
    primaryEmail: json["primary_email"] ?? json["email"],
    phoneNumber: json["phone_number"],
    location: json["location"],
    bio: json["bio"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "role": role,
    "profile_image_url": profileImageUrl,
    "primary_email": primaryEmail,
    "phone_number": phoneNumber,
    "location": location,
    "bio": bio,
  };
}

class DashboardData {
  final List<DashboardAppointment>? appointments;
  final List<TreatmentData>? suggestedTreatments;
  final List<TopDoctor>? topDoctors;
  final List<TopClinic>? topClinics;

  DashboardData({
    this.appointments,
    this.suggestedTreatments,
    this.topDoctors,
    this.topClinics,
  });

  factory DashboardData.fromJson(Map<String, dynamic> json) => DashboardData(
    appointments: json["appointments"] == null
        ? []
        : List<DashboardAppointment>.from(
            json["appointments"]!.map((x) => DashboardAppointment.fromJson(x)),
          ),
    suggestedTreatments: json["suggested_treatments"] == null
        ? []
        : List<TreatmentData>.from(
            json["suggested_treatments"]!.map((x) => TreatmentData.fromJson(x)),
          ),
    topDoctors: json["top_doctors"] == null
        ? []
        : List<TopDoctor>.from(
            json["top_doctors"]!.map((x) => TopDoctor.fromJson(x)),
          ),
    topClinics: json["top_clinics"] == null
        ? []
        : List<TopClinic>.from(
            json["top_clinics"]!.map((x) => TopClinic.fromJson(x)),
          ),
  );

  Map<String, dynamic> toJson() => {
    "appointments": appointments?.map((x) => x.toJson()).toList(),
    "suggested_treatments": suggestedTreatments?.map((x) => x.toJson()).toList(),
    "top_doctors": topDoctors?.map((x) => x.toJson()).toList(),
    "top_clinics": topClinics?.map((x) => x.toJson()).toList(),
  };
}

class DashboardAppointment {
  final int? date;
  final String? appointmentType;
  final int? appointmentTypeId;
  final List<List<AppointmentTreatment>>? treatments;
  final DashboardDoctor? doctor;
  final DashboardClinic? clinic;

  DashboardAppointment({
    this.date,
    this.appointmentType,
    this.appointmentTypeId,
    this.treatments,
    this.doctor,
    this.clinic,
  });

  factory DashboardAppointment.fromJson(Map<String, dynamic> json) =>
      DashboardAppointment(
        date: json["date"],
        appointmentType: json["appointment_type"],
        appointmentTypeId: json["appointment_type_id"],
        treatments: json["treatments"] == null
            ? []
            : List<List<AppointmentTreatment>>.from(
                json["treatments"]!.map(
                  (x) => List<AppointmentTreatment>.from(
                    x.map((y) => AppointmentTreatment.fromJson(y)),
                  ),
                ),
              ),
        doctor: json["doctor"] == null
            ? null
            : DashboardDoctor.fromJson(json["doctor"]),
        clinic: json["clinic"] == null
            ? null
            : DashboardClinic.fromJson(json["clinic"]),
      );

  Map<String, dynamic> toJson() => {
    "date": date,
    "appointment_type": appointmentType,
    "appointment_type_id": appointmentTypeId,
    "treatments": treatments
        ?.map((x) => x.map((y) => y.toJson()).toList())
        .toList(),
    "doctor": doctor?.toJson(),
    "clinic": clinic?.toJson(),
  };

  AppointmentItem toAppointmentItem() {
    return AppointmentItem(
      date: date,
      appointmentType: appointmentType,
      appointmentTypeId: appointmentTypeId,
      treatments: treatments?.expand((x) => x).toList(),
      doctor: doctor != null
          ? AppointmentDoctor(
            doctorId: doctor!.doctorId,
            doctorName: doctor!.doctorName,
            doctorImage: doctor!.doctorImage,
          )
          : null,
      clinic: clinic != null
          ? AppointmentClinic(
            clinicId: clinic!.clinicId,
            clinicName: clinic!.clinicName,
            clinicImage: clinic!.clinicImage,
          )
          : null,
    );
  }
}

// Remove AppointmentTreatment and AppointmentMaterial here to use from get_appointment_response.dart

class DashboardDoctor {
  final int? doctorId;
  final String? doctorName;
  final String? doctorImage;

  DashboardDoctor({this.doctorId, this.doctorName, this.doctorImage});

  factory DashboardDoctor.fromJson(Map<String, dynamic> json) =>
      DashboardDoctor(
        doctorId: json["doctor_id"],
        doctorName: json["doctor_name"],
        doctorImage: json["docotor_image"],
      );

  Map<String, dynamic> toJson() => {
    "doctor_id": doctorId,
    "doctor_name": doctorName,
    "docotor_image": doctorImage,
  };
}

class DashboardClinic {
  final int? clinicId;
  final String? clinicName;
  final String? clinicImage;

  DashboardClinic({this.clinicId, this.clinicName, this.clinicImage});

  factory DashboardClinic.fromJson(Map<String, dynamic> json) =>
      DashboardClinic(
        clinicId: json["clinic_id"],
        clinicName: json["clinic_name"],
        clinicImage: json["clinic_image"],
      );

  Map<String, dynamic> toJson() => {
    "clinic_id": clinicId,
    "clinic_name": clinicName,
    "clinic_image": clinicImage,
  };
}

class TopDoctor {
  final int? doctorId;
  final String? doctorImage;
  final num? doctorRating;
  final String? doctorName;
  final String? specialization;
  final DashboardClinic? clinic;

  TopDoctor({
    this.doctorId,
    this.doctorImage,
    this.doctorRating,
    this.doctorName,
    this.specialization,
    this.clinic,
  });

  factory TopDoctor.fromJson(Map<String, dynamic> json) => TopDoctor(
    doctorId: json["doctor_id"],
    doctorImage: json["doctor_image"],
    doctorRating: json["doctor_rating"],
    doctorName: json["doctor_name"],
    specialization: json["specaialization"],
    clinic: json["clinic"] == null
        ? null
        : DashboardClinic.fromJson(json["clinic"]),
  );

  Map<String, dynamic> toJson() => {
    "doctor_id": doctorId,
    "doctor_image": doctorImage,
    "doctor_rating": doctorRating,
    "doctor_name": doctorName,
    "specaialization": specialization,
    "clinic": clinic?.toJson(),
  };
}

class TopClinic {
  final int? clinicId;
  final String? clinicImage;
  final num? clinicRating;
  final String? clinicName;
  final String? address;
  final int? doctorCount;

  TopClinic({
    this.clinicId,
    this.clinicImage,
    this.clinicRating,
    this.clinicName,
    this.address,
    this.doctorCount,
  });

  factory TopClinic.fromJson(Map<String, dynamic> json) => TopClinic(
    clinicId: json["clinic_id"],
    clinicImage: json["clinic_image"],
    clinicRating: json["clinic_rating"],
    clinicName: json["clinic_name"],
    address: json["address"],
    doctorCount: json["doctor_count"],
  );

  Map<String, dynamic> toJson() => {
    "clinic_id": clinicId,
    "clinic_image": clinicImage,
    "clinic_rating": clinicRating,
    "clinic_name": clinicName,
    "address": address,
    "doctor_count": doctorCount,
  };
}
