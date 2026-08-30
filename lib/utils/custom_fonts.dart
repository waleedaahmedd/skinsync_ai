import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import 'color_constant.dart';

abstract final class CustomFonts {
  static double _sp(double size) {
    return ScreenUtilPlus().setSp(size);
  }

  static TextStyle get black50w600 => TextStyle(
        height: 0,
        fontSize: _sp(50),
        fontWeight: FontWeight.w600,
        color: CustomColors.blackColor,
        fontFamily: 'Degular',
      );
  static TextStyle get white50w600 => TextStyle(
        height: 0,
        fontSize: _sp(50),
        fontWeight: FontWeight.w600,
        color: CustomColors.whiteColor,
        fontFamily: 'Degular',
      );
  static TextStyle get grey20w500 => TextStyle(
        height: 0,
        fontSize: _sp(20),
        fontWeight: FontWeight.w500,
        color: CustomColors.silverColor,
        fontFamily: 'Degular',
      );
  static TextStyle get white22w600 => TextStyle(
        height: 0,
        fontSize: _sp(22),
        fontWeight: FontWeight.w600,
        color: CustomColors.whiteColor,
        fontFamily: 'Degular',
      );
  static TextStyle get white20w700 => TextStyle(
        height: 0,
        fontSize: _sp(20),
        fontWeight: FontWeight.w700,
        color: CustomColors.whiteColor,
        fontFamily: 'Degular',
      );
  static TextStyle get white18w600 => TextStyle(
        height: 0,
        fontSize: _sp(18),
        fontWeight: FontWeight.w600,
        color: CustomColors.whiteColor,
        fontFamily: 'Degular',
      );
  static TextStyle get white18w500 => TextStyle(
        height: 0,
        fontSize: _sp(18),
        fontWeight: FontWeight.w500,
        color: CustomColors.whiteColor,
        fontFamily: 'Degular',
      );
  static TextStyle get white12w600 => TextStyle(
        height: 0,
        fontSize: _sp(12),
        fontWeight: FontWeight.w600,
        color: CustomColors.whiteColor,
        fontFamily: 'Degular',
      );
  static TextStyle get white12w400 => TextStyle(
        height: 0,
        fontSize: _sp(12),
        fontWeight: FontWeight.w400,
        color: CustomColors.whiteColor,
        fontFamily: 'Degular',
      );
  static TextStyle get white14w600 => TextStyle(
        height: 0,
        fontSize: _sp(14),
        fontWeight: FontWeight.w600,
        color: CustomColors.whiteColor,
        fontFamily: 'Degular',
      );
  static TextStyle get white14w500 => TextStyle(
        height: 0,
        fontSize: _sp(14),
        fontWeight: FontWeight.w500,
        color: CustomColors.whiteColor,
        fontFamily: 'Degular',
      );
  static TextStyle get white14w400 => TextStyle(
        height: 0,
        fontSize: _sp(14),
        fontWeight: FontWeight.w400,
        color: CustomColors.whiteColor,
        fontFamily: 'Degular',
      );
  static TextStyle get white15w400 => TextStyle(
        height: 0,
        fontSize: _sp(15),
        fontWeight: FontWeight.w400,
        color: CustomColors.whiteColor,
        fontFamily: 'Degular',
      );
  static TextStyle get white17w500 => TextStyle(
        height: 0,
        fontSize: _sp(17),
        fontWeight: FontWeight.w500,
        color: CustomColors.whiteColor,
        fontFamily: 'Degular',
      );
  static TextStyle get black18w600 => TextStyle(
        height: 0,
        fontSize: _sp(18),
        fontWeight: FontWeight.w600,
        color: CustomColors.blackColor,
        fontFamily: 'Degular',
      );
  static TextStyle get black14w400 => TextStyle(
        height: 0,
        fontSize: _sp(14),
        fontWeight: FontWeight.w400,
        color: CustomColors.blackColor,
        fontFamily: 'Degular',
      );
  static TextStyle get black14w600 => TextStyle(
        height: 0,
        fontSize: _sp(14),
        fontWeight: FontWeight.w600,
        color: CustomColors.blackColor,
        fontFamily: 'Degular',
      );
  static TextStyle get black14w700 => TextStyle(
        height: 0,
        fontSize: _sp(14),
        fontWeight: FontWeight.w700,
        color: CustomColors.blackColor,
        fontFamily: 'Degular',
      );
  static TextStyle get black15w400 => TextStyle(
        height: 0,
        fontSize: _sp(15),
        fontWeight: FontWeight.w400,
        color: CustomColors.blackColor,
        fontFamily: 'Degular',
      );
  static TextStyle get black12w600 => TextStyle(
        height: 0,
        fontSize: _sp(12),
        fontWeight: FontWeight.w600,
        color: CustomColors.blackColor,
        fontFamily: 'Degular',
      );
  static TextStyle get black14w500 => TextStyle(
        height: 0,
        fontSize: _sp(14),
        fontWeight: FontWeight.w500,
        color: CustomColors.blackColor,
        fontFamily: 'Degular',
      );
  static TextStyle get black14w400Underline => TextStyle(
        height: 0,
        fontSize: _sp(14),
        fontWeight: FontWeight.w400,
        color: CustomColors.blackColor,
        decoration: TextDecoration.underline,
        decorationColor: CustomColors.blackColor,
        // optional
        decorationThickness: 1.0,
        fontFamily: 'Degular',
      );
  static TextStyle get blue14w400Underline => TextStyle(
        height: 0,
        fontSize: _sp(14),
        fontWeight: FontWeight.w400,
        color: CustomColors.blueColor,
        decoration: TextDecoration.underline,
        decorationColor: CustomColors.blueColor,
        // optional
        decorationThickness: 1.0,
        fontFamily: 'Degular',
      );
  static TextStyle get black14w500Underline => TextStyle(
        height: 0,
        fontSize: _sp(14),
        fontWeight: FontWeight.w500,
        color: CustomColors.blackColor,
        decoration: TextDecoration.underline,
        decorationColor: CustomColors.blackColor,
        // optional
        decorationThickness: 1.0,
        fontFamily: 'Degular',
      );
  static TextStyle get black22w600Underline => TextStyle(
        height: 0,
        fontSize: _sp(22),
        fontWeight: FontWeight.w600,
        color: CustomColors.blackColor,
        decoration: TextDecoration.underline,
        decorationColor: CustomColors.blackColor,
        // optional
        decorationThickness: 1.0,
        fontFamily: 'Degular',
      );
  static TextStyle get black30w600 => TextStyle(
        height: 0,
        fontSize: _sp(30),
        fontWeight: FontWeight.w600,
        color: CustomColors.blackColor,
        fontFamily: 'Degular',
      );
  static TextStyle get grey18w400 => TextStyle(
        height: 0,
        fontSize: _sp(18),
        fontWeight: FontWeight.w400,
        color: CustomColors.textGreyColor,
        fontFamily: 'Degular',
      );
  static TextStyle get grey14w400 => TextStyle(
        height: 0,
        fontSize: _sp(14),
        fontWeight: FontWeight.w400,
        color: CustomColors.textGreyColor,
        fontFamily: 'Degular',
      );
  static TextStyle get grey15w400 => TextStyle(
        height: 0,
        fontSize: _sp(15),
        fontWeight: FontWeight.w400,
        color: CustomColors.textGreyColor,
        fontFamily: 'Degular',
      );
  static TextStyle get grey13w400 => TextStyle(
        height: 0,
        fontSize: _sp(13),
        fontWeight: FontWeight.w400,
        color: CustomColors.textGreyColor,
        fontFamily: 'Degular',
      );
  static TextStyle get grey14w400LineThrough => TextStyle(
        height: 0,
        fontSize: _sp(14),
        fontWeight: FontWeight.w400,
        color: CustomColors.textGreyColor,
        fontFamily: 'Degular',
        decoration: TextDecoration.lineThrough,
        decorationColor: CustomColors.textGreyColor,
        // optional
        decorationThickness: 1.0,
      );
  static TextStyle get grey16w400 => TextStyle(
        height: 0,
        fontSize: _sp(16),
        fontWeight: FontWeight.w400,
        color: CustomColors.textGreyColor,
        fontFamily: 'Degular',
      );
  static TextStyle get grey16w500 => TextStyle(
        height: 0,
        fontSize: _sp(16),
        fontWeight: FontWeight.w500,
        color: CustomColors.textGreyColor,
        fontFamily: 'Degular',
      );
  static TextStyle get grey18w500 => TextStyle(
        height: 0,
        fontSize: _sp(18),
        fontWeight: FontWeight.w500,
        color: CustomColors.textGreyColor,
        fontFamily: 'Degular',
      );
  static TextStyle get grey22w500 => TextStyle(
        height: 0,
        fontSize: _sp(22),
        fontWeight: FontWeight.w500,
        color: CustomColors.textGreyColor,
        fontFamily: 'Degular',
      );
  static TextStyle get grey22w600 => TextStyle(
        height: 0,
        fontSize: _sp(22),
        fontWeight: FontWeight.w600,
        color: CustomColors.textGreyColor,
        fontFamily: 'Degular',
      );
  static TextStyle get black18w400 => TextStyle(
        height: 0,
        fontSize: _sp(18),
        fontWeight: FontWeight.w400,
        color: CustomColors.blackColor,
        fontFamily: 'Degular',
      );
  static TextStyle get black18w500 => TextStyle(
        height: 0,
        fontSize: _sp(18),
        fontWeight: FontWeight.w500,
        color: CustomColors.blackColor,
        fontFamily: 'Degular',
      );
  static TextStyle get black10w600 => TextStyle(
        height: 0,
        fontSize: _sp(10),
        fontWeight: FontWeight.w600,
        color: CustomColors.blackColor,
        fontFamily: 'Degular',
      );
  static TextStyle get black12w500 => TextStyle(
        height: 0,
        fontSize: _sp(12),
        fontWeight: FontWeight.w500,
        color: CustomColors.blackColor,
        fontFamily: 'Degular',
      );
  static TextStyle get black12w400 => TextStyle(
        height: 0,
        fontSize: _sp(12),
        fontWeight: FontWeight.w400,
        color: CustomColors.blackColor,
        fontFamily: 'Degular',
      );
  static TextStyle get black13w400 => TextStyle(
        height: 0,
        fontSize: _sp(13),
        fontWeight: FontWeight.w400,
        color: CustomColors.blackColor,
        fontFamily: 'Degular',
      );
  static TextStyle get black13w500 => TextStyle(
        height: 0,
        fontSize: _sp(13),
        fontWeight: FontWeight.w500,
        color: CustomColors.blackColor,
        fontFamily: 'Degular',
      );
  static TextStyle get red13w500 => TextStyle(
        height: 0,
        fontSize: _sp(13),
        fontWeight: FontWeight.w500,
        color: const Color(0xFFFE3A30),
        fontFamily: 'Degular',
      );
  static TextStyle get black20w600 => TextStyle(
        height: 0,
        fontSize: _sp(20),
        fontWeight: FontWeight.w600,
        color: CustomColors.blackColor,
        fontFamily: 'Degular',
      );
  static TextStyle get black20w500 => TextStyle(
        height: 0,
        fontSize: _sp(20),
        fontWeight: FontWeight.w500,
        color: CustomColors.blackColor,
        fontFamily: 'Degular',
      );
  static TextStyle get black20w600Underlined => TextStyle(
        height: 0,
        fontSize: _sp(20),
        fontWeight: FontWeight.w600,
        color: CustomColors.blackColor,
        fontFamily: 'Degular',
      );
  static TextStyle get black26w600 => TextStyle(
        height: 0,
        fontSize: _sp(26),
        fontWeight: FontWeight.w600,
        color: CustomColors.blackColor,
        fontFamily: 'Degular',
      );
  static TextStyle get black22w600 => TextStyle(
        height: 0,
        fontSize: _sp(22),
        fontWeight: FontWeight.w600,
        color: CustomColors.blackColor,
        fontFamily: 'Degular',
      );
  static TextStyle get black24w600 => TextStyle(
        height: 0,
        fontSize: _sp(24),
        fontWeight: FontWeight.w600,
        color: CustomColors.blackColor,
        fontFamily: 'Degular',
      );
  static TextStyle get black22w500 => TextStyle(
        height: 0,
        fontSize: _sp(22),
        fontWeight: FontWeight.w500,
        color: CustomColors.blackColor,
        fontFamily: 'Degular',
      );
  static TextStyle get black16w400 => TextStyle(
        height: 0,
        fontSize: _sp(16),
        fontWeight: FontWeight.w400,
        color: CustomColors.blackColor,
        fontFamily: 'Degular',
      );
  static TextStyle get black16w500 => TextStyle(
        height: 0,
        fontSize: _sp(16),
        fontWeight: FontWeight.w500,
        color: CustomColors.blackColor,
        fontFamily: 'Degular',
      );
  static TextStyle get black16w600 => TextStyle(
        height: 0,
        fontSize: _sp(16),
        fontWeight: FontWeight.w600,
        color: CustomColors.blackColor,
        fontFamily: 'Degular',
      );
  static TextStyle get black17w500 => TextStyle(
        height: 0,
        fontSize: _sp(17),
        fontWeight: FontWeight.w500,
        color: CustomColors.blackColor,
        fontFamily: 'Degular',
      );
  static TextStyle get black28w600 => TextStyle(
        height: 0,
        fontSize: _sp(28),
        fontWeight: FontWeight.w600,
        color: CustomColors.blackColor,
        fontFamily: 'Degular',
      );
  static TextStyle get pinkunderlined20w600 => TextStyle(
        height: 0,
        fontSize: _sp(20),
        fontWeight: FontWeight.w600,
        decoration: TextDecoration.underline,
        color: CustomColors.purpleColor,
        fontFamily: 'Degular',
      );

