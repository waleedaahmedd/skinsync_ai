import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:image_picker/image_picker.dart';
import '../../utills/color_constant.dart';
import '../../utills/custom_fonts.dart';

class MediaSourceSheet extends StatelessWidget {
  final bool isVideo;
  final Function(ImageSource) onSourceSelected;

  const MediaSourceSheet({
    super.key,
    required this.isVideo,
    required this.onSourceSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: context.h(20)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            isVideo ? "Select Video Source" : "Select Image Source",
            style: CustomFonts.black16w600,
          ),
          SizedBox(height: context.h(20)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildPickerOption(
                context: context,
                onTap: () {
                  Navigator.pop(context);
                  onSourceSelected(ImageSource.camera);
                },
                icon: Icons.camera_alt_rounded,
                label: "Camera",
              ),
              _buildPickerOption(
                context: context,
                onTap: () {
                  Navigator.pop(context);
                  onSourceSelected(ImageSource.gallery);
                },
                icon: Icons.photo_library_rounded,
                label: "Gallery",
              ),
            ],
          ),
          SizedBox(height: context.h(20)),
        ],
      ),
    );
  }

  Widget _buildPickerOption({
    required BuildContext context,
    required VoidCallback onTap,
    required IconData icon,
    required String label,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(context.r(15)),
            decoration: BoxDecoration(
              color: CustomColors.purpleColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: CustomColors.purpleColor, size: context.sp(30)),
          ),
          SizedBox(height: context.h(8)),
          Text(label, style: CustomFonts.black14w500),
        ],
      ),
    );
  }
}
