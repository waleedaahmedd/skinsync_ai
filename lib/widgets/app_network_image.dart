import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppNetworkImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final Color? placeholderColor;
  final Color? errorIconColor;
  final IconData? errorIcon;
  final double? errorIconSize;

  const AppNetworkImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.placeholderColor,
    this.errorIconColor,
    this.errorIcon,
    this.errorIconSize,
  });

  @override
  Widget build(BuildContext context) {
    final imageWidget = CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      placeholder: (context, url) => Container(
        width: width,
        height: height,
        color: placeholderColor ?? Colors.grey.shade100,
        child: const Center(
          child: CupertinoActivityIndicator(),
        ),
      ),
      errorWidget: (context, url, error) => Container(
        width: width,
        height: height,
        color: placeholderColor ?? Colors.grey.shade100,
        child: Center(
          child: Icon(
            errorIcon ?? Icons.broken_image_rounded,
            color: errorIconColor ?? Colors.grey.shade400,
            size: errorIconSize ?? 24.sp,
          ),
        ),
      ),
    );

    if (borderRadius != null) {
      return ClipRRect(
        borderRadius: borderRadius!,
        child: imageWidget,
      );
    }

    return imageWidget;
  }
}