  static TextStyle get purple30w700 => black30w600.copyWith(
        color: CustomColors.darkPurple,
        fontWeight: FontWeight.w700,
      );

  // Reusable Premium Static Font Styles
  static TextStyle get darkPurple12w600 => TextStyle(
        fontSize: _sp(12),
        fontWeight: FontWeight.w600,
        color: CustomColors.darkPurple,
        letterSpacing: 1.2,
        fontFamily: 'Degular',
      );

  static TextStyle get pink10w600 => TextStyle(
        fontSize: _sp(10),
        fontWeight: FontWeight.w600,
        color: CustomColors.pinkColor,
        fontFamily: 'Degular',
      );

  static TextStyle get pink13w500 => TextStyle(
        fontSize: _sp(13),
        fontWeight: FontWeight.w500,
        color: CustomColors.pinkColor,
        fontFamily: 'Degular',
      );

  static TextStyle get black17w600 => TextStyle(
        fontSize: _sp(17),
        fontWeight: FontWeight.w600,
        color: CustomColors.blackColor,
        fontFamily: 'Degular',
      );

  static TextStyle get black87_15w400 => TextStyle(
        fontSize: _sp(15),
        fontWeight: FontWeight.w400,
        color: const Color(0xDD000000),
        fontFamily: 'Degular',
      );

