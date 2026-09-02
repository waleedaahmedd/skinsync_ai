import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../utils/custom_fonts.dart';
import 'app_network_image.dart';

void showStickyTooltip({
  required BuildContext context,
  required String title,
  String? description,
  String? imageUrl,
}) {
  final String? validDesc =
      (description != null && description.trim().isNotEmpty)
          ? description.trim()
          : null;
  final String? validImg =
      (imageUrl != null && imageUrl.trim().isNotEmpty)
          ? imageUrl.trim()
          : null;

  if (validDesc == null && validImg == null) return;

  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'DismissTooltip',
    barrierColor: Colors.black.withValues(alpha: 0.35),
    transitionDuration: const Duration(milliseconds: 150),
    pageBuilder: (context, animation, secondaryAnimation) {
      return SafeArea(
        child: Stack(
          children: [
            // Barrier tap handler (tap anywhere outside to dismiss)
            GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              behavior: HitTestBehavior.opaque,
              child: const SizedBox.expand(),
            ),

            // Tooltip Content Card
            Center(
              child: Material(
                color: Colors.transparent,
                child: Container(
                  width: 0.85.sw,
                  margin: EdgeInsets.symmetric(horizontal: context.w(24)),
                  padding: EdgeInsets.all(context.w(16)),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.92),
                    borderRadius: BorderRadius.circular(context.r(16)),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.2),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.3),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (title.isNotEmpty) ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                title,
                                style: CustomFonts.white16w600,
                              ),
                            ),
                            GestureDetector(
                              onTap: () => Navigator.of(context).pop(),
                              child: Icon(
                                Icons.close_rounded,
                                color: Colors.white70,
                                size: context.sp(20),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: context.h(12)),
                      ],
                      if (validImg != null) ...[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(context.r(10)),
                          child: AppNetworkImage(
                            imageUrl: validImg,
                            width: double.infinity,
                            height: context.h(160),
                            fit: BoxFit.cover,
                            errorIcon: Icons.broken_image,
                          ),
                        ),
                        if (validDesc != null) SizedBox(height: context.h(12)),
                      ],
                      if (validDesc != null)
                        Text(
                          validDesc,
                          style: CustomFonts.white14w400.copyWith(
                            height: 1.4,
                            color: Colors.white.withValues(alpha: 0.9),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.92, end: 1.0).animate(
            CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
          ),
          child: child,
        ),
      );
    },
  );
}
