import 'base_response_model.dart';

class AppointmentTypeListResponse extends BaseResponseModel {
  List<AppointmentTypeData>? data;

  AppointmentTypeListResponse({
    super.isSuccess,
    super.message,
    this.data,
  });

  AppointmentTypeListResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['is_success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <AppointmentTypeData>[];
      json['data'].forEach((v) {
        data!.add(AppointmentTypeData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['is_success'] = isSuccess;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AppointmentTypeData {
  int? id;
  String? title;
  String? key;
  String? description;
  String? timing;
  int? maxDuration;
  List<String>? appointmentModes;
  String? icon;
  String? image;
  String? status;

  AppointmentTypeData({
    this.id,
    this.title,
    this.key,
    this.description,
    this.timing,
    this.maxDuration,
    this.appointmentModes,
    this.icon,
    this.image,
    this.status,
  });

  AppointmentTypeData copyWith({
    int? id,
    String? title,
    String? key,
    String? description,
    String? timing,
    int? maxDuration,
    List<String>? appointmentModes,
    String? icon,
    String? image,
    String? status,
  }) {
    return AppointmentTypeData(
      id: id ?? this.id,
      title: title ?? this.title,
      key: key ?? this.key,
      description: description ?? this.description,
      timing: timing ?? this.timing,
      maxDuration: maxDuration ?? this.maxDuration,
      appointmentModes: appointmentModes ?? this.appointmentModes,
      icon: icon ?? this.icon,
      image: image ?? this.image,
      status: status ?? this.status,
    );
  }

  AppointmentTypeData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    key = json['key'];
    description = json['description'];
    timing = json['timing'];
    maxDuration = json['max_duration'];
    appointmentModes = json['appointment_modes'] != null
        ? List<String>.from(json['appointment_modes'])
        : null;
    icon = json['icon'];
    image = json['image'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['key'] = key;
    data['description'] = description;
    data['timing'] = timing;
    data['max_duration'] = maxDuration;
    if (appointmentModes != null) {
      data['appointment_modes'] = appointmentModes;
    }
    data['icon'] = icon;
    data['image'] = image;
    data['status'] = status;
    return data;
  }
}
