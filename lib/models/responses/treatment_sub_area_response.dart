import 'base_response_model.dart';

class TreatmentSubAreaResponse extends BaseResponseModel {
  List<TreatmentSubAreaModel>? data;

  TreatmentSubAreaResponse({super.status, super.message, this.data});

  TreatmentSubAreaResponse.fromJson(Map<String, dynamic> json) {
    status = json['is_success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <TreatmentSubAreaModel>[];
      json['data'].forEach((v) {
        data!.add(TreatmentSubAreaModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['is_success'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TreatmentSubAreaModel {
  int? id;
  String? name;
  String? icon;
  String? description;
  int? minSyringe;
  int? maxSyringe;
  List<int>? syringeOptions;
  final int currentSyringe;
  final int? areaId;

  TreatmentSubAreaModel({
    this.id,
    this.name,
    this.icon,
    this.description,
    this.minSyringe,
    this.maxSyringe,
    this.syringeOptions,
    required this.currentSyringe,
    this.areaId,
  });

  factory TreatmentSubAreaModel.fromJson(Map<String, dynamic> json) {
    return TreatmentSubAreaModel(
      id: json['id'],
      name: json['name'],
      icon: json['icon'],
      description: json['description'],
      minSyringe: json['min_syringe'],
      maxSyringe: json['max_syringe'],
      syringeOptions: json['syringe_options'].cast<int>(),
      currentSyringe: json['min_syringe'] ?? 0,
      areaId: json['area_id'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['icon'] = icon;
    data['description'] = description;
    data['min_syringe'] = minSyringe;
    data['max_syringe'] = maxSyringe;
    data['syringe_options'] = syringeOptions;
    return data;
  }

  TreatmentSubAreaModel copyWith({
    int? id,
    String? name,
    String? icon,
    String? description,
    int? minSyringe,
    int? maxSyringe,
    List<int>? syringeOptions,
    int? currentSyringe,
    int? areaId,
  }) {
    return TreatmentSubAreaModel(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      description: description ?? this.description,
      minSyringe: minSyringe ?? this.minSyringe,
      maxSyringe: maxSyringe ?? this.maxSyringe,
      syringeOptions: syringeOptions ?? this.syringeOptions,
      currentSyringe: currentSyringe ?? this.currentSyringe,
      areaId: areaId ?? this.areaId,
    );
  }
}
