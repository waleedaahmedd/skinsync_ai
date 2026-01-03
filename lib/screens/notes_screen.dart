import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart';
import 'package:iconsax/iconsax.dart';
import 'package:skinsync_ai/utills/color_constant.dart';
import 'package:skinsync_ai/utills/custom_fonts.dart';
import 'package:skinsync_ai/widgets/custom_app_bar.dart';

class NotesScreen extends StatelessWidget {
  const NotesScreen({super.key});
  static const routeName = "/NotesScreen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text("Notes", style: CustomFonts.black26w600),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30.w),
        child: Column(
          children: [
            SizedBox(height: 23.h),
            Text("Important Notes", style: CustomFonts.black30w600),
            Text(
              "We’ll scan your face and create a cool model just for you to enhance your experience!",
              style: CustomFonts.black16w500,
            ),
            SizedBox(height: 28.h),
            Expanded(
              child: ListView(
                children: [
                  notes(
                    note: "Do not consume alcohol in the last 24-48 hours?",
                  ),
                  SizedBox(height: 31.h),
                  notes(
                    note:
                        "Please share any allergies, medications, or recent skin treatments.",
                  ),
                  SizedBox(height: 31.h),
                  notes(note: "Arrive with clean, product-free skin."),
                  SizedBox(height: 31.h),
                  notes(
                    note:
                        "Mild redness may occur—follow aftercare and avoid sun.",
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Checkbox(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  value: true,
                  onChanged: (value) {},
                  side: BorderSide(color: Colors.grey, width: 1.w),
                ),
                SizedBox(width: 6.w),
                Text(
                  "Yes I have read the notes and agree to ",
                  style: CustomFonts.black13w500,
                ),
                GestureDetector(
                  child: Text(
                    "terms & conditions",
                    style: CustomFonts.blue13w500UnderLine,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                child: Text("Confirm Appointment"),
              ),
            ),
            SizedBox(height: 24.h),
            Center(
              child: Text("Powered By ARKit", style: CustomFonts.grey22w600),
            ),
            SizedBox(height: 60.h),
          ],
        ),
      ),
    );
  }

  Row notes({required String note}) {
    return Row(
      children: [
        Icon(
          Iconsax.info_circle,
          color: CustomColors.lightPurpleColor,
          size: 24.sp,
        ),
        SizedBox(width: 5.w),
        Flexible(child: Text(note, style: CustomFonts.black18w500)),
      ],
    );
  }
}
