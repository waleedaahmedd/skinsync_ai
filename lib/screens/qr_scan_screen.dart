import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../widgets/custom_app_bar.dart';

class QrScanScreen extends StatefulWidget {
  const QrScanScreen({super.key});

  @override
  State<QrScanScreen> createState() => _QrScanScreenState();
}

class _QrScanScreenState extends State<QrScanScreen> {
  final _controller = MobileScannerController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Scan QR Code', showTitle: true),
      body: MobileScanner(
        controller: _controller,
        onDetect: (capture) {
          final qrData = capture.barcodes.firstOrNull?.rawValue;
          if (qrData != null) {
            _controller.pause();
            Navigator.pop(context, qrData);
          }
        },
        onDetectError: (e, s) {
          log(e.toString(), stackTrace: s);
        },
      ),
    );
  }
}
