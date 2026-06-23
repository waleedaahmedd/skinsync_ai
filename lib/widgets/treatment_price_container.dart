import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../models/responses/treatment_response_model.dart';
import '../models/responses/treatment_sub_area_response.dart';
import '../utills/color_constant.dart';
import '../utills/custom_fonts.dart';

class TreatmentPriceContainer extends StatelessWidget {
  final List<TreatmentSubAreaModel> selectedSubAreasList;
  final TreatmentsModel? selectedTreatment;
  final String image;

  final bool isSelected;

  const TreatmentPriceContainer({
    super.key,
    required this.image,
    required this.isSelected,
    this.selectedSubAreasList = const [],
    required this.selectedTreatment,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.r),
          border: Border.all(
            color: isSelected
                ? CustomColors.lightPurpleColor
                : CustomColors.greyColor,
            width: 0.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: .start,
          children: [
            Row(
              children: [
                Container(
                  height: 48.h,
                  width: 48.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10.r)),
                    image: DecorationImage(
                      image: AssetImage(image),
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                ),
                SizedBox(width: 11.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: .spaceBetween,
                        children: [
                          Text(
                            selectedTreatment?.name ?? "N/A",
                            style: CustomFonts.black14w700,
                          ),
                          Text("\$ 550", style: CustomFonts.red13w500),
                        ],
                      ),
                      SizedBox(height: 2.h),

                      // SizedBox(height: 2.h),
                      Row(
                        children: [
                          Text(
                            "No Of Injectors:",
                            style: CustomFonts.grey13w400,
                          ),
                          SizedBox(width: 2.w),
                          Text("4", style: CustomFonts.red13w500),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 4.h),
            Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: selectedSubAreasList.map((e) {
                final name = e.name ?? '-';
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(999.r),
                    border: Border.all(
                      color: Colors.black.withValues(alpha: 0.08),
                    ),
                  ),
                  child: Text(name, style: CustomFonts.black14w500),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
