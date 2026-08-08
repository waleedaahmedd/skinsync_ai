import 'base_response_model.dart';

class RefreshTokenResponse extends BaseResponseModel {
  final Data? data;

  RefreshTokenResponse({super.isSuccess, super.message, this.data});

  factory RefreshTokenResponse.fromJson(Map<String, dynamic> json) =>
      RefreshTokenResponse(
        isSuccess: json["is_success"],
        message: json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
    "is_success": isSuccess,
    "message": message,
    "data": data?.toJson(),
  };
}

class Data {
  final bool? isFirstLogin;
  final bool? isActive;
  final String? accessToken;
  final String? refreshToken;
  final int? isActiveExpiry;
  final int? refreshTokenExpiry;
  final Dashboard? dashboard;
  final User? user;

  Data({
    this.isFirstLogin,
    this.isActive,
    this.accessToken,
    this.refreshToken,
    this.isActiveExpiry,
    this.refreshTokenExpiry,
    this.dashboard,
    this.user,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    isFirstLogin: json["is_first_login"],
    isActive: json["is_active"],
    accessToken: json["access_token"],
    refreshToken: json["refresh_token"],
    isActiveExpiry: json["is_active_expiry"],
    refreshTokenExpiry: json["refresh_token_expiry"],
    dashboard: json["dashboard"] == null
        ? null
        : Dashboard.fromJson(json["dashboard"]),
    user: json["user"] == null ? null : User.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "is_first_login": isFirstLogin,
    "is_active": isActive,
    "access_token": accessToken,
    "refresh_token": refreshToken,
    "is_active_expiry": isActiveExpiry,
    "refresh_token_expiry": refreshTokenExpiry,
    "dashboard": dashboard?.toJson(),
    "user": user?.toJson(),
  };
}

class Dashboard {
  final List<Appointment>? appointments;
  final List<SuggestedTreatment>? suggestedTreatments;
  final List<TopDoctor>? topDoctors;
  final List<TopClinic>? topClinics;

  Dashboard({
    this.appointments,
    this.suggestedTreatments,
    this.topDoctors,
    this.topClinics,
  });

  factory Dashboard.fromJson(Map<String, dynamic> json) => Dashboard(
    appointments: json["appointments"] == null
        ? []
        : List<Appointment>.from(
            json["appointments"]!.map((x) => Appointment.fromJson(x)),
          ),
    suggestedTreatments: json["suggested_treatments"] == null
        ? []
        : List<SuggestedTreatment>.from(
            json["suggested_treatments"]!.map(
              (x) => SuggestedTreatment.fromJson(x),
            ),
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
    "appointments": appointments == null
        ? []
        : List<dynamic>.from(appointments!.map((x) => x.toJson())),
    "suggested_treatments": suggestedTreatments == null
        ? []
        : List<dynamic>.from(suggestedTreatments!.map((x) => x.toJson())),
    "top_doctors": topDoctors == null
        ? []
        : List<dynamic>.from(topDoctors!.map((x) => x.toJson())),
    "top_clinics": topClinics == null
        ? []
        : List<dynamic>.from(topClinics!.map((x) => x.toJson())),
  };
}

class Appointment {
  final int? id;
  final int? date;
  final Slot? slot;
  final String? appointmentType;
  final int? appointmentTypeId;
  final String? appointmentKey;
  final List<Treatment>? treatments;
  final Doctor? doctor;
  final AppointmentClinic? clinic;

