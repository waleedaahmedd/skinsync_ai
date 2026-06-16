import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../utills/custom_fonts.dart';
import '../view_models/auth_view_model.dart';

import '../utills/color_constant.dart';

class AppBarWithActionIcon extends StatelessWidget
    implements PreferredSizeWidget {
  const AppBarWithActionIcon({super.key, this.action});
  @override
  Size get preferredSize => Size.fromHeight(110.h);

  final Widget? action;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),

        child: Column(
          children: [
            SizedBox(height: 17.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Consumer(
                    builder: (context, ref, _) {
                      final state = ref.watch(authViewModel);
                      final name = state.authResponse?.data?.user?.name;
                      // final address = state.addressData?.address;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hello, ${name ?? ''}!',
                            style: CustomFonts.black30w600,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Your journey to radiant skin starts now.',
                            style: CustomFonts.grey18w400,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          // Text(address ?? 'N/A', style: CustomFonts.grey18w400,overflow: TextOverflow.ellipsis,maxLines: 1,),
                        ],
                      );
                    },
                  ),
                ),
                SizedBox(width: 40.w),
                ?action,
              ],
            ),
            const Spacer(),
            const Divider(color: CustomColors.greyColor),
          ],
        ),
      ),
    );
  }
}
