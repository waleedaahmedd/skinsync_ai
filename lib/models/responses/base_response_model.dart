class BaseResponseModel {
  bool? isSuccess;
  String? message;

  // Backward compatibility getter/setter for any existing .status accesses
  bool? get status => isSuccess;
  set status(bool? value) => isSuccess = value;

  BaseResponseModel({this.isSuccess, this.message});

  BaseResponseModel.fromJson(Map<String, dynamic> json) {
    isSuccess = json['is_success'];
    message = json['message'];
  }
}
