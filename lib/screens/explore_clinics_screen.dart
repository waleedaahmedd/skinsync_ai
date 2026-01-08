import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:skinsync_ai/models/dummy_list_model.dart';
import 'package:skinsync_ai/utills/assets.dart';
import 'package:skinsync_ai/utills/color_constant.dart';
import 'package:skinsync_ai/widgets/custom_clinic_grid_view_title.dart';
import 'package:skinsync_ai/widgets/custom_grid_view_tile.dart';
import 'package:skinsync_ai/widgets/frosted_container.dart';

import '../utills/custom_fonts.dart';
import '../view_models/checkout_view_model.dart';
import '../widgets/app_bar_with_action_icon.dart';
import '../widgets/grey_container.dart';
import 'clinics_detail_screen.dart';

class ExploreClinicsScreen extends ConsumerWidget {
  const ExploreClinicsScreen({super.key});
  static const String routeName = '/ExploreClinicsScreen';

  @override
  Widget build(BuildContext context, ref) {
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
                  itemCount: 6,
                  itemBuilder: (context, index) {
                    return CustomClinicGridViewTile(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          ClinicsDetailScreen.routeName,
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
