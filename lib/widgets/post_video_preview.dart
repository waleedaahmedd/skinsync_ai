import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:image_picker/image_picker.dart';
import '../utils/custom_fonts.dart';

class PostVideoPreview extends StatelessWidget {
  final XFile? video;
  final VoidCallback onRemove;

  const PostVideoPreview({
    super.key,
    required this.video,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    if (video == null) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Selected Video", style: CustomFonts.black14w600),
        SizedBox(height: context.h(10)),
        Stack(
          children: [
            Container(
              height: context.h(150),
              width: context.w(200),
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(context.r(12)),
              ),
              child: Center(
                child: Icon(Icons.play_circle_fill, size: context.sp(50), color: Colors.white70),
              ),
            ),
            Positioned(
              top: context.h(10),
              right: context.w(10),
              child: GestureDetector(
                onTap: onRemove,
                child: Container(
                  padding: EdgeInsets.all(context.r(4)),
                  decoration: const BoxDecoration(
                    color: Colors.black54,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.close, color: Colors.white, size: context.sp(16)),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
