// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
//
// import '../../utils/custom_fonts.dart';
// import '../../view_models/treatment_view_model.dart';
//
// class FaceScanningCompleteScreen extends StatelessWidget {
//   const FaceScanningCompleteScreen({super.key});
//   static const String routeName = '/FaceScanningCompleteScreen';
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: [
//             Column(
//               children: [
//                 Consumer(
//                   builder: (context, ref, _) {
//                     final image = ref.watch(
//                       treatmentViewModel.select((state) => state.capturedImage),
//                     );
//                     return Image.file(File(image!.path), height: context.h(300));
//                   },
//                 ),
//                 Text("Before", style: CustomFonts.black18w600),
//               ],
//             ),
//
//             Column(
//               children: [
//                 Consumer(
//                   builder: (context, ref, _) {
//                     final image = ref.watch(
//                       treatmentViewModel.select((state) => state.capturedImage),
//                     );
//                     return Image.file(File(image!.path), height: context.h(300));
//                   },
//                 ),
//                 Text("After", style: CustomFonts.black18w600),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
