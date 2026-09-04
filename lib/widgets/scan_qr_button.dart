import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../screens/qr_scan_screen.dart';
import '../utils/color_constant.dart';
import '../utils/custom_fonts.dart';
import '../view_models/appointment_view_model.dart';
import 'circular_icon_button.dart';

class ScanQrButton extends ConsumerWidget {
  const ScanQrButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CircularIconButton(
      icon: Icon(
        Icons.qr_code_scanner_rounded,
        color: CustomColors.blackColor,
        size: context.sp(20),
      ),
      onTap: () async {
        final data = await Navigator.push<String?>(
          context,
          MaterialPageRoute(builder: (context) => const QrScanScreen()),
        );
        if (data == null) return;

        final response = await ref
            .read(appointmentProvider.notifier)
            .decodeQrCode(data);

        if (response == null) {
          // runSafely already routed the failure through onError, which
          // sets errorMessage + dismisses EasyLoading — surface it here.
          final message = ref.read(appointmentProvider).errorMessage ??
              'Could not check in with this QR code';
          EasyLoading.showError(message);
          return;
        }

        log("Checked in successfully via QR");
        if (!context.mounted) return;
        _showCheckInSuccessDialog(context, response.message);
      },
    );
  }

  void _showCheckInSuccessDialog(BuildContext context, String? message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(dialogContext.r(16)),
          ),
          content: Column(
            mainAxisSize: .min,
            children: [
              Icon(
                Icons.check_circle_rounded,
                color:Colors.green,
                size: dialogContext.sp(56),
              ),
              SizedBox(height: dialogContext.h(16)),
              Text(
                "Checked In",
                style: CustomFonts.black16w600.copyWith(
                  fontSize: dialogContext.sp(16),
                ),
              ),
              SizedBox(height: dialogContext.h(8)),
              Text(
                message ?? "You have been successfully checked in for this appointment.",
                textAlign: TextAlign.center,
                style: CustomFonts.grey13w400,
              ),
            ],
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(
                "OK",
                style: CustomFonts.black16w600.copyWith(
                  color: CustomColors.purpleColor,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}