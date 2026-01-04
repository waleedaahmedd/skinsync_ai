import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:skinsync_ai/screens/bottom_nav_screens/treatments_screen.dart';
import 'package:skinsync_ai/screens/select_sub_sections_screen.dart';
import 'package:skinsync_ai/screens/treatment_detail_screen.dart';
import 'package:skinsync_ai/utills/color_constant.dart';
import 'package:skinsync_ai/utills/custom_fonts.dart';
import 'package:skinsync_ai/view_models/treatment_view_model.dart';
import 'package:skinsync_ai/widgets/fillter_container.dart';

import '../models/dummy_list_model.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_grid_view_tile.dart';

class SelectSectionsScreen extends StatefulWidget {
  static const String routeName = '/SelectSectionScreen';
  const SelectSectionsScreen({super.key});

  @override
  State<SelectSectionsScreen> createState() => _SelectSectionsScreenState();
}

class _SelectSectionsScreenState extends State<SelectSectionsScreen> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(showTitle: true, title: "Select Section"),
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
              child: AnimationLimiter(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 18.w,
                    mainAxisSpacing: 18.h,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: sections.length,
                  itemBuilder: (context, index) {
                    return AnimationConfiguration.staggeredGrid(
                      position: index,
                      duration: const Duration(milliseconds: 600),
                      columnCount: sections.length,
                      child: ScaleAnimation(
                        child: FadeInAnimation(
                          child: CustomGridViewTile(
                            onTap: () {
                              Navigator.pushNamed(context, SelectSubSectionsScreen.routeName);
                            }, subSections: sections[index],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
