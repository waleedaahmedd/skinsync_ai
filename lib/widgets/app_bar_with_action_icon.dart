import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import '../utils/custom_fonts.dart';
import '../view_models/auth_view_model.dart';

import '../utils/color_constant.dart';

class AppBarWithActionIcon extends StatelessWidget
    implements PreferredSizeWidget {
  const AppBarWithActionIcon({super.key, this.action});

  @override
  Size get preferredSize =>
      Size.fromHeight(ScreenUtilPlus().setHeight(100));

  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: context.w(24)),
        child: Column(
          children: [
            SizedBox(height: context.h(12)),
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
                                width: context.w(2),
                              ),
                            ),
                            child: ClipOval(
                              child: CachedNetworkImage(
                                imageUrl: userDetails?.profileImageUrl ?? "",
                                height: context.w(48),
                                width: context.w(48),
                                fit: BoxFit.cover,
                                placeholder: (context, url) =>
                                    const CupertinoActivityIndicator(),
                                errorWidget: (context, url, error) => Container(
                                  height: context.w(48),
                                  width: context.w(48),
                                  color: Colors.grey.shade100,
                                  child: Icon(
                                    Icons.person_outline_rounded,
                                    size: context.sp(24),
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: context.w(12)),
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
                                SizedBox(height: context.h(2)),
                                Text(
                                  'Your aesthetic journey starts here.',
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
                SizedBox(width: context.w(12)),
                action ?? const SizedBox.shrink(),
              ],
            ),
            const Spacer(),
            Divider(
              color: CustomColors.greyColor.withValues(alpha: 0.5),
              height: context.h(1),
            ),
          ],
        ),
      ),
    );
  }
}
