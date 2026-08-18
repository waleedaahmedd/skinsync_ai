import 'base_response_model.dart';

class SimulationHistoryResponse extends BaseResponseModel {
  final List<SimulationData>? data;

  SimulationHistoryResponse({super.isSuccess, super.message, this.data});

  factory SimulationHistoryResponse.fromJson(Map<String, dynamic> json) =>
      SimulationHistoryResponse(
        isSuccess: json["is_success"],
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
  final int? userId;
  final int? groupId;
  final String? name;
  final String? frontImageBefore;
  final String? frontImageAfter;
  final String? rightImageBefore;
  final String? rightImageAfter;
  final String? leftImageBefore;
  final String? leftImageAfter;
  final List<SimulationTreatment>? treatments;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const SimulationData({
    this.id,
    this.userId,
    this.groupId,
    this.name,
    this.frontImageBefore,
    this.frontImageAfter,
    this.rightImageBefore,
    this.rightImageAfter,
    this.leftImageBefore,
    this.leftImageAfter,
    this.treatments,
    this.createdAt,
    this.updatedAt,
  });

  factory SimulationData.fromJson(Map<String, dynamic> json) => SimulationData(
    id: json["id"],
    userId: json["user_id"],
    groupId: json["group_id"],
    name: json["name"],
    frontImageBefore: json["front_image_before"],
    frontImageAfter: json["front_image_after"],
    rightImageBefore: json["right_image_before"],
    rightImageAfter: json["right_image_after"],
    leftImageBefore: json["left_image_before"],
    leftImageAfter: json["left_image_after"],
    treatments: json["treatments"] == null
        ? []
        : List<SimulationTreatment>.from(
            json["treatments"]!.map((x) => SimulationTreatment.fromJson(x)),
          ),
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]).toLocal(),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]).toLocal(),
  );
}

class SimulationTreatment {
  final int? id;
  final String? name;
  final String? description;
  final String? image;
  final String? icon;
  final List<SimulationArea>? areas;

  const SimulationTreatment({
    this.id,
    this.name,
    this.description,
    this.image,
    this.icon,
    this.areas,
  });

  factory SimulationTreatment.fromJson(Map<String, dynamic> json) =>
      SimulationTreatment(
        id: json["treatment_id"],
        name: json["treatment_name"],
        description: json["treatment_desc"],
        image: json["treatment_image"],
        icon: json["treatment_icon"],
        areas: json["areas"] == null
            ? []
            : List<SimulationArea>.from(
                json["areas"].map(
                  (x) => SimulationArea.fromJson(x),
                ),
              ),
      );
}

class SimulationArea {
  final String? id;
  final String? name;
  final String? image;
  final String? icon;
  final List<SimulationMaterial>? materials;

  const SimulationArea({
    this.id,
    this.name,
    this.image,
    this.icon,
    this.materials,
  });

  factory SimulationArea.fromJson(Map<String, dynamic> json) =>
      SimulationArea(
        id: json["area_id"]?.toString(),
        name: json["area_name"],
        image: json["area_image"],
        icon: json["area_icon"],
        materials: json["materials"] == null
            ? []
            : List<SimulationMaterial>.from(
                json["materials"].map(
                  (x) => SimulationMaterial.fromJson(x),
                ),
              ),
      );
}

class SimulationMaterial {
  final int? id;
  final String? name;
  final int? selectedQuantity;

  const SimulationMaterial({
    this.id,
    this.name,
    this.selectedQuantity,
  });

  factory SimulationMaterial.fromJson(Map<String, dynamic> json) =>
      SimulationMaterial(
        id: json["id"],
        name: json["name"],
        selectedQuantity: json["selected_quantity"],
      );
}
