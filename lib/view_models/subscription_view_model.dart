import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../app_init.dart';
import '../models/base_state_model.dart';
import '../models/responses/patient_plans_response.dart';
import '../repositories/subscription_repository.dart';
import '../screens/webview_page.dart';
import '../services/api_base_helper.dart';
import '../services/subscription_service.dart';
import '../utils/enums.dart';
import 'base_view_model.dart';

final subscriptionProvider =
    NotifierProvider<SubscriptionViewModel, SubscriptionState>(() {
      final apiBaseHelper = ApiBaseHelper();
      final service = SubscriptionService(apiClient: apiBaseHelper);
      return SubscriptionViewModel(repository: service);
    });

class SubscriptionViewModel extends BaseViewModel<SubscriptionState> {
  final SubscriptionRepository _repository;

  SubscriptionViewModel({required this._repository})
    : super(initialState: const SubscriptionState());

  Future<void> fetchSubscriptionPlans() async {
    return await runSafely(() async {
      state = state.copyWith(loading: true, errorMessage: null);
      final response = await _repository.getPatientCurrentPlan();

      if (!ref.mounted) return;

      if (response.isSuccess ?? false) {
        state = state.copyWith(
          loading: false,
          currentPlan: response.data?.currentPlan,
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

  Future<bool> upgradePlan(int planId, {int? durationId}) async {
    EasyLoading.show(status: 'Upgrading...');
    try {
      final response = await _repository.upgradePlan(
        planId: planId,
        durationId: durationId,
      );
      if (response.isSuccess ?? false) {
        EasyLoading.dismiss();
        final params = await WebviewPage.open(
          context: navigatorKey.currentContext!,
          url: response.data!.stripeUrl!,
          successUrl: response.data!.successUrl!,
          cancelUrl: response.data!.cancelUrl!,
          title: 'Subscribe',
        );
        log('PARAMS: $params');
        if (params != null) {
          await Future.delayed(const Duration(seconds: 3));
          await fetchSubscriptionPlans();
          EasyLoading.showSuccess(
            response.message ?? 'Plan upgraded successfully!',
          );
        } else {
          EasyLoading.showError('Something went wrong!');
        }
        return true;
      } else {
        EasyLoading.showError(response.message ?? 'Failed to upgrade plan');
        return false;
      }
    } catch (e) {
      EasyLoading.showError(e.toString());
      return false;
    }
  }

  Future<bool> recordUsage({
    required UsageType usageType,
    required int subscriptionId,
  }) async {
    EasyLoading.show(status: 'Updating usage...');
    final result = await runSafely(() async {
      final response = await _repository.recordUsage(
        usageType: usageType,
        subscriptionId: subscriptionId,
      );
      if (response.isSuccess ?? false) {
        await fetchSubscriptionPlans();
        return true;
      }
      return false;
    });
    EasyLoading.dismiss();
    return result ?? false;
  }

  @override
  void onError(String message) {
    state = state.copyWith(loading: false);
    super.onError(message);
  }
}

@immutable
class SubscriptionState extends BaseStateModel {
  final CurrentPlan? currentPlan;
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
    CurrentPlan? currentPlan,
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
