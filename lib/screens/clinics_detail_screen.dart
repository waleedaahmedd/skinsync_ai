import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_glass_morphism/flutter_glass_morphism.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:iconsax/iconsax.dart';
import 'package:skinsync_ai/models/responses/get_clinic_response.dart';
import 'package:skinsync_ai/utills/assets.dart';
import 'package:skinsync_ai/utills/color_constant.dart';
import 'package:skinsync_ai/utills/custom_fonts.dart';
import 'package:skinsync_ai/view_models/auth_view_model.dart';

import '../widgets/dialogs/appointment_success_dialog.dart';
import 'bottom_nav_page.dart';

class ClinicsDetailScreen extends ConsumerWidget {
  final Clinic? clinic;
  const ClinicsDetailScreen({super.key, this.clinic});

  static const String routeName = '/ClinicsDetailScreen';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      extendBody: true,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              alignment: Alignment.topCenter,
              height: 293.h,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(DummyAssets.treatmentimage),
                  fit: BoxFit.cover,
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 55.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: EdgeInsets.all(11),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey.withValues(alpha: 0.7),
                        ),
                        child: Icon(
                          CupertinoIcons.arrow_left,
                          size: 22.sp,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    Container(
                      padding: EdgeInsets.all(11),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey.withValues(alpha: 0.7),
                      ),
                      child: Icon(
                        Iconsax.heart,
                        size: 22.sp,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 15.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Consumer(
                    builder: (context, ref, _) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              clinic?.clinicName ?? 'N/A',
                              style: CustomFonts.black30w600,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 6.w,
                              vertical: 4.w,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50.r),
                              color: CustomColors.lightBlueColor.withValues(
                                alpha: 0.2,
                              ),
                            ),
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  SvgAssets.flame,
                                  height: 16.05.h,
                                  width: 12.58,
                                ),
                                SizedBox(width: 7.5.w),
                                Text(
                                  "Top Choice",
                                  style: CustomFonts.black12w600,
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      Icon(Icons.star, size: 18.sp, color: Colors.amberAccent),
                      SizedBox(width: 4.5.w),
                      Text("5.0", style: CustomFonts.black18w600),
                      SizedBox(width: 8.w),
                      Text(
                        "( 30k Reviews ) 1M+ Booked",
                        style: CustomFonts.black16w400,
                      ),
                    ],
                  ),
                  SizedBox(height: 14.h),
                  Text(
                    "Achieve a youthful appearance with our aesthetic treatments to highlight your features. Whether adding volume, smoothing lines, or redefining contours, our solutions help you look and feel your best.",
                    style: CustomFonts.black16w400,
                  ),
                  SizedBox(height: 20.h),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 30.w),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 22.h),
                decoration: BoxDecoration(
                  color: CustomColors.lightPurpleColor.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10.r),
                    bottomLeft: Radius.circular(10.r),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "What Are Off-Peak Hours?",
                      style: CustomFonts.black22w600,
                    ),
                    SizedBox(height: 11.w),
                    Text(
                      "Book your appointment during quieter times and enjoy exclusive discounts.",
                      style: CustomFonts.black16w400,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 22.h),
            Divider(color: CustomColors.greyColor),
            SizedBox(height: 20.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.w),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 21.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                  color: CustomColors.lightBlueColor.withValues(alpha: 0.4),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Monday - Sunday", style: CustomFonts.black20w600),
                        Text(
                          "7 : 00 AM - 12 : 00 PM",
                          style: CustomFonts.black16w400,
                        ),
                      ],
                    ),
                    SizedBox(height: 25.h),
                    Divider(
                      height: 0.h,
                      color: CustomColors.blackColor.withValues(alpha: 0.1),
                    ),
                    SizedBox(height: 18.h),
                    SizedBox(
                      height: 300.h, // ✅ fixed height
                      width: double.infinity,
                      child: Consumer(
                        builder: (_, ref, _) {
                          final position = CameraPosition(
                            target:
                                clinic?.location ??
                                LatLng(24.9211313, 67.0708059),
                            zoom: 13,
                          );
                          log('ADDRESS: ${clinic?.location}');
                          return GoogleMap(
                            initialCameraPosition: position,
                            padding: MediaQuery.paddingOf(ref.context),
                            markers: {
                              Marker(
                                markerId: const MarkerId("clinic_location"),
                                position:
                                    clinic?.location ??
                                    LatLng(24.9211313, 67.0708059),
                              ),
                            },
                            onMapCreated: (controller) async {
                              await controller.animateCamera(
                                CameraUpdate.newCameraPosition(position),
                              );
                            },
                          );
                        },
                      ),
                    ),
                    // Row(
                    //   children: [
                    //     Icon(
                    //       Iconsax.location,
                    //       color: Colors.black,
                    //       size: 20.sp,
                    //     ),
                    //     SizedBox(width: 14.w),
                    //     Flexible(
                    //       child: Text(
                    //         "Bedford-Stuyvesant, Brooklyn, NY 11221",
                    //         overflow: TextOverflow.ellipsis,
                    //         style: CustomFonts.black20w600,
                    //       ),
                    //     ),
                    //   ],
                    // ),

                    // Image.asset(DummyAssets.map, height: 203.h, width: 380.w),
                  ],
                ),
              ),
            ),
            //  SizedBox(height: 26.h),
            // Padding(
            //   padding: EdgeInsets.symmetric(horizontal: 30.0.w),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: [
            //       Column(
            //         crossAxisAlignment: CrossAxisAlignment.start,
            //         children: [
            //           Text(
            //             "Glow Med Spa Services",
            //             style: CustomFonts.black22w600,
            //           ),
            //           SizedBox(height: 9.h),
            //           Text(
            //             "Beloved Services for Everyone",
            //             style: CustomFonts.black16w400,
            //           ),
            //         ],
            //       ),
            //       GestureDetector(
            //         onTap: () {},
            //         child: Container(
            //           padding: EdgeInsets.all(7.w),
            //           decoration: BoxDecoration(
            //             shape: BoxShape.circle,
            //             color: CustomColors.greyColor,
            //           ),
            //           child: Icon(
            //             CupertinoIcons.arrow_right,
            //             size: 16.sp,
            //             color: Colors.black,
            //           ),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            // ListView.builder(
            //   padding: EdgeInsets.only(top: 20.h, bottom: 0),
            //   shrinkWrap: true,
            //   physics: const NeverScrollableScrollPhysics(),
            //   // ⭐ ADD THIS
            //   itemCount: 3,
            //   itemBuilder: (context, index) {
            //     return Padding(
            //       padding: EdgeInsets.symmetric(horizontal: 30.w),
            //       child: Column(
            //         children: [
            //           ListTile(
            //             visualDensity: const VisualDensity(vertical: 0),
            //             contentPadding: EdgeInsets.zero,
            //             leading: ClipRRect(
            //               // ⭐ Better image clipping
            //               borderRadius: BorderRadius.circular(15.r),
            //               child: Image.network(
            //                "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQl-cyJqFlcZav1TlRMEuajtrg2RJlWY3rTQA&s",
            //                 height: 69.h,
            //                 width: 69.w,
            //                 fit: BoxFit.cover,
            //               ),
            //             ),
            //             title: Text(
            //               "Botox Injections",
            //               style: CustomFonts.black18w600,
            //             ),
            //             subtitle: Text(
            //               "Enhance your natural beauty with precision. Subtle results that make a big difference.",
            //               style: CustomFonts.black16w400,
            //             ),
            //             // trailing: Container(
            //             //   padding: EdgeInsets.all(5.w),
            //             //   decoration: BoxDecoration(
            //             //     color: CustomColors.lightPurpleColor.withValues(
            //             //       alpha: 0.2,
            //             //     ),
            //             //     borderRadius: BorderRadius.circular(8.r),
            //             //   ),
            //             //   child: Icon(
            //             //     Icons.add,
            //             //     size: 16.sp,
            //             //     color: CustomColors.pinkColor,
            //             //   ),
            //             // ),
            //           ),
            //           SizedBox(height: 18.h),
            //           Divider(color: CustomColors.greyColor),
            //         ],
            //       ),
            //     );
            //   },
            // ),

            // // Divider(color: CustomColors.greyColor),
            SizedBox(height: 160.h),
            // Padding(
            //   padding: EdgeInsets.symmetric(horizontal: 30.0.w),
            //   child: Text("Proof Of Expertise", style: CustomFonts.black22w600),
            // ),
            // SizedBox(height: 18.h),
            // SizedBox(
            //   height: 210.h,
            //   child: ListView.builder(
            //     padding: EdgeInsets.symmetric(horizontal: 30.w),
            //     scrollDirection: Axis.horizontal,
            //     itemCount: 4,

            //     itemBuilder: (context, index) {
            //       return Padding(
            //         padding: EdgeInsetsGeometry.only(right: 20.w),
            //         child: Column(
            //           crossAxisAlignment: CrossAxisAlignment.start,
            //           children: [
            //             ClipRRect(
            //               borderRadius: BorderRadius.circular(10.r),
            //               child: Image.asset(
            //                 DummyAssets.doctorImage,
            //                 height: 174.h,
            //                 width: 181.w,
            //                 fit: BoxFit.cover,
            //               ),
            //             ),
            //             SizedBox(height: 6.h),
            //             Text("Treatment Name", style: CustomFonts.black18w600),
            //           ],
            //         ),
            //       );
            //     },
            //   ),
            // ),
            // SizedBox(height: 27.h),
            // Divider(color: CustomColors.greyColor),
            // SizedBox(height: 25.h),
            // Padding(
            //   padding: EdgeInsets.symmetric(horizontal: 30.w),
            //   child: Text(
            //     "Our Clients Feedback",
            //     style: CustomFonts.black28w600,
            //   ),
            // ),
            // SizedBox(height: 25.h),
            // SizedBox(
            //   height: 265.h,
            //   child: ListView.builder(
            //     padding: EdgeInsets.symmetric(horizontal: 30.w),
            //     scrollDirection: Axis.horizontal,
            //     itemCount: 4,

            //     itemBuilder: (context, index) {
            //       return Padding(
            //         padding: EdgeInsetsGeometry.only(right: 10.w),
            //         child: Container(
            //           width: 381.w,
            //           padding: EdgeInsets.all(21.w),
            //           decoration: BoxDecoration(
            //             borderRadius: BorderRadius.circular(15.r),
            //             border: Border.all(color: CustomColors.greyColor),
            //           ),
            //           child: Column(
            //             crossAxisAlignment: CrossAxisAlignment.start,
            //             children: [
            //               Text(
            //                 "⭐⭐⭐⭐⭐ 2 Week ago",
            //                 style: CustomFonts.black14w400,
            //               ),
            //               SizedBox(height: 18.h),
            //               Text(
            //                 "“I got lip fillers here, and I’m obsessed! They look so natural and plump—exactly what I wanted. The injector was so skilled and made sure I was comfortable. I’ll definitely be back for more treatments!”",
            //                 style: CustomFonts.black18w400,
            //                 maxLines: 5,
            //                 overflow: TextOverflow.ellipsis,
            //               ),
            //               SizedBox(height: 21.h),
            //               Row(
            //                 children: [
            //                   ClipOval(
            //                     child: Image.asset(
            //                       DummyAssets.acen,
            //                       height: 43.w,
            //                       width: 43.w,
            //                       fit: BoxFit.fill,
            //                     ),
            //                   ),
            //                   SizedBox(width: 8.w),
            //                   Text(
            //                     "Sarah Jhonson",
            //                     style: CustomFonts.black18w600,
            //                   ),
            //                 ],
            //               ),
            //             ],
            //           ),
            //         ),
            //       );
            //     },
            //   ),
            // ),

            // SizedBox(height: 160.h),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.paddingOf(context).bottom),
        child: GlassMorphismContainer(
          borderRadius: BorderRadius.all(Radius.circular(0.r)),
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
                padding: EdgeInsets.only(top: 20.h, left: 30.w, right: 30.w),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // ref
                      //     .read(checkoutViewModel.notifier)
                      //     .updateState(clinicId: "xx");

                      // Navigator.pushNamed(
                      //   context,
                      //   ClinicServiceScreen.routeName,
                      //   arguments: clinic,
                      // );
                      showAppointmentSuccessDialog(
                        context: context,
                        onDone: () {
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            BottomNavPage.routeName,
                            (_) => false,
                          );
                        },
                      );
                    },
                    child: Text("Book An Appointment"),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
