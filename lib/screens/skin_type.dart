import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skinsync_ai/utills/custom_fonts.dart';
import 'package:skinsync_ai/widgets/question_title.dart';

import 'package:skinsync_ai/widgets/radio_button_widget.dart';

class SkinType extends StatelessWidget {
  const SkinType({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 33.h),
        Text('Please Describe Your Skin\nType Here?',style: CustomFonts.black28w600,),
        SizedBox(height: 39.h),
    
        // ⭐ FIX: Give ListView a height using Expanded
        Expanded(
          child: ListView.builder(
            itemCount: 10,
            itemBuilder: (context, index) {
              return QuestionTitle(title: "Combination skin");
            },
          ),
        ),
        SizedBox(height: 20.h,),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(onPressed: (){}, child: Text("Next"))),
          SizedBox(height: 20.h,),
      ],
    );
  }
}
