import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'additional_info_screen.dart';
import '../utills/assets.dart';
import '../utills/color_constant.dart';
import '../utills/custom_fonts.dart';
import '../widgets/custom_app_bar.dart';

final selectedProductProvider = StateProvider<int?>((ref) => null);

class SelectProductScreen extends ConsumerWidget {
  static const routeName = '/select_product_screen';
  const SelectProductScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: const CustomAppBar(showTitle: false),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10.h),

            Text.rich(
              TextSpan(
                text: 'Select Product',
                style: CustomFonts.black22w600,
                children: [
                  TextSpan(
                    text: ' (Treatment Name)',
                    style: CustomFonts.black22w500,
                  ),
                ],
              ),
            ),

            SizedBox(height: 11.h),

            Text(
              "Choose the product best suited for your treatment.\nEach option is selected to enhance your results.",
              style: CustomFonts.black16w400,
            ),

            SizedBox(height: 16.h),

            Expanded(
              child: ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) {
                   final selectedIndex = ref.watch(selectedProductProvider);
      final isSelected = selectedIndex == index;
                  return Padding(
                    padding: EdgeInsets.only(bottom: 15.h),
                    child: GestureDetector(
                      onTap: (){
                          ref.read(selectedProductProvider.notifier).state = index;
                      },
                      child: Container(
                      
                        padding: EdgeInsets.symmetric(
                            horizontal: 12.w, vertical: 12.h),
                        decoration: BoxDecoration(
                          color: isSelected ? CustomColors.lightPurpleColor.withValues(alpha: 0.2): Colors.white,
                          borderRadius: BorderRadius.circular(10.r),
                          border: Border.all(color:isSelected ? CustomColors.lightPurpleColor:  Colors.grey.shade300),
                        ),
                        child: Row(
                          children: [
                            Image.asset(
                              DummyAssets.productImage,
                              height: 48.h,
                              width: 48.w,
                            ),
                            SizedBox(width: 10.w),
                      
                            /// Prevent overflow
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Product Name",
                                    style: CustomFonts.black14w700,
                                  ),
                                  SizedBox(height: 4.h),
                                  Text(
                                    "\$ 40",
                                    style: CustomFonts.red13w500,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),

      /// Bottom Bar
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(
        
          top: 20.h,
          bottom: MediaQuery.paddingOf(context).bottom + 20.h,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(padding: EdgeInsetsGeometry.symmetric(horizontal: 30.w),
            child: Column(
              children: [
                const Divider(height: 0,),
            SizedBox(height: 14.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    "Derma Fillers - Cheeks By Glow Skin Clinic",
                    style: CustomFonts.black14w600,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(width: 10.w),
                Text(
                  "\$ 550",
                  style: CustomFonts.black14w600,
                ),
              ],
            ),
            SizedBox(height: 14.h),
            const Divider(height: 0,),
             SizedBox(height: 14.h),
             Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    "Total Amount",
                    style: CustomFonts.black14w600,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(width: 10.w),
                Text(
                  "\$ 550",
                  style: CustomFonts.black14w600,
                ),
              ],
            ),
            SizedBox(height: 14.h,),
              ],
            ),),
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
                padding: EdgeInsets.only(top: 10.h),
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
                      SizedBox(width: 47.h),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            AdditionalInfoScreen.routeName,
                          );
                        },
                        child: Container(
                          width: 187.w,
                          height: 60.h,
                          alignment: Alignment.center,

                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50.r),
                            color: Colors.black,
                          ),
                          child: Center(
                            child: Text(
                              "Book Now",
                              style: CustomFonts.white22w600,
                            ),
                          ),
                        ),
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
}