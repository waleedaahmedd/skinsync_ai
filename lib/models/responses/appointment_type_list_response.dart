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
  String? name;
  String? description;
  String? imageUrl;
  String? icon;

  AppointmentTypeData({
    this.id,
    this.name,
    this.description,
    this.imageUrl,
    this.icon,
  });

  AppointmentTypeData copyWith({
    int? id,
    String? name,
    String? description,
    String? imageUrl,
    String? icon,
  }) {
    return AppointmentTypeData(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      icon: icon ?? this.icon,
    );
  }

  AppointmentTypeData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    imageUrl = json['image_url'];
    icon = json['icon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['image_url'] = imageUrl;
    data['icon'] = icon;
    return data;
  }
}