  Appointment({
    this.id,
    this.date,
    this.slot,
    this.appointmentType,
    this.appointmentTypeId,
    this.appointmentKey,
    this.treatments,
    this.doctor,
    this.clinic,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) => Appointment(
    id: json["id"],
    date: json["date"],
    slot: json["slot"] == null ? null : Slot.fromJson(json["slot"]),
    appointmentType: json["appointment_type"],
    appointmentTypeId: json["appointment_type_id"],
    appointmentKey: json["appointment_key"],
    treatments: json["treatments"] == null
        ? []
        : List<Treatment>.from(
            json["treatments"]!.map((x) => Treatment.fromJson(x)),
          ),
    doctor: json["doctor"] == null ? null : Doctor.fromJson(json["doctor"]),
    clinic: json["clinic"] == null
        ? null
        : AppointmentClinic.fromJson(json["clinic"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "date": date,
    "slot": slot?.toJson(),
    "appointment_type": appointmentType,
    "appointment_type_id": appointmentTypeId,
    "appointment_key": appointmentKey,
    "treatments": treatments == null
        ? []
        : List<dynamic>.from(treatments!.map((x) => x.toJson())),
    "doctor": doctor?.toJson(),
    "clinic": clinic?.toJson(),
  };
}

class AppointmentClinic {
  final int? clinicId;
  final String? clinicName;
  final String? clinicImage;

  AppointmentClinic({this.clinicId, this.clinicName, this.clinicImage});

  factory AppointmentClinic.fromJson(Map<String, dynamic> json) =>
      AppointmentClinic(
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

class Doctor {
  final int? doctorId;
  final String? doctorName;
  final String? doctorImage;

  Doctor({this.doctorId, this.doctorName, this.doctorImage});

  factory Doctor.fromJson(Map<String, dynamic> json) => Doctor(
    doctorId: json["doctor_id"],
    doctorName: json["doctor_name"],
    doctorImage: json["doctor_image"],
  );

  Map<String, dynamic> toJson() => {
    "doctor_id": doctorId,
    "doctor_name": doctorName,
    "doctor_image": doctorImage,
  };
}

class Slot {
  final int? startTime;
  final int? endTime;

  Slot({this.startTime, this.endTime});

  factory Slot.fromJson(Map<String, dynamic> json) =>
      Slot(startTime: json["start_time"], endTime: json["end_time"]);

  Map<String, dynamic> toJson() => {
    "start_time": startTime,
    "end_time": endTime,
  };
}

class Treatment {
  final int? treatmentId;
  final String? treatmentName;
  final String? treatmentImage;
  final int? areaId;
  final String? areaName;
  final Material? material;

  Treatment({
    this.treatmentId,
    this.treatmentName,
    this.treatmentImage,
    this.areaId,
    this.areaName,
    this.material,
  });

  factory Treatment.fromJson(Map<String, dynamic> json) => Treatment(
    treatmentId: json["treatment_id"],
    treatmentName: json["treatment_name"],
    treatmentImage: json["treatment_image"],
    areaId: json["area_id"],
    areaName: json["area_name"],
    material: json["material"] == null
        ? null
        : Material.fromJson(json["material"]),
  );

  Map<String, dynamic> toJson() => {
    "treatment_id": treatmentId,
    "treatment_name": treatmentName,
    "treatment_image": treatmentImage,
    "area_id": areaId,
    "area_name": areaName,
    "material": material?.toJson(),
  };
}

class Material {
  final int? id;
  final int? selectedQuantity;
  final String? name;

  Material({this.id, this.selectedQuantity, this.name});

  factory Material.fromJson(Map<String, dynamic> json) => Material(
    id: json["id"],
    selectedQuantity: json["selected_quantity"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "selected_quantity": selectedQuantity,
    "name": name,
  };
}

class SuggestedTreatment {
  final int? id;
  final String? name;
  final String? icon;
  final String? shortDescription;
  final String? image;
  final bool? useInAiSimulator;

  SuggestedTreatment({
    this.id,
    this.name,
    this.icon,
    this.shortDescription,
    this.image,
    this.useInAiSimulator,
  });

  factory SuggestedTreatment.fromJson(Map<String, dynamic> json) =>
      SuggestedTreatment(
        id: json["id"],
        name: json["name"],
        icon: json["icon"],
        shortDescription: json["short_description"],
        image: json["image"],
        useInAiSimulator: json["use_in_ai_simulator"],
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "icon": icon,
    "short_description": shortDescription,
    "image": image,
    "use_in_ai_simulator": useInAiSimulator,
  };
}

class TopClinic {
  final int? clinicId;
  final String? clinicImage;
  final int? clinicRating;
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

class TopDoctor {
  final int? doctorId;
  final String? doctorImage;
  final int? doctorRating;
  final String? doctorName;
  final String? specialization;
  final TopDoctorClinic? clinic;

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
    specialization: json["specialization"],
    clinic: json["clinic"] == null
        ? null
        : TopDoctorClinic.fromJson(json["clinic"]),
  );

  Map<String, dynamic> toJson() => {
    "doctor_id": doctorId,
    "doctor_image": doctorImage,
    "doctor_rating": doctorRating,
    "doctor_name": doctorName,
    "specialization": specialization,
    "clinic": clinic?.toJson(),
  };
}

class TopDoctorClinic {
  final int? clinicId;
  final String? clinicName;

  TopDoctorClinic({this.clinicId, this.clinicName});

  factory TopDoctorClinic.fromJson(Map<String, dynamic> json) =>
      TopDoctorClinic(
        clinicId: json["clinic_id"],
        clinicName: json["clinic_name"],
      );

  Map<String, dynamic> toJson() => {
    "clinic_id": clinicId,
    "clinic_name": clinicName,
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
  final int? userProfileId;
  final String? status;
  final String? emailAddress;
  final String? cc;
  final String? country;
  final DateTime? createdAt;
  final DateTime? updatedAt;

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
    this.userProfileId,
    this.status,
    this.emailAddress,
    this.cc,
    this.country,
    this.createdAt,
    this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    role: json["role"],
    profileImageUrl: json["profile_image_url"],
    primaryEmail: json["primary_email"],
    phoneNumber: json["phone_number"],
    location: json["location"],
    bio: json["bio"],
    userProfileId: json["user_profile_id"],
    status: json["status"],
    emailAddress: json["email_address"],
    cc: json["cc"],
    country: json["country"],
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
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
    "user_profile_id": userProfileId,
    "status": status,
    "email_address": emailAddress,
    "cc": cc,
    "country": country,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
