import 'base_response_model.dart';
import 'simulation_history_response.dart';

class TJOptionSimulationsResponse extends BaseResponseModel {
  final SimulationData? data;

  TJOptionSimulationsResponse({
    super.isSuccess,
    super.message,
    this.data,
  });

  factory TJOptionSimulationsResponse.fromJson(
    Map<String, dynamic> json,
  ) =>
      TJOptionSimulationsResponse(
        isSuccess: json["is_success"],
        message: json["message"],
        data: json["data"] == null
            ? null
            : SimulationData.fromJson(json["data"]),
      );
}