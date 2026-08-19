import 'base_response_model.dart';

class TJOptionsListResponse extends BaseResponseModel {
  final List<TJOption>? data;

  TJOptionsListResponse({super.isSuccess, super.message, this.data});

  factory TJOptionsListResponse.fromJson(Map<String, dynamic> json) =>
      TJOptionsListResponse(
        isSuccess: json["is_success"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<TJOption>.from(
                json["data"]!.map((x) => TJOption.fromJson(x)),
              ),
      );
}

class TJOption {
  final int? id;
  final String? name;
  final String? description;
  final bool? isShared;

  const TJOption({this.id, this.name, this.description, this.isShared});

  factory TJOption.fromJson(Map<String, dynamic> json) => TJOption(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        isShared: json["is_shared"],
      );
}
