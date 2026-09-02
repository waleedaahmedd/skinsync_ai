import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import '../utils/color_constant.dart';
import '../utils/custom_fonts.dart';
import 'app_network_image.dart';

class ServiceTypeButton extends StatelessWidget {
  final String? icon;
  final String text;
  final bool selected;
  final VoidCallback? onPressed;
  final String? imageUrl;
  final String? description;
  final String? highLightedArea;
  final String? infoImageUrl; // NEW

  final GlobalKey<TooltipState> _tooltipKey = GlobalKey<TooltipState>();

  ServiceTypeButton({
    super.key,
    this.icon,
    this.text = "",
    this.selected = false,
    this.onPressed,
    this.imageUrl,
    this.description,
    this.highLightedArea,
    this.infoImageUrl, // NEW
  });

  Widget _buildLeftIcon(BuildContext context, String iconPath, bool selected) {
    if (iconPath.startsWith('http://') || iconPath.startsWith('https://')) {
      return AppNetworkImage(
        imageUrl: iconPath,
        width: context.w(26),
        height: context.w(26),
        fit: BoxFit.cover,
        borderRadius: BorderRadius.circular(context.r(6)),
        errorIcon: Icons.broken_image,
      );
    } else {
      return Image.asset(
        iconPath,
        width: context.w(22),
        height: context.w(22),
        color: selected ? Colors.white : Colors.black,
      );
    }
  }

  Widget _buildTooltipImage(BuildContext context, String imagePath) {
    final double squareSize = context.w(48);

    if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
      return AppNetworkImage(
        imageUrl: imagePath,
        width: squareSize,
        height: squareSize,
        fit: BoxFit.cover,
        borderRadius: BorderRadius.circular(context.r(8)),
        errorIcon: Icons.broken_image,
      );
    } else {
      return ClipRRect(
        borderRadius: BorderRadius.circular(context.r(8)),
        child: Image.asset(
          imagePath,
          width: squareSize,
          height: squareSize,
          fit: BoxFit.cover,
        ),
      );
    }
  }

  Widget _buildTooltipContent(BuildContext context) {
    final bool hasTooltipImage =
        highLightedArea != null && highLightedArea!.isNotEmpty;
    final bool hasDescription =
        description != null && description!.isNotEmpty;

    return IntrinsicWidth(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: context.w(10),
          vertical: context.h(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (hasTooltipImage) ...[
              _buildTooltipImage(context, highLightedArea!),
              if (hasDescription) SizedBox(width: context.w(10)),
            ],
            if (hasDescription)
              Flexible(
                child: Text(
                  description!,
                  style: CustomFonts.black13w600.copyWith(
                    color: Colors.white,
                    fontSize: context.sp(12),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // NEW: small info badge that explicitly opens the tooltip on tap
  Widget _buildInfoBadge(BuildContext context) {
    return Positioned(
      top: -context.h(6),
      right: -context.w(6),
      child: GestureDetector(
        onTap: () {
          _tooltipKey.currentState?.ensureTooltipVisible();
        },
        child: Container(
          width: context.w(18),
          height: context.w(18),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.85),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 1.5),
          ),
          child: Icon(
            Icons.info_outline,
            color: Colors.white,
            size: context.sp(12),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool hasImage = imageUrl != null && imageUrl!.isNotEmpty;
    final bool hasTooltip = (highLightedArea != null && highLightedArea!.isNotEmpty) ||
        (description != null && description!.isNotEmpty);
    final bool hasInfoBadge = infoImageUrl != null && infoImageUrl!.isNotEmpty;

    Widget buttonContent = GestureDetector(
      onTap: onPressed,
      child: Container(
        height: context.h(50),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(context.r(16)),
          border: Border.all(
            color: selected ? CustomColors.purpleColor : Colors.black,
            width: 2.0,
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
              if (hasImage)
                Positioned.fill(
                  child: AppNetworkImage(
                    imageUrl: imageUrl!,
                    fit: BoxFit.cover,
                    placeholderColor: Colors.transparent,
                  ),
                ),
              Positioned.fill(
                child: Container(
                  color: selected
                      ? Colors.black.withValues(alpha: 0.5)
                      : (hasImage
                          ? Colors.white.withValues(alpha: 0.8)
                          : Colors.white),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: context.w(16),
                  vertical: context.h(10),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (icon != null && icon!.isNotEmpty) ...[
                      _buildLeftIcon(context, icon!, selected),
                      SizedBox(width: context.w(8)),
                    ],
                    Text(
                      text,
                      style: CustomFonts.black13w600.copyWith(
                        color: selected ? Colors.white : Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );

    if (!hasTooltip) {
      return buttonContent;
    }

    final tooltip = Tooltip(
      key: _tooltipKey,
      preferBelow: false,
      verticalOffset: context.h(10),
      triggerMode: TooltipTriggerMode.longPress,
      margin: EdgeInsets.all(context.w(20)),
      padding: EdgeInsets.zero,
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(context.r(10)),
      ),
      richMessage: WidgetSpan(
        child: _buildTooltipContent(context),
      ),
      child: buttonContent,
    );

    if (!hasInfoBadge) {
      return tooltip;
    }

    return Stack(
      clipBehavior: Clip.none,
      children: [
        tooltip,
        _buildInfoBadge(context),
      ],
    );
  }
}