import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../models/subscription_plan_model.dart';
import '../utils/color_constant.dart';
import '../utils/custom_fonts.dart';

class SubscriptionPlanCard extends StatelessWidget {
  final PatientSubscriptionPlanModel plan;
  final bool isSelected;
  final bool isActive;
  final VoidCallback onTap;
  final double? width;
  final EdgeInsetsGeometry? margin;

  const SubscriptionPlanCard({
    super.key,
    required this.plan,
    required this.isSelected,
    this.isActive = false,
    required this.onTap,
    this.width,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        margin: margin ?? EdgeInsets.only(bottom: context.h(16)),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(context.r(24)),
          color: isSelected ? null : Colors.white,
          gradient: isSelected ? CustomColors.purpleBlueGradient : null,
          border: Border.all(
            color: isSelected
                ? Colors.transparent
                : CustomColors.greyColor.withValues(alpha: 0.3),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                  BoxShadow(
                    color: Colors.white.withValues(alpha: 0.1),
                    blurRadius: 10,
                  ),
                ]
              : CustomColors.cardShadow,
        ),
        child: Padding(
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
                          ? CustomColors.blackColor
                          : CustomColors.silverColor,
                    ),
                  ),
                  if (isActive)
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: context.w(12),
                        vertical: context.h(4),
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? CustomColors.blackColor.withValues(alpha: 0.1)
                            : CustomColors.silverColor.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(context.r(20)),
                        border: Border.all(
                          color: isSelected ? CustomColors.blackColor : CustomColors.silverColor,
                          width: 1,
                        ),
                      ),
                      child: Text(
                        "Active",
                        style: CustomFonts.white12w600.copyWith(
                          color: isSelected ? CustomColors.blackColor : CustomColors.silverColor,
                          fontSize: context.sp(10),
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(height: context.h(8)),
              Text(
                plan.basePrice == 0 ? "Free" : "\$${plan.basePrice}/month",
                style: CustomFonts.black18w400.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isSelected
                      ? CustomColors.blackColor
                      : CustomColors.silverColor,
                ),
              ),
              SizedBox(height: context.h(16)),
              _buildBenefitItem(
                context,
                plan.unlimitedSimulations
                    ? "Unlimited AI Simulations"
                    : "${plan.simulationCount} AI Simulations",
                color: isSelected
                    ? CustomColors.blackColor
                    : CustomColors.silverColor,
              ),
              _buildBenefitItem(
                context,
                plan.unlimitedPostsView
                    ? "Unlimited Posts View"
                    : "${plan.postsViewCount} Posts View",
                color: isSelected
                    ? CustomColors.blackColor
                    : CustomColors.silverColor,
              ),
              if (plan.id == 2 || plan.id == 3)
                _buildBenefitItem(
                  context,
                  "Priority Support",
                  color: isSelected
                      ? CustomColors.blackColor
                      : CustomColors.silverColor,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBenefitItem(BuildContext context, String title, {Color? color}) {
    return Padding(
      padding: EdgeInsets.only(bottom: context.h(8)),
      child: Row(
        children: [
          Icon(
            Icons.check_circle_outline_rounded,
            size: context.sp(18),
            color: color ?? CustomColors.darkPurple,
          ),
          SizedBox(width: context.w(10)),
          Text(
            title,
            style: CustomFonts.black14w400.copyWith(
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
