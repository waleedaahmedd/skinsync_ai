import 'base_response_model.dart';

class SubscriptionResponse extends BaseResponseModel {
  final SubscriptionData? data;

  SubscriptionResponse({super.isSuccess, super.message, this.data});

  factory SubscriptionResponse.fromJson(Map<String, dynamic> json) =>
      SubscriptionResponse(
        isSuccess: json["is_success"],
        message: json["message"],
        data: json["data"] == null
            ? null
            : SubscriptionData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
    "is_success": isSuccess,
    "message": message,
    "data": data?.toJson(),
  };
}

class SubscriptionData {
  final String? cancelUrl;
  final String? stripeUrl;
  final String? successUrl;

  SubscriptionData({this.cancelUrl, this.stripeUrl, this.successUrl});

  factory SubscriptionData.fromJson(Map<String, dynamic> json) =>
      SubscriptionData(
        cancelUrl: json["cancel_url"],
        stripeUrl: json["stripe_url"],
        successUrl: json["success_url"],
      );

  Map<String, dynamic> toJson() => {
    "cancel_url": cancelUrl,
    "stripe_url": stripeUrl,
    "success_url": successUrl,
  };
}
