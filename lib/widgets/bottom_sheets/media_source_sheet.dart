import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
      padding: EdgeInsets.symmetric(vertical: 20.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            isVideo ? "Select Video Source" : "Select Image Source",
            style: CustomFonts.black16w600,
          ),
          SizedBox(height: 20.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildPickerOption(
                onTap: () {
                  Navigator.pop(context);
                  onSourceSelected(ImageSource.camera);
                },
                icon: Icons.camera_alt_rounded,
                label: "Camera",
              ),
              _buildPickerOption(
                onTap: () {
                  Navigator.pop(context);
                  onSourceSelected(ImageSource.gallery);
                },
                icon: Icons.photo_library_rounded,
                label: "Gallery",
              ),
            ],
          ),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }

  Widget _buildPickerOption({
    required VoidCallback onTap,
    required IconData icon,
    required String label,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(15.r),
            decoration: BoxDecoration(
              color: CustomColors.purpleColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: CustomColors.purpleColor, size: 30.sp),
          ),
          SizedBox(height: 8.h),
          Text(label, style: CustomFonts.black14w500),
        ],
      ),
    );
  }
}
