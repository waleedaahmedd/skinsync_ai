import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:skinsync_ai/route_generator.dart';
import 'package:skinsync_ai/utills/assets.dart';
import 'package:skinsync_ai/utills/color_constant.dart';
import 'package:skinsync_ai/utills/custom_fonts.dart';
import 'package:skinsync_ai/widgets/custom_app_bar.dart';

class ScanYourFaceScreen extends StatelessWidget {
  const ScanYourFaceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Scan Your Face",
        showTitle: true,

      ),
      body: Column(
        children: [
          Divider(color:CustomColors.greyColor ,),
          Padding(
            padding: EdgeInsets.symmetric(horizontal:  30.0.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 23.h,),
                Text("Face Scan",style: CustomFonts.black30w600,),
                SizedBox(height: 2.h,),
                Text("We’ll scan your face and create a cool model just for you to enhance your experience!",style: CustomFonts.grey16w400,),
                SizedBox(height: 28.h,),
                Row(children: [
                  SvgPicture.asset(SvgAssets.eye,height: 24.h,width: 26,),
                  SizedBox(width: 17.w,),
                  Flexible(child: Text("Face forward and make sure your eyes are clearly visible.",style: CustomFonts.black18w400,))
                ],),
                SizedBox(height: 31.h,),
                Row(children: [
                  SvgPicture.asset(SvgAssets.profileIcon,height: 24.h,width: 24.w,color: Color(0xffEEA1F0),),
                  SizedBox(width: 17.w,),
                  Flexible(child: Text("Align your face within the oval frame..",style: CustomFonts.black18w400,))
                ],),
                SizedBox(height: 31.h,),
                Row(children: [
                  SvgPicture.asset(SvgAssets.glasses,height: 8.h,width: 22.w,),
                  SizedBox(width: 17.w,),
                  Flexible(child: Text("Remove anything that covers your face eg: Eye glasses, Cap etc",style: CustomFonts.black18w400,))
                ],),
                SizedBox(height: 31.h,),
                Row(children: [
                  SvgPicture.asset(SvgAssets.face,height: 24.h,width: 22.w,),
                  SizedBox(width: 17.w,),
                  Flexible(child: Text("Move Your Face Inside The Border",style: CustomFonts.black18w400,))
                ],),
              SizedBox(height: 279.h,),
                 SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(onPressed:(){
                    Navigator.of(context).pushNamed(faceDetection);
                  }, child: Text("Scan Now")),
                ),
                SizedBox(height: 24.h,),
                Center(child: Text("Powered By ARKit",style: CustomFonts.grey22w600))
              ],
            ),
          ),
        ],
      ),
     
    );
  }
}