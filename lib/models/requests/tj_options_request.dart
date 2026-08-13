
import 'save_history_request.dart';

class TjOptionsRequest {
    final int? groupId;
    final String? name;
    final String? frontImageBefore;
    final String? frontImageAfter;
    final String? rightImageBefore;
    final String? rightImageAfter;
    final String? leftImageBefore;
    final String? leftImageAfter;
    final List<HistoryTreatmentRequest>? treatments;

    TjOptionsRequest({
        this.groupId,
        this.name,
        this.frontImageBefore,
        this.frontImageAfter,
        this.rightImageBefore,
        this.rightImageAfter,
        this.leftImageBefore,
        this.leftImageAfter,
        this.treatments,
    });

   

    Map<String, dynamic> toJson() => {
        "group_id": groupId,
        "name": name,
        "front_image_before": frontImageBefore,
        "front_image_after": frontImageAfter,
        "right_image_before": rightImageBefore,
        "right_image_after": rightImageAfter,
        "left_image_before": leftImageBefore,
        "left_image_after": leftImageAfter,
        "treatments": treatments == null ? [] : List<dynamic>.from(treatments!.map((x) => x.toJson())),
    };
}

