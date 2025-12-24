import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utills/custom_fonts.dart';
import '../../view_models/face_scan_provider.dart';

class FaceScanningCompleteScreen extends StatelessWidget {
  const FaceScanningCompleteScreen({super.key});
  static const String routeName = '/FaceScanningCompleteScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                Consumer(
                  builder: (context, ref, _) {
                    final image = ref.watch(
                      faceScanProvider.select((state) => state.capturedImage),
                    );
                    return Image.file(File(image!.path), height: 300.h);
                  },
                ),
                Text("Before", style: CustomFonts.black18w600),
              ],
            ),

            Column(
              children: [
                Consumer(
                  builder: (context, ref, _) {
                    final image = ref.watch(
                      faceScanProvider.select((state) => state.capturedImage),
                    );
                    return Image.file(File(image!.path), height: 300.h);
                  },
                ),
                Text("After", style: CustomFonts.black18w600),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
