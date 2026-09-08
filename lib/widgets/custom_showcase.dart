import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';
import '../utils/color_constant.dart';
import '../utils/custom_fonts.dart';

class CustomShowcase extends StatelessWidget {
  final GlobalKey showcaseKey;
  final String title;
  final String description;
  final Widget child;
  final VoidCallback? onBarrierClick;
  final ShapeBorder? shapeBorder;
  final EdgeInsets? tooltipPadding;
  final EdgeInsets? targetPadding;
  final TextStyle? titleTextStyle;
  final TextStyle? descTextStyle;

  const CustomShowcase({
    super.key,
    required this.showcaseKey,
    required this.title,
    required this.description,
    required this.child,
    this.onBarrierClick,
    this.shapeBorder,
    this.tooltipPadding,
    this.targetPadding,
    this.titleTextStyle,
    this.descTextStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Showcase(
      key: showcaseKey,
      tooltipBackgroundColor: CustomColors.whiteColor,
      title: title,
      description: description,
      onBarrierClick: onBarrierClick,
      enableAutoScroll: true,
      targetPadding: targetPadding ?? const EdgeInsets.all(0),
      targetShapeBorder:
          shapeBorder ??
          const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
      tooltipPadding: tooltipPadding ?? const EdgeInsets.all(12),
      titleTextStyle: titleTextStyle ?? CustomFonts.black13w600,
      descTextStyle: CustomFonts.black12w400,
      child: child,
    );
  }
}
