import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../models/dummy_list_model.dart';
import '../utills/color_constant.dart';
import '../utills/custom_fonts.dart';
import '../widgets/doctor_card.dart';

class DoctorsListingScreen extends StatelessWidget {
  const DoctorsListingScreen({super.key});
  static const String routeName = "/DoctorsListingScreen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.whiteColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(CupertinoIcons.arrow_left, color: Colors.black, size: 22),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("Our Specialists", style: CustomFonts.black24w600),
      ),
      body: GridView.builder(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
        physics: const BouncingScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.76,
          crossAxisSpacing: 14.w,
          mainAxisSpacing: 14.h,
        ),
        itemCount: dummyDoctors.length,
        itemBuilder: (context, index) {
          final doctor = dummyDoctors[index];
          return DoctorCard(
            doctor: doctor,
            width: double.infinity,
            margin: EdgeInsets.zero,
          );
        },
      ),
    );
  }
}
