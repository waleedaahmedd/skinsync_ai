import 'base_response_model.dart';
import 'treatment_category_list_response.dart';

class TreatmentDetailResponse extends BaseResponseModel {
  TreatmentDetailModel? data;

  TreatmentDetailResponse({super.isSuccess, super.message, this.data});

  TreatmentDetailResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['is_success'];
    message = json['message'];
    data = json['data'] != null ? TreatmentDetailModel.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['is_success'] = isSuccess;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class TreatmentDetailModel {
  int? id;
  int? currentStep;
  String? status;
  String? name;
  List<int>? selectedCategoryIds;
  List<TreatmentCategoryModel>? selectedCategories;
  String? globalSku;
  String? patientDisplayName;
  String? image;
  String? icon;
  String? shortDescription;
  String? description;
  List<int>? selectedAreaIds;
  List<SelectedArea>? selectedAreas;
  List<ProductUsage>? productUsages;
  int? baseDuration;
  int? prepTime;
  int? cleanupTime;
  List<ProductDuration>? productDurations;
  bool? allowClinicOverride;
  bool? allowProviderOverride;
  bool? onlineBookable;
  bool? manualApprovalRequired;
  int? minimumBookingNotice;
  int? maximumDaysInAdvance;
  num? basePrice;
  List<UnitPriceOverride>? unitPriceOverrides;
  ClinicalProtocolPdf? clinicalProtocolPdf;
  String? preTreatmentInstructions;
  List<Attachment>? preTreatmentAttachments;
  String? postTreatmentInstructions;
  List<Attachment>? postTreatmentAttachments;
  bool? requirePostTreatmentPhotos;
  int? requiredPostTreatmentPhotoCount;
  List<NotificationModel>? preNotifications;
  List<NotificationModel>? postNotifications;
  String? downtimeLevel;
  int? downtimeDays;
  List<String>? allowedRoles;
  int? totalSessions;
  List<Session>? sessions;
  ConsentForm? preTreatmentConsentForm;
  bool? enableByDefault;
  bool? useInAiSimulator;
  String? createdAt;
  String? updatedAt;

  TreatmentDetailModel({
    this.id,
    this.currentStep,
    this.status,
    this.name,
    this.selectedCategoryIds,
    this.selectedCategories,
    this.globalSku,
    this.patientDisplayName,
    this.image,
    this.icon,
    this.shortDescription,
    this.description,
    this.selectedAreaIds,
    this.selectedAreas,
    this.productUsages,
    this.baseDuration,
    this.prepTime,
    this.cleanupTime,
    this.productDurations,
    this.allowClinicOverride,
    this.allowProviderOverride,
    this.onlineBookable,
    this.manualApprovalRequired,
    this.minimumBookingNotice,
    this.maximumDaysInAdvance,
    this.basePrice,
    this.unitPriceOverrides,
    this.clinicalProtocolPdf,
    this.preTreatmentInstructions,
    this.preTreatmentAttachments,
    this.postTreatmentInstructions,
    this.postTreatmentAttachments,
    this.requirePostTreatmentPhotos,
    this.requiredPostTreatmentPhotoCount,
    this.preNotifications,
    this.postNotifications,
    this.downtimeLevel,
    this.downtimeDays,
    this.allowedRoles,
    this.totalSessions,
    this.sessions,
    this.preTreatmentConsentForm,
    this.enableByDefault,
    this.useInAiSimulator,
    this.createdAt,
    this.updatedAt,
  });

  TreatmentDetailModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    currentStep = json['current_step'];
    status = json['status'];
    selectedCategoryIds = json['selected_category_ids'] != null
        ? List<int>.from(json['selected_category_ids'])
        : null;
    if (json['selected_categories'] != null) {
      selectedCategories = <TreatmentCategoryModel>[];
      json['selected_categories'].forEach((v) {
        selectedCategories!.add(TreatmentCategoryModel.fromJson(v));
      });
    }
    globalSku = json['global_sku'];
    patientDisplayName = json['patient_display_name'];
    image = json['image'];
    icon = json['icon'];
    shortDescription = json['short_description'];
    description = json['description'];
    selectedAreaIds = json['selected_area_ids'] != null
        ? List<int>.from(json['selected_area_ids'])
        : null;
    if (json['selected_areas'] != null) {
      selectedAreas = <SelectedArea>[];
      json['selected_areas'].forEach((v) {
        selectedAreas!.add(SelectedArea.fromJson(v));
      });
    }
    if (json['product_usages'] != null) {
      productUsages = <ProductUsage>[];
      json['product_usages'].forEach((v) {
        productUsages!.add(ProductUsage.fromJson(v));
      });
    }
    baseDuration = json['base_duration'];
    prepTime = json['prep_time'];
    cleanupTime = json['cleanup_time'];
    if (json['product_durations'] != null) {
      productDurations = <ProductDuration>[];
      json['product_durations'].forEach((v) {
        productDurations!.add(ProductDuration.fromJson(v));
      });
    }
    allowClinicOverride = json['allow_clinic_override'];
    allowProviderOverride = json['allow_provider_override'];
    onlineBookable = json['online_bookable'];
    manualApprovalRequired = json['manual_approval_required'];
    minimumBookingNotice = json['minimum_booking_notice'];
    maximumDaysInAdvance = json['maximum_days_in_advance'];
    basePrice = json['base_price'];
    if (json['unit_price_overrides'] != null) {
      unitPriceOverrides = <UnitPriceOverride>[];
      json['unit_price_overrides'].forEach((v) {
        unitPriceOverrides!.add(UnitPriceOverride.fromJson(v));
      });
    }
    clinicalProtocolPdf = json['clinical_protocol_pdf'] != null
        ? ClinicalProtocolPdf.fromJson(json['clinical_protocol_pdf'])
        : null;
    preTreatmentInstructions = json['pre_treatment_instructions'];
    if (json['pre_treatment_attachments'] != null) {
      preTreatmentAttachments = <Attachment>[];
      json['pre_treatment_attachments'].forEach((v) {
        preTreatmentAttachments!.add(Attachment.fromJson(v));
      });
    }
    postTreatmentInstructions = json['post_treatment_instructions'];
    if (json['post_treatment_attachments'] != null) {
      postTreatmentAttachments = <Attachment>[];
      json['post_treatment_attachments'].forEach((v) {
        postTreatmentAttachments!.add(Attachment.fromJson(v));
      });
    }
    requirePostTreatmentPhotos = json['require_post_treatment_photos'];
    requiredPostTreatmentPhotoCount = json['required_post_treatment_photo_count'];
    if (json['pre_notifications'] != null) {
      preNotifications = <NotificationModel>[];
      json['pre_notifications'].forEach((v) {
        preNotifications!.add(NotificationModel.fromJson(v));
      });
    }
    if (json['post_notifications'] != null) {
      postNotifications = <NotificationModel>[];
      json['post_notifications'].forEach((v) {
        postNotifications!.add(NotificationModel.fromJson(v));
      });
    }
    downtimeLevel = json['downtime_level'];
    downtimeDays = json['downtime_days'];
    allowedRoles = json['allowed_roles'] != null
        ? List<String>.from(json['allowed_roles'])
        : null;
    totalSessions = json['total_sessions'];
    if (json['sessions'] != null) {
      sessions = <Session>[];
      json['sessions'].forEach((v) {
        sessions!.add(Session.fromJson(v));
      });
    }
    preTreatmentConsentForm = json['pre_treatment_consent_form'] != null
        ? ConsentForm.fromJson(json['pre_treatment_consent_form'])
        : null;
    enableByDefault = json['enable_by_default'];
    useInAiSimulator = json['use_in_ai_simulator'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['current_step'] = currentStep;
    data['status'] = status;
    if (selectedCategoryIds != null) {
      data['selected_category_ids'] = selectedCategoryIds;
    }
    if (selectedCategories != null) {
      data['selected_categories'] = selectedCategories!.map((v) => v.toJson()).toList();
    }
    data['global_sku'] = globalSku;
    data['patient_display_name'] = patientDisplayName;
    data['image'] = image;
    data['icon'] = icon;
    data['short_description'] = shortDescription;
    data['description'] = description;
    if (selectedAreaIds != null) {
      data['selected_area_ids'] = selectedAreaIds;
    }
    if (selectedAreas != null) {
      data['selected_areas'] = selectedAreas!.map((v) => v.toJson()).toList();
    }
    if (productUsages != null) {
      data['product_usages'] = productUsages!.map((v) => v.toJson()).toList();
    }
    data['base_duration'] = baseDuration;
    data['prep_time'] = prepTime;
    data['cleanup_time'] = cleanupTime;
    if (productDurations != null) {
      data['product_durations'] = productDurations!.map((v) => v.toJson()).toList();
    }
    data['allow_clinic_override'] = allowClinicOverride;
    data['allow_provider_override'] = allowProviderOverride;
    data['online_bookable'] = onlineBookable;
    data['manual_approval_required'] = manualApprovalRequired;
    data['minimum_booking_notice'] = minimumBookingNotice;
    data['maximum_days_in_advance'] = maximumDaysInAdvance;
    data['base_price'] = basePrice;
    if (unitPriceOverrides != null) {
      data['unit_price_overrides'] = unitPriceOverrides!.map((v) => v.toJson()).toList();
    }
    if (clinicalProtocolPdf != null) {
      data['clinical_protocol_pdf'] = clinicalProtocolPdf!.toJson();
    }
    data['pre_treatment_instructions'] = preTreatmentInstructions;
    if (preTreatmentAttachments != null) {
      data['pre_treatment_attachments'] = preTreatmentAttachments!.map((v) => v.toJson()).toList();
    }
    data['post_treatment_instructions'] = postTreatmentInstructions;
    if (postTreatmentAttachments != null) {
      data['post_treatment_attachments'] = postTreatmentAttachments!.map((v) => v.toJson()).toList();
    }
    data['require_post_treatment_photos'] = requirePostTreatmentPhotos;
    data['required_post_treatment_photo_count'] = requiredPostTreatmentPhotoCount;
    if (preNotifications != null) {
      data['pre_notifications'] = preNotifications!.map((v) => v.toJson()).toList();
    }
    if (postNotifications != null) {
      data['post_notifications'] = postNotifications!.map((v) => v.toJson()).toList();
    }
    data['downtime_level'] = downtimeLevel;
    data['downtime_days'] = downtimeDays;
    if (allowedRoles != null) {
      data['allowed_roles'] = allowedRoles;
    }
    data['total_sessions'] = totalSessions;
    if (sessions != null) {
      data['sessions'] = sessions!.map((v) => v.toJson()).toList();
    }
    if (preTreatmentConsentForm != null) {
      data['pre_treatment_consent_form'] = preTreatmentConsentForm!.toJson();
    }
    data['enable_by_default'] = enableByDefault;
    data['use_in_ai_simulator'] = useInAiSimulator;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class SelectedArea {
  int? id;
  String? name;
  String? globalSku;
  String? icon;
  String? image;
  String? status;

  SelectedArea({
    this.id,
    this.name,
    this.globalSku,
    this.icon,
    this.image,
    this.status,
  });

  SelectedArea.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    globalSku = json['global_sku'];
    icon = json['icon'];
    image = json['image'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['global_sku'] = globalSku;
    data['icon'] = icon;
    data['image'] = image;
    data['status'] = status;
    return data;
  }
}

class ProductUsage {
  int? productId;
  String? productName;
  String? productImage;
  String? productSku;
  String? deductionTiming;
  bool? allowSubstitution;
  String? notes;
  List<SubAreaConsumption>? subAreaConsumptions;

  ProductUsage({
    this.productId,
    this.productName,
    this.productImage,
    this.productSku,
    this.deductionTiming,
    this.allowSubstitution,
    this.notes,
    this.subAreaConsumptions,
  });

  ProductUsage.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    productName = json['product_name'];
    productImage = json['product_image'];
    productSku = json['product_sku'];
    deductionTiming = json['deduction_timing'];
    allowSubstitution = json['allow_substitution'];
    notes = json['notes'];
    if (json['sub_area_consumptions'] != null) {
      subAreaConsumptions = <SubAreaConsumption>[];
      json['sub_area_consumptions'].forEach((v) {
        subAreaConsumptions!.add(SubAreaConsumption.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['product_id'] = productId;
    data['product_name'] = productName;
    data['product_image'] = productImage;
    data['product_sku'] = productSku;
    data['deduction_timing'] = deductionTiming;
    data['allow_substitution'] = allowSubstitution;
    data['notes'] = notes;
    if (subAreaConsumptions != null) {
      data['sub_area_consumptions'] = subAreaConsumptions!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SubAreaConsumption {
  int? subAreaId;
  String? subAreaName;
  num? minQuantity;
  num? maxQuantity;

  SubAreaConsumption({
    this.subAreaId,
    this.subAreaName,
    this.minQuantity,
    this.maxQuantity,
  });

  SubAreaConsumption.fromJson(Map<String, dynamic> json) {
    subAreaId = json['sub_area_id'];
    subAreaName = json['sub_area_name'];
    minQuantity = json['min_quantity'];
    maxQuantity = json['max_quantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sub_area_id'] = subAreaId;
    data['sub_area_name'] = subAreaName;
    data['min_quantity'] = minQuantity;
    data['max_quantity'] = maxQuantity;
    return data;
  }
}

class ProductDuration {
  int? productId;
  String? productName;
  num? perUnitDuration;

  ProductDuration({this.productId, this.productName, this.perUnitDuration});

  ProductDuration.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    productName = json['product_name'];
    perUnitDuration = json['per_unit_duration'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['product_id'] = productId;
    data['product_name'] = productName;
    data['per_unit_duration'] = perUnitDuration;
    return data;
  }
}

class UnitPriceOverride {
  int? productId;
  String? productName;
  num? pricePerUnit;

  UnitPriceOverride({this.productId, this.productName, this.pricePerUnit});

  UnitPriceOverride.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    productName = json['product_name'];
    pricePerUnit = json['price_per_unit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['product_id'] = productId;
    data['product_name'] = productName;
    data['price_per_unit'] = pricePerUnit;
    return data;
  }
}

class ClinicalProtocolPdf {
  String? name;
  String? url;

  ClinicalProtocolPdf({this.name, this.url});

  ClinicalProtocolPdf.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['url'] = url;
    return data;
  }
}

class Attachment {
  String? name;
  String? url;
  String? type;

  Attachment({this.name, this.url, this.type});

  Attachment.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    url = json['url'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['url'] = url;
    data['type'] = type;
    return data;
  }
}

class NotificationModel {
  String? title;
  String? message;
  int? timing;
  String? timingUnit;
  String? type;

  NotificationModel({
    this.title,
    this.message,
    this.timing,
    this.timingUnit,
    this.type,
  });

  NotificationModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    message = json['message'];
    timing = json['timing'];
    timingUnit = json['timing_unit'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['message'] = message;
    data['timing'] = timing;
    data['timing_unit'] = timingUnit;
    data['type'] = type;
    return data;
  }
}

class Session {
  int? sessionNumber;
  List<FollowUp>? followUps;

  Session({this.sessionNumber, this.followUps});

  Session.fromJson(Map<String, dynamic> json) {
    sessionNumber = json['session_number'];
    if (json['follow_ups'] != null) {
      followUps = <FollowUp>[];
      json['follow_ups'].forEach((v) {
        followUps!.add(FollowUp.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['session_number'] = sessionNumber;
    if (followUps != null) {
      data['follow_ups'] = followUps!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FollowUp {
  String? type;
  int? durationValue;
  String? durationUnit;
  int? intervalValue;
  String? intervalUnit;
  bool? isImageRequired;
  String? notes;

  FollowUp({
    this.type,
    this.durationValue,
    this.durationUnit,
    this.intervalValue,
    this.intervalUnit,
    this.isImageRequired,
    this.notes,
  });

  FollowUp.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    durationValue = json['duration_value'];
    durationUnit = json['duration_unit'];
    intervalValue = json['interval_value'];
    intervalUnit = json['interval_unit'];
    isImageRequired = json['is_image_required'];
    notes = json['notes'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['duration_value'] = durationValue;
    data['duration_unit'] = durationUnit;
    data['interval_value'] = intervalValue;
    data['interval_unit'] = intervalUnit;
    data['is_image_required'] = isImageRequired;
    data['notes'] = notes;
    return data;
  }
}

class ConsentForm {
  String? name;
  String? url;

  ConsentForm({this.name, this.url});

  ConsentForm.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['url'] = url;
    return data;
  }
}
