import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../utills/color_constant.dart';
import '../utills/custom_fonts.dart';
import 'app_network_image.dart';

class ServiceTypeButton extends StatelessWidget {
  final String? icon;
  final String text;
  final bool selected;
  final VoidCallback? onPressed;
  final String? imageUrl;

  const ServiceTypeButton({
    super.key,
    this.icon,
    this.text = "",
    this.selected = false,
    this.onPressed,
    this.imageUrl,
  });

  Widget _buildLeftIcon(String iconPath, bool selected) {
    if (iconPath.startsWith('http://') || iconPath.startsWith('https://')) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6.r),
          border: Border.all(color: Colors.white, width: 1),
        ),
        child: AppNetworkImage(
          imageUrl: iconPath,
          width: 20.w,
          height: 20.w,
          fit: BoxFit.cover,
          borderRadius: BorderRadius.circular(6.r),
          errorIcon: Icons.broken_image,
        ),
      );
    } else {
      return Image.asset(
        iconPath,
        width: 16.w,
        height: 16.w,
        color: selected ? Colors.white : Colors.black,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool hasImage = imageUrl != null && imageUrl!.isNotEmpty;

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 50.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: selected ? CustomColors.purpleColor : Colors.black,
            width: selected ? 2.0 : 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: selected
                  ? CustomColors.purpleColor.withValues(alpha: 0.2)
                  : Colors.black.withValues(alpha: 0.015),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14.r),
          child: Stack(
            children: [
              // 1. Background Image if provided
              if (hasImage)
                Positioned.fill(
                  child: AppNetworkImage(
                    imageUrl: imageUrl!,
                    fit: BoxFit.cover,
                    placeholderColor: Colors.transparent,
                  ),
                ),

              // 2. Translucent Mask Overlay for perfect contrast
              Positioned.fill(
                child: Container(
                  color: selected
                      ? Colors.black.withValues(alpha: 0.5) // Dark overlay for selected state
                      : (hasImage
                          ? Colors.white.withValues(alpha: 0.8) // White translucent overlay for unselected state with image
                          : Colors.white), // Solid white background when no image
                ),
              ),

              // 3. Content Layer (Icon + Text)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (icon != null && icon!.isNotEmpty) ...[
                      _buildLeftIcon(icon!, selected),
                      SizedBox(width: 8.w),
                    ],
                    Text(
                      text,
                      style: selected ? CustomFonts.white12w600 : CustomFonts.black13w600,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
