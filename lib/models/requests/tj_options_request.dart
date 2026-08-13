import 'save_history_request.dart';

class TjOptionsRequest extends SaveHistoryRequest {
  final int groupId;
  final String name;

  const TjOptionsRequest({
    required this.groupId,
    required this.name,
    super.frontImageBefore,
    super.frontImageAfter,
    super.rightImageBefore,
    super.rightImageAfter,
    super.leftImageBefore,
    super.leftImageAfter,
    required super.treatments,
  });

  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    json['group_id'] = groupId;
    json['name'] = name;
    return json;
  }
}
