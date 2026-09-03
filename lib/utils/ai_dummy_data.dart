import '../models/chat_treatment_request_model.dart';

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
}
