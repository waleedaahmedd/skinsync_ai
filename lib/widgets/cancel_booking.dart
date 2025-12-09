import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:skinsync_ai/utills/assets.dart';
import 'package:skinsync_ai/utills/color_constant.dart';
import 'package:skinsync_ai/utills/custom_fonts.dart';


void showCancelBookingSheet(BuildContext context) {
  showModalBottomSheet(
    backgroundColor: Colors.transparent,
    constraints: BoxConstraints(minWidth: double.infinity),
    context: context,
    isScrollControlled: true,
    
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
    ),
    builder: (context) {
      return Container(
       color: Colors.transparent,
        padding: EdgeInsets.only(
          top: 10.h,
          left: 10.w,
          right: 10.w,
          bottom: MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: Container(
        
          decoration: BoxDecoration(
              color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(44.r),
              topRight: Radius.circular(44.r),
              bottomLeft: Radius.circular(55.r),
              bottomRight: Radius.circular(55.r),
              )
          ),
          padding: EdgeInsets.symmetric(horizontal: 20.w,vertical: 28.h),
          child: SingleChildScrollView(
            
            child:
            //  Column(
             
            //   crossAxisAlignment: CrossAxisAlignment.start,
            //   children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                   
                    children: [
                    
                      Text(
                        "Get Started",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 30.sp,
                          color: Colors.black,
                        ),
                      ),
          
                   SizedBox(height: 4.h,),

                      Text(
                        
                        "Lorem ipsum dolor sit amet consectetur Ut consectetur mauris tellus ultricies.",
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                          color: Color(0xff494949)
                        ),
                      ),
                      SizedBox(height: 18.h),
                      SizedBox(
                        width: double.infinity,
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.r),
                            color: Colors.black),
                        child: Center(child: Text("Continue With Phone",style:CustomFonts.white18w600,)),
                          ),
                      ),
                       SizedBox(height: 10.h),
                        SizedBox(
                        width: double.infinity,
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.r),
                            color:CustomColors.greyColor
                            ),
                        child: Center(child: Text("Continue With Phone",style:CustomFonts.black18w600,)),
                          ),
                      ),
                      SizedBox(height: 10.h,),
                      Row(children: [
                        Expanded(
                      
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.r),
                            color:CustomColors.greyColor
                            ),
                        child: Center(child: Image.asset(SvgAssets.google,height: 32.h,width: 32,)),
                          ),
                      ),
                      SizedBox(width: 8,),
                       Expanded(
                        
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.r),
                            color:CustomColors.greyColor
                            ),
                        child: Center(child: Image.asset(SvgAssets.apple,height: 32.h,width: 32,)),
                          ),
                      ),
                      ],),
                    
                     
          
                      SizedBox(height: 30.h),
                    ],
                  ),
                ),
                // Drag handle
                // Center(
                //   child: Container(
                //     height: 5.h,
                //     width: 48.w,
                //     margin: EdgeInsets.only(bottom: 30.h),
                //     decoration: BoxDecoration(
                //       color: Color(0xffCDCFD0),
                //       borderRadius: BorderRadius.circular(100.r),
                //     ),
                //   ),
                // ),
          
                // Review text
          
                // Submit button
            //  Row(
            //         children: [
            //           Expanded(
            //             child: GestureDetector(
            //               onTap: () {
            //                 Navigator.pop(context);
            //               },
            //               child: Container(
            //                 padding: EdgeInsets.symmetric(
            //                   // vertical: 19.h,
            //                   horizontal: 12.w,
            //                 ),
            //                 decoration: BoxDecoration(
            //                   borderRadius: BorderRadius.circular(10.r),
            //                   border: Border.all(
            //                     color: Colors.black,
            //                     width: 2.w,
            //                   ),
            //                   color: Colors.transparent,
            //                 ),
            //                 child: Center(
            //                   child: Text(
            //                     "No, Go back",
            //                     style: TextStyle(
            //                       height: 0,
            //                       fontSize: 15.sp,
            //                       fontWeight: FontWeight.w600,
            //                     ),
            //                   ),
            //                 ),
            //               ),
            //             ),
            //           ),
            //           SizedBox(width: 16.w),
            //           Expanded(
            //             child: GestureDetector(
            //               onTap: () {
            //                 Navigator.pop(context);
            //               },
            //               child: Container(
            //                 padding: EdgeInsets.symmetric(
            //                   vertical: 19.h,
            //                   horizontal: 12.w,
            //                 ),
            //                 decoration: BoxDecoration(
            //                   borderRadius: BorderRadius.circular(10.r),
          
            //                   color: Color(0xffD72547),
            //                 ),
            //                 child: Center(
            //                   child: Text(
            //                     "Cancel Booking",
            //                     style: TextStyle(
            //                       height: 0,
            //                       fontSize: 15.sp,
            //                       fontWeight: FontWeight.w600,
            //                       color: Colors.white,
            //                     ),
            //                   ),
            //                 ),
            //               ),
            //             ),
            //           ),
            //         ],
            //       ),
                
                // SizedBox(height: 20.h),
            //   ],
            // ),
          ),
        ),
      );
    },
  );
}
