import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import '../models/responses/payment_options_response.dart';
import '../utills/color_constant.dart';
import '../utills/custom_fonts.dart';
import '../view_models/clinlic_doctor_view_model.dart';
import '../widgets/custom_app_bar.dart';

import '../models/responses/availability_response.dart';
import '../models/responses/get_clinic_response.dart';
import '../models/responses/get_doctor_response.dart';
import 'bottom_nav_page.dart';

final notesAgreementProvider = StateProvider<bool>((ref) => false);

class NotesScreen extends ConsumerWidget {
  final Clinic clinic;
  final Doctor doctor;
  final Slot slot;
  final PaymentOption paymentOption;

  static const routeName = "/notes_screen";
  const NotesScreen({
    super.key,
    required this.clinic,
    required this.doctor,
    required this.slot,
    required this.paymentOption,
  });

  void _listener(
    WidgetRef ref,
    ClinicDoctorState? prev,
    ClinicDoctorState next,
  ) {
    if (next.appointment != null) {
      ref.read(clinicDoctorProvider.notifier).clearState();
      Navigator.pushNamedAndRemoveUntil(
        ref.context,
        BottomNavPage.routeName,
        (_) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(
      clinicDoctorProvider,
      (prev, next) => _listener(ref, prev, next),
    );
    return Scaffold(
      appBar: const CustomAppBar(showTitle: true, title: "Notes"),
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
            const Spacer(),
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
              child: Consumer(
                builder: (_, ref, _) {
                  final loading = ref.watch(
                    clinicDoctorProvider.select((s) => s.loading),
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
                        ? () => ref
                              .read(clinicDoctorProvider.notifier)
                              .createAppointment(
                                clinic: clinic,
                                doctor: doctor,
                                slot: slot,
                                paymentOption: paymentOption,
                              )
                        : null,
                    child: const Text("Confirm Appointment"),
                  );
                },
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
