import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import '../utills/custom_fonts.dart';

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
        SizedBox(height: 10.h),
        Stack(
          children: [
            Container(
              height: 150.h,
              width: 200.w,
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Center(
                child: Icon(Icons.play_circle_fill, size: 50.sp, color: Colors.white70),
              ),
            ),
            Positioned(
              top: 10.h,
              right: 10.w,
              child: GestureDetector(
                onTap: onRemove,
                child: Container(
                  padding: EdgeInsets.all(4.r),
                  decoration: const BoxDecoration(
                    color: Colors.black54,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.close, color: Colors.white, size: 16.sp),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
