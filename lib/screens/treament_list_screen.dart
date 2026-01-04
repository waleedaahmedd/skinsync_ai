import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skinsync_ai/screens/bottom_nav_screens/treatments_screen.dart';
import 'package:skinsync_ai/screens/treatment_detail_screen.dart';
import 'package:skinsync_ai/utills/color_constant.dart';
import 'package:skinsync_ai/utills/custom_fonts.dart';
import 'package:skinsync_ai/view_models/treatment_view_model.dart';
import 'package:skinsync_ai/widgets/fillter_container.dart';

import '../widgets/custom_grid_view_tile.dart';

class TreamentListScreen extends StatefulWidget {
  const TreamentListScreen({super.key});

  @override
  State<TreamentListScreen> createState() => _TreamentListScreenState();
}

class _TreamentListScreenState extends State<TreamentListScreen> {
  int selectedFilterIndex = 0;
  List<Fillter> fillter = [
    Fillter(title: "All"),
    Fillter(title: "Lip Augmentation"),
    Fillter(title: "Cheek Fillers"),
    Fillter(title: "Jawline Contouring"),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Consumer(
                builder: (_, ref, _) {
                  return GestureDetector(
                    onTap: () {
                      ref
                          .read(treatmentViewModel.notifier)
                          .setTreatmentMainScreen(value: true);
                    },
                    child: Container(
                      padding: EdgeInsets.all(14.w),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: CustomColors.greyColor,
                      ),
                      child: Icon(
                        CupertinoIcons.arrow_left,
                        size: 16.sp,
                        color: Colors.black,
                      ),
                    ),
                  );
                },
              ),
              SizedBox(width: 22.w),
              Text("Injectables", style: CustomFonts.black24w600),
            ],
          ),
          SizedBox(height: 15.h),
          SizedBox(
            height: 50.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: fillter.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(right: 10.w),
                  child: FillterContainer(
                    isSelected: selectedFilterIndex == index,
                    title: fillter[index].title,
                    svgImage: fillter[index].svg,
                    onTap: () {
                      setState(() {
                        selectedFilterIndex = index;
                      });
                    },
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 30),
          GridView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 18.w,
              mainAxisSpacing: 18.h,
              childAspectRatio: 0.7,
            ),
            itemCount: 10,
            itemBuilder: (context, index) {
              return CustomGridViewTile(
                onTap: () {
                  Navigator.pushNamed(context, TreatmentDetailScreen.routeName);
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
