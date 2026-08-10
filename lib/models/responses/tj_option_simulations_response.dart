import 'base_response_model.dart';
import 'simulation_history_response.dart';

class TJOptionSimulationsResponse extends BaseResponseModel {
  final List<SimulationData>? data;

  TJOptionSimulationsResponse({super.isSuccess, super.message, this.data});

  factory TJOptionSimulationsResponse.fromJson(Map<String, dynamic> json) =>
      TJOptionSimulationsResponse(
        isSuccess: json["is_success"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<SimulationData>.from(
                json["data"]!.map((x) => SimulationData.fromJson(x)),
              ),
      );
}
