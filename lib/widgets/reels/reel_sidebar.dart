import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../utills/custom_fonts.dart';

class ReelSidebar extends StatelessWidget {
  final int likesCount;
  final int commentsCount;
  final int sharesCount;
  final bool isLiked;
  final bool isSaved;
  final VoidCallback onLike;
  final VoidCallback onComment;
  final VoidCallback onShare;
  final VoidCallback onSave;
  final VoidCallback onMore;

  const ReelSidebar({
    super.key,
    required this.likesCount,
    required this.commentsCount,
    required this.sharesCount,
    required this.isLiked,
    required this.isSaved,
    required this.onLike,
    required this.onComment,
    required this.onShare,
    required this.onSave,
    required this.onMore,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildSidebarAction(
          icon: isLiked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
          label: _formatCount(likesCount),
          color: isLiked ? Colors.red : Colors.white,
          onTap: onLike,
        ),
        SizedBox(height: 20.h),
        _buildSidebarAction(
          icon: Icons.chat_bubble_rounded,
          label: _formatCount(commentsCount),
          onTap: onComment,
        ),
        SizedBox(height: 20.h),
        _buildSidebarAction(
          icon: Icons.share_rounded,
          label: _formatCount(sharesCount),
          onTap: onShare,
        ),
        SizedBox(height: 20.h),
        _buildSidebarAction(
          icon: isSaved ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
          label: 'Save',
          color: isSaved ? Colors.yellow : Colors.white,
          onTap: onSave,
        ),
        SizedBox(height: 20.h),
        _buildSidebarAction(
          icon: Icons.more_vert_rounded,
          onTap: onMore,
        ),
      ],
    );
  }

  Widget _buildSidebarAction({
    required IconData icon,
    String? label,
    Color color = Colors.white,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Icon(icon, color: color, size: 30.sp),
        ),
        if (label != null) ...[
          SizedBox(height: 4.h),
          Text(
            label,
            style: CustomFonts.white12w600,
          ),
        ],
      ],
    );
  }

  String _formatCount(int count) {
    if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}k';
    }
    return count.toString();
  }
}
