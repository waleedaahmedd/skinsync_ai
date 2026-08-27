import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/base_state_model.dart';
import '../models/responses/patient_plans_response.dart';
import '../repositories/subscription_repository.dart';
import '../services/api_base_helper.dart';
import '../services/subscription_service.dart';
import 'base_view_model.dart';

final subscriptionProvider =
    NotifierProvider<SubscriptionViewModel, SubscriptionState>(() {
      final apiBaseHelper = ApiBaseHelper();
      final service = SubscriptionService(apiClient: apiBaseHelper);
      return SubscriptionViewModel(repository: service);
    });

class SubscriptionViewModel extends BaseViewModel<SubscriptionState> {
  final SubscriptionRepository _repository;

  SubscriptionViewModel({required SubscriptionRepository repository})
    : _repository = repository,
      super(initialState: const SubscriptionState());

  Future<void> fetchSubscriptionPlans() async {
    return await runSafely(() async {
      state = state.copyWith(loading: true, errorMessage: null);
      final response = await _repository.getPatientCurrentPlan();

      if (!ref.mounted) return;

      if (response.isSuccess ?? false) {
        state = state.copyWith(
          loading: false,
          currentPlan: response.data?.currentPlan?.plan,
          plans: response.data?.plans ?? [],
        );
      } else {
        state = state.copyWith(
          loading: false,
          errorMessage: response.message ?? 'Failed to load subscription plans',
        );
      }
    });
  }

  Future<bool> upgradePlan(int planId) async {
    EasyLoading.show(status: 'Upgrading...');
    try {
      final response = await _repository.upgradePlan(planId);
      if (response.isSuccess ?? false) {
        EasyLoading.showSuccess(
          response.message ?? 'Plan upgraded successfully!',
        );
        await fetchSubscriptionPlans();
        return true;
      } else {
        EasyLoading.showError(response.message ?? 'Failed to upgrade plan');
        return false;
      }
    } catch (e) {
      EasyLoading.showError(e.toString());
      return false;
    } finally {
      EasyLoading.dismiss();
    }
  }
}

@immutable
class SubscriptionState extends BaseStateModel {
  final Plan? currentPlan;
  final List<Plan> plans;

  const SubscriptionState({
    super.loading = false,
    super.errorMessage,
    this.currentPlan,
    this.plans = const [],
  });

  @override
  SubscriptionState copyWith({
    bool? loading,
    String? errorMessage,
    Plan? currentPlan,
    List<Plan>? plans,
  }) {
    return SubscriptionState(
      loading: loading ?? this.loading,
      errorMessage: errorMessage ?? this.errorMessage,
      currentPlan: currentPlan ?? this.currentPlan,
      plans: plans ?? this.plans,
    );
  }
}
