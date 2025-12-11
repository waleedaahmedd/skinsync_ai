import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skinsync_ai/utills/custom_fonts.dart';
import 'package:skinsync_ai/widgets/radio_button_widget.dart';

class QuestionTitle extends StatelessWidget {
  final String title;
  const QuestionTitle({super.key,required this.title});

  @override
  Widget build(BuildContext context) {
    return Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(50.r)),
                ),
                margin: EdgeInsets.only(bottom: 12.h),
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Row(
                    children: [
                      RadioButtonWidget(),
                      SizedBox(width: 12.w),
                      Flexible(
                        child: Text(
                          title,
                          style: CustomFonts.black18w600,
                        ),
                      ),
                    ],
                  ),
                ),
              );;
  }
}