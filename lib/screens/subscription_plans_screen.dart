import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../utils/color_constant.dart';
import '../utils/custom_fonts.dart';
import '../view_models/subscription_view_model.dart';
import '../widgets/app_loader.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_button.dart';
import '../widgets/horizontal_empty_state.dart';
import '../widgets/subscription_plan_card.dart';

class SubscriptionPlansScreen extends ConsumerStatefulWidget {
  const SubscriptionPlansScreen({super.key});

  static const String routeName = "/SubscriptionPlansScreen";

  @override
  ConsumerState<SubscriptionPlansScreen> createState() =>
      _SubscriptionPlansScreenState();
}

class _SubscriptionPlansScreenState
    extends ConsumerState<SubscriptionPlansScreen> {
  int? selectedPlanId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(subscriptionProvider.notifier).fetchSubscriptionPlans();
    });
  }

  @override
  Widget build(BuildContext context) {
    final subscriptionState = ref.watch(subscriptionProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(showTitle: true, title: "Subscription Plans"),
      body: subscriptionState.loading
          ? const Center(child: AppLoader())
          : subscriptionState.errorMessage != null
              ? Center(child: Text(subscriptionState.errorMessage!))
              : _buildBody(subscriptionState),
      bottomNavigationBar: subscriptionState.loading ||
              subscriptionState.errorMessage != null
          ? null
          : _buildBottomButton(subscriptionState),
    );
  }

  Widget _buildBottomButton(SubscriptionState state) {
    final currentPlan = state.currentPlan;
    final allPlans = state.plans;

    if (selectedPlanId == null && allPlans.isNotEmpty) {
      selectedPlanId = currentPlan?.id ?? allPlans.first.id;
    }

    return Container(
      padding: EdgeInsets.fromLTRB(
        context.w(24),
        context.h(12),
        context.w(24),
        context.h(32),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: CustomButton(
        onPressed:
            selectedPlanId == currentPlan?.id
                ? null
                : () async {
                    if (selectedPlanId != null) {
                      final success = await ref
                          .read(subscriptionProvider.notifier)
                          .upgradePlan(selectedPlanId!);
                      if (success && mounted) {
                        // Plan refreshed inside upgradePlan
                      }
                    }
                  },
        text:
            selectedPlanId == currentPlan?.id
                ? "Currently Active"
                : "Upgrade to ${allPlans.firstWhere((p) => p.id == selectedPlanId, orElse: () => allPlans.first).name}",
      ),
    );
  }

  Widget _buildBody(SubscriptionState state) {
    final currentPlan = state.currentPlan;
    final allPlans = state.plans;

    // Initialize selectedPlanId if not set
    if (selectedPlanId == null && allPlans.isNotEmpty) {
      selectedPlanId = currentPlan?.id ?? allPlans.first.id;
    }

    return AnimationLimiter(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: AnimationConfiguration.toStaggeredList(
            duration: const Duration(milliseconds: 600),
            childAnimationBuilder:
                (widget) => SlideAnimation(
                  verticalOffset: 50.0,
                  child: FadeInAnimation(child: widget),
                ),
            children: [
              Divider(
                color: CustomColors.greyColor.withValues(alpha: 0.6),
                height: context.h(1),
              ),

              // Current Plan Section
              Padding(
                padding: EdgeInsets.fromLTRB(
                  context.w(24),
                  context.h(24),
                  context.w(24),
                  context.h(12),
                ),
                child: Text(
                  "Current Active Plan",
                  style: CustomFonts.black18w600,
                ),
              ),
              if (currentPlan != null)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: context.w(24)),
                  child: SubscriptionPlanCard(
                    plan: currentPlan,
                    isSelected: selectedPlanId == currentPlan.id,
                    isActive: true,
                    onTap:
                        () => setState(() => selectedPlanId = currentPlan.id),
                  ),
                )
              else
                const HorizontalEmptyState(
                  icon: Icons.subscriptions_outlined,
                  title: "No Active Plan",
                  subtitle:
                      "You are not currently subscribed to any plan. Choose a plan below to get started.",
                ),
              SizedBox(height: context.h(20)),

              // Other Plans Section
              Padding(
                padding: EdgeInsets.fromLTRB(
                  context.w(24),
                  currentPlan == null ? context.h(24) : 0,
                  context.w(24),
                  context.h(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Explore More Plans", style: CustomFonts.black18w600),
                    SizedBox(height: context.h(4)),
                    Text(
                      "Choose a plan that fits your skincare journey best",
                      style: CustomFonts.grey14w400,
                    ),
                  ],
                ),
              ),

              SizedBox(
                height: 0.32.sh,
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: context.w(24)),
                  scrollDirection: Axis.horizontal,
                  itemCount: allPlans.length,
                  clipBehavior: Clip.none,
                  itemBuilder: (context, index) {
                    final plan = allPlans[index];
                    // Hide from "Other" if it's the current plan
                    if (plan.id == currentPlan?.id) return const SizedBox.shrink();

                    final isSelected = plan.id == selectedPlanId;

                    return AnimationConfiguration.staggeredList(
                      position: index,
                      duration: const Duration(milliseconds: 600),
                      child: SlideAnimation(
                        horizontalOffset: 50.0,
                        child: FadeInAnimation(
                          child: SubscriptionPlanCard(
                            width: context.w(300),
                            height: double.infinity,
                            margin: EdgeInsets.only(right: context.w(16)),
                            plan: plan,
                            isSelected: isSelected,
                            isActive: plan.id == currentPlan?.id,
                            onTap:
                                () => setState(() => selectedPlanId = plan.id),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              SizedBox(height: context.h(20)),
            ],
          ),
        ),
      ),
    );
  }
}
