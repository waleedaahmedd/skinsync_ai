import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../../utils/color_constant.dart';
import '../../utils/custom_fonts.dart';
import '../custom_button.dart';

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
      padding: EdgeInsets.all(context.w(20)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(context.r(20)),
          topRight: Radius.circular(context.r(20)),
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
          SizedBox(height: context.h(20)),
          Container(
            padding: EdgeInsets.all(context.w(20)),
            decoration: BoxDecoration(
              color: CustomColors.lightBlueColor.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(context.r(16)),
              border: Border.all(
                color: CustomColors.lightBlueColor.withValues(alpha: 0.2),
              ),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.account_balance_wallet_outlined,
                  size: context.sp(40),
                  color: CustomColors.darkPurple,
                ),
                SizedBox(height: context.h(15)),
                Text(
                  "Please add \$100 to your wallet to proceed. This ensures that once the clinic is onboarded, your appointment and related charges can be automatically processed and updated.",
                  style: CustomFonts.black16w400.copyWith(height: 1.5),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          SizedBox(height: context.h(30)),
          SizedBox(
            width: double.infinity,
            child: CustomButton(
              onPressed: () {
                Navigator.pop(context);
                onConfirm();
              },
              text: "Add \$100 & Proceed",
            ),
          ),
          SizedBox(height: context.h(10)),
        ],
      ),
    );
  }
}
