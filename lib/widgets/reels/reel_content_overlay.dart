import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

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
              radius: context.r(18),
              backgroundImage: NetworkImage(userProfileImage),
            ),
            SizedBox(width: context.w(10)),
            Text(userName, style: CustomFonts.white16w600),
            // SizedBox(width: context.w(10)),
            // Container(
            //   padding: EdgeInsets.symmetric(horizontal: context.w(8), vertical: context.h(2)),
            //   decoration: BoxDecoration(
            //     border: Border.all(color: Colors.white),
            //     borderRadius: BorderRadius.circular(context.r(4)),
            //   ),
            //   child: Text(
            //     'Follow',
            //     style: CustomFonts.white12w600,
            //   ),
            // ),
          ],
        ),
        SizedBox(height: context.h(12)),
        if (caption != null)
          Text(
            caption!,
            style: CustomFonts.white14w400,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        SizedBox(height: context.h(8)),
        if (musicTitle != null)
          Row(
            children: [
              Icon(
                Icons.music_note_rounded,
                size: context.sp(14),
                color: Colors.white,
              ),
              SizedBox(width: context.w(4)),
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
