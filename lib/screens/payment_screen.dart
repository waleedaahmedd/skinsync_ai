import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iconsax/iconsax.dart';
import 'package:skinsync_ai/screens/bottom_nav_page.dart';
import 'package:skinsync_ai/screens/notes_screen.dart';
import 'package:skinsync_ai/utills/assets.dart';
import 'package:skinsync_ai/utills/color_constant.dart';
import 'package:skinsync_ai/utills/custom_fonts.dart';
import 'package:skinsync_ai/widgets/custom_app_bar.dart';

class PaymentScreen extends StatelessWidget {
  static const routeName = "/payment_screen";
  const PaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(showTitle: false),
      body: Padding(
        padding: EdgeInsetsGeometry.symmetric(horizontal: 30.w),
        child: Column(
          crossAxisAlignment: .start,
          children: [
            SizedBox(height: 10.h),
            Text(
              "Your Treatment Appointment is Ready!",
              style: CustomFonts.black30w600,
            ),
            SizedBox(height: 18.h),
            Container(
              padding: EdgeInsets.all(6.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.r),
                border: Border.all(color: CustomColors.blackColor),
              ),
              child: Row(
                children: [
                  Image.asset(
                    DummyAssets.treatmentimage,
                    fit: BoxFit.fill,
                    height: 105.h,
                    width: 151.w,
                  ),
                  SizedBox(width: 21.w),
                  Column(
                    crossAxisAlignment: .start,
                    children: [
                      Text(
                        "Monday, Feb 03 - 11:00 AM",
                        style: CustomFonts.black14w500,
                      ),
                      Text(
                        "Derma Fillers - Cheeks",
                        style: CustomFonts.black14w600,
                      ),
                      Text("Glow Skin Clinic", style: CustomFonts.black14w400),
                      Row(
                        children: [
                          Icon(
                            Icons.attach_file,
                            size: 12.sp,
                            color: CustomColors.blackColor,
                          ),
                          Text(
                            " Derma Fillers Cheeks Model",
                            style: CustomFonts.black14w400Underline,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 22.h),
            Divider(height: 0, color: Colors.grey.shade300),
            SizedBox(height: 22.h),
            Text("Payment Details", style: CustomFonts.black16w600),
            SizedBox(height: 19.h),
            Text("Select Payment Method", style: CustomFonts.black16w500),
            SizedBox(height: 20.h),
            Row(
              children: [
               Image.asset(PngAssets.masterLogo,height: 50.h,width: 50.w,),
                SizedBox(width: 10.w),
                Column(
                  crossAxisAlignment: .start,
                  children: [
                    Text("Master Card", style: CustomFonts.black14w600),
                    SizedBox(height: 4.h),
                    Text("5689470025899658", style: CustomFonts.black12w500),
                  ],
                ),
              ],
            ),
            SizedBox(width: 10.w),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 7.w,
                    vertical: 19.h,
                  ),
                  height: 50.h,
                  width: 50.w,
                  child: SvgPicture.asset(SvgAssets.visaLogo),
                ),
                SizedBox(width: 10.w),
                Column(
                  crossAxisAlignment: .start,
                  children: [
                    Text("Visa Card", style: CustomFonts.black14w600),
                    SizedBox(height: 4.h),
                    Text("5689470025899658", style: CustomFonts.black12w500),
                  ],
                ),
              ],
            ),
            SizedBox(height: 16.h,),
            Container(
              padding: EdgeInsets.symmetric(vertical: 
              11.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.r),
                color: CustomColors.purpleColor

              ),
              child: Center(child: Text("Add New Card",style: CustomFonts.white18w600,),),
            ),
             SizedBox(height: 22.h,),
             Divider(height: 0,color: Colors.grey.shade300,),
             SizedBox(height: 22.h,),
             Row(
              mainAxisAlignment: .spaceBetween,
              children: [
                Text("Derma Fillers - Cheeks By Glow Skin Clinic",style: CustomFonts.black16w600,),
              Text("\$ 550",style: CustomFonts.black16w600,)
              ],
             ),
               SizedBox(height: 14.h,),
                Divider(height: 0,color: Colors.grey.shade300,),
             SizedBox(height: 14.h,),

               Row(children: [
                CustomSizedSwitch(),
                Text("Use loyalty points",style: CustomFonts.black18w600,),
                Spacer(),
                Text("- \$ 50",style:  CustomFonts.red13w500.copyWith(fontSize: 20.sp,fontWeight: FontWeight.w600), )
               ],),
                SizedBox(height: 14.h,),
                Divider(height: 0,color: Colors.grey.shade300,),
             SizedBox(height: 14.h,),
              Row(
              mainAxisAlignment: .spaceBetween,
              children: [
                Text("Total Amount",style: CustomFonts.black16w600,),
              Text("\$ 550",style: CustomFonts.black16w600,)
              ],
             ),
             SizedBox(height: 24.h,),
             SizedBox(
              width: double.infinity,
              child: ElevatedButton(onPressed: (){
                Navigator.pushNamed(context, NotesScreen.routeName);
              }, child:Text("PayNow")),
             )


          ],
        ),
      ),
    );
  }
}
class CustomSizedSwitch extends StatefulWidget {
  const CustomSizedSwitch({super.key});

  @override
  State<CustomSizedSwitch> createState() => _CustomSizedSwitchState();
}

class _CustomSizedSwitchState extends State<CustomSizedSwitch> {
  bool isOn = false;

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: 0.8,
      child: SwitchTheme(
        data: SwitchThemeData(
          thumbColor: WidgetStateProperty.all(Colors.white),
          trackColor: WidgetStateProperty.all(isOn? CustomColors.lightBlueColor : Colors.grey.shade400),
          trackOutlineColor:
              WidgetStateProperty.all(Colors.transparent),
          materialTapTargetSize:
              MaterialTapTargetSize.shrinkWrap,
        ),
        child: Switch(
          value: isOn,
          onChanged: (value) {
            setState(() {
              isOn = value;
            });
          },
        ),
      ),
    );
  }
}
