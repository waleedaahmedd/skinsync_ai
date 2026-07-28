import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../models/social_post_model.dart';
import '../utills/color_constant.dart';
import '../utills/custom_fonts.dart';
import '../view_models/social_view_model.dart';
import 'app_network_image.dart';

class SocialPostCard extends ConsumerStatefulWidget {
  final SocialPost post;

  const SocialPostCard({
    super.key,
    required this.post,
  });

  @override
  ConsumerState<SocialPostCard> createState() => _SocialPostCardState();
}

class _SocialPostCardState extends ConsumerState<SocialPostCard> {
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User Info Header
          Padding(
            padding: EdgeInsets.all(14.w),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(2.r),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: CustomColors.purpleColor.withValues(alpha: 0.3),
                      width: 1.5,
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 22.r,
                    backgroundColor: CustomColors.greyColor,
                    backgroundImage: NetworkImage(widget.post.userProfileImage),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.post.userName,
                        style: CustomFonts.black16w600,
                      ),
                      Text(
                        _getRelativeTime(widget.post.createdAt),
                        style: CustomFonts.grey12w400.copyWith(
                          fontSize: 11.sp,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.more_vert, color: Colors.grey.shade600, size: 22.sp),
                  onPressed: () {},
                ),
              ],
            ),
          ),

          // Post Content Text
          if (widget.post.contentText != null && widget.post.contentText!.isNotEmpty)
            Padding(
              padding: EdgeInsets.fromLTRB(14.w, 0, 14.w, 12.h),
              child: Text(
                widget.post.contentText!,
                style: CustomFonts.black14w400.copyWith(
                  height: 1.5,
                  color: Colors.black87,
                ),
              ),
            ),

          // Post Images
          if (widget.post.imageUrls.isNotEmpty)
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 14.w),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.r),
                    child: SizedBox(
                      height: 280.h,
                      width: double.infinity,
                      child: PageView.builder(
                        itemCount: widget.post.imageUrls.length,
                        onPageChanged: (index) {
                          setState(() {
                            _currentPage = index;
                          });
                        },
                        itemBuilder: (context, i) {
                          return AppNetworkImage(
                            imageUrl: widget.post.imageUrls[i],
                            width: double.infinity,
                            fit: BoxFit.cover,
                          );
                        },
                      ),
                    ),
                  ),
                ),
                if (widget.post.imageUrls.length > 1)
                  Positioned(
                    bottom: 12.h,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        widget.post.imageUrls.length,
                        (index) => AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: EdgeInsets.symmetric(horizontal: 3.w),
                          height: 6.h,
                          width: _currentPage == index ? 18.w : 6.w,
                          decoration: BoxDecoration(
                            color: _currentPage == index 
                                ? CustomColors.purpleColor 
                                : Colors.white.withValues(alpha: 0.6),
                            borderRadius: BorderRadius.circular(3.r),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),

          // Interaction Bar
          Padding(
            padding: EdgeInsets.all(14.w),
            child: Row(
              children: [
                _buildActionButton(
                  onTap: () => ref.read(socialViewModel.notifier).toggleLike(widget.post.id),
                  icon: widget.post.isLiked ? Icons.favorite : Icons.favorite_border,
                  iconColor: widget.post.isLiked ? Colors.red : Colors.black87,
                  label: widget.post.likesCount.toString(),
                ),
                SizedBox(width: 24.w),
                _buildActionButton(
                  onTap: () {},
                  icon: Icons.chat_bubble_outline_rounded,
                  iconColor: Colors.black87,
                  label: widget.post.commentsCount.toString(),
                ),
                const Spacer(),
                IconButton(
                  visualDensity: VisualDensity.compact,
                  onPressed: () {},
                  icon: Icon(Icons.share_outlined, size: 22.sp, color: Colors.black87),
                ),
                IconButton(
                  visualDensity: VisualDensity.compact,
                  onPressed: () {},
                  icon: Icon(Icons.bookmark_border_rounded, size: 22.sp, color: Colors.black87),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required VoidCallback onTap,
    required IconData icon,
    required Color iconColor,
    required String label,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 22.sp),
          SizedBox(width: 6.w),
          Text(
            label,
            style: CustomFonts.black13w600.copyWith(color: Colors.black87),
          ),
        ],
      ),
    );
  }

  String _getRelativeTime(DateTime dateTime) {
    final duration = DateTime.now().difference(dateTime);
    if (duration.inDays > 7) {
      return DateFormat.yMMMd().format(dateTime);
    } else if (duration.inDays >= 1) {
      return '${duration.inDays}d ago';
    } else if (duration.inHours >= 1) {
      return '${duration.inHours}h ago';
    } else if (duration.inMinutes >= 1) {
      return '${duration.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}
