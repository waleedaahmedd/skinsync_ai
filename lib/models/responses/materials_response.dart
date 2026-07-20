import 'base_response_model.dart';

class MaterialsResponse extends BaseResponseModel {
  MaterialData? data;

  MaterialsResponse({
    super.isSuccess,
    super.message,
    this.data,
  });

  MaterialsResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['is_success'];
    message = json['message'];
    final rawData = json['data'];
    if (rawData != null && rawData is Map) {
      data = MaterialData.fromJson(Map<String, dynamic>.from(rawData));
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['is_success'] = isSuccess;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class MaterialData {
  int? id;
  String? unitType;
  int? minQty;
  int? maxQty;

  MaterialData({
    this.id,
    this.unitType,
    this.minQty,
    this.maxQty,
  });

  MaterialData.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    unitType = json['unit_type'];
    minQty = json['min_qty'];
    maxQty = json['max_qty'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['unit_type'] = unitType;
    data['min_qty'] = minQty;
    data['max_qty'] = maxQty;
    return data;
  }
}
