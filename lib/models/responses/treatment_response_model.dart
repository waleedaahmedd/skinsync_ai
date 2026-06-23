import 'base_response_model.dart';

class TreatmentResponse extends BaseResponseModel {
  List<TreatmentsModel>? data;

  TreatmentResponse({super.status, super.message, this.data});

  TreatmentResponse.fromJson(Map<String, dynamic> json) {
    status = json['is_success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <TreatmentsModel>[];
      json['data'].forEach((v) {
        data!.add(TreatmentsModel.fromJson(v));
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

class TreatmentsModel {
  int? id;
  String? name;
  String? icon;
  String? description;
  bool? isArea;
  String? imageUrl;

  TreatmentsModel({
    this.id,
    this.name,
    this.icon,
    this.description,
    this.isArea,
    this.imageUrl,
  });

  TreatmentsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    icon = json['icon'];
    description = json['description'];
    isArea = json['is_area'];
    imageUrl = json['image_url '];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['icon'] = icon;
    data['description'] = description;
    data['is_area'] = isArea;
    data['image_url '] = imageUrl;
    return data;
  }
}
