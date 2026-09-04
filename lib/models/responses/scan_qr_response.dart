import 'base_response_model.dart';

class ScanQrResponse extends BaseResponseModel {
  
  final ScanQrData? data;

  ScanQrResponse({
    super.isSuccess,
    super.message,
    this.data,
  });

  factory ScanQrResponse.fromJson(Map<String, dynamic> json) => ScanQrResponse(
        isSuccess: json["is_success"],
        message: json["message"],
        data: json["data"] == null
            ? null
            : ScanQrData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "is_success": isSuccess,
        "message": message,
        "data": data?.toJson(),
      };
}

class ScanQrData {
  final int? appointmentId;
  final String? appointmentKey;
  final String? status;

  ScanQrData({
    this.appointmentId,
    this.appointmentKey,
    this.status,
  });

  factory ScanQrData.fromJson(Map<String, dynamic> json) => ScanQrData(
        appointmentId: json["appointment_id"],
        appointmentKey: json["appointment_key"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "appointment_id": appointmentId,
        "appointment_key": appointmentKey,
        "status": status,
      };
}