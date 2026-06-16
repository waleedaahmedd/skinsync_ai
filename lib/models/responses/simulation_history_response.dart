import 'base_response_model.dart';

class SimulationHistoryResponse extends BaseResponseModel {
  final List<SimulationData>? data;

  SimulationHistoryResponse({super.status, super.message, this.data});

  factory SimulationHistoryResponse.fromJson(Map<String, dynamic> json) =>
      SimulationHistoryResponse(
        status: json["is_success"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<SimulationData>.from(
                json["data"]!.map((x) => SimulationData.fromJson(x)),
              ),
      );
}

class SimulationData {
  final int? id;
  final int? treatmentId;
  final String? treatmentName;
  final String? beforeImage;
  final String? afterImage;
  final List<Subsection>? subsections;
  final DateTime? createdAt;

  const SimulationData({
    this.id,
    this.treatmentId,
    this.treatmentName,
    this.beforeImage,
    this.afterImage,
    this.subsections,
    this.createdAt,
  });

  factory SimulationData.fromJson(Map<String, dynamic> json) => SimulationData(
    id: json["id"],
    treatmentId: json["treatment_id"],
    treatmentName: json["treatment_name"],
    beforeImage: json["before_image"],
    afterImage: json["after_image"],
    subsections: json["subsections"] == null
        ? []
        : List<Subsection>.from(
            json["subsections"]!.map((x) => Subsection.fromJson(x)),
          ),
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]).toLocal(),
  );
}

class Subsection {
  final int? areaId;
  final String? areaName;
  final int? sectionId;
  final String? sectionName;
  final int? syringesQuantity;

  const Subsection({
    this.areaId,
    this.areaName,
    this.sectionId,
    this.sectionName,
    this.syringesQuantity,
  });

  factory Subsection.fromJson(Map<String, dynamic> json) => Subsection(
    areaId: json['area_id'],
    areaName: json['area_name'],
    sectionId: json["section_id"],
    sectionName: json["section_name"],
    syringesQuantity: json["syringes_quantity"],
  );
}
