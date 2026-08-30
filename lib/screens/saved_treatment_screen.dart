import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_svg/svg.dart';
import '../utils/assets.dart';
import '../utils/color_constant.dart';
import '../utils/custom_fonts.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/heading_with_right_arrow.dart';

class SavedTreatmentScreen extends StatelessWidget {
  const SavedTreatmentScreen({super.key});
  static const String routeName = '/SavedTreatmentScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(
        showTitle: true,
        title: "Saved Treatments",
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Divider(color: CustomColors.greyColor.withValues(alpha: 0.6), height: context.h(1)),
            SizedBox(height: context.h(24)),

            // Section 1: AI Model Treatment Section
            Padding(
              padding: EdgeInsets.symmetric(horizontal: context.w(24)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Your AI Treatment Models",
                        style: CustomFonts.black20w600,
                      ),
                      Container(
                        padding: EdgeInsets.all(context.w(6)),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: CustomColors.greyColor.withValues(alpha: 0.6),
                        ),
                        child: Icon(
                          CupertinoIcons.arrow_right,
                          size: context.sp(14),
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: context.h(16)),

            // Horizontal AI Models list
            SizedBox(
              height: context.h(225),
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount: 4,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(
                      left: index == 0 ? context.w(24) : 0,
                      right: context.w(12),
                    ),
                    child: Container(
                      width: context.w(170),
                      padding: EdgeInsets.all(context.w(8)),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(context.r(20)),
                        border: Border.all(
                          color: CustomColors.greyColor.withValues(alpha: 0.5),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.015),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(context.r(14)),
                            child: Image.asset(
                              DummyAssets.doctorImage,
                              height: context.h(125),
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(height: context.h(8)),
                          Expanded(
                            child: Text(
                              "AI Model Session",
                              style: CustomFonts.black13w600,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: context.h(28)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: context.w(24)),
              child: Divider(color: Colors.grey.shade100, height: context.h(1)),
            ),
            SizedBox(height: context.h(24)),

            // Section 2: Clinical Treatment List
            Padding(
              padding: EdgeInsets.symmetric(horizontal: context.w(24)),
              child: HeadingWithRightArrow(
                title: "Your Saved Clinics & Treatments",
                onTap: () {},
              ),
            ),
            SizedBox(height: context.h(16)),

            // Saved Clinics List
            SizedBox(
              height: context.h(220),
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount: 4,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(
                      left: index == 0 ? context.w(24) : 0,
                      right: context.w(12),
                    ),
                    child: Container(
                      width: context.w(290),
                      padding: EdgeInsets.all(context.w(10)),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(context.r(20)),
                        border: Border.all(
                          color: CustomColors.greyColor.withValues(alpha: 0.5),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.015),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(context.r(14)),
                            child: Image.asset(
                              DummyAssets.treatmentimage,
                              height: context.h(120),
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(height: context.h(10)),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Botox Treatment",
                                      style: CustomFonts.black13w600,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: context.h(2)),
                                    Text(
                                      "October 20, 3:00 PM",
                                      style: CustomFonts.grey700_10w400,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: context.w(8)),
                              Row(
                                children: [
                                  SvgPicture.asset(
                                    SvgAssets.mappin,
                                    height: context.h(11),
                                    width: context.w(11),
                                    colorFilter: const ColorFilter.mode(
                                      CustomColors.pinkColor,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                  SizedBox(width: context.w(4)),
                                  Text(
                                    "Glow Clinic",
                                    style: CustomFonts.pink10w700,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: context.h(40)),
          ],
        ),
      ),
    );
  }
}