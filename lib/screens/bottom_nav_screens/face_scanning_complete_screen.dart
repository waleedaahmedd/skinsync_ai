import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
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
            Column(children: [
              Consumer<FaceScanProvider>(builder:   (context, provider, __) {
                return Image.file(
                  File(provider.capturedImage!.path),
                  height: 300.h,
                );
              }),
              Text("Before", style:  CustomFonts.black18w600,)
            ],),
            
            Column(children: [
              Consumer<FaceScanProvider>(builder:   (context, provider, __) {
                return Image.file(
                  File(provider.capturedImage!.path),
                 height: 300.h,
                );
              }),
                          Text("After", style:  CustomFonts.black18w600,)
            ],)
            
          ],
        ),
      ),
    );
  }
}