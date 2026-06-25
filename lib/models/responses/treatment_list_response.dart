import 'base_response_model.dart';
import 'treatment_response_model.dart';

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

class TreatmentData extends TreatmentsModel {
  String? shortDescription;
  String? globalSku;
  String? image;
  bool? useInAiSimulator;

  TreatmentData({
    super.id,
    super.name,
    this.shortDescription,
    this.globalSku,
    super.icon,
    this.image,
    this.useInAiSimulator,
  }) : super(
          description: shortDescription,
          imageUrl: image,
          isArea: true, // Maintain compatibility with isArea logic
        );

  TreatmentData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    shortDescription = json['short_description'];
    description = shortDescription;
    globalSku = json['global_sku'];
    icon = json['icon'];
    image = json['image'];
    imageUrl = image;
    useInAiSimulator = json['use_in_ai_simulator'];
    isArea = true; // Maintain compatibility with isArea logic
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['short_description'] = shortDescription;
    data['global_sku'] = globalSku;
    data['icon'] = icon;
    data['image'] = image;
    data['use_in_ai_simulator'] = useInAiSimulator;
    return data;
  }
}
