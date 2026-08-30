import 'package:material_ui/material_ui.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:iconsax/iconsax.dart';

import '../../utils/custom_fonts.dart';
import '../custom_button.dart';

class DeleteAccountDialog extends StatelessWidget {
  const DeleteAccountDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink(); // Placeholder if imported somewhere as widget
  }
}

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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(context.r(24)),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: context.w(24),
            vertical: context.h(32),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Beautiful Red Warning Badge Icon
              Container(
                height: context.w(72),
                width: context.w(72),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red.shade50,
                ),
                child: Center(
                  child: Icon(
                    Iconsax.user_remove,
                    size: context.sp(32),
                    color: const Color(0xffD72547),
                  ),
                ),
              ),
              SizedBox(height: context.h(24)),

              // Title
              Text(
                "Delete Account?",
                textAlign: TextAlign.center,
                style: CustomFonts.black20w600,
              ),
              SizedBox(height: context.h(12)),

              // Subtitle
              Text(
                "Your account will be deleted within 7 days if you don't use this app. Are you sure you want to proceed?",
                textAlign: TextAlign.center,
                style: CustomFonts.textGrey14w400,
              ),
              SizedBox(height: context.h(28)),

              // Delete Action Button
              CustomButton(
                onPressed: () {
                  Navigator.pop(context);
                  onSuccess();
                },
                backgroundColor: const Color(0xffD72547),
                text: "Delete",
              ),
              SizedBox(height: context.h(12)),

              // Cancel Button
              SizedBox(
                width: double.infinity,
                height: context.h(52),
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets
                        .zero, // Zero padding prevents vertical text clipping
                    side: BorderSide(color: Colors.grey.shade300),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(context.r(26)),
                    ),
                  ),
                  child: Text(
                    "Cancel",
                    style: CustomFonts.black14w600.copyWith(
                      color: Colors.black54,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
