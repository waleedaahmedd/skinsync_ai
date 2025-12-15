import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:skinsync_ai/utills/assets.dart';
import 'package:skinsync_ai/widgets/appointment_date_widget.dart';
import 'package:skinsync_ai/widgets/scheduled_appointment_tile.dart';

import '../../utills/color_constant.dart';
import '../../utills/custom_fonts.dart';
import '../../utills/date_time_utills.dart';

class ApppointmentsScreen extends StatelessWidget {
  const ApppointmentsScreen({super.key});

  @override
  Widget build(BuildContext context) { 
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 84.h,
        automaticallyImplyLeading: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Row(
              children: [
                Icon(Iconsax.location,size: 20.sp, color: Colors.black,),
                SizedBox(width: 6.w,),
                Text("Hello, Burak!", style: CustomFonts.black30w600),
              ],
            ),
            SizedBox(height: 2.h),
            Text(
              "195 Karlie Brooks, Anderson",
              style: CustomFonts.grey18w400,
            ),
          ],
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 30.0.w),
            child: Container(
              decoration: BoxDecoration(
                color: CustomColors.greyColor,
                borderRadius: BorderRadius.circular(8.r),
              ),
              height: 44.h,
              width: 44.w,

              child: Icon(
                Icons.notifications_none_outlined,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
body: SingleChildScrollView(
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    Divider(color: CustomColors.greyColor,),
    Padding(
      padding:  EdgeInsets.symmetric(horizontal: 30.w),
      child: TextField(
                      style:CustomFonts.black18w400 ,
                      
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.search, ),
                          hintText: "Search Appointment"),
                      ),
    ),
    SizedBox(height: 21.h,),
                      Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 30.0.w),
  
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                                          Text("Today’s schedule", style: CustomFonts.black30w600),
                        Container(
                          decoration: BoxDecoration(
                            color: CustomColors.greyColor,
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                           padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 8.h),
                        
                        
                          child: Icon(
                            Icons.tune,
                            color: Colors.black,
                          ),
                        ),
                        ],),
                      ),
    SizedBox(height: 21.h,),
    SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children:
       getNextNDays(7).map((dateItem) {
        return AppointmentDateWidget(date: dateItem["date"]!, day: dateItem["day"]!);
      }).toList(),),
    ),

    SizedBox(height: 22.h,), 
                                          Padding(
                                                padding:  EdgeInsets.symmetric(horizontal: 30.w),
  
                                            child: Text("Today’s schedule", style: CustomFonts.black20w600),
                                          ),
    SizedBox(height: 28.h,),

                                          Padding(
                                                padding:  EdgeInsets.symmetric(horizontal: 30.w),
                                            child: Container(
                                                                    decoration: BoxDecoration(
                                                                      color: CustomColors.purpleColor,
                                                                      borderRadius: BorderRadius.circular(8.r),
                                                                    ),
                                                                     padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 8.h),
                                                                  
                                                                  
                                                                    child: Text("11:00  AM", style: CustomFonts.white12w600),
                                                                  ),
                                          ),
                        Padding(
                                                                        padding:  EdgeInsets.symmetric(horizontal: 30.w),
  
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: ScheduledAppointmentTile()),
                        ),
                                          Padding(
                                                padding:  EdgeInsets.symmetric(horizontal: 30.w),
                                            child: Container(
                                                                    decoration: BoxDecoration(
                                                                      color: CustomColors.purpleColor,
                                                                      borderRadius: BorderRadius.circular(8.r),
                                                                    ),
                                                                     padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 8.h),
                                                                  
                                                                  
                                                                    child: Text("11:00  AM", style: CustomFonts.white12w600),
                                                                  ),
                                          ),
                        Padding(
                                                                        padding:  EdgeInsets.symmetric(horizontal: 30.w),
  
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: ScheduledAppointmentTile()),
                        ),
                            SizedBox(height: 200.h,),

  
  ],),
),
    );
  }
}
