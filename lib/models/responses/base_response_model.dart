class BaseResponseModel {
  bool? isSuccess;
  String? message;

  BaseResponseModel({this.isSuccess, this.message});

  BaseResponseModel.fromJson(Map<String, dynamic> json) {
    isSuccess = json['isSuccess'];
    message = json['message'];
  }

}