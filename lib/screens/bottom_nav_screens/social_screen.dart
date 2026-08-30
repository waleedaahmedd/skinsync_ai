import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import '../../utils/color_constant.dart';
import '../../utils/custom_fonts.dart';
import '../../view_models/social_view_model.dart';
import '../../widgets/social_post_card.dart';
import '../create_post_screen.dart';

class SocialScreen extends ConsumerWidget {
  const SocialScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(socialViewModel);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: context.w(20), vertical: context.h(10)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Community",
                          style: CustomFonts.black30w600.copyWith(fontSize: context.sp(28)),
                        ),
                        SizedBox(height: context.h(4)),
                        Text(
                          "Share your journey and connect with others.",
                          style: CustomFonts.grey14w400.copyWith(height: 1.3),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const CreatePostScreen()),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.all(context.w(8)),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: CustomColors.purpleColor,
                      ),
                      child: const Icon(Icons.add, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: state.loading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      padding: EdgeInsets.only(bottom: context.h(80)),
                      physics: const BouncingScrollPhysics(),
                      itemCount: state.posts.length,
                      itemBuilder: (context, index) {
                        return SocialPostCard(post: state.posts[index]);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
