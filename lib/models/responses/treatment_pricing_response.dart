import 'base_response_model.dart';

class TreatmentPricingResponse extends BaseResponseModel {
  final PricingData? data;

  TreatmentPricingResponse({this.data, super.status, super.message});

  factory TreatmentPricingResponse.fromJson(Map<String, dynamic> json) =>
      TreatmentPricingResponse(
        data: json["data"] == null ? null : PricingData.fromJson(json["data"]),
        status: json["is_success"],
        message: json["message"],
      );
}

class PricingData {
  final Treatment? treatment;
  final List<SubSection>? subSections;

  PricingData({this.treatment, this.subSections});

  factory PricingData.fromJson(Map<String, dynamic> json) => PricingData(
    treatment: json["treatment"] == null
        ? null
        : Treatment.fromJson(json["treatment"]),
    subSections: json["sub_sections"] == null
        ? []
        : List<SubSection>.from(
            json["sub_sections"]!.map((x) => SubSection.fromJson(x)),
          ),
  );
}

class SubSection {
  final int? id;
  final String? name;
  final int? perSyringePrice;

  SubSection({this.id, this.name, this.perSyringePrice});

  factory SubSection.fromJson(Map<String, dynamic> json) => SubSection(
    id: json['id'] ?? 0,
    name: json["name"],
    perSyringePrice: json["per_syringe_price"],
  );
}

class Treatment {
  final String? name;
  final int? price;

  Treatment({this.name, this.price});

  factory Treatment.fromJson(Map<String, dynamic> json) =>
      Treatment(name: json["name"], price: json["price"]);
}
