import '../models/chat_appointment_model.dart';
import '../models/chat_message_model.dart';
import '../models/chat_treatment_request_model.dart';
import 'enums.dart';

class AiDummyData {
  static final List<ChatTreatmentRequestModel> dummyTreatmentRequests = [
    ChatTreatmentRequestModel(
      id: 1,
      userId: 101,
      groupId: 201,
      name: 'Botox & Facial Contouring Assessment',
      patientName: 'Jane Cooper',
      patientEmail: 'jane.cooper@example.com',
      frontImageBefore:
          'https://images.unsplash.com/photo-1570172619644-dfd03ed5d881?w=800&q=80',
      frontImageAfter:
          'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=800&q=80',
      createdAt: '2026-08-28 10:25:00',
      treatments: [
        ChatTreatmentData(
          treatmentId: 10,
          treatmentName: 'Botox Cosmetic',
          description: 'Forehead wrinkle reduction and glabella smoothing',
          areas: [
            ChatTreatmentAreaData(
              areaId: 1,
              areaName: 'Forehead Lines',
              materials: [
                ChatTreatmentMaterialData(
                  id: 101,
                  name: 'Botox Units',
                  selectedQuantity: 20,
                ),
              ],
            ),
            ChatTreatmentAreaData(
              areaId: 2,
              areaName: 'Crow\'s Feet',
              materials: [
                ChatTreatmentMaterialData(
                  id: 102,
                  name: 'Botox Units',
                  selectedQuantity: 12,
                ),
              ],
            ),
          ],
        ),
      ],
    ),
    ChatTreatmentRequestModel(
      id: 2,
      userId: 102,
      groupId: 202,
      name: 'Juvederm Cheek Volumizer Plan',
      patientName: 'Jane Cooper',
      patientEmail: 'jane.cooper@example.com',
      createdAt: '2026-08-25 14:10:00',
      treatments: [
        ChatTreatmentData(
          treatmentId: 12,
          treatmentName: 'Juvederm Voluma',
          description: 'Cheek volume restoration and contouring',
          areas: [
            ChatTreatmentAreaData(
              areaId: 3,
              areaName: 'Cheekbones',
              materials: [
                ChatTreatmentMaterialData(
                  id: 103,
                  name: 'Juvederm Syringes',
                  selectedQuantity: 2,
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  ];

  static final List<ChatMessageModel> chatDummyMessages = [
    ChatMessageModel(
      id: '1',
      senderName: 'SkinSync Clinic',
      time: '10:15 AM',
      isMe: false,
      messageType: ChatMessageType.normal,
      text: 'Hello! Thank you for reaching out to SkinSync Clinic. How can we help you today?',
    ),
    ChatMessageModel(
      id: '2',
      senderName: 'You',
      time: '10:18 AM',
      isMe: true,
      isRead: true,
      messageType: ChatMessageType.normal,
      text:
          'Hi Doctor! I reviewed my simulation results for Option 1 and have a few questions.',
    ),
    ChatMessageModel(
      id: '3',
      senderName: 'SkinSync Clinic',
      time: '10:20 AM',
      isMe: false,
      messageType: ChatMessageType.media,
      text: 'Here is the recommended treatment area overview based on your face scan.',
      mediaUrl:
          'https://images.unsplash.com/photo-1570172619644-dfd03ed5d881?w=800&q=80',
      mediaCaption: 'SkinSync Face Scan Analysis',
    ),
    ChatMessageModel(
      id: '4',
      senderName: 'You',
      time: '10:22 AM',
      isMe: true,
      isRead: true,
      messageType: ChatMessageType.document,
      text: 'I uploaded my recent medical history document for your reference.',
      documentName: 'Patient_Medical_History.pdf',
      documentSize: '1.2 MB',
    ),
    ChatMessageModel(
      id: '5',
      senderName: 'SkinSync Clinic',
      time: '10:25 AM',
      isMe: false,
      messageType: ChatMessageType.sharedRequest,
      text: 'We have updated your shared treatment request plan.',
      sharedRequestData: dummyTreatmentRequests.isNotEmpty
          ? dummyTreatmentRequests[0]
          : null,
    ),
    ChatMessageModel(
      id: '6',
      senderName: 'You',
      time: '10:28 AM',
      isMe: true,
      isRead: true,
      messageType: ChatMessageType.appointment,
      text: 'I booked the follow-up appointment below.',
      appointmentData: ChatAppointmentData(
        appointmentId: 405,
        patientName: 'Jane Cooper',
        serviceName: 'Botox Follow-up Session',
        date: 'Sep 05, 2026',
        time: '10:00 AM',
        practitionerName: 'Dr. Sarah Johnson',
        status: 'Confirmed',
      ),
    ),
  ];
}
