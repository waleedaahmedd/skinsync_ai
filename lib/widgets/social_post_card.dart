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
      margin: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(
          color: Colors.grey.withValues(alpha: 0.08),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User Info Header
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 12.h),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(2.5.r),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        CustomColors.purpleColor.withValues(alpha: 0.5),
                        CustomColors.lightBlueColor.withValues(alpha: 0.5),
                      ],
                    ),
                  ),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    padding: EdgeInsets.all(1.5.r),
                    child: CircleAvatar(
                      radius: 22.r,
                      backgroundColor: CustomColors.greyColor,
                      backgroundImage: NetworkImage(widget.post.userProfileImage),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.post.userName,
                        style: CustomFonts.black16w600.copyWith(
                          letterSpacing: -0.3,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      Row(
                        children: [
                          Icon(Icons.public, size: 10.sp, color: Colors.grey.shade400),
                          SizedBox(width: 4.w),
                          Text(
                            _getRelativeTime(widget.post.createdAt),
                            style: CustomFonts.grey12w400.copyWith(
                              fontSize: 11.sp,
                              color: Colors.grey.shade500,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20.r),
                    onTap: () {},
                    child: Padding(
                      padding: EdgeInsets.all(8.r),
                      child: Icon(Icons.more_horiz_rounded, color: Colors.grey.shade600, size: 22.sp),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Post Content Text
          if (widget.post.contentText != null && widget.post.contentText!.isNotEmpty)
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
              child: Text(
                widget.post.contentText!,
                style: CustomFonts.black14w400.copyWith(
                  height: 1.6,
                  color: Colors.black.withValues(alpha: 0.85),
                  letterSpacing: 0.1,
                ),
              ),
            ),

          // Post Images
          if (widget.post.imageUrls.isNotEmpty)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(18.r),
                    child: SizedBox(
                      height: 300.h,
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
                  if (widget.post.imageUrls.length > 1)
                    Positioned(
                      bottom: 16.h,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            widget.post.imageUrls.length,
                            (index) => AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              margin: EdgeInsets.symmetric(horizontal: 3.w),
                              height: 5.h,
                              width: _currentPage == index ? 16.w : 5.w,
                              decoration: BoxDecoration(
                                color: _currentPage == index 
                                    ? Colors.white 
                                    : Colors.white.withValues(alpha: 0.5),
                                borderRadius: BorderRadius.circular(3.r),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

          // Interaction Bar
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              children: [
                _buildActionButton(
                  onTap: () => ref.read(socialViewModel.notifier).toggleLike(widget.post.id),
                  icon: widget.post.isLiked ? Icons.favorite_rounded : Icons.favorite_outline_rounded,
                  iconColor: widget.post.isLiked ? Colors.red.shade400 : Colors.black.withValues(alpha: 0.7),
                  label: widget.post.likesCount.toString(),
                  isActive: widget.post.isLiked,
                ),
                SizedBox(width: 20.w),
                _buildActionButton(
                  onTap: () {},
                  icon: Icons.chat_bubble_outline_rounded,
                  iconColor: Colors.black.withValues(alpha: 0.7),
                  label: widget.post.commentsCount.toString(),
                ),
                const Spacer(),
                _buildSimpleIconButton(
                  onTap: () {},
                  icon: Icons.share_outlined,
                ),
                SizedBox(width: 8.w),
                _buildSimpleIconButton(
                  onTap: () {},
                  icon: Icons.bookmark_border_rounded,
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
    bool isActive = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isActive 
              ? Colors.red.withValues(alpha: 0.05) 
              : Colors.grey.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          children: [
            Icon(icon, color: iconColor, size: 20.sp),
            SizedBox(width: 8.w),
            Text(
              label,
              style: CustomFonts.black13w600.copyWith(
                color: iconColor,
                fontSize: 12.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSimpleIconButton({
    required VoidCallback onTap,
    required IconData icon,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: EdgeInsets.all(8.r),
        decoration: BoxDecoration(
          color: Colors.grey.withValues(alpha: 0.05),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 20.sp, color: Colors.black.withValues(alpha: 0.7)),
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
