import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:skinsync_ai/utills/assets.dart';
import 'package:skinsync_ai/utills/color_constant.dart';
import 'package:skinsync_ai/widgets/frosted_container.dart';

import '../utills/custom_fonts.dart';
import '../widgets/app_bar_with_action_icon.dart';
import '../widgets/grey_container.dart';

class ExploreClinicsScreen extends StatelessWidget {
  const ExploreClinicsScreen({super.key});
  static const String routeName = '/ExploreClinicsScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWithActionIcon(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.location_on_outlined, color: CustomColors.blackColor),
            Text("New York", style: CustomFonts.black30w600),
          ],
        ),
        subTitle: Text(
          "195 Karlie Brooks, Anderson",
          style: CustomFonts.grey18w400,
        ),
        action: GreyContainer(
          icon: Icons.notifications_none_outlined,
          onTap: () {},
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30.w),
        child: Column(
          children: [
            TextField(
              style: CustomFonts.black18w400,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: "Search  doctor, injector, treatment & clinic",
              ),
            ),
            SizedBox(height: 15.h),

            Row(
              children: [
                InkWell(
                  onTap: () => Navigator.pop(context),
                  child: GreyContainer(
                    icon: Icons.arrow_back,
                    shape: BoxShape.circle,
                    onTap: () => Navigator.pop(context),
                  ),
                ),
                Spacer(),
                Text("AR Face Model Preview", style: CustomFonts.black26w600),
                Spacer(),
              ],
            ),
            SizedBox(height: 20.h),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // 2 items horizontally
                  crossAxisSpacing: 18.w,
                  mainAxisSpacing: 18.h,
                  childAspectRatio: 0.7,
                ),
                itemCount: 10,
                itemBuilder: (context, index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10.r),
                            child: Image.asset(
                              PngAssets.laserTreatment,
                              fit: BoxFit.fitWidth,
                            ),
                          ),
                          Positioned(
                            top: 6.h,
                            left: 5.w,
                            child: FrostedContainer(
                              borderRadius: 8.r,
                              padding: EdgeInsets.symmetric(
                                horizontal: 6.w,
                                vertical: 4.h,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SvgPicture.asset(SvgAssets.flame),
                                  SizedBox(width: 7.w),
                                  Text(
                                    "Top Choice",
                                    style: CustomFonts.black12w600,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 6.h,
                            right: 5.w,
                            child: FrostedContainer(
                              borderRadius: 8.r,
                              padding: EdgeInsets.symmetric(
                                horizontal: 6.w,
                                vertical: 4.h,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.star,
                                    color: Color(0XFFF68712),
                                    size: 16.sp,
                                  ),
                                  SizedBox(width: 4.w),
                                  Text("4.9", style: CustomFonts.black12w600),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            top: 6.h,
                            right: 5.w,
                            child: FrostedContainer(
                              borderRadius: 50.r,
                              padding: EdgeInsets.symmetric(
                                horizontal: 6.w,
                                vertical: 4.h,
                              ),
                              child: Icon(
                                Icons.favorite_border,
                                color: Colors.white,
                                size: 19.sp,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        "Facial Aesthetic Clinic",
                        style: CustomFonts.black18w600,
                      ),
                      Text(
                        "Dermal Fillers – Cheeks",
                        style: CustomFonts.black14w400,
                      ),
                      Text(
                        "11:00 AM - 12:00 PM",
                        style: CustomFonts.black14w400,
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
