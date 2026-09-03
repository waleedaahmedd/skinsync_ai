import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import '../screens/qr_scan_screen.dart';
import '../utils/color_constant.dart';
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
        if (data != null) {
          final success = await ref
              .read(appointmentProvider.notifier)
              .decodeQrCode(data);
          if (success ?? false) {
            log("QR code decoded successfully");
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (_) =>
            //         AppointmentDetailScreen(appointment: AppointmentItem()),
            //   ),
            // );
          }
        }
      },
    );
  }
}
