import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../../utils/color_constant.dart';
import '../../utils/custom_fonts.dart';
import '../custom_button.dart';

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
      constraints: .new(minWidth: 1.sw),
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
        padding: EdgeInsets.all(context.w(20)),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(context.r(20)),
            topRight: Radius.circular(context.r(20)),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(width: context.w(28)),
                Text(widget.title, style: CustomFonts.black20w600),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: context.w(28),
                    height: context.w(28),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: CustomColors.blackColor),
                    ),
                    child: Icon(
                      Icons.close,
                      size: context.sp(16),
                      color: CustomColors.blackColor,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: context.h(16)),
            ...widget.notes.map(
              (note) => Padding(
                padding: EdgeInsets.only(bottom: context.h(10)),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('• ', style: CustomFonts.black14w400),
                    Expanded(child: Text(note, style: CustomFonts.black14w400)),
                  ],
                ),
              ),
            ),
            SizedBox(height: context.h(12)),
            Row(
              children: [
                SizedBox(
                  width: context.w(20),
                  height: context.w(20),
                  child: Checkbox(
                    value: _isChecked,
                    onChanged: (value) => setState(() => _isChecked = value!),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(context.r(4)),
                    ),
                    side: BorderSide(color: Colors.grey.shade400),
                    activeColor: CustomColors.purpleColor,
                  ),
                ),
                SizedBox(width: context.w(8)),
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
            SizedBox(height: context.h(20)),
            SizedBox(
              width: double.infinity,
              // height: context.h(52),
              child: CustomButton(
                onPressed: _isChecked
                    ? () {
                        Navigator.pop(context);
                        widget.onConfirm?.call();
                      }
                    : null,
                backgroundColor: _isChecked
                    ? Colors.black
                    : Colors.grey.shade300,
                text: widget.buttonText,
              ),
            ),
            SizedBox(height: context.h(8)),
          ],
        ),
      ),
    );
  }
}
