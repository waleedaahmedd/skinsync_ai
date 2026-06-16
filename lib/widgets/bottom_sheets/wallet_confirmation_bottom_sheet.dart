import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../utills/color_constant.dart';
import '../../utills/custom_fonts.dart';

class WalletConfirmationBottomSheet extends StatelessWidget {
  final VoidCallback onConfirm;

  const WalletConfirmationBottomSheet({super.key, required this.onConfirm});

  static void show(BuildContext context, {required VoidCallback onConfirm}) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => WalletConfirmationBottomSheet(onConfirm: onConfirm),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Wallet Confirmation", style: CustomFonts.black20w600),
              IconButton(
                icon: const Icon(Icons.close, color: CustomColors.blackColor),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: CustomColors.lightBlueColor.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: CustomColors.lightBlueColor.withValues(alpha: 0.2)),
            ),
            child: Column(
              children: [
                Icon(Icons.account_balance_wallet_outlined, size: 40.sp, color: CustomColors.darkPurple),
                SizedBox(height: 15.h),
                Text(
                  "Please add \$100 to your wallet to proceed. This ensures that once the clinic is onboarded, your appointment and related charges can be automatically processed and updated.",
                  style: CustomFonts.black16w400.copyWith(height: 1.5),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          SizedBox(height: 30.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                onConfirm();
              },
              child: const Text("Add \$100 & Proceed"),
            ),
          ),
          SizedBox(height: 10.h),
        ],
      ),
    );
  }
}
