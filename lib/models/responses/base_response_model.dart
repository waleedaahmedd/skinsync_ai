class BaseResponseModel {
  bool? status;
  String? message;

  BaseResponseModel({this.status, this.message});

  BaseResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
  }
}
