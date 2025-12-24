import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skinsync_ai/screens/ar_face_model_Preview_screen.dart';
import 'package:skinsync_ai/utills/color_constant.dart';
import 'package:skinsync_ai/widgets/grey_container.dart';
import 'package:skinsync_ai/widgets/service_type_button.dart';

import '../utills/assets.dart';
import '../utills/custom_fonts.dart';
import '../view_models/face_scan_provider.dart';

class ServiceSelectionScreen extends StatelessWidget {
  ServiceSelectionScreen({super.key});
  static const String routeName = '/ServiceSelectionScreen';

  final List<String> skinServices = [
    'Facial',
    'Deep Cleanse',
    'Anti-Aging',
    'Hydrating',
    'Brightening',
    'Acne Care',
    'Oxygen Facial',
    'Collagen Boost',
    'Microdermabrasion',
    'Chemical Peel',
    'Microneedling',
    'Dermaplaning',
    'LED Therapy',
    'RF Tightening',
    'Laser Resurfacing',
    'Botox',
    'Fillers',
    'PRP Therapy',
    'Body Scrub',
    'Body Wrap',
    'Back Facial',
    'Hand & Foot',
    'Skin Brightening',
    'Scar Reduction',
    'Mole Removal',
    'Wart Removal',
    'Skin Tag Removal',
    'Pigmentation',
    'Dark Spot Reduction',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Consumer(
            builder: (_, ref, _) {
              final image = ref.watch(
                faceScanProvider.select((state) => state.capturedImage),
              );
              return Image.file(
                File(image!.path),
                fit: BoxFit.cover,
                width: double.infinity,
                height: 326.h,
              );
            },
          ),
          Positioned(
            top: 30.h,
            left: 16.w,
            right: 16.w,
            child: SafeArea(
              child: Row(
                children: [
                  GreyContainer(
                    icon: Icons.arrow_back,
                    shape: BoxShape.circle,
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  SizedBox(width: 16.w),
                  ServiceTypeButton(
                    icon: Image.asset(PngAssets.syringe, width: 21.w),
                    text: "Dermal Fillers",
                    selected: true,
                    frosted: true,
                  ),
                  SizedBox(width: 10.w),
                  ServiceTypeButton(
                    icon: Image.asset(PngAssets.hand, width: 21.w),
                    text: "Botox",
                    selected: false,
                  ),
                ],
              ),
            ),
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              height: 440.h,
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.r),
                  topRight: Radius.circular(30.r),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),

                  child: Container(
                    // height: 440.h,
                    padding: EdgeInsets.only(
                      top: 22.h,
                      left: 30.h,
                      right: 30.h,
                    ),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              ...List.generate(skinServices.length, (index) {
                                return Container(
                                  margin: EdgeInsets.only(right: 10.w),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 14.w,
                                  ),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: index.isEven
                                        ? Colors.transparent
                                        : CustomColors.purpleColor,
                                    borderRadius: BorderRadius.circular(15.r),
                                  ),
                                  height: 85.h,
                                  width: 76.w,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(PngAssets.splashLogo),
                                      Text(
                                        skinServices[index],
                                        style: index.isEven
                                            ? CustomFonts.black14w500.copyWith(
                                                overflow: TextOverflow.ellipsis,
                                              )
                                            : CustomFonts.white14w500.copyWith(
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                            ],
                          ),
                        ),

                        SizedBox(height: 25.h),
                        Text('Area Selection', style: CustomFonts.black18w600),
                        SizedBox(height: 10.h),
                        DropdownButtonFormField(
                          value: skinServices[0],
                          items: skinServices
                              .map(
                                (e) => DropdownMenuItem(
                                  value: e,
                                  child: Text(
                                    e,
                                    style: CustomFonts.black16w500,
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (_) {},
                          decoration: InputDecoration(
                            fillColor: CustomColors.whiteColor,
                            filled: true,
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: CustomColors.blackColor,
                              ),
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                        ),
                        SizedBox(height: 25.h),
                        Text(
                          'Select no of syringes',
                          style: CustomFonts.black18w600,
                        ),
                        SizedBox(height: 10.h),
                        DropdownButtonFormField(
                          value: 1,
                          items: List.generate(10, (index) => index + 1)
                              .map(
                                (e) => DropdownMenuItem(
                                  value: e,
                                  child: Text(
                                    e.toString(),
                                    style: CustomFonts.black16w500,
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (_) {},
                          decoration: InputDecoration(
                            fillColor: CustomColors.whiteColor,
                            filled: true,
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: CustomColors.blackColor,
                              ),
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                        ),
                        SizedBox(height: 22.h),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                ArFaceModelPreviewScreen.routeName,
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: CustomColors.blackColor,
                              padding: EdgeInsets.symmetric(
                                horizontal: 100.w,
                                vertical: 15.h,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.r),
                              ),
                            ),
                            child: Text(
                              'Proceed',
                              style: CustomFonts.white18w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
