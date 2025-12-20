import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:skinsync_ai/screens/bottom_nav_screens/treatments_screen.dart';
import 'package:skinsync_ai/utills/color_constant.dart';
import 'package:skinsync_ai/utills/custom_fonts.dart';
import 'package:skinsync_ai/view_models/treatment_view_model.dart';
import 'package:skinsync_ai/widgets/fillter_container.dart';
import 'package:skinsync_ai/widgets/treatment_card.dart';

class TreamentListScreen extends StatefulWidget {
  TreamentListScreen({super.key});

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.0.w),
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  context.read<TreatmentViewModel>().settreamentMainScreen(
                    value: true,
                  );
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
              ),
              SizedBox(width: 22.w),
              Text("Injectables", style: CustomFonts.black24w600),
            ],
          ),
        ),
        SizedBox(height: 15.h),
        SizedBox(
          height: 50.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: fillter.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(
                  left: index == 0 ? 30.w : 0,
                  right: 10.w,
                ),
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
        Padding(
          padding: EdgeInsets.only(left: 30.w, right: 30.w),
          child: Wrap(
            spacing: 18.w, // Horizontal spacing
            runSpacing: 23.0.h, // Vertical spacing
            children: List.generate(8, (index) {
              return TreamentCard();
            }),
          ),
        ),
      ],
    );
  }
}
