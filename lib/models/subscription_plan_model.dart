class PatientSubscriptionPlanModel {
  final int? id;
  final String? name;
  final double? basePrice;
  final int simulationCount;
  final bool unlimitedSimulations;
  final int postsViewCount;
  final bool unlimitedPostsView;
  final List<String>? assignedPatients;
  final bool isActive;

  PatientSubscriptionPlanModel({
    this.id,
    this.name,
    this.basePrice,
    this.simulationCount = 0,
    this.unlimitedSimulations = false,
    this.postsViewCount = 0,
    this.unlimitedPostsView = false,
    this.assignedPatients,
    this.isActive = true,
  });

  factory PatientSubscriptionPlanModel.fromJson(Map<String, dynamic> json) {
    return PatientSubscriptionPlanModel(
      id: json['id'] as int?,
      name: json['name'] as String?,
      basePrice: (json['base_price'] as num?)?.toDouble(),
      simulationCount: json['simulation_count'] as int? ?? 0,
      unlimitedSimulations: json['unlimited_simulations'] as bool? ?? false,
      postsViewCount: json['posts_view_count'] as int? ?? 0,
      unlimitedPostsView: json['unlimited_posts_view'] as bool? ?? false,
      isActive: (json['is_active'] as bool?) ?? true,
      assignedPatients: json['assigned_patients'] != null
          ? List<String>.from(json['assigned_patients'] as Iterable)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'base_price': basePrice,
      'simulation_count': simulationCount,
      'unlimited_simulations': unlimitedSimulations,
      'posts_view_count': postsViewCount,
      'unlimited_posts_view': unlimitedPostsView,
      'is_active': isActive,
      'assigned_patients': assignedPatients,
    };
  }
}
