import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../utills/color_constant.dart';
import '../../utills/custom_fonts.dart';
import '../../view_models/explore_view_model.dart';
import '../../view_models/social_view_model.dart';
import '../../widgets/social_post_card.dart';
import '../../widgets/social_toggle_button.dart';
import '../create_post_screen.dart';

class CommunityScreen extends ConsumerWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(socialViewModel);

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Community",
                        style: CustomFonts.black30w600.copyWith(fontSize: 28.sp),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        "Share your journey and connect with others.",
                        style: CustomFonts.grey14w400.copyWith(height: 1.3),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    SocialToggleButton(
                      onTap: () => ref.read(exploreViewModel.notifier).toggleViewType(),
                      icon: Icons.play_circle_outline_rounded,
                      isReels: false,
                    ),
                    SizedBox(width: 12.w),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const CreatePostScreen()),
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.all(8.w),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: CustomColors.purpleColor,
                        ),
                        child: const Icon(Icons.add, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: state.loading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    padding: EdgeInsets.only(bottom: 120.h),
                    physics: const BouncingScrollPhysics(),
                    itemCount: state.posts.length,
                    itemBuilder: (context, index) {
                      return SocialPostCard(post: state.posts[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
