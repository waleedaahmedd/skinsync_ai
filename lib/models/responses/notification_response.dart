import 'dart:convert';
import 'base_response_model.dart';

class NotificationResponse extends BaseResponseModel {
    final List<NotificationData>? data;
    final int? limit;
    final int? page;
    final int? totalPages;

    NotificationResponse({
        this.data,
        super.isSuccess,
        this.limit,
        super.message,
        this.page,
        this.totalPages,
    });

    factory NotificationResponse.fromRawJson(String str) => NotificationResponse.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory NotificationResponse.fromJson(Map<String, dynamic> json) => NotificationResponse(
        data: json["data"] == null ? [] : List<NotificationData>.from(json["data"]!.map((x) => NotificationData.fromJson(x))),
        isSuccess: json["is_success"],
        limit: json["limit"],
        message: json["message"],
        page: json["page"],
        totalPages: json["total_pages"],
    );

    Map<String, dynamic> toJson() => {
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
        "is_success": isSuccess,
        "limit": limit,
        "message": message,
        "page": page,
        "total_pages": totalPages,
    };
}

class NotificationData {
    final String? body;
    final DateTime? createdAt;
    final int? id;
    final String? status;
    final String? title;

    NotificationData({
        this.body,
        this.createdAt,
        this.id,
        this.status,
        this.title,
    });

    factory NotificationData.fromRawJson(String str) => NotificationData.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory NotificationData.fromJson(Map<String, dynamic> json) => NotificationData(
        body: json["body"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        id: json["id"],
        status: json["status"],
        title: json["title"],
    );

    Map<String, dynamic> toJson() => {
        "body": body,
        "created_at": createdAt?.toIso8601String(),
        "id": id,
        "status": status,
        "title": title,
    };
}
