import '../explore_models.dart';
import 'base_response_model.dart';

class ReelsListResponse extends BaseResponseModel {
  final int page;
  final int limit;
  final int totalPages;
  final List<ReelModel>? data;

   ReelsListResponse({
    required super.isSuccess,
    required super.message,
    required this.page,
    required this.limit,
    required this.totalPages,
    this.data,
  });

  factory ReelsListResponse.fromJson(Map<String, dynamic> json) {
    return ReelsListResponse(
      isSuccess: (json['is_success'] as bool?) ?? false,
      message: json['message'] ?? '',
      page: json['page'] as int? ?? 0,
      limit: json['limit'] as int? ?? 0,
      totalPages: json['total_pages'] as int? ?? json['totalPages'] as int? ?? 1,
      data: json['data'] == null || json['data']['items'] == null
          ? []
          : (json['data']['items'] as List)
              .map((e) => ReelModel.fromJson(e as Map<String, dynamic>))
              .toList(),
    );
  }
}
