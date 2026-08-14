import 'base_response_model.dart';

class GroupsListResponse extends BaseResponseModel {
  final List<TreatmentJourneyGroup>? data;

  GroupsListResponse({super.isSuccess, super.message, this.data});

  factory GroupsListResponse.fromJson(Map<String, dynamic> json) =>
      GroupsListResponse(
        isSuccess: json["is_success"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<TreatmentJourneyGroup>.from(
                json["data"]!.map((x) => TreatmentJourneyGroup.fromJson(x)),
              ),
      );
}

class TreatmentJourneyGroup {
  final int? id;
  final String? name;
  final DateTime? createdAt;
  final int? optionsCount;

  const TreatmentJourneyGroup({
    this.id,
    this.name,
    this.createdAt,
    this.optionsCount,
  });

  factory TreatmentJourneyGroup.fromJson(Map<String, dynamic> json) =>
      TreatmentJourneyGroup(
        id: json["id"],
        name: json["name"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]).toLocal(),
        optionsCount: json["options_count"],
      );
}
