import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skinsync_ai/utills/color_constant.dart';
import 'package:skinsync_ai/utills/custom_fonts.dart';
import 'package:skinsync_ai/widgets/custom_app_bar.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:CustomAppBar(
      ),
      body: Column(
        children: [
        SizedBox(height: 37.h,),
        Text("Your Treatment Appointment is Ready!",style: CustomFonts.black30w600,),
        SizedBox(height: 18.h,),
        Container(
          padding: EdgeInsets.all(6),
          decoration: BoxDecoration(

            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(color: CustomColors.blackColor,width: 1.w)
          ),
        )
        ],
      ),
    );
  }
}