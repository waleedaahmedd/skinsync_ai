import 'base_response_model.dart';

class TreatmentResponse extends BaseResponseModel {
  List<TreatmentsModel>? data;

  TreatmentResponse({super.isSuccess, super.message, this.data});

  TreatmentResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['is_success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <TreatmentsModel>[];
      json['data'].forEach((v) {
        data!.add(new TreatmentsModel.fromJson(v));
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

class TreatmentsModel {
  int? id;
  String? name;
  String? icon;
  String? description;
  bool? isArea;

  TreatmentsModel({
    this.id,
    this.name,
    this.icon,
    this.description,
    this.isArea,
  });

  TreatmentsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    icon = json['icon'];
    description = json['description'];
    isArea = json['is_area'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['icon'] = this.icon;
    data['description'] = this.description;
    data['is_area'] = this.isArea;
    return data;
  }
}
