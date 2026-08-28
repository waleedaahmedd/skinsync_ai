import 'base_response_model.dart';

class PatientPlansResponse extends BaseResponseModel {
  final PatientPlansData? data;

  PatientPlansResponse({super.isSuccess, super.message, this.data});

  factory PatientPlansResponse.fromJson(Map<String, dynamic> json) =>
      PatientPlansResponse(
        isSuccess: json["is_success"],
        message: json["message"],
        data: json["data"] == null
            ? null
            : PatientPlansData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
    "is_success": isSuccess,
    "message": message,
    "data": data?.toJson(),
  };
}

class PatientPlansData {
  final CurrentPlan? currentPlan;
  final List<Plan>? plans;

  PatientPlansData({this.currentPlan, this.plans});

  factory PatientPlansData.fromJson(Map<String, dynamic> json) =>
      PatientPlansData(
        currentPlan: json["current_plan"] == null
            ? null
            : CurrentPlan.fromJson(json["current_plan"]),
        plans: json["plans"] == null
            ? []
            : List<Plan>.from(json["plans"]!.map((x) => Plan.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
    "current_plan": currentPlan?.toJson(),
    "plans": plans == null
        ? []
        : List<dynamic>.from(plans!.map((x) => x.toJson())),
  };
}

class CurrentPlan {
  final int? id;
  final int? userId;
  final int? planId;
  final String? name;
  final int? simulationCount;
  final bool? unlimitedSimulation;
  final int? postsViewCount;
  final bool? unlimitedPostsView;
  final bool? isActive;
  final bool? isDefault;
  final bool? isLifetime;
  final DateTime? startDate;
  final DateTime? endDate;
  final int? durationId;
  final String? durationName;
  final double? price;
  final List<Benefit>? benefits;

  CurrentPlan({
    this.id,
    this.userId,
    this.planId,
    this.name,
    this.simulationCount,
    this.unlimitedSimulation,
    this.postsViewCount,
    this.unlimitedPostsView,
    this.isActive,
    this.isDefault,
    this.isLifetime,
    this.startDate,
    this.endDate,
    this.durationId,
    this.durationName,
    this.price,
    this.benefits,
  });

  factory CurrentPlan.fromJson(Map<String, dynamic> json) => CurrentPlan(
    id: json["id"],
    userId: json["user_id"],
    planId: json["plan_id"],
    name: json["name"],
    simulationCount: json["simulation_count"],
    unlimitedSimulation: json["unlimited_simulation"],
    postsViewCount: json["posts_view_count"],
    unlimitedPostsView: json["unlimited_posts_view"],
    isActive: json["is_active"],
    isDefault: json["is_default"],
    isLifetime: json["is_lifetime"],
    startDate: json["start_date"] == null
        ? null
        : DateTime.parse(json["start_date"]),
    endDate: json["end_date"] == null ? null : DateTime.parse(json["end_date"]),
    durationId: json["duration_id"],
    durationName: json["duration_name"],
    price: json["price"]?.toDouble(),
    benefits: json["benefits"] == null
        ? []
        : List<Benefit>.from(json["benefits"]!.map((x) => Benefit.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "plan_id": planId,
    "name": name,
    "simulation_count": simulationCount,
    "unlimited_simulation": unlimitedSimulation,
    "posts_view_count": postsViewCount,
    "unlimited_posts_view": unlimitedPostsView,
    "is_active": isActive,
    "is_default": isDefault,
    "is_lifetime": isLifetime,
    "start_date": startDate?.toIso8601String(),
    "end_date": endDate?.toIso8601String(),
    "duration_id": durationId,
    "duration_name": durationName,
    "price": price,
    "benefits": benefits == null
        ? []
        : List<dynamic>.from(benefits!.map((x) => x.toJson())),
  };
}

class Benefit {
  final int? id;
  final String? sku;
  final String? title;
  final String? description;

  Benefit({this.id, this.sku, this.title, this.description});

  factory Benefit.fromJson(Map<String, dynamic> json) => Benefit(
    id: json["id"],
    sku: json["sku"],
    title: json["title"],
    description: json["description"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "sku": sku,
    "title": title,
    "description": description,
  };
}

class Plan {
  final int? id;
  final String? name;
  final int? simulationCount;
  final bool? unlimitedSimulation;
  final int? postsViewCount;
  final bool? unlimitedPostsView;
  final dynamic assignedPatients;
  final List<DurationOption>? durationOptions;
  final List<Benefit>? benefits;
  final bool? isActive;
  final bool? isDefault;
  final bool? isLifetime;
  final int? basePrice;

  Plan({
    this.id,
    this.name,
    this.simulationCount,
    this.unlimitedSimulation,
    this.postsViewCount,
    this.unlimitedPostsView,
    this.assignedPatients,
    this.durationOptions,
    this.benefits,
    this.isActive,
    this.isDefault,
    this.isLifetime,
    this.basePrice,
  });

  factory Plan.fromJson(Map<String, dynamic> json) => Plan(
    id: json["id"],
    name: json["name"],
    simulationCount: json["simulation_count"],
    unlimitedSimulation: json["unlimited_simulation"],
    postsViewCount: json["posts_view_count"],
    unlimitedPostsView: json["unlimited_posts_view"],
    assignedPatients: json["assigned_patients"],
    durationOptions: json["duration_options"] == null
        ? []
        : List<DurationOption>.from(
            json["duration_options"]!.map((x) => DurationOption.fromJson(x)),
          ),
    benefits: json["benefits"] == null
        ? []
        : List<Benefit>.from(json["benefits"]!.map((x) => Benefit.fromJson(x))),
    isActive: json["is_active"],
    isDefault: json["is_default"],
    isLifetime: json["is_lifetime"],
    basePrice: json["base_price"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "simulation_count": simulationCount,
    "unlimited_simulation": unlimitedSimulation,
    "posts_view_count": postsViewCount,
    "unlimited_posts_view": unlimitedPostsView,
    "assigned_patients": assignedPatients,
    "duration_options": durationOptions == null
        ? []
        : List<dynamic>.from(durationOptions!.map((x) => x.toJson())),
    "benefits": benefits == null
        ? []
        : List<dynamic>.from(benefits!.map((x) => x.toJson())),
    "is_active": isActive,
    "is_default": isDefault,
    "is_lifetime": isLifetime,
    "base_price": basePrice,
  };
}

class DurationOption {
  final int? id;
  final String? name;
  final double? price;

  DurationOption({this.id, this.name, this.price});

  factory DurationOption.fromJson(Map<String, dynamic> json) => DurationOption(
    id: json["id"],
    name: json["name"],
    price: json["price"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {"id": id, "name": name, "price": price};
}
