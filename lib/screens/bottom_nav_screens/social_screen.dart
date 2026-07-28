import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../utills/color_constant.dart';
import '../../view_models/social_view_model.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/social_post_card.dart';
import '../create_post_screen.dart';

class SocialScreen extends ConsumerWidget {
  const SocialScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(socialViewModel);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        showTitle: true,
        title: "Community",
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16.w),
            child: GestureDetector(
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
          ),
        ],
      ),
      body: SafeArea(
        child: state.loading
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                padding: EdgeInsets.only( bottom:80.h),
                itemCount: state.posts.length,
                itemBuilder: (context, index) {
                  return SocialPostCard(post: state.posts[index]);
                },
              ),
      ),
    );
  }
}
