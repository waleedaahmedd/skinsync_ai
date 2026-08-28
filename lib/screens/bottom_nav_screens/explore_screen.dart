
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../../utils/color_constant.dart';
import '../../utils/custom_fonts.dart';
import '../../view_models/explore_view_model.dart';
import '../../view_models/subscription_view_model.dart';
import '../subscription_plans_screen.dart';
import 'community_screen.dart';
import 'reels_screen.dart';

class ExploreScreen extends ConsumerWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(exploreViewModel);
    final viewType = state.viewType;

    final subscriptionState = ref.watch(subscriptionProvider);
    final currentPlan = subscriptionState.currentPlan;

    final bool showUsageContainer =
        currentPlan != null && currentPlan.unlimitedPostsView == false;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        top: viewType == ExploreViewType.community,
        bottom: false,
        child: Column(
          children: [
            if (showUsageContainer) _buildUsageContainer(context, currentPlan),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                transitionBuilder: (
                  Widget child,
                  Animation<double> animation,
                ) {
                  return FadeTransition(
                    opacity: animation,
                    child: child,
                  );
                },
                child: viewType == ExploreViewType.community
                    ? const CommunityScreen(
                        key: ValueKey('community'),
                      )
                    : const ReelsScreen(
                        key: ValueKey('reels'),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUsageContainer(BuildContext context, dynamic currentPlan) {
    final int used = currentPlan.usedPostCount ?? 0;
    final int total = currentPlan.postsViewCount ?? 0;
    final double progress = total > 0 ? (used / total).clamp(0.0, 1.0) : 0.0;

    return Container(
      width: double.infinity,
      margin: EdgeInsets.fromLTRB(
        context.w(20),
        context.h(10),
        context.w(20),
        context.h(5),
      ),
      padding: EdgeInsets.all(context.w(15)),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            CustomColors.purpleColor.withValues(alpha: 0.1),
            CustomColors.lightBlueColor.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(context.r(16)),
        border: Border.all(
          color: CustomColors.purpleColor.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${(currentPlan.durationName != null && currentPlan.durationName!.isNotEmpty) ? currentPlan.durationName! : 'Total'} Post Views",
                style: CustomFonts.black14w600,
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
                style: CustomFonts.grey12w400,
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
              backgroundColor: Colors.grey.shade200,
              valueColor: const AlwaysStoppedAnimation<Color>(
                CustomColors.purpleColor,
              ),
            ),
          ),
          if (used >= total)
            Padding(
              padding: EdgeInsets.only(top: context.h(8)),
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

