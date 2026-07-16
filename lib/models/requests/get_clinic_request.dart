class GetClinicRequest {
  final int page;
  final String? search;
  final int limit;
  final int? doctorId;
  final List<GetClinicTreatmentRequest> treatments;

  const GetClinicRequest({
    this.page = 1,
    this.search,
    this.limit = 10,
    this.doctorId,
    required this.treatments,
  });

  Map<String, dynamic> toJson() {
    return {
      'page': page,
      'search': search,
      'limit': limit,
      'doctor_id': doctorId,
      'treatments': treatments.map((e) => e.toJson()).toList(),
    };
  }
}

class GetClinicTreatmentRequest {
  final int treatmentId;
  final List<int> areaIds;

  const GetClinicTreatmentRequest({
    required this.treatmentId,
    required this.areaIds,
  });

  Map<String, dynamic> toJson() {
    return {'treatment_id': treatmentId, 'area_ids': areaIds};
  }
}
