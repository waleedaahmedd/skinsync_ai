import 'base_response_model.dart';

typedef BaseApiResponseModel = BaseResponseModel;

class TreatmentCategoryListResponse extends BaseApiResponseModel {
  List<TreatmentCategoryModel>? data;

  TreatmentCategoryListResponse({super.isSuccess, super.message, this.data});

  TreatmentCategoryListResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['is_success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <TreatmentCategoryModel>[];
      json['data'].forEach((v) {
        data!.add(TreatmentCategoryModel.fromJson(v));
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

class TreatmentCategoryModel {
  int? id;
  String? name;
  String? icon;
  String? image;
  String? shortDescription;
  int? parentId;
  List<TreatmentCategoryModel>? subCategories;

  TreatmentCategoryModel({
    this.id,
    this.name,
    this.icon,
    this.image,
    this.shortDescription,
    this.parentId,
    this.subCategories,
  });

  TreatmentCategoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    icon = json['icon'];
    image = json['image'];
    shortDescription = json['short_description'];
    parentId = json['parent_id'];
    if (json['sub_categories'] != null) {
      subCategories = <TreatmentCategoryModel>[];
      json['sub_categories'].forEach((v) {
        subCategories!.add(TreatmentCategoryModel.fromJson(v));
      });
    } else {
      subCategories = [];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['icon'] = icon;
    data['image'] = image;
    data['short_description'] = shortDescription;
    data['parent_id'] = parentId;
    if (subCategories != null) {
      data['sub_categories'] = subCategories!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
