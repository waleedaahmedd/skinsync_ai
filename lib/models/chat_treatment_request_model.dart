import 'responses/simulation_history_response.dart';

class ChatTreatmentRequestModel {
  final String text;
  final int id;
  final int userId;
  final int groupId;
  final String name;

  // Patient information
  final String? patientName;
  final String? patientImage;
  final String? patientEmail;

  final String? frontImageBefore;
  final String? frontImageAfter;

  final String? rightImageBefore;
  final String? rightImageAfter;

  final String? leftImageBefore;
  final String? leftImageAfter;
  final List<SimulationTreatment> treatments;

  ChatTreatmentRequestModel({
    required this.text,
    required this.id,
    required this.userId,
    required this.groupId,
    required this.name,
    this.patientName,
    this.patientImage,
    this.patientEmail,
    this.frontImageBefore,
    this.frontImageAfter,
    this.rightImageBefore,
    this.rightImageAfter,
    this.leftImageBefore,
    this.leftImageAfter,
    required this.treatments,
  });

  factory ChatTreatmentRequestModel.fromJson(Map<String, dynamic> json) {
    return ChatTreatmentRequestModel(
      text: json['text'] ?? '',
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      groupId: json['group_id'] ?? 0,
      name: json['name'] ?? '',
      patientName: json['patient_name'],
      patientImage: json['patient_image'],
      patientEmail: json['patient_email'],
      frontImageBefore: json['front_image_before'],
      frontImageAfter: json['front_image_after'],
      rightImageBefore: json['right_image_before'],
      rightImageAfter: json['right_image_after'],
      leftImageBefore: json['left_image_before'],
      leftImageAfter: json['left_image_after'],
      treatments:
          (json['treatments'] as List<dynamic>?)
              ?.map(
                (e) => SimulationTreatment.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
    'text': text,
    'id': id,
    'user_id': userId,
    'group_id': groupId,
    'name': name,
    'patient_name': patientName,
    'patient_image': patientImage,
    'patient_email': patientEmail,
    'front_image_before': frontImageBefore,
    'front_image_after': frontImageAfter,
    'right_image_before': rightImageBefore,
    'right_image_after': rightImageAfter,
    'left_image_before': leftImageBefore,
    'left_image_after': leftImageAfter,
    'treatments': treatments.map((e) => e.toJson()).toList(),
  };

  ChatTreatmentRequestModel copyWith({
    String? text,
    int? id,
    int? userId,
    int? groupId,
    String? name,
    String? patientName,
    String? patientImage,
    String? patientEmail,
    String? frontImageBefore,
    String? frontImageAfter,
    String? rightImageBefore,
    String? rightImageAfter,
    String? leftImageBefore,
    String? leftImageAfter,
    List<SimulationTreatment>? treatments,
  }) {
    return ChatTreatmentRequestModel(
      text: text ?? this.text,
      id: id ?? this.id,
      userId: userId ?? this.userId,
      groupId: groupId ?? this.groupId,
      name: name ?? this.name,
      patientName: patientName ?? this.patientName,
      patientImage: patientImage ?? this.patientImage,
      patientEmail: patientEmail ?? this.patientEmail,
      frontImageBefore: frontImageBefore ?? this.frontImageBefore,
      frontImageAfter: frontImageAfter ?? this.frontImageAfter,
      rightImageBefore: rightImageBefore ?? this.rightImageBefore,
      rightImageAfter: rightImageAfter ?? this.rightImageAfter,
      leftImageBefore: leftImageBefore ?? this.leftImageBefore,
      leftImageAfter: leftImageAfter ?? this.leftImageAfter,
      treatments: treatments ?? this.treatments,
    );
  }
}
