import 'package:skinsync_ai/models/responses/base_response_model.dart';

class SubSelectionResponse extends BaseResponseModel {
 
  List<Data>? data;

  SubSelectionResponse({super.isSuccess, super.message, this.data});

  SubSelectionResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['is_success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
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

class Data {
  int? id;
  String? name;
  String? icon;
  String? description;
  int? minSyringe;
  int? maxSyringe;
  List<int>? syringeOptions;

  Data(
      {this.id,
      this.name,
      this.icon,
      this.description,
      this.minSyringe,
      this.maxSyringe,
      this.syringeOptions});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    icon = json['icon'];
    description = json['description'];
    minSyringe = json['min_syringe'];
    maxSyringe = json['max_syringe'];
    syringeOptions = json['syringe_options'].cast<int>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['icon'] = this.icon;
    data['description'] = this.description;
    data['min_syringe'] = this.minSyringe;
    data['max_syringe'] = this.maxSyringe;
    data['syringe_options'] = this.syringeOptions;
    return data;
  }
}
