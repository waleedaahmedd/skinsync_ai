import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utills/color_constant.dart';
import '../../utills/custom_fonts.dart';

class BeforeYouBookBottomSheet extends StatefulWidget {
  final String title;
  final List<String> notes;
  final String termsText;
  final String buttonText;
  final VoidCallback? onConfirm;

  const BeforeYouBookBottomSheet({
    super.key,
    this.title = 'Before You Book',
    this.notes = const [
      'Pricing shown is an estimate and may vary based on your in-person consultation and provider assessment.',
      'Treatment results are not guaranteed, and your final outcome may differ from the simulation.',
    ],
    this.termsText = 'terms & conditions',
    this.buttonText = 'I Understand',
    this.onConfirm,
  });

  static void show(
    BuildContext context, {
    String? title,
    List<String>? notes,
    String? buttonText,
    VoidCallback? onConfirm,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => BeforeYouBookBottomSheet(
        title: title ?? 'Before You Book',
        notes:
            notes ??
            const [
              'Pricing shown is an estimate and may vary based on your in-person consultation and provider assessment.',
              'Treatment results are not guaranteed, and your final outcome may differ from the simulation.',
            ],
        buttonText: buttonText ?? 'I Understand',
        onConfirm: onConfirm,
      ),
    );
  }

  @override
  State<BeforeYouBookBottomSheet> createState() =>
      _BeforeYouBookBottomSheetState();
}

class _BeforeYouBookBottomSheetState extends State<BeforeYouBookBottomSheet> {
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.r),
            topRight: Radius.circular(20.r),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(width: 28.w),
                Text(widget.title, style: CustomFonts.black20w600),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 28.w,
                    height: 28.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: CustomColors.blackColor),
                    ),
                    child: Icon(
                      Icons.close,
                      size: 16.sp,
                      color: CustomColors.blackColor,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            ...widget.notes.map(
              (note) => Padding(
                padding: EdgeInsets.only(bottom: 10.h),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('• ', style: CustomFonts.black14w400),
                    Expanded(child: Text(note, style: CustomFonts.black14w400)),
                  ],
                ),
              ),
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                SizedBox(
                  width: 20.w,
                  height: 20.w,
                  child: Checkbox(
                    value: _isChecked,
                    onChanged: (value) => setState(() => _isChecked = value!),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    side: BorderSide(color: Colors.grey.shade400),
                    activeColor: CustomColors.purpleColor,
                  ),
                ),
                SizedBox(width: 8.w),
                RichText(
                  text: TextSpan(
                    text: 'I have read the notes and agree to ',
                    style: CustomFonts.grey14w400,
                    children: [
                      TextSpan(
                        text: widget.termsText,
                        style: CustomFonts.grey14w400.copyWith(
                          decoration: TextDecoration.underline,
                          color: CustomColors.purpleColor,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            // handle terms tap
                          },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),
            SizedBox(
              width: double.infinity,
              // height: 52.h,
              child: ElevatedButton(
                onPressed: _isChecked
                    ? () {
                        Navigator.pop(context);
                        widget.onConfirm?.call();
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: CustomColors.blackColor,
                  disabledBackgroundColor: Colors.grey.shade300,
                ),
                child: Text(widget.buttonText),
              ),
            ),
            SizedBox(height: 8.h),
          ],
        ),
      ),
    );
  }
}
