import 'package:skinsync_ai/models/responses/base_response_model.dart';

class SelectSelectionResponse extends BaseResponseModel {
 
  List<SelectSection>? data;

  SelectSelectionResponse({super.isSuccess, super.message, this.data});

  SelectSelectionResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['is_success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <SelectSection>[];
      json['data'].forEach((v) {
        data!.add(new SelectSection.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['is_success'] = this.isSuccess;
    data['message'] = this.message;
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['icon'] = this.icon;
    data['description'] = this.description;
    data['is_sidearea'] = this.isSidearea;
    return data;
  }
}
