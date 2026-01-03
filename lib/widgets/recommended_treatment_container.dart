// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:skinsync_ai/screens/treatment_detail_screen.dart';
// import 'package:skinsync_ai/utills/assets.dart';
// import 'package:skinsync_ai/utills/custom_fonts.dart';
//
// class RecommendedTreatmentContainer extends StatelessWidget {
//   final String treatmentImage;
//   final String treatmentName;
//   const RecommendedTreatmentContainer({
//     super.key,
//     required this.treatmentImage,
//     required this.treatmentName,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap:(){
//         Navigator.pushNamed(context,TreatmentDetailScreen.routeName);
//       },
//       child: Container(
//         height: 299.h,
//         width: 279.w,
//         padding: EdgeInsets.only(bottom: 20.w),
//         decoration: BoxDecoration(
//           image: DecorationImage(
//             image: AssetImage(treatmentImage),
//             fit: BoxFit.fill,
//           ),
//           borderRadius: BorderRadius.circular(10.r),
//         ),
//         child: Align(
//           alignment: Alignment.bottomCenter,
//           child: Container(
//             padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 8.h),
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(50.r),
//               color: Colors.transparent.withValues(alpha: 0.2),
//             ),
//             child: Text(treatmentName, style: CustomFonts.white14w600),
//           ),
//         ),
//       ),
//     );
//   }
// }
