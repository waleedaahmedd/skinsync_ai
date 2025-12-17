import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:skinsync_ai/utills/assets.dart';
import 'package:skinsync_ai/utills/color_constant.dart';
import 'package:skinsync_ai/utills/custom_fonts.dart';
import 'package:skinsync_ai/view_models/face_scan_provider.dart';
import 'package:skinsync_ai/widgets/grey_container.dart';

class ArFaceModelPreviewScreen extends StatelessWidget {
  const ArFaceModelPreviewScreen({super.key});
  static const String routeName = '/ArFaceModelPreviewScreen';

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        leadingWidth: 80.w,
        leading: Padding(
        padding:  EdgeInsets.only(left:  30.w),
        child: GreyContainer(icon: Icons.arrow_back,shape: BoxShape.circle,),
      ),title: Text("AR Face Model Preview",style: CustomFonts.black26w600,),actions: [
        Padding(
          padding: EdgeInsets.only(right:  13.w),
          child: Text("Reset",style: CustomFonts.pinkunderlined20w600,),
        )
      ],),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _facePreview(),
             SizedBox(height: 18.h),
            _accuracyRate(),
             SizedBox(height: 36.h),
            _treatmentSection(
              area: 'Under-Eyes',
              syringes: '01 Syringe',
            ),
             SizedBox(height: 50.h),
            _treatmentSection(
              area: 'Under-Nose',
              syringes: '01 Syringe',
            ),
             SizedBox(height: 50.h),
            _addMoreService(),
             SizedBox(height: 50.h),
            _bottomButtons(),
          ],
        ),
      ),

    );
  }

  Widget _facePreview() {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(20.r),
          child: Consumer<FaceScanProvider>(
            builder: (context,provider,_) {
              return Image.file(
                File(provider.capturedImage!.path),
                fit: BoxFit.cover,
                width: double.infinity,
                height: 326.h,
              );
            }
          ),
        ),
         Positioned(
          top: 13.h,
          left: 23.w,
          child: Consumer<FaceScanProvider>(
            builder: (context, provider, _) {
              return Text(
                provider.isBefore ? 'Before' : 'After',
                style: CustomFonts.black20w600,
              );
            }
          ),
        ),
         Positioned(
          top: 13.h,
          right: 23.w,
          child: Consumer<FaceScanProvider>(
            builder: (context, provider, _) {
              return GestureDetector(
                onTap: () {
                  provider.toggleIsBefore();
                },
                child: CircleAvatar(
                  backgroundColor: CustomColors.greyColor ,
                  child: SvgPicture.asset(
                    SvgAssets.beforeAfter,
                  ),
                ),
              );
            }
          ),
        ),
         
        Positioned(
          bottom: 16.h,
          left: 16.w,
          right: 16.w,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 8.w),
            decoration: BoxDecoration(
              color: CustomColors.blackColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child:  Text(
              'See How 2 Syringes Will Look On Your Under Eyes',
              textAlign: TextAlign.center,
              style: CustomFonts.white14w600,
            ),
          ),
        ),
      ],
    );
  }


  Widget _accuracyRate() {
    return Row(
      children: [
        SvgPicture.asset(
                  SvgAssets.beforeAfter,
                ),
         SizedBox(width: 5.w),
         Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Accuracy Rate',
              style: CustomFonts.black20w600,
            ),
            Text(
              'This score is based on your Face analysis',
              style: CustomFonts.black16w400,
            ),
          ],
        ),
      ],
    );
  }

  // ================= Treatment Section =================

  Widget _treatmentSection({
    required String area,
    required String syringes,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
         Text(
          'Treatment Selection',
          style: CustomFonts.black18w600,
        ),
         SizedBox(height: 8.h),
        Row(
          children: [
            Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color:  Colors.black ,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            SvgAssets.syringe,
          ),
           SizedBox(width: 8.w),
          Text(
            "Dermal Fillers",
            style: CustomFonts.white17w500
          ),
        ],
      ),
    ),
             SizedBox(width: 10.w),
            Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color:  Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            SvgAssets.hand,
          ),
           SizedBox(width: 8.w),
          Text(
            "Botox",
            style: CustomFonts.black17w500,
          ),
        ],
      ),
    )
            
          ],
        ),
         SizedBox(height: 16.h),
         Text(
          'Area Selection',
          style: CustomFonts.black18w600,
        ),
         SizedBox(height: 8.h),
        DropdownButtonFormField(
          value: area,
          items: [area]
              .map(
                (e) => DropdownMenuItem(
                  value: e,
                  child: Text(e, style: CustomFonts.black16w500),
                ),
              )
              .toList(),
          onChanged: (_) {},
          decoration: InputDecoration(

            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: CustomColors.blackColor,
              ),
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
        ),
         SizedBox(height: 16.h  ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
             Text(
              'Adjustable Parameters:',
                 style: CustomFonts.black18w600,
            ),
            Text(syringes, style: CustomFonts.black14w500),
          ],
        ),
        Slider(
          activeColor:CustomColors.lightBlueColor,
          value: 1,
          min: 0,
          max: 2,
          onChanged: (_) {},
        ),
      ],
    );
  }

  

  // ================= Add More =================

  Widget _addMoreService() {
    return Center(
      child: TextButton.icon(
        onPressed: () {},
        icon: Container(
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: CustomColors.blackColor,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(8.r),

          ),
          child: const Icon(Icons.add, color: Colors.white)),
        label:  Text(
          'Add More Service',
          style:CustomFonts.black20w600Underlined,
        ),
      ),
    );
  }

  // ================= Bottom Buttons =================

  Widget _bottomButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.r),
              ),
              padding:  EdgeInsets.symmetric(vertical: 19.h),
            ),
            child:  Text('Save',style:  CustomFonts.black22w600),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.r),
              ),
              padding:  EdgeInsets.symmetric(vertical: 19.h),
            ),
            child:  Text('Explore Clinics',style:  CustomFonts.white22w600),
          ),
        ),
      ],
    );
  }
}
