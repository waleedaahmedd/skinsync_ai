// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
// import 'package:skinsync_ai/screens/bottom_nav_screens/treatments_screen.dart';
// import 'package:skinsync_ai/screens/treatment_sub_area_screen.dart';
// import 'package:skinsync_ai/screens/treatment_detail_screen.dart';
// import 'package:skinsync_ai/utills/color_constant.dart';
// import 'package:skinsync_ai/utills/custom_fonts.dart';
// import 'package:skinsync_ai/view_models/treatment_view_model.dart';
// import 'package:skinsync_ai/widgets/fillter_container.dart';
//
// import '../models/dummy_list_model.dart';
// import '../view_models/checkout_view_model.dart';
// import '../widgets/custom_app_bar.dart';
// import '../widgets/custom_grid_view_tile.dart';
//
// class TreatmentAreaScreen extends StatefulWidget {
//   static const String routeName = '/TreatmentAreaScreen';
//   const TreatmentAreaScreen({super.key});
//
//   @override
//   State<TreatmentAreaScreen> createState() => _TreatmentAreaScreenState();
//
//   // Static method to show as bottom sheet
//   static Future<void> show(BuildContext context) {
//     return showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       enableDrag: false, // Disable drag on the modal itself (we use DraggableScrollableSheet)
//       isDismissible: true,
//       useSafeArea: true,
//       useRootNavigator: false, // Use the current navigator, not root
//       builder: (context) => const TreatmentAreaScreen(),
//       routeSettings: const RouteSettings(name: '/SelectSectionBottomSheet'),
//     );
//   }
// }
//
// class _TreatmentAreaScreenState extends State<TreatmentAreaScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return DraggableScrollableSheet(
//       initialChildSize: 0.5, // Fixed at half screen height
//       minChildSize: 0.5,
//       maxChildSize: 0.5,
//       builder: (context, scrollController) {
//         return Container(
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.only(
//               topLeft: Radius.circular(20.r),
//               topRight: Radius.circular(20.r),
//             ),
//           ),
//           child: Column(
//             children: [
//               // Handle bar
//               Container(
//                 margin: EdgeInsets.only(top: 12.h, bottom: 8.h),
//                 width: 40.w,
//                 height: 4.h,
//                 decoration: BoxDecoration(
//                   color: CustomColors.greyColor,
//                   borderRadius: BorderRadius.circular(2.r),
//                 ),
//               ),
//               // Title
//               Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 20.w),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       "Select Section",
//                       style: CustomFonts.black24w600,
//                     ),
//                     IconButton(
//                       icon: Icon(Icons.close, size: 24.sp),
//                       onPressed: () => Navigator.pop(context),
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(height: 20.h),
//               // Grid content
//               Expanded(
//                 child: Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 20.w),
//                   child: Consumer(
//                     builder: (context, ref, _) {
//                       final loading = ref.watch(treatmentViewModel).treatmentAreaLoading;
//                       if (loading) {
//                         return Center(
//                           child: CircularProgressIndicator(
//                             color: CustomColors.purpleColor,
//                           ),
//                         );
//                       }
//                       return AnimationLimiter(
//                         child: GridView.builder(
//                           controller: scrollController,
//                           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                             crossAxisCount: 3, // Changed from 2 to 3 for bottom sheet
//                             crossAxisSpacing: 12.w,
//                             mainAxisSpacing: 12.h,
//                             childAspectRatio: 0.75, // Adjusted for smaller tiles
//                           ),
//                           itemCount:
//                               ref
//                                   .read(treatmentViewModel)
//                                   .treatmentAreaResponse
//                                   ?.data
//                                   ?.length ??
//                               0,
//                           itemBuilder: (context, index) {
//                             final section = ref
//                                 .read(treatmentViewModel)
//                                 .treatmentAreaResponse
//                                 ?.data;
//                             return AnimationConfiguration.staggeredGrid(
//                               position: index,
//                               duration: const Duration(milliseconds: 600),
//                               columnCount: 3, // Updated to match crossAxisCount
//                               child: ScaleAnimation(
//                                 child: FadeInAnimation(
//                                   child: CustomGridViewTile(
//                                     onTap: () {
//                                       ref
//                                           .read(checkoutViewModel.notifier)
//                                           .updateState(
//                                             treatmentAreaId: section[index].id,
//                                           );
//                                       Navigator.pop(context); // Close bottom sheet first
//                                       if (section[index].isSidearea == true) {
//                                         ref
//                                             .read(treatmentViewModel.notifier)
//                                             .onTapTreatmentArea(treatmentArea: section[index], isCallPredictAPI: false);
//                                     TreatmentSubAreaScreen.show(context);
//                                       } else {
//                                         Navigator.pushNamed(
//                                           context,
//                                           ref
//                                               .read(checkoutViewModel.notifier)
//                                               .navigateTo(),
//                                         );
//                                       }
//                                     },
//                                     title: section![index].name,
//                                   ),
//                                 ),
//                               ),
//                             );
//                           },
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }
