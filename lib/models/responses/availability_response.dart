import 'base_response_model.dart';
import '../../utills/date_time_utills.dart';

class AvailabilityResponse extends BaseResponseModel {
  final List<Slot> slots;

  AvailabilityResponse({super.status, super.message, required this.slots});

  factory AvailabilityResponse.fromJson(Map<String, dynamic> json) =>
      AvailabilityResponse(
        status: json["is_success"],
        message: json["message"],
        slots: json["slots"] == null
            ? []
            : List<Slot>.from(json["slots"]!.map((x) => Slot.fromJson(x))),
      );
}

class Slot {
  final DateTime startTime;
  final DateTime endTime;
  final bool isBooked;

  Slot({
    required this.startTime,
    required this.endTime,
    required this.isBooked,
  });

  factory Slot.fromJson(Map<String, dynamic> json) => Slot(
    startTime: DateTime.fromMillisecondsSinceEpoch(json["start_time"] * 1000),
    endTime: DateTime.fromMillisecondsSinceEpoch(json["end_time"] * 1000),
    isBooked: json["is_booked"] ?? false,
  );

  String get formattedTime {
    return '${startTime.formattedTime} - ${endTime.formattedTime}';
  }

  String get appointmentDateTime {
    return startTime.formattedWeekdayDateTime;
  }
}
