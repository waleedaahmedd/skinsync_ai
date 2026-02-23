import 'package:skinsync_ai/models/responses/base_response_model.dart';

class TreatmentAreaResponse extends BaseResponseModel {
 
  List<SelectSection>? data;

  TreatmentAreaResponse({super.isSuccess, super.message, this.data});

  TreatmentAreaResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['is_success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <SelectSection>[];
      json['data'].forEach((v) {
        data!.add(SelectSection.fromJson(v));
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

class SelectSection {
  int? id;
  String? name;
  String? icon;
  String? description;
  bool? isSidearea;

  SelectSection({this.id, this.name, this.icon, this.description, this.isSidearea});

  SelectSection.fromJson(Map<String, dynamic> json) {
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
