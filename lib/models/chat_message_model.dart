import '../utils/enums.dart';
import 'chat_appointment_model.dart';
import 'chat_treatment_request_model.dart';

class ChatMessageModel {
  final String id;
  final String senderName;
  final String time;
  final bool isMe;
  final bool isRead;
  final ChatMessageType messageType;
  final String text;

  // Media attachment fields
  final String? mediaUrl;
  final String? mediaCaption;

  // Document attachment fields
  final String? documentName;
  final String? documentSize;
  final String? documentUrl;

  // Shared Treatment Request Data
  final ChatTreatmentRequestModel? sharedRequestData;

  // Appointment fields
  final ChatAppointmentModel? appointmentData;

  ChatMessageModel({
    required this.id,
    required this.senderName,
    required this.time,
    required this.isMe,
    this.isRead = false,
    this.messageType = ChatMessageType.normal,
    this.text = '',
    this.mediaUrl,
    this.mediaCaption,
    this.documentName,
    this.documentSize,
    this.documentUrl,
    this.sharedRequestData,
    this.appointmentData,
  });
}
