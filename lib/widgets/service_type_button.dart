import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
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

  Widget _buildLeftIcon(BuildContext context, String iconPath, bool selected) {
    if (iconPath.startsWith('http://') || iconPath.startsWith('https://')) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(context.r(6)),
          border: Border.all(color: Colors.white, width: 1),
        ),
        child: AppNetworkImage(
          imageUrl: iconPath,
          width: context.w(20),
          height: context.w(20),
          fit: BoxFit.cover,
          borderRadius: BorderRadius.circular(context.r(6)),
          errorIcon: Icons.broken_image,
        ),
      );
    } else {
      return Image.asset(
        iconPath,
        width: context.w(16),
        height: context.w(16),
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
        height: context.h(50),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(context.r(16)),
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
          borderRadius: BorderRadius.circular(context.r(14)),
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
                padding: EdgeInsets.symmetric(horizontal: context.w(16), vertical: context.h(10)),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (icon != null && icon!.isNotEmpty) ...[
                      _buildLeftIcon(context, icon!, selected),
                      SizedBox(width: context.w(8)),
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
