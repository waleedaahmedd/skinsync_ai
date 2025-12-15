import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:skinsync_ai/utills/assets.dart';
import 'package:skinsync_ai/utills/custom_fonts.dart';
import 'package:skinsync_ai/widgets/custom_app_bar.dart';

class PersonalDetail extends StatelessWidget {
  const PersonalDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(showTitle: true, title: "Personal Details"),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30.w),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 28.h,),
              Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [
                  ClipOval(
                    child: Image.asset(
                      DummyAssets.acen,
                      height: 91.w,
                      width: 91.w,
                      fit: BoxFit.cover,
                    ),
                  ),
          
                  Positioned(
                    bottom: -5,
                    right: -5,
                    child: Container(
                      height: 35.w,
                      width: 35.w,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Iconsax.camera,
                        size: 20.w,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 7.h,),
              Text("Your Profile",style: CustomFonts.black30w600,),
              Text("Introduce yourself to others in your events.",style: CustomFonts.grey18w400,),
              SizedBox(height: 22.h,),
              TextField(
                style: CustomFonts.black18w400,
                decoration: InputDecoration(hintText: "Lizzy Johnson"),
          
              ),
              SizedBox(height: 20.h,),
               TextField(
                style: CustomFonts.black18w400,
                decoration: InputDecoration(hintText: "+ 012 345 6798"),
          
              ),
              SizedBox(height: 20.h,),
               TextField(
                style: CustomFonts.black18w400,
                decoration: InputDecoration(hintText: "lizzyjhonson@gmail.com"),
          
              ),
              SizedBox(height: 20.h,),
               TextField(
                style: CustomFonts.black18w400,
                decoration: InputDecoration(hintText: "New York"),
          
              ),
              SizedBox(height: 20.h,),
              Row(
                children: [
                   Expanded(
                     child: TextField(
                                   style: CustomFonts.black18w400,
                                   decoration: InputDecoration(hintText: "Skin Type +2"),
                                 
                                 ),
                   ),
              SizedBox(width: 12.39.h,),
               Expanded(
                 child: TextField(
                  style: CustomFonts.black18w400,
                  decoration: InputDecoration(hintText: "Skin Goal +4"),
                             
                             ),
               ),
              
                ],
              ),
              SizedBox(height: 20.h,),
               TextField(
                style: CustomFonts.black18w400,
                decoration: InputDecoration(hintText: "Primary Concerns  +3"),
          
              ),
              SizedBox(height: 20.h,),
               TextField(
                maxLines: 4,
                style: CustomFonts.black18w400,
                decoration: InputDecoration(hintText: "Bio"),
          
              ),
              SizedBox(height: 35.h,),
              SizedBox( 
                width: double.infinity,
                child: ElevatedButton(onPressed:(){}, child: Text("Save")))
            ],
          ),
        ),
      ),
    );
  }
}
