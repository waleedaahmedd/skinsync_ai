import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iconsax/iconsax.dart';
import 'package:skinsync_ai/screens/notes_screen.dart';
import 'package:skinsync_ai/utills/assets.dart';
import 'package:skinsync_ai/utills/color_constant.dart';
import 'package:skinsync_ai/utills/custom_fonts.dart';
import 'package:skinsync_ai/widgets/custom_app_bar.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key});
  static const String routeName = '/PaymentScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 37.h),
            Text(
              "Your Treatment Appointment is Ready!",
              style: CustomFonts.black30w600,
            ),
            SizedBox(height: 18.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 6.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(color: CustomColors.blackColor, width: 1.w),
              ),
              child: Row(
                children: [
                  Container(
                    height: 105.h,
                    width: 151.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Image.asset(
                      DummyAssets.treatmentimage,
                      fit: BoxFit.fill,
                    ),
                  ),
                  SizedBox(width: 21.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Text(
                        "Monday, Feb 03 - 11:00 AM",
                        style: CustomFonts.black12w500,
                      ),
                      SizedBox(height: 5.h),
                      Text(
                        "Derma Fillers - Cheeks",
                        style: CustomFonts.black12w600,
                      ),
                      SizedBox(height: 1.h),
                      Text("Glow Skin Clinic", style: CustomFonts.black12w400),
                      SizedBox(height: 2.h),
                      Row(
                        children: [
                          Transform.rotate(
                            angle: 7,
                            child: Icon(
                              Icons.attach_file,
                              size: 12.sp,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            "Derma Fillers - Cheeks Model",
                            style: CustomFonts.black12w400UnderLine,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 32.h),
            Divider(height: 0.h, color: CustomColors.greyColor),
            SizedBox(height: 25.h),
            Text("Payment Details", style: CustomFonts.black12w600),
            SizedBox(height: 19.h),
            Text("Select Payment Method", style: CustomFonts.black12w600),
            SizedBox(height: 19.h),
            Row(
              children: [
                Image.asset(DummyAssets.master_card, height: 50.h, width: 50.w),
                SizedBox(width: 10.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Master Card", style: CustomFonts.black12w600),
                    SizedBox(height: 5.h),
                    Text("5689470025899658", style: CustomFonts.black12w600),
                  ],
                ),
                Spacer(),
                RadioButtonWidgetOrange(),
              ],
            ),
            SizedBox(height: 13.h),
            Row(
              children: [
                Image.asset(DummyAssets.master_card, height: 50.h, width: 50.w),
                SizedBox(width: 10.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Visa Card", style: CustomFonts.black12w600),
                    SizedBox(height: 5.h),
                    Text("5689470025899658", style: CustomFonts.black12w600),
                  ],
                ),
                Spacer(),
                RadioButtonWidgetOrange(),
              ],
            ),
            SizedBox(height: 26.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 19.h),
                  textStyle: CustomFonts.white22w600,
                  backgroundColor: CustomColors.lightPurpleColor,
                  foregroundColor: CustomColors.whiteColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50.r),
                  ),
                ),
                child: Text("Add New Card"),
              ),
            ),
            SizedBox(height: 22.h),
            Divider(height: 0.h, color: CustomColors.greyColor),
            SizedBox(height: 15.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 206.w,
                  child: Text(
                    "Derma Fillers - Cheeks   By Glow Skin Clinic",
                    style: CustomFonts.black12w600,
                  ),
                ),

                Text("\$ 550", style: CustomFonts.black12w600),
              ],
            ),
            SizedBox(height: 15.h),
            Divider(height: 0.h, color: CustomColors.greyColor),
            SizedBox(height: 15.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Total Amount", style: CustomFonts.black12w600),

                Text("\$ 550", style: CustomFonts.black12w600),
              ],
            ),
            SizedBox(height: 43.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, NotesScreen.routeName);
                },
                child: Text("Pay Now"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RadioButtonWidgetOrange extends StatefulWidget {
  RadioButtonWidgetOrange({super.key});

  bool isSelected = false;
  @override
  State<RadioButtonWidgetOrange> createState() =>
      _RadioButtonWidgetOrangeState();
}

class _RadioButtonWidgetOrangeState extends State<RadioButtonWidgetOrange> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          widget.isSelected = !widget.isSelected;
        });
      },
      child: Container(
        height: 18.h,
        width: 18.w,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(
            color: widget.isSelected ? Colors.orange : CustomColors.greyColor,
            width: 3.w,
          ),
        ),
        child: Center(
          child: Container(
            height: 10.h,
            width: 10.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
