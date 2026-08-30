import 'package:material_ui/material_ui.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import '../../utils/custom_fonts.dart';
import '../../widgets/app_bar_with_action_icon.dart';
import '../../widgets/custom_search_field.dart';

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
          SizedBox(height: context.h(15)),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: context.w(30.0)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const CustomSearchField(
                  hintText: "Search Progress",
                ),
                SizedBox(height: context.h(15)),
                Text("Progress", style: CustomFonts.black24w600),
                SizedBox(height: context.h(200)),
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
                    SizedBox(width: context.w(11)),
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
                SizedBox(height: context.h(22)),*/
              ],
            ),
          ),
          /* Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: context.w(30.0)),
              child: ListView.builder(
                itemCount: 4,
                itemBuilder: (context, index) {
                  return ProgressCard();
                },
              ),
            ),
          ),*/
          SizedBox(height: context.h(70)),
        ],
      ),
    );
  }
}
