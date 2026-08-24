import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:iconsax/iconsax.dart';

import '../models/subscription_plan_model.dart';
import '../utils/color_constant.dart';
import '../utils/custom_fonts.dart';

class SubscriptionPlanCard extends StatelessWidget {
  final PatientSubscriptionPlanModel plan;
  final bool isSelected;
  final VoidCallback onTap;

  const SubscriptionPlanCard({
    super.key,
    required this.plan,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: context.h(16)),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(context.r(24)),
          gradient: CustomColors.purpleBlueGradient,
          border: Border.all(
            color: isSelected
                ? CustomColors.darkPurple
                : CustomColors.greyColor.withValues(alpha: 0.3),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: CustomColors.cardShadow,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(context.r(24)),
          child: Stack(
            children: [
              Positioned.fill(
                child: Container(
                  color: Colors.white.withValues(
                    alpha: isSelected ? 0.85 : 0.95,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(context.w(20)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          plan.name ?? '',
                          style: CustomFonts.black20w600.copyWith(
                            color: isSelected
                                ? CustomColors.darkPurple
                                : CustomColors.blackColor,
                          ),
                        ),
                        if (isSelected)
                          const Icon(
                            Iconsax.tick_circle5,
                            color: CustomColors.darkPurple,
                          ),
                      ],
                    ),
                    SizedBox(height: context.h(8)),
                    Text(
                      plan.basePrice == 0
                          ? "Free"
                          : "\$${plan.basePrice}/month",
                      style: CustomFonts.black18w400.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isSelected
                            ? CustomColors.darkPurple
                            : CustomColors.blackColor,
                      ),
                    ),
                    SizedBox(height: context.h(16)),
                    _buildBenefitItem(
                      context,
                      plan.unlimitedSimulations
                          ? "Unlimited AI Simulations"
                          : "${plan.simulationCount} AI Simulations",
                    ),
                    _buildBenefitItem(
                      context,
                      plan.unlimitedPostsView
                          ? "Unlimited Posts View"
                          : "${plan.postsViewCount} Posts View",
                    ),
                    if (plan.id == 2 || plan.id == 3)
                      _buildBenefitItem(
                        context,
                        "Priority Support",
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBenefitItem(BuildContext context, String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: context.h(8)),
      child: Row(
        children: [
          Icon(
            Icons.check_circle_outline_rounded,
            size: context.sp(18),
            color: CustomColors.darkPurple,
          ),
          SizedBox(width: context.w(10)),
          Text(
            title,
            style: CustomFonts.black14w400,
          ),
        ],
      ),
    );
  }
}
