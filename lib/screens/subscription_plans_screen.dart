import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../models/subscription_plan_model.dart';
import '../utils/color_constant.dart';
import '../utils/custom_fonts.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_button.dart';
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
  final List<PatientSubscriptionPlanModel> dummyPlans = [
    PatientSubscriptionPlanModel(
      id: 0,
      name: 'Free Plan',
      basePrice: 0.00,
      simulationCount: 1,
      postsViewCount: 5,
      isActive: true,
    ),
    PatientSubscriptionPlanModel(
      id: 1,
      name: 'Basic Care',
      basePrice: 19.99,
      interval: 'week',
      simulationCount: 5,
      postsViewCount: 20,
      isActive: true,
    ),
    PatientSubscriptionPlanModel(
      id: 2,
      name: 'Premium Glow',
      basePrice: 49.99,
      simulationCount: 15,
      unlimitedPostsView: true,
      isActive: true,
    ),
    PatientSubscriptionPlanModel(
      id: 3,
      name: 'Unlimited Elite',
      basePrice: 99.99,
      unlimitedSimulations: true,
      unlimitedPostsView: true,
      isActive: true,
    ),
  ];

  int selectedPlanId = 0; // Free Plan selected by default
  final int currentActivePlanId = 0; // Simulation of current active plan

  @override
  Widget build(BuildContext context) {
    final currentPlan = dummyPlans.firstWhere((p) => p.id == currentActivePlanId);
    final otherPlans = dummyPlans.where((p) => p.id != currentActivePlanId).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(showTitle: true, title: "Subscription Plans"),
      body: AnimationLimiter(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: AnimationConfiguration.toStaggeredList(
              duration: const Duration(milliseconds: 600),
              childAnimationBuilder: (widget) => SlideAnimation(
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
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: context.w(24)),
                  child: SubscriptionPlanCard(
                    plan: currentPlan,
                    isSelected: selectedPlanId == currentActivePlanId,
                    isActive: true,
                    onTap: () =>
                        setState(() => selectedPlanId = currentActivePlanId),
                  ),
                ),

                SizedBox(height: context.h(20)),

                // Other Plans Section
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    context.w(24),
                    0,
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
                  height: context.h(260),
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: context.w(24)),
                    scrollDirection: Axis.horizontal,
                    itemCount: otherPlans.length,
                    clipBehavior: Clip.none,
                    itemBuilder: (context, index) {
                      final plan = otherPlans[index];
                      final isSelected = plan.id == selectedPlanId;

                      return AnimationConfiguration.staggeredList(
                        position: index,
                        duration: const Duration(milliseconds: 600),
                        child: SlideAnimation(
                          horizontalOffset: 50.0,
                          child: FadeInAnimation(
                            child: SubscriptionPlanCard(
                              width: context.w(300),
                              margin: EdgeInsets.only(right: context.w(16)),
                              plan: plan,
                              isSelected: isSelected,
                              isActive: plan.id == currentActivePlanId,
                              onTap: () =>
                                  setState(() => selectedPlanId = plan.id!),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                SizedBox(height: context.h(40)),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: context.w(24)),
                  child: CustomButton(
                    onPressed:
                        selectedPlanId == currentActivePlanId
                            ? null
                            : () {
                              Navigator.pop(context);
                            },
                    text:
                        selectedPlanId == currentActivePlanId
                            ? "Currently Active"
                            : "Upgrade to ${dummyPlans.firstWhere((p) => p.id == selectedPlanId).name}",


                  ),
                ),
                SizedBox(height: context.h(40)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
