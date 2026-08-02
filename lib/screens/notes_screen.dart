
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:iconsax/iconsax.dart';
import '../utills/color_constant.dart';
import '../utills/custom_fonts.dart';
import '../view_models/checkout_view_model.dart';
import '../widgets/custom_app_bar.dart';

import 'bottom_nav_page.dart';

final notesAgreementProvider = StateProvider<bool>((ref) => false);

class NotesScreen extends ConsumerWidget {
  static const routeName = "/notes_screen";
  const NotesScreen({super.key});

  void _listener(
    BuildContext context,
    WidgetRef ref,
    CheckoutState? prev,
    CheckoutState next,
  ) {
    if (next.appointment != null) {
      ref.read(checkoutViewModel.notifier).clearState();
      Navigator.pushNamedAndRemoveUntil(
        context,
        BottomNavPage.routeName,
        (_) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(
      checkoutViewModel,
      (prev, next) => _listener(context, ref, prev, next),
    );
    return Scaffold(
      appBar: const CustomAppBar(showTitle: true, title: "Notes"),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: context.w(30.0)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: context.h(20)),
            Text("Important Notes", style: CustomFonts.black30w600),
            SizedBox(height: context.h(2)),
            Text(
              "We’ll scan your face and create a cool model just for you to enhance your experience!",
              style: CustomFonts.black16w500,
            ),
            SizedBox(height: context.h(28)),
            _buildNotes(
              context: context,
              note: "Do not consume alcohol in the last 24-48 hours?",
            ),
            SizedBox(height: context.h(30)),
            _buildNotes(
              context: context,
              note:
                  "Please share any allergies, medications, or recent skin treatments.",
            ),
            SizedBox(height: context.h(30)),
            _buildNotes(context: context, note: "Arrive with clean, product-free skin."),
            SizedBox(height: context.h(30)),
            _buildNotes(
              context: context,
              note: "Mild redness may occur—follow aftercare and avoid sun.",
            ),
            const Spacer(),
            Row(
              children: [
                Consumer(
                  builder: (context, ref, _) {
                    final isChecked = ref.watch(notesAgreementProvider);
                    return Checkbox(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(context.r(4)),
                        side: BorderSide(
                          color: Colors.grey.shade100,
                          width: context.w(1),
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
                SizedBox(width: context.w(6)),
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
            SizedBox(height: context.h(20)),
            SizedBox(
              width: double.infinity,
              child: Consumer(
                builder: (_, ref, _) {
                  final loading = ref.watch(
                    checkoutViewModel.select((s) => s.loading),
                  );
                  final agreed = ref.watch(notesAgreementProvider);
                  if (loading) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: CustomColors.pinkColor,
                      ),
                    );
                  }
                  return ElevatedButton(
                    onPressed: agreed
                        ? () {
                            // final checkoutNotifier =
                            //     ref.read(checkoutViewModel.notifier);
                            // // Ensure objects are synced to state
                            // checkoutNotifier.setSelectedSlotObject(slot);
                            // checkoutNotifier.setSelectedPaymentOption(
                            //   paymentOption,
                            // );
                            // checkoutNotifier.setSelectedDoctorObject(doctor);

                            // Trigger booking
                            ref
                                .read(checkoutViewModel.notifier)
                                .createAppointment();
                          }
                        : null,
                    child: const Text("Confirm Appointment"),
                  );
                },
              ),
            ),
            SizedBox(height: context.h(20)),
            Center(
              child: Text("Powered By ARKit", style: CustomFonts.grey22w600),
            ),
            SizedBox(height: MediaQuery.paddingOf(context).bottom + context.h(20)),
          ],
        ),
      ),
    );
  }

  Widget _buildNotes({required BuildContext context, required String note}) {
    return Row(
      children: [
        Icon(
          Iconsax.info_circle,
          color: CustomColors.lightPurpleColor,
          size: context.sp(24),
        ),
        SizedBox(width: context.w(17)),
        Expanded(child: Text(note, style: CustomFonts.black18w500)),
      ],
    );
  }
}
