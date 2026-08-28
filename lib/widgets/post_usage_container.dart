import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../screens/subscription_plans_screen.dart';
import '../utils/color_constant.dart';
import '../utils/custom_fonts.dart';
import '../view_models/subscription_view_model.dart';

class PostUsageContainer extends ConsumerWidget {
  final bool isDark;
  final EdgeInsetsGeometry? margin;

  const PostUsageContainer({
    super.key,
    this.isDark = false,
    this.margin,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subscriptionState = ref.watch(subscriptionProvider);
    final currentPlan = subscriptionState.currentPlan;

    if (currentPlan == null || currentPlan.unlimitedPostsView == true) {
      return const SizedBox.shrink();
    }

    final int used = currentPlan.usedPostCount ?? 0;
    final int total = currentPlan.postsViewCount ?? 0;
    final double progress = total > 0 ? (used / total).clamp(0.0, 1.0) : 0.0;

    final bgColor = isDark
        ? Colors.black.withValues(alpha: 0.6)
        : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black;
    final borderColor = isDark
        ? Colors.white.withValues(alpha: 0.1)
        : CustomColors.purpleColor.withValues(alpha: 0.2);

    return Container(
      width: double.infinity,
      margin: margin ??
          EdgeInsets.symmetric(
            horizontal: context.w(20),
            vertical: context.h(10),
          ),
      padding: EdgeInsets.all(context.w(15)),
      decoration: BoxDecoration(
        color: bgColor,
        gradient: isDark
            ? null
            : LinearGradient(
                colors: [
                  CustomColors.purpleColor.withValues(alpha: 0.1),
                  CustomColors.lightBlueColor.withValues(alpha: 0.05),
                ],
              ),
        borderRadius: BorderRadius.circular(context.r(16)),
        border: Border.all(color: borderColor),
        boxShadow: isDark
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                )
              ]
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${(currentPlan.durationName != null && currentPlan.durationName!.isNotEmpty) ? currentPlan.durationName! : 'Total'} Post Views",
                style: CustomFonts.black14w600.copyWith(color: textColor),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    SubscriptionPlansScreen.routeName,
                  );
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.w(12),
                    vertical: context.h(4),
                  ),
                  decoration: BoxDecoration(
                    color: CustomColors.purpleColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(context.r(12)),
                    border: Border.all(
                      color: CustomColors.purpleColor.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Text(
                    "Upgrade",
                    style: CustomFonts.black12w600.copyWith(
                      color: CustomColors.purpleColor,
                      fontSize: context.sp(10),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: context.h(12)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Usage Progress",
                style: CustomFonts.grey12w400.copyWith(
                  color: isDark ? Colors.white70 : null,
                ),
              ),
              Text(
                "$used / $total Views",
                style: CustomFonts.black12w600.copyWith(
                  color: CustomColors.purpleColor,
                ),
              ),
            ],
          ),
          SizedBox(height: context.h(8)),
          ClipRRect(
            borderRadius: BorderRadius.circular(context.r(10)),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: context.h(6),
              backgroundColor: isDark ? Colors.white10 : Colors.grey.shade200,
              valueColor: const AlwaysStoppedAnimation<Color>(
                CustomColors.purpleColor,
              ),
            ),
          ),
          if (used >= total)
            Padding(
              padding: EdgeInsets.only(top: context.h(6)),
              child: Text(
                "You've reached your limit. Upgrade to see more!",
                style: CustomFonts.black10w600.copyWith(color: Colors.red),
              ),
            ),
        ],
      ),
    );
  }
}
