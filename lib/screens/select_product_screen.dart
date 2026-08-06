import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
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
        padding: EdgeInsets.symmetric(horizontal: context.w(30)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: context.h(10)),

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

            SizedBox(height: context.h(11)),

            Text(
              "Choose the product best suited for your treatment.\nEach option is selected to enhance your results.",
              style: CustomFonts.black16w400,
            ),
            SizedBox(height: context.h(16)),

            Expanded(
              child: ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) {
                   final selectedIndex = ref.watch(selectedProductProvider);
      final isSelected = selectedIndex == index;
                  return Padding(
                    padding: EdgeInsets.only(bottom: context.h(15)),
                    child: GestureDetector(
                      onTap: (){
                          ref.read(selectedProductProvider.notifier).state = index;
                      },
                      child: Container(
                      
                        padding: EdgeInsets.symmetric(
                            horizontal: context.w(12), vertical: context.h(12)),
                        decoration: BoxDecoration(
                          color: isSelected ? CustomColors.lightPurpleColor.withValues(alpha: 0.2): Colors.white,
                          borderRadius: BorderRadius.circular(context.r(10)),
                          border: Border.all(color:isSelected ? CustomColors.lightPurpleColor:  Colors.grey.shade300),
                        ),
                        child: Row(
                          children: [
                            Image.asset(
                              DummyAssets.productImage,
                              height: context.h(48),
                              width: context.w(48),
                            ),
                            SizedBox(width: context.w(10)),
                      
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
                                  SizedBox(height: context.h(4)),
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
        
          top: context.h(20),
          bottom: MediaQuery.paddingOf(context).bottom + context.h(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(padding: EdgeInsetsGeometry.symmetric(horizontal: context.w(30)),
            child: Column(
              children: [
                const Divider(height: 0,),
            SizedBox(height: context.h(14)),
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
                SizedBox(width: context.w(10)),
                Text(
                  "\$ 550",
                  style: CustomFonts.black14w600,
                ),
              ],
            ),
            SizedBox(height: context.h(14)),
            const Divider(height: 0,),
             SizedBox(height: context.h(14)),
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
                SizedBox(width: context.w(10)),
                Text(
                  "\$ 550",
                  style: CustomFonts.black14w600,
                ),
              ],
            ),
            SizedBox(height: context.h(14),),
              ],
            ),),
                Container(
                padding: EdgeInsets.symmetric(vertical: context.h(12)),
                color: CustomColors.lightPurpleColor,
                child: Center(
                  child: Text(
                    "Complete The Appointment Timing Slot To View Full Price",
                    style: CustomFonts.black14w600,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: context.h(10)),
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
                      SizedBox(width: context.h(47)),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            AdditionalInfoScreen.routeName,
                          );
                        },
                        child: Container(
                          width: context.w(187),
                          height: context.h(60),
                          alignment: Alignment.center,

                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(context.r(50)),
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