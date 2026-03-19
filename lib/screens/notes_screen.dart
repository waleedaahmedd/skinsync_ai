import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:skinsync_ai/screens/bottom_nav_page.dart';
import 'package:skinsync_ai/utills/color_constant.dart';
import 'package:skinsync_ai/utills/custom_fonts.dart';
import 'package:skinsync_ai/widgets/custom_app_bar.dart';

final notesAgreementProvider = StateProvider<bool>((ref) => false);

class NotesScreen extends StatelessWidget {
  static const routeName = "/notes_screen";
  const NotesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(showTitle: true, title: "Notes"),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30.0.w),
        child: Column(
          crossAxisAlignment: .start,
          children: [
            SizedBox(height: 20.h),
            Text("Important Notes", style: CustomFonts.black30w600),
            SizedBox(height: 2.h),
            Text(
              "We’ll scan your face and create a cool model just for you to enhance your experience!",
              style: CustomFonts.black16w500,
            ),
            SizedBox(height: 28.h),
            _buildNotes(
              note: "Do not consume alcohol in the last 24-48 hours?",
            ),
            SizedBox(height: 30.h),
            _buildNotes(
              note:
                  "Please share any allergies, medications, or recent skin treatments.",
            ),
            SizedBox(height: 30.h),
            _buildNotes(note: "Arrive with clean, product-free skin."),
            SizedBox(height: 30.h),
            _buildNotes(
              note: "Mild redness may occur—follow aftercare and avoid sun.",
            ),
            Spacer(),
            Row(
              children: [
                Consumer(
                  builder: (context, ref, _) {
                    final isChecked = ref.watch(notesAgreementProvider);
                    return Checkbox(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.r),
                        side: BorderSide(
                          color: Colors.grey.shade100,
                          width: 1.w,
                        ),
                      ),
                      value: isChecked,
                      onChanged: (value) {
                        ref.read(notesAgreementProvider.notifier).state =
                            value ?? false;
                      },
                    );
                  },
                ),
                SizedBox(width: 6.w),
                Text(
                  "Yes I have read the notes and agree to",
                  style: CustomFonts.black13w500,
                ),
                GestureDetector(
                  child: Text(
                    " terms & conditions",
                    style: CustomFonts.blue14w400Underline,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    BottomNavPage.routeName,
                    (_) => false,
                  );
                },
                child: Text("Confirm Appointment"),
              ),
            ),
            SizedBox(height: 20.h),
            Center(
              child: Text("Powered By ARKit", style: CustomFonts.grey22w600),
            ),
            SizedBox(height: MediaQuery.paddingOf(context).bottom + 20.h),
          ],
        ),
      ),
    );
  }

  Widget _buildNotes({required String note}) {
    return Row(
      children: [
        Icon(
          Iconsax.info_circle,
          color: CustomColors.lightPurpleColor,
          size: 24.sp,
        ),
        SizedBox(width: 17.w),
        Expanded(child: Text(note, style: CustomFonts.black18w500)),
      ],
    );
  }
}
