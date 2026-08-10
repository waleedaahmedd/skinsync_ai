import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:intl/intl.dart';
import '../models/explore_models.dart';
import '../utills/assets.dart';
import '../utills/color_constant.dart';
import '../utills/custom_fonts.dart';
import 'app_network_image.dart';

class SocialPostCard extends ConsumerStatefulWidget {
  final CommunityPostModel post;

  const SocialPostCard({super.key, required this.post});

  @override
  ConsumerState<SocialPostCard> createState() => _SocialPostCardState();
}

class _SocialPostCardState extends ConsumerState<SocialPostCard> {
  @override
  Widget build(BuildContext context) {
    final post = widget.post;
    final hasImage = post.imageUrl != null && post.imageUrl!.isNotEmpty;
    final hasProfileLogo =
        post.profileLogo != null && post.profileLogo!.isNotEmpty;

    return Container(
      margin: EdgeInsets.symmetric(
        vertical: context.h(12),
        horizontal: context.w(16),
      ),
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
            padding: EdgeInsets.fromLTRB(
              context.w(16),
              context.h(16),
              context.w(16),
              context.h(12),
            ),
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
                      backgroundImage: hasProfileLogo
                          ? NetworkImage(post.profileLogo!)
                          : const AssetImage(PngAssets.splashLogo),
                    ),
                  ),
                ),
                SizedBox(width: context.w(12)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        (post.profileName != null &&
                                post.profileName!.isNotEmpty)
                            ? post.profileName!
                            : 'Community Member',
                        style: CustomFonts.black16w600.copyWith(
                          letterSpacing: -0.3,
                        ),
                      ),
                      SizedBox(height: context.h(1)),
                      Row(
                        children: [
                          Icon(
                            Icons.public,
                            size: context.sp(10),
                            color: Colors.grey.shade400,
                          ),
                          SizedBox(width: context.w(4)),
                          Text(
                            _getRelativeTime(post.createdAt),
                            style: CustomFonts.grey12w400.copyWith(
                              fontSize: context.sp(11),
                              color: Colors.grey.shade500,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          if (post.category != null &&
                              post.category!.isNotEmpty) ...[
                            SizedBox(width: context.w(6)),
                            Text(
                              '·',
                              style: TextStyle(color: Colors.grey.shade400),
                            ),
                            SizedBox(width: context.w(6)),
                            Text(
                              post.category!,
                              style: CustomFonts.grey12w400.copyWith(
                                fontSize: context.sp(11),
                                color: CustomColors.purpleColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
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
                      child: Icon(
                        Icons.more_horiz_rounded,
                        color: Colors.grey.shade600,
                        size: context.sp(22),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Title
          if (post.title.isNotEmpty)
            Padding(
              padding: EdgeInsets.fromLTRB(
                context.w(16),
                0,
                context.w(16),
                context.h(6),
              ),
              child: Text(
                post.title,
                style: CustomFonts.black16w600.copyWith(letterSpacing: -0.2),
              ),
            ),

          // Post Content Text
          if (post.content.isNotEmpty)
            Padding(
              padding: EdgeInsets.fromLTRB(
                context.w(16),
                0,
                context.w(16),
                context.h(16),
              ),
              child: Text(
                post.content,
                style: CustomFonts.black14w400.copyWith(
                  height: 1.6,
                  color: Colors.black.withValues(alpha: 0.85),
                  letterSpacing: 0.1,
                ),
              ),
            ),

          // Post Image
          if (hasImage)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: context.w(12)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(context.r(18)),
                child: SizedBox(
                  height: context.h(300),
                  width: double.infinity,
                  child: AppNetworkImage(
                    imageUrl: post.imageUrl!,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),

          // Tags
          if (post.tags.isNotEmpty)
            Padding(
              padding: EdgeInsets.fromLTRB(
                context.w(16),
                context.h(12),
                context.w(16),
                0,
              ),
              child: Wrap(
                spacing: context.w(8),
                runSpacing: context.h(8),
                children: post.tags
                    .map(
                      (tag) => Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: context.w(10),
                          vertical: context.h(4),
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(context.r(20)),
                        ),
                        child: Text(
                          '#$tag',
                          style: CustomFonts.grey12w400.copyWith(
                            fontSize: context.sp(11),
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),

          // Interaction Bar
          Padding(
            padding: EdgeInsets.all(context.w(16)),
            child: Row(
              children: [
                _buildSimpleIconButton(
                  onTap: () {},
                  icon: Icons.favorite_outline_rounded,
                ),
                SizedBox(width: context.w(8)),
                _buildSimpleIconButton(
                  onTap: () {},
                  icon: Icons.chat_bubble_outline_rounded,
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
        child: Icon(
          icon,
          size: context.sp(20),
          color: Colors.black.withValues(alpha: 0.7),
        ),
      ),
    );
  }

  String _getRelativeTime(DateTime? dateTime) {
    if (dateTime == null) return '';
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
