// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
// import 'package:skinsync_ai/utills/assets.dart';
// import 'package:skinsync_ai/utills/color_constant.dart';
// import 'package:skinsync_ai/utills/custom_fonts.dart';
//
//
// void loginBottomSheet(BuildContext context) {
//   showModalBottomSheet(
//     backgroundColor: Colors.transparent,
//     constraints: BoxConstraints(minWidth: double.infinity),
//     context: context,
//     isScrollControlled: true,
//
//     shape: RoundedRectangleBorder(
//       borderRadius: BorderRadius.vertical(top: Radius.circular(context.r(20))),
//     ),
//     builder: (context) {
//       return Container(
//        color: Colors.transparent,
//         padding: EdgeInsets.only(
//           top: context.h(10),
//           left: context.w(10),
//           right: context.w(10),
//           bottom: MediaQuery.viewInsetsOf(context).bottom,
//         ),
//         child: Container(
//
//           decoration: BoxDecoration(
//               color: Colors.white,
//             borderRadius: BorderRadius.only(
//               topLeft: Radius.circular(context.r(44)),
//               topRight: Radius.circular(context.r(44)),
//               bottomLeft: Radius.circular(context.r(55)),
//               bottomRight: Radius.circular(context.r(55)),
//               )
//           ),
//           padding: EdgeInsets.symmetric(horizontal: context.w(20),vertical: context.h(28)),
//           child: SingleChildScrollView(
//
//             child:
//             //  Column(
//
//             //   crossAxisAlignment: CrossAxisAlignment.start,
//             //   children: [
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//
//                   children: [
//
//                     Text(
//                       "Get Started",
//                       style: TextStyle(
//                         fontWeight: FontWeight.w600,
//                         fontSize: context.sp(30),
//                         color: Colors.black,
//                       ),
//                     ),
//
//                  SizedBox(height: context.h(4),),
//
//                     Text(
//
//                       "Sign in to continue your journey.\nAccess personalized care and exclusive features.",
//                       style: TextStyle(
//                         fontSize: context.sp(16),
//                         fontWeight: FontWeight.w400,
//                         color: Color(0xff494949)
//                       ),
//                     ),
//                     SizedBox(height: context.h(18)),
//                     SizedBox(
//                       width: double.infinity,
//                       child: Container(
//                         padding: EdgeInsets.symmetric(vertical: context.h(16)),
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(context.r(10)),
//                           color: Colors.black),
//                       child: Center(child: Text("Continue With Phone",style:CustomFonts.white18w600,)),
//                         ),
//                     ),
//                      SizedBox(height: context.h(10)),
//                       SizedBox(
//                       width: double.infinity,
//                       child: Container(
//                         padding: EdgeInsets.symmetric(vertical: context.h(16)),
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(context.r(10)),
//                           color:CustomColors.greyColor
//                           ),
//                       child: Center(child: Text("Continue With Phone",style:CustomFonts.black18w600,)),
//                         ),
//                     ),
//                     SizedBox(height: context.h(10),),
//                     Row(children: [
//                       Expanded(
//
//                       child: Container(
//                         padding: EdgeInsets.symmetric(vertical: context.h(16)),
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(context.r(10)),
//                           color:CustomColors.greyColor
//                           ),
//                       child: Center(
//                         child: Image.asset(
//                           PngAssets.google,
//                           height: context.h(32),
//                           width: context.w(32),
//                           fit: BoxFit.contain,
//                         ),
//                       ),
//                         ),
//                     ),
//                     SizedBox(width: 8,),
//                      Expanded(
//
//                       child: Container(
//                         padding: EdgeInsets.symmetric(vertical: context.h(16)),
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(context.r(10)),
//                           color:CustomColors.greyColor
//                           ),
//                       child: Center(
//                         child:Image.asset(
//                           PngAssets.apple,
//                           height: context.h(32),
//                           width: context.w(32),
//                           fit: BoxFit.contain,
//                         ),
//                       ),
//                         ),
//                     ),
//                     ],),
//
//
//
//                     SizedBox(height: context.h(30)),
//                   ],
//                 ),
//                 // Drag handle
//                 // Center(
//                 //   child: Container(
//                 //     height: context.h(5),
//                 //     width: context.w(48),
//                 //     margin: EdgeInsets.only(bottom: context.h(30)),
//                 //     decoration: BoxDecoration(
//                 //       color: Color(0xffCDCFD0),
//                 //       borderRadius: BorderRadius.circular(context.r(100)),
//                 //     ),
//                 //   ),
//                 // ),
//
//                 // Review text
//
//                 // Submit button
//             //  Row(
//             //         children: [
//             //           Expanded(
//             //             child: GestureDetector(
//             //               onTap: () {
//             //                 Navigator.pop(context);
//             //               },
//             //               child: Container(
//             //                 padding: EdgeInsets.symmetric(
//             //                   // vertical: context.h(19),
//             //                   horizontal: context.w(12),
//             //                 ),
//             //                 decoration: BoxDecoration(
//             //                   borderRadius: BorderRadius.circular(context.r(10)),
//             //                   border: Border.all(
//             //                     color: Colors.black,
//             //                     width: context.w(2),
//             //                   ),
//             //                   color: Colors.transparent,
//             //                 ),
//             //                 child: Center(
//             //                   child: Text(
//             //                     "No, Go back",
//             //                     style: TextStyle(
//             //                       height: 0,
//             //                       fontSize: context.sp(15),
//             //                       fontWeight: FontWeight.w600,
//             //                     ),
//             //                   ),
//             //                 ),
//             //               ),
//             //             ),
//             //           ),
//             //           SizedBox(width: context.w(16)),
//             //           Expanded(
//             //             child: GestureDetector(
//             //               onTap: () {
//             //                 Navigator.pop(context);
//             //               },
//             //               child: Container(
//             //                 padding: EdgeInsets.symmetric(
//             //                   vertical: context.h(19),
//             //                   horizontal: context.w(12),
//             //                 ),
//             //                 decoration: BoxDecoration(
//             //                   borderRadius: BorderRadius.circular(context.r(10)),
//
//             //                   color: Color(0xffD72547),
//             //                 ),
//             //                 child: Center(
//             //                   child: Text(
//             //                     "Cancel Booking",
//             //                     style: TextStyle(
//             //                       height: 0,
//             //                       fontSize: context.sp(15),
//             //                       fontWeight: FontWeight.w600,
//             //                       color: Colors.white,
//             //                     ),
//             //                   ),
//             //                 ),
//             //               ),
//             //             ),
//             //           ),
//             //         ],
//             //       ),
//
//                 // SizedBox(height: context.h(20)),
//             //   ],
//             // ),
//           ),
//         ),
//       );
//     },
//   );
// }
