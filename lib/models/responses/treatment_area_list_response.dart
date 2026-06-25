import 'base_response_model.dart';

typedef BaseApiResponseModel = BaseResponseModel;

class TreatmentAreaListResponse extends BaseApiResponseModel {
  List<TreatmentAreaModel>? data;

  TreatmentAreaListResponse({super.isSuccess, super.message, this.data});

  TreatmentAreaListResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['is_success'];
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
    data['is_success'] = isSuccess;
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
  String? globalSku;
  String? icon;
  String? image;
  int? subAreasCount;
  List<TreatmentAreaModel>? subAreas;

  TreatmentAreaModel({
    this.id,
    this.name,
    this.globalSku,
    this.icon,
    this.image,
    this.subAreasCount,
    this.subAreas,
  });

  TreatmentAreaModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    globalSku = json['global_sku'];
    icon = json['icon'];
    image = json['image'];
    subAreasCount = json['sub_areas_count'];
    if (json['sub_areas'] != null) {
      subAreas = <TreatmentAreaModel>[];
      json['sub_areas'].forEach((v) {
        subAreas!.add(TreatmentAreaModel.fromJson(v));
      });
    } else {
      subAreas = [];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['global_sku'] = globalSku;
    data['icon'] = icon;
    data['image'] = image;
    data['sub_areas_count'] = subAreasCount;
    if (subAreas != null) {
      data['sub_areas'] = subAreas!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
