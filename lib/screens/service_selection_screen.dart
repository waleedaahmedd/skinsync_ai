// import 'dart:io';
// import 'dart:ui';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
// import 'package:skinsync_ai/screens/ar_face_model_preview_screen.dart';
// import 'package:skinsync_ai/utills/color_constant.dart';
// import 'package:skinsync_ai/widgets/grey_container.dart';
// import 'package:skinsync_ai/widgets/service_type_button.dart';
//
// import '../utills/assets.dart';
// import '../utills/custom_fonts.dart';
// import '../view_models/face_scan_provider.dart';
//
// class ServiceSelectionScreen extends StatelessWidget {
//   ServiceSelectionScreen({super.key});
//   static const String routeName = '/ServiceSelectionScreen';
//
//   final List<String> skinServices = [
//     'Facial',
//     'Deep Cleanse',
//     'Anti-Aging',
//     'Hydrating',
//     'Brightening',
//     'Acne Care',
//     'Oxygen Facial',
//     'Collagen Boost',
//     'Microdermabrasion',
//     'Chemical Peel',
//     'Microneedling',
//     'Dermaplaning',
//     'LED Therapy',
//     'RF Tightening',
//     'Laser Resurfacing',
//     'Botox',
//     'Fillers',
//     'PRP Therapy',
//     'Body Scrub',
//     'Body Wrap',
//     'Back Facial',
//     'Hand & Foot',
//     'Skin Brightening',
//     'Scar Reduction',
//     'Mole Removal',
//     'Wart Removal',
//     'Skin Tag Removal',
//     'Pigmentation',
//     'Dark Spot Reduction',
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         fit: StackFit.expand,
//         children: [
//           Consumer(
//             builder: (_, ref, _) {
//               // Use watch instead of read to keep the provider alive
//               final image = ref.watch(faceScanProvider).capturedImage;
//               if (image == null) {
//                 return const SizedBox.shrink();
//               }
//               return Image.file(
//                 File(image.path),
//                 fit: BoxFit.cover,
//                 width: double.infinity,
//                 height: context.h(326),
//               );
//             },
//           ),
//           Positioned(
//             top: context.h(30),
//             left: context.w(16),
//             right: context.w(16),
//             child: SafeArea(
//               child: Row(
//                 children: [
//                   GreyContainer(
//                     icon: Icons.arrow_back,
//                     shape: BoxShape.circle,
//                     onTap: () {
//                       Navigator.pop(context);
//                     },
//                   ),
//                   SizedBox(width: context.w(16)),
//                   ServiceTypeButton(
//                     icon: Image.asset(PngAssets.syringe, width: context.w(21)),
//                     text: "Dermal Fillers",
//                     selected: true,
//                     frosted: true,
//                   ),
//                   SizedBox(width: context.w(10)),
//                   ServiceTypeButton(
//                     icon: Image.asset(PngAssets.hand, width: context.w(21)),
//                     text: "Botox",
//                     selected: false,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//
//           Align(
//             alignment: Alignment.bottomCenter,
//             child: SizedBox(
//               height: context.h(440),
//               child: ClipRRect(
//                 borderRadius: BorderRadius.only(
//                   topLeft: Radius.circular(context.r(30)),
//                   topRight: Radius.circular(context.r(30)),
//                 ),
//                 child: BackdropFilter(
//                   filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
//
//                   child: Container(
//                     // height: context.h(440),
//                     padding: EdgeInsets.only(
//                       top: context.h(22),
//                       left: context.h(30),
//                       right: context.h(30),
//                     ),
//                     width: double.infinity,
//                     decoration: BoxDecoration(
//                       color: Colors.white.withOpacity(0.3),
//                       borderRadius: const BorderRadius.only(
//                         topLeft: Radius.circular(30),
//                         topRight: Radius.circular(30),
//                       ),
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         SingleChildScrollView(
//                           scrollDirection: Axis.horizontal,
//                           child: Row(
//                             children: [
//                               ...List.generate(skinServices.length, (index) {
//                                 return Container(
//                                   margin: EdgeInsets.only(right: context.w(10)),
//                                   padding: EdgeInsets.symmetric(
//                                     horizontal: context.w(14),
//                                   ),
//                                   alignment: Alignment.center,
//                                   decoration: BoxDecoration(
//                                     color: index.isEven
//                                         ? Colors.transparent
//                                         : CustomColors.purpleColor,
//                                     borderRadius: BorderRadius.circular(context.r(15)),
//                                   ),
//                                   height: context.h(85),
//                                   width: context.w(76),
//                                   child: Column(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       Image.asset(PngAssets.splashLogo),
//                                       Text(
//                                         skinServices[index],
//                                         style: index.isEven
//                                             ? CustomFonts.black14w500.copyWith(
//                                                 overflow: TextOverflow.ellipsis,
//                                               )
//                                             : CustomFonts.white14w500.copyWith(
//                                                 overflow: TextOverflow.ellipsis,
//                                               ),
//                                       ),
//                                     ],
//                                   ),
//                                 );
//                               }),
//                             ],
//                           ),
//                         ),
//
//                         SizedBox(height: context.h(25)),
//                         Text('Area Selection', style: CustomFonts.black18w600),
//                         SizedBox(height: context.h(10)),
//                         DropdownButtonFormField(
//                           value: skinServices[0],
//                           items: skinServices
//                               .map(
//                                 (e) => DropdownMenuItem(
//                                   value: e,
//                                   child: Text(
//                                     e,
//                                     style: CustomFonts.black16w500,
//                                   ),
//                                 ),
//                               )
//                               .toList(),
//                           onChanged: (_) {},
//                           decoration: InputDecoration(
//                             fillColor: CustomColors.whiteColor,
//                             filled: true,
//                             border: OutlineInputBorder(
//                               borderSide: BorderSide(
//                                 color: CustomColors.blackColor,
//                               ),
//                               borderRadius: BorderRadius.circular(context.r(12)),
//                             ),
//                           ),
//                         ),
//                         SizedBox(height: context.h(25)),
//                         Text(
//                           'Select no of syringes',
//                           style: CustomFonts.black18w600,
//                         ),
//                         SizedBox(height: context.h(10)),
//                         DropdownButtonFormField(
//                           value: 1,
//                           items: List.generate(10, (index) => index + 1)
//                               .map(
//                                 (e) => DropdownMenuItem(
//                                   value: e,
//                                   child: Text(
//                                     e.toString(),
//                                     style: CustomFonts.black16w500,
//                                   ),
//                                 ),
//                               )
//                               .toList(),
//                           onChanged: (_) {},
//                           decoration: InputDecoration(
//                             fillColor: CustomColors.whiteColor,
//                             filled: true,
//                             border: OutlineInputBorder(
//                               borderSide: BorderSide(
//                                 color: CustomColors.blackColor,
//                               ),
//                               borderRadius: BorderRadius.circular(context.r(12)),
//                             ),
//                           ),
//                         ),
//                         SizedBox(height: context.h(22)),
//                         SizedBox(
//                           width: double.infinity,
//                           child: ElevatedButton(
//                             onPressed: () {
//                               Navigator.pushNamed(
//                                 context,
//                                 ArFaceModelPreviewScreen.routeName,
//                               );
//                             },
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: CustomColors.blackColor,
//                               padding: EdgeInsets.symmetric(
//                                 horizontal: context.w(100),
//                                 vertical: context.h(15),
//                               ),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(context.r(30)),
//                               ),
//                             ),
//                             child: Text(
//                               'Proceed',
//                               style: CustomFonts.white18w600,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
