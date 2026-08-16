import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import '../../utils/custom_fonts.dart';

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
          context: context,
          icon: isLiked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
          label: _formatCount(likesCount),
          color: isLiked ? Colors.red : Colors.white,
          onTap: onLike,
        ),
        SizedBox(height: context.h(20)),
        _buildSidebarAction(
          context: context,
          icon: Icons.chat_bubble_rounded,
          label: _formatCount(commentsCount),
          onTap: onComment,
        ),
        SizedBox(height: context.h(20)),
        _buildSidebarAction(
          context: context,
          icon: Icons.share_rounded,
          label: _formatCount(sharesCount),
          onTap: onShare,
        ),
        SizedBox(height: context.h(20)),
        _buildSidebarAction(
          context: context,
          icon: isSaved ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
          label: 'Save',
          color: isSaved ? Colors.yellow : Colors.white,
          onTap: onSave,
        ),
        SizedBox(height: context.h(20)),
        _buildSidebarAction(
          context: context,
          icon: Icons.more_vert_rounded,
          onTap: onMore,
        ),
      ],
    );
  }

  Widget _buildSidebarAction({
    required BuildContext context,
    required IconData icon,
    String? label,
    Color color = Colors.white,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Icon(icon, color: color, size: context.sp(30)),
        ),
        if (label != null) ...[
          SizedBox(height: context.h(4)),
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
