import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import '../utils/color_constant.dart';

class SocialToggleButton extends StatelessWidget {
  final VoidCallback onTap;
  final IconData icon;
  final bool isReels;

  const SocialToggleButton({
    super.key,
    required this.onTap,
    required this.icon,
    required this.isReels,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: EdgeInsets.all(context.w(10)),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isReels ? Colors.black.withValues(alpha: 0.2) : CustomColors.purpleColor.withValues(alpha: 0.1),
          border: Border.all(
            color: isReels ? Colors.white.withValues(alpha: 0.3) : CustomColors.purpleColor.withValues(alpha: 0.2),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: (isReels ? Colors.black : CustomColors.purpleColor).withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(
          icon,
          color: isReels ? Colors.white : CustomColors.purpleColor,
          size: context.sp(20),
        ),
      ),
    );
  }
}
