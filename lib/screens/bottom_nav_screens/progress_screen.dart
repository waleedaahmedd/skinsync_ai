import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../utills/custom_fonts.dart';
import '../../widgets/app_bar_with_action_icon.dart';

import '../../widgets/grey_container.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  String selectedFilter = 'ongoing'; // 'completed' or 'ongoing'

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWithActionIcon(
        action: GreyContainer(
          icon: Icons.notifications_none_outlined,
          onTap: () {},
        ),
      ),

      body: Column(
        children: [
          SizedBox(height: 15.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.0.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  style: CustomFonts.black18w400,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    hintText: "Search Progress",
                  ),
                ),
                SizedBox(height: 15.h),
                Text("Progress", style: CustomFonts.black24w600),
                SizedBox(height: 200.h),
                Center(
                  child: Text(
                    'No treatment progress recorded',
                    style: CustomFonts.grey16w400,
                  ),
                ),

                /* Row(
                  children: [
                    ProgressFillterButton(
                      isSelected: selectedFilter == 'completed',
                      label: 'Completed',
                      icon: SvgAssets.tick,
                      onTap: () {
                        setState(() {
                          selectedFilter = 'completed';
                        });
                      },
                    ),
                    SizedBox(width: 11.w),
                    ProgressFillterButton(
                      isSelected: selectedFilter == 'ongoing',
                      label: 'Ongoing',
                      icon: SvgAssets.progressfilled,
                      onTap: () {
                        setState(() {
                          selectedFilter = 'ongoing';
                        });
                      },
                    ),
                  ],
                ),
                SizedBox(height: 22.h),*/
              ],
            ),
          ),
          /* Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.0.w),
              child: ListView.builder(
                itemCount: 4,
                itemBuilder: (context, index) {
                  return ProgressCard();
                },
              ),
            ),
          ),*/
          SizedBox(height: 70.h),
        ],
      ),
    );
  }
}
