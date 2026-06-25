import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skinsync_ai/utills/custom_fonts.dart';
import 'package:skinsync_ai/view_models/auth_view_model.dart';

import '../utills/color_constant.dart';

class AppBarWithActionIcon extends StatelessWidget
    implements PreferredSizeWidget {
  const AppBarWithActionIcon({super.key, this.action});

  @override
  Size get preferredSize => Size.fromHeight(100.h);

  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          children: [
            SizedBox(height: 12.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Consumer(
                    builder: (context, ref, _) {
                      final state = ref.watch(authViewModel);
                      final userDetails = state.authData?.user;
                      final name = userDetails?.name;

                      return Row(
                        children: [
                          // Optional Profile Image Avatar
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: CustomColors.purpleColor.withValues(
                                  alpha: 0.5,
                                ),
                                width: 2.w,
                              ),
                            ),
                            child: ClipOval(
                              child: CachedNetworkImage(
                                imageUrl: userDetails?.profileImageUrl ?? "",
                                height: 48.w,
                                width: 48.w,
                                fit: BoxFit.cover,
                                placeholder: (context, url) =>
                                    const CupertinoActivityIndicator(),
                                errorWidget: (context, url, error) => Container(
                                  height: 48.w,
                                  width: 48.w,
                                  color: Colors.grey.shade100,
                                  child: Icon(
                                    Icons.person_outline_rounded,
                                    size: 24.sp,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Hello, ${name ?? "Guest"}!',
                                  style: CustomFonts.black22w600,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                                SizedBox(height: 2.h),
                                Text(
                                  'Your skin health journey starts here.',
                                  style: CustomFonts.grey12w400,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                SizedBox(width: 12.w),
                action ?? const SizedBox.shrink(),
              ],
            ),
            const Spacer(),
            Divider(
              color: CustomColors.greyColor.withValues(alpha: 0.5),
              height: 1.h,
            ),
          ],
        ),
      ),
    );
  }
}
