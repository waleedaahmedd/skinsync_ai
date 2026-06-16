import 'base_response_model.dart';

class TreatmentAreaResponse extends BaseResponseModel {
  List<TreatmentAreaModel>? data;

  TreatmentAreaResponse({super.status, super.message, this.data});

  TreatmentAreaResponse.fromJson(Map<String, dynamic> json) {
    status = json['is_success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <TreatmentAreaModel>[];
      json['data'].forEach((v) {
        data!.add(TreatmentAreaModel.fromJson(v));
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

class TreatmentAreaModel {
  int? id;
  String? name;
  String? icon;
  String? description;
  bool? isSidearea;

  TreatmentAreaModel({
    this.id,
    this.name,
    this.icon,
    this.description,
    this.isSidearea,
  });

  TreatmentAreaModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    icon = json['icon'];
    description = json['description'];
    isSidearea = json['is_sidearea'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['icon'] = icon;
    data['description'] = description;
    data['is_sidearea'] = isSidearea;
    return data;
  }
}