  static TextStyle get grey12w500Underline => TextStyle(
        fontSize: _sp(12),
        fontWeight: FontWeight.w500,
        color: const Color(0xff757575),
        decoration: TextDecoration.underline,
        decorationColor: const Color(0xff757575),
        fontFamily: 'Degular',
      );

  static TextStyle get white16w600 => TextStyle(
        fontSize: _sp(16),
        fontWeight: FontWeight.w600,
        color: CustomColors.whiteColor,
        fontFamily: 'Degular',
      );

  static TextStyle get textGrey15w400 => TextStyle(
        fontSize: _sp(15),
        fontWeight: FontWeight.w400,
        color: CustomColors.textGreyColor,
        fontFamily: 'Degular',
      );

  static TextStyle get textGrey16w400 => TextStyle(
        fontSize: _sp(16),
        fontWeight: FontWeight.w400,
        color: CustomColors.textGreyColor,
        fontFamily: 'Degular',
      );

  static TextStyle get textGrey13w400 => TextStyle(
        fontSize: _sp(13),
        fontWeight: FontWeight.w400,
        color: CustomColors.textGreyColor,
        fontFamily: 'Degular',
      );

  static TextStyle get textGrey14w400 => TextStyle(
        fontSize: _sp(14),
        fontWeight: FontWeight.w400,
        color: CustomColors.textGreyColor,
        fontFamily: 'Degular',
      );

