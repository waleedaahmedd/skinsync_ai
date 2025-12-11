import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skinsync_ai/utills/custom_fonts.dart';
import 'package:skinsync_ai/widgets/question_title.dart';

class MainSkinConcernsScreen extends StatelessWidget {
  const MainSkinConcernsScreen ({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 33.h),
        Text('What are your main skin concerns? (Select all that apply)',style: CustomFonts.black28w600,),
        SizedBox(height: 39.h),
    
        // ⭐ FIX: Give ListView a height using Expanded
        Expanded(
          child: ListView.builder(
            itemCount: 10,
            itemBuilder: (context, index) {
              return QuestionTitle(title: "Dark spots or pigmentation ");
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