import 'auth_response.dart';
import 'base_response_model.dart';

class SharedClinicResponse extends BaseResponseModel {
  final List<RequestClinicTreatmentModel>? data;
  final int? page;
  final int? total;
  final int? totalPages;

  SharedClinicResponse({
    super.isSuccess,
    super.message,
    this.data,
    this.page,
    this.total,
    this.totalPages,
  });

  factory SharedClinicResponse.fromJson(Map<String, dynamic> json) {
    return SharedClinicResponse(
      isSuccess: json["is_success"],
      message: json["message"],
      data: json["data"] == null
          ? []
          : List<RequestClinicTreatmentModel>.from(
              json["data"].map(
                (x) => RequestClinicTreatmentModel.fromJson(x),
              ),
            ),
      page: json["page"],
      total: json["total"],
      totalPages: json["total_pages"],
    );
  }
}

