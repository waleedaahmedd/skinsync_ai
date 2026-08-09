import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../models/responses/payment_options_response.dart';
import '../utills/assets.dart';
import '../utills/color_constant.dart';
import '../utills/custom_fonts.dart';
import '../view_models/checkout_view_model.dart';
import '../view_models/doctor_view_model.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_button.dart';
import 'notes_screen.dart';

class TreatmentPaymentScreen extends ConsumerStatefulWidget {
  static const routeName = "/treatment_payment_screen";
  const TreatmentPaymentScreen({super.key});

  @override
  ConsumerState<TreatmentPaymentScreen> createState() =>
      _TreatmentPaymentScreenState();
}

class _TreatmentPaymentScreenState
    extends ConsumerState<TreatmentPaymentScreen> {
  PaymentOption? selectedMode;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final checkoutState = ref.read(checkoutViewModel);
      final clinic = checkoutState.selectedClinic;
      final doctor = checkoutState.selectedDoctorObject;
      ref
          .read(doctorProvider.notifier)
          .getPaymentOptions(
            clinicId: clinic!.id!,
            doctorId: doctor!.doctorId!,
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(showTitle: false),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: context.w(30)),
        child: _buildBody(context),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(
          top: context.h(20),
          bottom: MediaQuery.paddingOf(context).bottom + context.h(20),
          left: context.w(20),
          right: context.w(20),
        ),
        child: CustomButton(
          text: "Pay Now",
          borderRadius: context.r(25),
          textColor: Colors.white,
          onPressed: () async {
            if (selectedMode == null) {
              EasyLoading.showError('Select a payment option!');
              return;
            }

            final checkoutNotifier = ref.read(checkoutViewModel.notifier);
            // checkoutNotifier.setSelectedSlotObject(widget.slot);
            checkoutNotifier.setSelectedPaymentOption(selectedMode!);
            // checkoutNotifier.setSelectedDoctorObject(widget.doctor);

            final request = await checkoutNotifier.buildAppointmentRequest();
            if (request != null) {
              debugPrint(
                const JsonEncoder.withIndent('  ').convert(request.toJson()),
              );
            }

            Navigator.pushNamed(context, NotesScreen.routeName);
          },
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Consumer(
      builder: (_, ref, _) {
        final state = ref.watch(
          doctorProvider.select((s) => (s.paymentOptions, s.loading)),
        );
        if (state.$2) {
          return const Center(
            child: CircularProgressIndicator(color: CustomColors.pinkColor),
          );
        }
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: context.h(10)),
              Text(
                "Your Treatment Appointment is Ready!",
                style: CustomFonts.black30w600,
              ),
              SizedBox(height: context.h(18)),
              Container(
                padding: EdgeInsets.all(context.w(6)),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(context.r(15)),
                  border: Border.all(color: CustomColors.blackColor),
                ),
                child: Consumer(
                  builder: (context, ref, _) {
                    final checkoutState = ref.watch(checkoutViewModel);
                    final clinic = checkoutState.selectedClinic;
                    final slot = checkoutState.selectedSlotObject;
                    return Row(
                      children: [
                        Image.asset(
                          DummyAssets.treatmentimage,
                          fit: BoxFit.fill,
                          height: context.h(105),
                          width: context.w(151),
                        ),
                        SizedBox(width: context.w(21)),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              slot?.appointmentDateTime ?? '',
                              style: CustomFonts.black14w500,
                            ),
                            Text(
                              "Derma Fillers - Cheeks",
                              style: CustomFonts.black14w600,
                            ),
                            Text(
                              clinic?.name ?? "Glow Skin Clinic",
                              style: CustomFonts.black14w400,
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.attach_file,
                                  size: context.sp(12),
                                  color: CustomColors.blackColor,
                                ),
                                Text(
                                  " Derma Fillers Cheeks Model",
                                  style: CustomFonts.black14w400Underline,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),
              SizedBox(height: context.h(22)),
              Divider(height: 0, color: Colors.grey.shade300),
              SizedBox(height: context.h(22)),
              Text("Select Your Payment Mode", style: CustomFonts.black22w600),
              SizedBox(height: context.h(20)),
              for (final paymentOption in state.$1)
                paymentTile(
                  context,
                  price: paymentOption.amount ?? 0,
                  paymentOption: paymentOption,
                  title: paymentOption.title ?? 'N/A',
                  description: paymentOption.description ?? 'N/A',
                ),
              SizedBox(height: context.h(22)),
              Divider(height: 0, color: Colors.grey.shade300),
              SizedBox(height: context.h(14)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Total Amount", style: CustomFonts.black16w600),
                  Text("\$ 550", style: CustomFonts.black16w600),
                ],
              ),
              SizedBox(height: context.h(24)),
            ],
          ),
        );
      },
    );
  }

  Widget paymentTile(
    BuildContext context, {
    required String title,
    required String description,
    required int price,
    required PaymentOption paymentOption,
  }) {
    final isSelected = selectedMode == paymentOption;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedMode = paymentOption;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: context.w(15),
          vertical: context.h(10),
        ),
        margin: EdgeInsets.only(bottom: context.h(15)),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(context.r(15)),
          border: Border.all(
            color: isSelected
                ? CustomColors.lightBlueColor
                : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: CustomFonts.black14w700),
                  SizedBox(height: context.h(2)),
                  Text(description, style: CustomFonts.black12w400),
                ],
              ),
            ),

            /// Radio icon
            Column(
              children: [
                Text("\$ $price", style: CustomFonts.red13w500),
                SizedBox(height: context.h(5)),
                Icon(
                  isSelected
                      ? Icons.radio_button_checked
                      : Icons.radio_button_off,
                  color: isSelected
                      ? CustomColors.lightBlueColor
                      : Colors.grey.shade400,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
