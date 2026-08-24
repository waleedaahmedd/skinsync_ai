import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:iconsax/iconsax.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(showTitle: true, title: "Subscription Plans"),
      body: Column(
        children: [
          Divider(
            color: CustomColors.greyColor.withValues(alpha: 0.6),
            height: context.h(1),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(context.w(24)),
              itemCount: dummyPlans.length,
              itemBuilder: (context, index) {
                final plan = dummyPlans[index];
                return SubscriptionPlanCard(
                  plan: plan,
                  isSelected: plan.id == selectedPlanId,
                  onTap: () => setState(() => selectedPlanId = plan.id!),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(context.w(24)),
            child: CustomButton(
              onPressed: () {
                Navigator.pop(context);
              },
              text: selectedPlanId == 0 ? "Current Plan" : "Upgrade Plan",
            ),
          ),
        ],
      ),
    );
  }
}