  static TextStyle get grey700_11w700 => TextStyle(
        fontSize: _sp(11),
        fontWeight: FontWeight.w700,
        color: const Color(0xFF616161),
        fontFamily: 'Degular',
      );

  static TextStyle get black13w600 => TextStyle(
        fontSize: _sp(13),
        fontWeight: FontWeight.w600,
        color: CustomColors.blackColor,
        fontFamily: 'Degular',
      );

  static TextStyle get white14w700 => TextStyle(
        fontSize: _sp(14),
        fontWeight: FontWeight.w700,
        color: CustomColors.whiteColor,
        fontFamily: 'Degular',
      );

  static TextStyle get blue10w700 => TextStyle(
        fontSize: _sp(10),
        fontWeight: FontWeight.w700,
        color: CustomColors.blueColor,
        fontFamily: 'Degular',
      );

  static TextStyle get pink10w700 => TextStyle(
        fontSize: _sp(10),
        fontWeight: FontWeight.w700,
        color: CustomColors.pinkColor,
        fontFamily: 'Degular',
      );

  static TextStyle get darkPurple10w700 => TextStyle(
        fontSize: _sp(10),
        fontWeight: FontWeight.w700,
        color: CustomColors.darkPurple,
        fontFamily: 'Degular',
      );

  static TextStyle get amber10w700 => TextStyle(
        fontSize: _sp(10),
        fontWeight: FontWeight.w700,
        color: const Color(0xFFFFB300),
        fontFamily: 'Degular',
      );

