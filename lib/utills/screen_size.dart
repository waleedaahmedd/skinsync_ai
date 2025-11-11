import 'dart:developer';

import 'package:flutter/material.dart';

Size getDesignSize({required BuildContext context}) {
  // Get the actual screen size
  final window = View.of(context);
  final size = window.physicalSize / window.devicePixelRatio;
  // Return appropriate design size based on screen width
  if (size.width >= 1200) {
    log('LARGE: ${size.width}');
    return Size(1200, 1600);
    // Large tablets/Desktop
  } else if (size.width >= 800) {
    log('MEDIUM: ${size.width}');
    return Size(768, 1024); // Tablets
  } else if (size.width >= 600) {
    log('SMALL: ${size.width}');
    return Size(600, 900); // Small tablets
  } else {
    log('DEFAULT: ${size.width}');
    return const Size(393, 852);
  }
}
