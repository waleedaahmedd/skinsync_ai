import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
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
      margin: EdgeInsets.symmetric(vertical: context.h(12), horizontal: context.w(16)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(context.r(24)),
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
            padding: EdgeInsets.fromLTRB(context.w(16), context.h(16), context.w(16), context.h(12)),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(context.r(2.5)),
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
                    padding: EdgeInsets.all(context.r(1.5)),
                    child: CircleAvatar(
                      radius: context.r(22),
                      backgroundColor: CustomColors.greyColor,
                      backgroundImage: NetworkImage(widget.post.userProfileImage),
                    ),
                  ),
                ),
                SizedBox(width: context.w(12)),
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
                      SizedBox(height: context.h(1)),
                      Row(
                        children: [
                          Icon(Icons.public, size: context.sp(10), color: Colors.grey.shade400),
                          SizedBox(width: context.w(4)),
                          Text(
                            _getRelativeTime(widget.post.createdAt),
                            style: CustomFonts.grey12w400.copyWith(
                              fontSize: context.sp(11),
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
                    borderRadius: BorderRadius.circular(context.r(20)),
                    onTap: () {},
                    child: Padding(
                      padding: EdgeInsets.all(context.r(8)),
                      child: Icon(Icons.more_horiz_rounded, color: Colors.grey.shade600, size: context.sp(22)),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Post Content Text
          if (widget.post.contentText != null && widget.post.contentText!.isNotEmpty)
            Padding(
              padding: EdgeInsets.fromLTRB(context.w(16), 0, context.w(16), context.h(16)),
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
              padding: EdgeInsets.symmetric(horizontal: context.w(12)),
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(context.r(18)),
                    child: SizedBox(
                      height: context.h(300),
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
                      bottom: context.h(16),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: context.w(8), vertical: context.h(6)),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(context.r(20)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            widget.post.imageUrls.length,
                            (index) => AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              margin: EdgeInsets.symmetric(horizontal: context.w(3)),
                              height: context.h(5),
                              width: _currentPage == index ? context.w(16) : context.w(5),
                              decoration: BoxDecoration(
                                color: _currentPage == index 
                                    ? Colors.white 
                                    : Colors.white.withValues(alpha: 0.5),
                                borderRadius: BorderRadius.circular(context.r(3)),
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
            padding: EdgeInsets.all(context.w(16)),
            child: Row(
              children: [
                _buildActionButton(
                  onTap: () => ref.read(socialViewModel.notifier).toggleLike(widget.post.id),
                  icon: widget.post.isLiked ? Icons.favorite_rounded : Icons.favorite_outline_rounded,
                  iconColor: widget.post.isLiked ? Colors.red.shade400 : Colors.black.withValues(alpha: 0.7),
                  label: widget.post.likesCount.toString(),
                  isActive: widget.post.isLiked,
                ),
                SizedBox(width: context.w(20)),
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
                SizedBox(width: context.w(8)),
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
        padding: EdgeInsets.symmetric(horizontal: context.w(12), vertical: context.h(8)),
        decoration: BoxDecoration(
          color: isActive 
              ? Colors.red.withValues(alpha: 0.05) 
              : Colors.grey.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(context.r(12)),
        ),
        child: Row(
          children: [
            Icon(icon, color: iconColor, size: context.sp(20)),
            SizedBox(width: context.w(8)),
            Text(
              label,
              style: CustomFonts.black13w600.copyWith(
                color: iconColor,
                fontSize: context.sp(12),
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
        padding: EdgeInsets.all(context.r(8)),
        decoration: BoxDecoration(
          color: Colors.grey.withValues(alpha: 0.05),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: context.sp(20), color: Colors.black.withValues(alpha: 0.7)),
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
