import 'base_response_model.dart';

class PaymentOptionsResponse extends BaseResponseModel {
  final List<PaymentOption>? data;

  PaymentOptionsResponse({this.data, super.status, super.message});

  factory PaymentOptionsResponse.fromJson(Map<String, dynamic> json) =>
      PaymentOptionsResponse(
        data: json["data"] == null
            ? []
            : List<PaymentOption>.from(
                json["data"]!.map((x) => PaymentOption.fromJson(x)),
              ),
        status: json["is_success"],
        message: json["message"],
      );
}

class PaymentOption {
  final int? id;
  final String? title;
  final String? description;
  final int? amount;

  PaymentOption({this.title, this.description, this.amount, this.id});

  factory PaymentOption.fromJson(Map<String, dynamic> json) => PaymentOption(
    id: json["id"],
    title: json["title"],
    description: json["description"],
    amount: json["amount"],
  );
}
