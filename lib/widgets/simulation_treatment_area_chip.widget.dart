import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../utils/assets.dart';
import '../utils/color_constant.dart';
import '../utils/custom_fonts.dart';
import 'app_network_image.dart';

class SimulationTreatmentAreaChip extends StatelessWidget {
  final String? icon;
  final String label;
  final bool isTreatment;
  final int? materialCount;
  final VoidCallback? onTap;

  const SimulationTreatmentAreaChip({
    super.key,
    this.icon,
    required this.label,
    this.isTreatment = false,
    this.materialCount,
    this.onTap,
  });

  Widget _buildIcon(BuildContext context) {
    final size = context.w(20);
    final hasIcon = icon != null && icon!.isNotEmpty;

    if (!hasIcon) {
      return Image.asset(
        PngAssets.splashLogo,
        width: size,
        height: size,
        fit: BoxFit.cover,
      );
    }

    final isNetwork = icon!.startsWith('http://') || icon!.startsWith('https://');

    if (isNetwork) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(context.r(5)),
        child: AppNetworkImage(
          imageUrl: icon!,
          width: size,
          height: size,
          fit: BoxFit.cover,
          borderRadius: BorderRadius.circular(context.r(5)),
          // AppNetworkImage's own error state - falls back to splashLogo
          errorIcon: Icons.broken_image,
        ),
      );
    }

    // Local asset path - fall back to splashLogo if it fails/breaks.
    return Image.asset(
      icon!,
      width: size,
      height: size,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => Image.asset(
        PngAssets.splashLogo,
        width: size,
        height: size,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget? _buildTrailing(BuildContext context) {
    if (isTreatment) {
      return Icon(
        Icons.visibility_outlined,
        size: context.sp(15),
        color: CustomColors.darkPurple,
      );
    }

    final hasMaterial = materialCount != null && materialCount! > 0;
    if (!hasMaterial) return null;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.w(6),
        vertical: context.h(1),
      ),
      decoration: BoxDecoration(
        color: CustomColors.purpleColor.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(context.r(20)),
      ),
      child: Text(
        "$materialCount",
        style: CustomFonts.black12w500.copyWith(
          color: CustomColors.darkPurple,
          fontSize: context.sp(11),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final trailing = _buildTrailing(context);

    return InkWell(
      onTap: isTreatment ? onTap : null,
      borderRadius: BorderRadius.circular(context.r(20)),
      child: Container(
        padding: EdgeInsets.symmetric(
         horizontal: context.w(12), // was 10
          vertical: context.h(6),   
        ),
        decoration: BoxDecoration(
          color: CustomColors.greyColor.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(context.r(20)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildIcon(context),
            SizedBox(width: context.w(6)),
            Flexible(
              child: Text(
                label,
                style: CustomFonts.black13w500,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (trailing != null) ...[
              SizedBox(width: context.w(6)),
              trailing,
            ],
          ],
        ),
      ),
    );
  }
}