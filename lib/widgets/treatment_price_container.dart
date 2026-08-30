import 'package:material_ui/material_ui.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import '../models/responses/treatment_list_response.dart';
import '../models/responses/treatment_area_list_response.dart';
import '../utils/string_utils.dart';
import '../utils/color_constant.dart';
import '../utils/custom_fonts.dart';

class TreatmentPriceContainer extends StatelessWidget {
  final List<TreatmentAreaModel> selectedSubAreasList;
  final TreatmentData? selectedTreatment;
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
          borderRadius: BorderRadius.circular(context.r(15)),
          border: Border.all(
            color: isSelected
                ? CustomColors.lightPurpleColor
                : CustomColors.greyColor,
            width: 0.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  height: context.h(48),
                  width: context.w(48),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(context.r(10)),
                    ),
                    image: DecorationImage(
                      image: AssetImage(image),
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                ),
                SizedBox(width: context.w(11)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            selectedTreatment?.name?.capitalize ?? "N/A",
                            style: CustomFonts.black14w700,
                          ),
                          Text("\$ 550", style: CustomFonts.red13w500),
                        ],
                      ),
                      SizedBox(height: context.h(2)),

                      // SizedBox(height: context.h(2)),
                      Row(
                        children: [
                          Text(
                            "No Of Injectors:",
                            style: CustomFonts.grey13w400,
                          ),
                          SizedBox(width: context.w(2)),
                          Text("4", style: CustomFonts.red13w500),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: context.h(4)),
            Wrap(
              spacing: context.w(8),
              runSpacing: context.h(8),
              children: selectedSubAreasList.map((e) {
                final name = e.name ?? '-';
                return Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.w(8),
                    vertical: context.h(4),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(context.r(999)),
                    border: Border.all(
                      color: Colors.black.withValues(alpha: 0.08),
                    ),
                  ),
                  child: Text(name.capitalize, style: CustomFonts.black14w500),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
