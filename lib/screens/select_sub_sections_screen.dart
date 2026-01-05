import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:skinsync_ai/screens/bottom_nav_screens/face_detection_screen.dart';
import 'package:skinsync_ai/screens/bottom_nav_screens/treatments_screen.dart';
import 'package:skinsync_ai/screens/treatment_detail_screen.dart';
import 'package:skinsync_ai/utills/color_constant.dart';
import 'package:skinsync_ai/utills/custom_fonts.dart';
import 'package:skinsync_ai/view_models/treatment_view_model.dart';
import 'package:skinsync_ai/widgets/fillter_container.dart';

import '../models/dummy_list_model.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_grid_view_tile.dart';
import 'face_scan_screen.dart';

class SelectSubSectionsScreen extends StatefulWidget {
  static const String routeName = '/SelectSubSectionScreen';
  const SelectSubSectionsScreen({super.key});

  @override
  State<SelectSubSectionsScreen> createState() => _SelectSectionsScreenState();
}

class _SelectSectionsScreenState extends State<SelectSubSectionsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(showTitle: true, title: "Select Sub Section"),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row(
            //   children: [
            //     Consumer(
            //       builder: (_, ref, _) {
            //         return GestureDetector(
            //           onTap: () {
            //             // ref
            //             //     .read(treatmentViewModel.notifier)
            //             //     .setTreatmentMainScreen(value: true);
            //           },
            //           child: Container(
            //             padding: EdgeInsets.all(14.w),
            //             decoration: BoxDecoration(
            //               shape: BoxShape.circle,
            //               color: CustomColors.greyColor,
            //             ),
            //             child: Icon(
            //               CupertinoIcons.arrow_left,
            //               size: 16.sp,
            //               color: Colors.black,
            //             ),
            //           ),
            //         );
            //       },
            //     ),
            //     SizedBox(width: 22.w),
            //     Text("Injectables", style: CustomFonts.black24w600),
            //   ],
            // ),
            // SizedBox(height: 15.h),
            // SizedBox(
            //   height: 50.h,
            //   child: ListView.builder(
            //     scrollDirection: Axis.horizontal,
            //     itemCount: fillter.length,
            //     itemBuilder: (context, index) {
            //       return Padding(
            //         padding: EdgeInsets.only(right: 10.w),
            //         child: FillterContainer(
            //           isSelected: selectedFilterIndex == index,
            //           title: fillter[index].title,
            //           svgImage: fillter[index].svg,
            //           onTap: () {
            //             setState(() {
            //               selectedFilterIndex = index;
            //             });
            //           },
            //         ),
            //       );
            //     },
            //   ),
            // ),
            SizedBox(height: 30),
            Expanded(
              child: Consumer(
                builder: (context, ref, _) {
                  final loading = ref.watch(treatmentViewModel).loading;
                 
                  if (loading) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: CustomColors.purpleColor,
                      ),
                    );
                  }
                  return AnimationLimiter(
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 18.w,
                        mainAxisSpacing: 18.h,
                        childAspectRatio: 0.8,
                      ),
                      itemCount:ref.read(treatmentViewModel).subSelectionResponse?.data?.length ?? 0,
                      itemBuilder: (context, index) {
                        final subSection = ref.read(treatmentViewModel).subSelectionResponse?.data;

                        return AnimationConfiguration.staggeredGrid(
                          position: index,
                          duration: const Duration(milliseconds: 600),
                          columnCount: subSection?.length ?? 0,
                          child: ScaleAnimation(
                            child: FadeInAnimation(
                              child: CustomGridViewTile(
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    FaceDetectionScreen.routeName,
                                  );
                                },
                                title: subSection?[index].name ?? "",
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
