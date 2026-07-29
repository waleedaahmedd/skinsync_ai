import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../utills/custom_fonts.dart';

class ReelContentOverlay extends StatelessWidget {
  final String userName;
  final String userProfileImage;
  final String? caption;
  final String? musicTitle;

  const ReelContentOverlay({
    super.key,
    required this.userName,
    required this.userProfileImage,
    this.caption,
    this.musicTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 18.r,
              backgroundImage: NetworkImage(userProfileImage),
            ),
            SizedBox(width: 10.w),
            Text(
              userName,
              style: CustomFonts.white16w600,
            ),
            SizedBox(width: 10.w),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white),
                borderRadius: BorderRadius.circular(4.r),
              ),
              child: Text(
                'Follow',
                style: CustomFonts.white12w600,
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        if (caption != null)
          Text(
            caption!,
            style: CustomFonts.white14w400,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        SizedBox(height: 8.h),
        if (musicTitle != null)
          Row(
            children: [
              Icon(Icons.music_note_rounded, size: 14.sp, color: Colors.white),
              SizedBox(width: 4.w),
              Expanded(
                child: Text(
                  musicTitle!,
                  style: CustomFonts.white12w400,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
      ],
    );
  }
}
