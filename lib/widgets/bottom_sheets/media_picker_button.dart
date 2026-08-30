import 'package:material_ui/material_ui.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import '../../utils/custom_fonts.dart';

class MediaPickerButton extends StatelessWidget {
  final VoidCallback onTap;
  final IconData icon;
  final String label;
  final Color color;

  const MediaPickerButton({
    super.key,
    required this.onTap,
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: context.w(16), vertical: context.h(10)),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(context.r(12)),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: context.sp(20)),
            SizedBox(width: context.w(8)),
            Text(
              label,
              style: CustomFonts.black14w600.copyWith(color: color, fontSize: context.sp(13)),
            ),
          ],
        ),
      ),
    );
  }
}