  static TextStyle get grey700_10w400 => TextStyle(
        fontSize: _sp(10),
        fontWeight: FontWeight.w400,
        color: const Color(0xFF616161),
        fontFamily: 'Degular',
      );
  static TextStyle get grey900_10w400 => TextStyle(
      fontSize: _sp(10),
      fontWeight: FontWeight.w400,
      color: const Color(0xFF212121),
      fontFamily: 'Degular',
    );
  static TextStyle get grey800_20w600 => TextStyle(
        fontSize: _sp(20),
        fontWeight: FontWeight.w600,
        color: const Color(0xFF424242),
        fontFamily: 'Degular',
      );

  static TextStyle get grey800_16w600 => TextStyle(
        fontSize: _sp(16),
        fontWeight: FontWeight.w600,
        color: const Color(0xFF424242),
        fontFamily: 'Degular',
      );

  static TextStyle get white70_12w500 => TextStyle(
        fontSize: _sp(12),
        fontWeight: FontWeight.w500,
        color: const Color(0xB2FFFFFF),
        fontFamily: 'Degular',
      );

  static TextStyle get white24w700 => TextStyle(
        fontSize: _sp(24),
        fontWeight: FontWeight.w700,
        color: CustomColors.whiteColor,
        fontFamily: 'Degular',
      );

  static TextStyle get white80_11w400 => TextStyle(
        fontSize: _sp(11),
        fontWeight: FontWeight.w400,
        color: const Color(0xCCFFFFFF),
        fontFamily: 'Degular',
      );

  static TextStyle get grey12w400 => TextStyle(
        fontSize: _sp(12),
        fontWeight: FontWeight.w400,
        color: CustomColors.textGreyColor,
        fontFamily: 'Degular',
      );

  static TextStyle get white10w600 => TextStyle(
        fontSize: _sp(10),
        fontWeight: FontWeight.w600,
        color: CustomColors.whiteColor,
        fontFamily: 'Degular',
      );

  static TextStyle get black16w700 => TextStyle(
        fontSize: _sp(16),
        fontWeight: FontWeight.w700,
        color: CustomColors.blackColor,
        fontFamily: 'Degular',
      );

  static TextStyle get grey700_12w400 => TextStyle(
        fontSize: _sp(12),
        fontWeight: FontWeight.w400,
        color: const Color(0xFF616161),
        fontFamily: 'Degular',
      );

  static TextStyle get red20w600 => TextStyle(
        fontSize: _sp(20),
        fontWeight: FontWeight.w600,
        color: const Color(0xFFF44336),
        fontFamily: 'Degular',
      );

  static TextStyle get red16w400 => TextStyle(
        fontSize: _sp(16),
        fontWeight: FontWeight.w400,
        color: const Color(0xFFD32F2F), // red.shade700
        fontFamily: 'Degular',
      );

  static TextStyle get pink22w600 => TextStyle(
        fontSize: _sp(22),
        fontWeight: FontWeight.w600,
        color: CustomColors.pinkColor,
        fontFamily: 'Degular',
      );
}
