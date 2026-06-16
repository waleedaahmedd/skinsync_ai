import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import '../../utills/color_constant.dart';

void showDeleteAccountDialog({
  required BuildContext screenContext,
  required Function onSuccess,
}) {
  showDialog(
    context: screenContext,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Colors.white,
        insetPadding: EdgeInsets.symmetric(horizontal: 20.w),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: 0.8.sh),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 23.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 40.h),
                  Icon(
                    Iconsax.user_remove,
                    size: 100.sp,
                    color: const Color(0xffD72547),
                  ),
                  SizedBox(height: 30.h),
                  Text(
                    "Delete Account?",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600,
                      color: CustomColors.blackColor,
                    ),
                  ),
                  SizedBox(height: 18.h),
                  Text(
                    "Your account will be deleted within 7 days if you don't use this app. Are you sure?",
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
                        Navigator.pop(context);
                        onSuccess();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xffD72547),
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                      ),
                      child: Text(
                        "Delete",
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 15.h),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: CustomColors.greyColor,
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(
                          width: 1.w,
                          color: Colors.grey[200]!,
                        ),
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
                  SizedBox(height: 30.h),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}
