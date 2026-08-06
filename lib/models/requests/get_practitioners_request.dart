class GetPractitionersRequest {
  final int page;
  final int limit;
  final int? date;
  final int? startTime;
  final int? endTime;
  final int? clinicId;
  final bool? isVirtual;
  final String? practitionerType;
  final String? search;
  final List<PractitionerTreatmentRequest>? treatments;

  GetPractitionersRequest({
    this.page = 1,
    this.limit = 10,
    this.date,
    this.startTime,
    this.endTime,
    this.clinicId,
    this.isVirtual,
    this.practitionerType = "doctor",
    this.search,
    this.treatments,
  });

  Map<String, dynamic> toJson() {
    return {
      "page": page,
      "limit": limit,
      "date": date,
      "start_time": startTime,
      "end_time": endTime,
      "clinic_id": clinicId,
      "is_virtual": isVirtual,
      "practitioner_type": practitionerType,
      "search": search,
      "treatments": treatments?.map((x) => x.toJson()).toList(),
    };
  }
}

class PractitionerTreatmentRequest {
  final int? treatmentId;
  final List<int>? areaIds;

  PractitionerTreatmentRequest({this.treatmentId, this.areaIds});

  Map<String, dynamic> toJson() {
    return {
      "treatment_id": treatmentId,
      "area_ids": areaIds,
    };
  }
}
