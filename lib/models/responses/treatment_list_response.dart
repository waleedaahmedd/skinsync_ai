import 'base_response_model.dart';

class TreatmentListResponse extends BaseResponseModel {
  int? page;
  int? limit;
  int? totalPages;
  List<TreatmentData>? data;

  TreatmentListResponse({
    super.isSuccess,
    super.message,
    this.page,
    this.limit,
    this.totalPages,
    this.data,
  });

  TreatmentListResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['is_success'];
    message = json['message'];
    page = json['page'];
    limit = json['limit'];
    totalPages = json['total_pages'];
    if (json['data'] != null) {
      data = <TreatmentData>[];
      json['data'].forEach((v) {
        data!.add(TreatmentData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['is_success'] = isSuccess;
    data['message'] = message;
    data['page'] = page;
    data['limit'] = limit;
    data['total_pages'] = totalPages;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TreatmentData {
  int? id;
  String? name;
  String? icon;
  String? description;
  bool? isArea;
  String? imageUrl;
  String? shortDescription;
  String? globalSku;
  String? image;
  bool? useInAiSimulator;

  TreatmentData({
    this.id,
    this.name,
    this.icon,
    this.description,
    this.isArea = true,
    this.imageUrl,
    this.shortDescription,
    this.globalSku,
    this.image,
    this.useInAiSimulator,
  });

  TreatmentData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    icon = json['icon'];
    shortDescription = json['short_description'];
    description = shortDescription;
    globalSku = json['global_sku'];
    image = json['image'];
    imageUrl = image;
    useInAiSimulator = json['use_in_ai_simulator'];
    isArea = true; // Maintain compatibility with isArea logic
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['icon'] = icon;
    data['short_description'] = shortDescription;
    data['global_sku'] = globalSku;
    data['image'] = image;
    data['use_in_ai_simulator'] = useInAiSimulator;
    return data;
  }
}
