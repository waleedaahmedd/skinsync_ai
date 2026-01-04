import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:iconsax/iconsax.dart';
import 'package:skinsync_ai/utills/color_constant.dart';

void showLogoutDialog({
  required BuildContext screenContext,
  required String desc,
  required Function onSuccess,
}) {
  showDialog(
    context: screenContext,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 23.0),
          child: Container(
            height: 466.h,
            width: 342.w,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 40.h),
                Transform.flip(
                  flipX: true,
                  flipY: true,
                  child: Icon(
                    Iconsax.logout,
                    size: 120.sp,
                    color: Color(0xffD72547),
                  ),
                ),
                SizedBox(height: 30.h),
                // Outer circle with red color and alpha 0.2
                Text(
                  "Logout?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w600,
                    color:CustomColors.blackColor,
                  ),
                ),
                SizedBox(height: 18.h),
                Text(
                  "Are you sure want to logout from the app?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                    color: CustomColors.blackColor,
                  ),
                ),
                SizedBox(height: 30.h),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                    onSuccess();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xffD72547),

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                    child: Text(
                      "Logout",
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 19.5.h),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color:CustomColors.greyColor,
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(width: 1.w, color: Colors.grey[200]!),
                    ),
                    child: Text(
                      "Cancel",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                        color: CustomColors.blackColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
