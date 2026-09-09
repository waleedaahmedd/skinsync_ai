import '../../utils/enums.dart';
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
}

class PatientPlansData {
  final CurrentPlan? currentPlan;
  final List<Plan>? plans;

  PatientPlansData({this.currentPlan, this. plans});

  factory PatientPlansData.fromJson(Map<String, dynamic> json) =>
      PatientPlansData(
        currentPlan: json["current_plan"] == null
            ? null
            : CurrentPlan.fromJson(json["current_plan"]),
        plans: json["plans"] == null
            ? []
            : List<Plan>.from(json["plans"]!.map((x) => Plan.fromJson(x))),
      );
}

class CurrentPlan {
  final String? id;
  final int? userId;
  final String? planId;
  final String? name;
  final int? simulationCount;
  final bool? unlimitedSimulation;
  final int? postsViewCount;
  final bool? unlimitedPostsView;
  final int? usedSimulationCount;
  final int? usedPostCount;
  final bool? isActive;
  final bool? isDefault;
  final bool? isLifetime;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? durationId;
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
    this.usedSimulationCount,
    this.usedPostCount,
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

  factory CurrentPlan.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> sub = json["subscription"] ?? {};
    final Map<String, dynamic> plan = json["plan"] ?? {};

    return CurrentPlan(
      id: sub["id"] ?? plan["id"] ?? json["id"],
      userId: sub["user_id"] ?? plan["user_id"] ?? json["user_id"],
      planId: sub["plan_id"] ?? plan["plan_id"] ?? json["plan_id"],
      name: sub["name"] ?? plan["name"] ?? json["name"],
      simulationCount:
          sub["simulation_count"] ??
          plan["simulation_count"] ??
          json["simulation_count"],
      unlimitedSimulation:
          sub["unlimited_simulation"] ??
          plan["unlimited_simulation"] ??
          json["unlimited_simulation"],
      postsViewCount:
          sub["posts_view_count"] ??
          plan["posts_view_count"] ??
          json["posts_view_count"],
      unlimitedPostsView:
          sub["unlimited_posts_view"] ??
          plan["unlimited_posts_view"] ??
          json["unlimited_posts_view"],
      usedSimulationCount:
          sub["used_simulation_count"] ??
          plan["used_simulation_count"] ??
          json["used_simulation_count"],
      usedPostCount:
          sub["used_post_count"] ??
          plan["used_post_count"] ??
          json["used_post_count"],
      isActive: sub["is_active"] ?? plan["is_active"] ?? json["is_active"],
      isDefault: sub["is_default"] ?? plan["is_default"] ?? json["is_default"],
      isLifetime:
          sub["is_lifetime"] ?? plan["is_lifetime"] ?? json["is_lifetime"],
      startDate: (sub["start_date"] ?? plan["start_date"] ?? json["start_date"]) ==
              null
          ? null
          : DateTime.parse(
            sub["start_date"] ?? plan["start_date"] ?? json["start_date"],
          ),
      endDate: (sub["end_date"] ?? plan["end_date"] ?? json["end_date"]) == null
          ? null
          : DateTime.parse(
            sub["end_date"] ?? plan["end_date"] ?? json["end_date"],
          ),
      durationId: sub["duration_id"] ?? plan["duration_id"] ?? json["duration_id"],
      durationName:
          sub["duration_name"] ?? plan["duration_name"] ?? json["duration_name"],
      price: (sub["price"] ?? plan["price"] ?? json["price"])?.toDouble(),
      benefits:
          json["benefits"] == null
              ? []
              : List<Benefit>.from(
                json["benefits"]!.map((x) => Benefit.fromJson(x)),
              ),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "plan_id": planId,
    "name": name,
    "simulation_count": simulationCount,
    "unlimited_simulation": unlimitedSimulation,
    "posts_view_count": postsViewCount,
    "unlimited_posts_view": unlimitedPostsView,
    "used_simulation_count": usedSimulationCount,
    "used_post_count": usedPostCount,
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
  final String? id;
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
  final num? basePrice;

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
}

class DurationOption {
  final String? id;
  final PlanInterval? interval;
  final double? amount;

  DurationOption({this.id, this.interval, this.amount});

  factory DurationOption.fromJson(Map<String, dynamic> json) => DurationOption(
    id: json["id"],
    interval: json["interval"] != null ? PlanInterval.values.byName(json["interval"]) : null,
    amount: json["amount"]?.toDouble(),
  );
}
