import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_glass_morphism/flutter_glass_morphism.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart';
import 'package:skinsync_ai/screens/treatment_detail_screen.dart';
import 'package:skinsync_ai/utills/assets.dart';
import 'package:skinsync_ai/utills/color_constant.dart';
import 'package:skinsync_ai/utills/custom_fonts.dart';
import 'package:skinsync_ai/widgets/custom_app_bar.dart';
import 'package:skinsync_ai/widgets/time_container.dart';
import 'package:skinsync_ai/widgets/treatment_card.dart';
import 'package:skinsync_ai/widgets/treatment_price_container.dart';

class ClinicServiceScreen extends StatefulWidget {
  const ClinicServiceScreen({super.key});
  static const String routeName = '/ClinicServiceScreen';

  @override
  State<ClinicServiceScreen> createState() => _ClinicServiceScreenState();
}

class _ClinicServiceScreenState extends State<ClinicServiceScreen> {
  int? selectedFilterIndex;
  int? selecteTime;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: CustomAppBar(showTitle: false),
      body: Container(
        decoration: BoxDecoration(gradient: CustomColors.whiteBlueGradient),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 25.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.0.w),
                child: Text(
                  "Select Dr / Injector",
                  style: CustomFonts.black22w600,
                ),
              ),
              SizedBox(height: 23.h),
              SizedBox(
                height: 150.h,
                child: ListView.builder(
                  itemCount: 4,
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.only(
                        left: index == 0 ? 30.w : 0,
                        right: 15.w,
                      ),
                      child: Container(
                        padding: EdgeInsets.only(
                          top: 21.h,
                          bottom: 12.h,
                          left: 25.w,
                          right: 25.w,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.r),
                          border: Border.all(
                            color: CustomColors.lightPurpleColor,
                            width: 2.w,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ClipOval(
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              child: Image.asset(
                                DummyAssets.doctorImage,
                                fit: BoxFit.cover,
                                height: 57.67.w,
                                width: 58.39.w,
                              ),
                            ),
                            SizedBox(height: 6.23.h),
                            Text(
                              "Dr, Selkon Kane",
                              style: CustomFonts.black18w600,
                            ),
                            SizedBox(height: 3.32.h),
                            Text("Injector", style: CustomFonts.black14w400),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 21.h),
              Divider(height: 0, color: CustomColors.greyColor),
              SizedBox(height: 25.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Select Your Services",
                      style: CustomFonts.black22w600,
                    ),
                    SizedBox(height: 17.h),
                    Text(
                      "Lorem ipsum dolor sit amet consectetur. Cursus iaculis est cras viverra vitae sit pellentesq",
                      style: CustomFonts.grey13w400,
                    ),
                    SizedBox(height: 10.h),
                    ListView.separated(
                      physics: NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.all(0),
                      separatorBuilder: (context, index) {
                        return SizedBox(height: 15.h);
                      },
                      shrinkWrap: true,
                      itemCount: 3,
                      itemBuilder: (context, index) {
                        return TreatmentPriceContainer(
                          isSelected: selectedFilterIndex == index,

                          image: DummyAssets.treatmentimage,
                          treatmentName: " Treatment Name",
                          price: 550,
                          onTap: () {
                            setState(() {
                              selectedFilterIndex = index;
                            });
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 25.h),
              Divider(height: 0, color: CustomColors.greyColor),
              SizedBox(height: 25.h),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Select a Date & Time",
                      style: CustomFonts.black30w600,
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      "we’ll notify you in advance so you’re always prepared. Your journey to glowing skin is just a tap away!",
                      style: CustomFonts.black16w400,
                    ),
                    SizedBox(height: 11.h),
                    Container(
                      padding: EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.r),
                        color: CustomColors.lightBlueColor.withValues(
                          alpha: 0.4,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Appointment Date",
                                style: CustomFonts.black12w400,
                              ),
                              SizedBox(height: 3.45.h),
                              Text(
                                "19/02/2019",
                                style: CustomFonts.black12w600,
                              ),
                            ],
                          ),
                          Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.r),
                              color: Colors.lightBlue.withValues(alpha: 0.5),
                            ),
                            child: SvgPicture.asset(
                              SvgAssets.edit,
                              height: 14.5,
                              width: 14.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 25.h),
                    Row(
                      children: [
                        statusHint(
                          status: "Booked",
                          color: CustomColors.greyColor,
                        ),
                        SizedBox(width: 16.w),
                        statusHint(status: "Available", color: Colors.grey),
                        SizedBox(width: 16.w),
                        statusHint(status: "Selected", color: Colors.green),
                      ],
                    ),
                    SizedBox(height: 25.h),
                    Wrap(
                      spacing: 12.w, // Horizontal spacing
                      runSpacing: 12.0.h, // Vertical spacing
                      children: List.generate(6, (index) {
                        return TimeContainer(
                          onTap: () {
                            setState(() {
                              selecteTime = index;
                            });
                          },
                          time: "10:30 AM - 10:30 AM",
                          isAvailable: index % 2 == 0 ? true : false,
                          isBooked: index % 2 == 0 ? false : true,
                          isSelected: selecteTime == index,
                        );
                        //Container(
                        //   height: 44.17.h,
                        //   width: 175.72.w,
                        //   //padding: EdgeInsets.symmetric(horizontal: 26.w,vertical: 13.h),
                        //   decoration: BoxDecoration(
                        //     border: Border.all(
                        //       width: 0.63.w,
                        //       color: CustomColors.blackColor,
                        //     ),
                        //     borderRadius: BorderRadius.circular(10.r),
                        //   ),
                        //   child: Center(
                        //     child: Text(
                        //       "10:30 AM-10:30 AM",
                        //       style: CustomFonts.black15w400,
                        //     ),
                        //   ),
                        // );
                      }),
                    ),
                    SizedBox(height: 25.h),
                    Divider(
                      color: CustomColors.blackColor.withValues(alpha: 0.2),
                      height: 0,
                    ),
                    SizedBox(height: 15.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 206.w,
                          child: Text(
                            "Derma Fillers - Cheeks By Glow Skin Clinic  ",
                            style: CustomFonts.black12w600,
                          ),
                        ),
                        Text("\$ 550", style: CustomFonts.black12w600),
                      ],
                    ),
                    SizedBox(height: 15.h),
                    Divider(
                      color: CustomColors.blackColor.withValues(alpha: 0.2),
                      height: 0,
                    ),
                    SizedBox(height: 15.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Total Amount", style: CustomFonts.black12w600),
                        Text("\$ 550", style: CustomFonts.black12w600),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 170.h,)
            ],
          ),
        ),
      ),
            bottomNavigationBar: GlassMorphismContainer(
        blurIntensity: 30.0,
      opacity: 0.10,
      glassThickness: 1.0,
    
     // tintColor: Colors.white.withOpacity(0.15),
      enableBackgroundDistortion: true,
      enableGlassBorder: true,
        height: 144.h,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 12.h),
              color: CustomColors.lightPurpleColor,
              child: Center(
                child: Text(
                  "Complete The Appointment Timing Slot To View Full Price",
                  style: CustomFonts.black14w600,
                ),
              ),
            ),
            Padding(
              padding:EdgeInsets.only( top: 10.h),
              child: Center(
                child: Row(
                  
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Text("\$ 650", style: CustomFonts.black28w600),
                
                        Text(
                          "View Pricing Policy",
                          style: CustomFonts.black14w500Underline,
                        ),
                      ],
                    ),
                   SizedBox(width: 47.h,),
                    Container(
                      
                      width: 187.w,
                      height: 60.h,
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(vertical: 19.h),
                      decoration: BoxDecoration(
                        
                        borderRadius: BorderRadius.circular(50.r),
                        color: Colors.black,
                      ),
                      child:  Text("Book Now", style: CustomFonts.white22w600),
                    ),
                  
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    
    );
  }

  Row statusHint({required String status, required Color color}) {
    return Row(
      children: [
        Container(
          height: 11.02.h,
          width: 11.02.w,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3.r),
          ),
        ),
        SizedBox(width: 6.78.w),
        Text(status, style: CustomFonts.black14w500),
      ],
    );
  }
}
