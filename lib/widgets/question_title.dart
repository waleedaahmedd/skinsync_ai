import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import '../utils/custom_fonts.dart';
import 'radio_button_widget.dart';

class QuestionTitle extends StatelessWidget {
  final bool isSelected;
  final String title;
  const QuestionTitle({super.key, required this.isSelected, required this.title});

  @override
  Widget build(BuildContext context) {
    return Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(context.r(50))),
                ),
                margin: EdgeInsets.only(bottom: context.h(12)),
                child: Padding(
                  padding: EdgeInsets.all(context.w(16)),
                  child: Row(
                    children: [
                      RadioButtonWidget(isSelected: isSelected),
                      SizedBox(width: context.w(12)),
                      Flexible(
                        child: Text(
                          title,
                          style: CustomFonts.black18w600,
                        ),
                      ),
                    ],
                  ),
                ),
              );
  }
}