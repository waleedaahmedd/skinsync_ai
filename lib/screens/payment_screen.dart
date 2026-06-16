import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../models/responses/get_clinic_response.dart';
import '../models/responses/payment_options_response.dart';
import 'notes_screen.dart';
import '../utills/assets.dart';
import '../utills/color_constant.dart';
import '../utills/custom_fonts.dart';
import '../view_models/clinlic_doctor_view_model.dart';
import '../widgets/custom_app_bar.dart';

import '../models/responses/availability_response.dart';
import '../models/responses/get_doctor_response.dart';

class PaymentScreen extends ConsumerStatefulWidget {
  final Clinic clinic;
  final Doctor doctor;
  final Slot slot;

  static const routeName = "/payment_screen";
  const PaymentScreen({
    super.key,
    required this.clinic,
    required this.doctor,
    required this.slot,
  });

  @override
  ConsumerState<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends ConsumerState<PaymentScreen> {
  PaymentOption? selectedMode;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(clinicDoctorProvider.notifier)
          .getPaymentOptions(
            clinicId: widget.clinic.clinicId!,
            doctorId: widget.doctor.id!,
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(showTitle: false),
      body: Padding(
        padding: EdgeInsetsGeometry.symmetric(horizontal: 30.w),
        child: _buildBody(),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(
          top: 20.h,
          bottom: MediaQuery.paddingOf(context).bottom + 20.h,
          left: 20.w,
          right: 20.w,
        ),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              if (selectedMode == null) {
                EasyLoading.showError('Select a payment option!');
              }
              Navigator.pushNamed(
                context,
                NotesScreen.routeName,
                arguments: {
                  'clinic': widget.clinic,
                  'doctor': widget.doctor,
                  'slot': widget.slot,
                  'paymentOption': selectedMode!,
                },
              );
            },
            child: const Text("Pay Now"),
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return Consumer(
      builder: (_, ref, _) {
        final state = ref.watch(
          clinicDoctorProvider.select((s) => (s.paymentOptions, s.loading)),
        );
        if (state.$2) {
          return const Center(
            child: CircularProgressIndicator(color: CustomColors.pinkColor),
          );
        }
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: .start,
            children: [
              SizedBox(height: 10.h),
              Text(
                "Your Treatment Appointment is Ready!",
                style: CustomFonts.black30w600,
              ),
              SizedBox(height: 18.h),
              Container(
                padding: EdgeInsets.all(6.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.r),
                  border: Border.all(color: CustomColors.blackColor),
                ),
                child: Row(
                  children: [
                    Image.asset(
                      DummyAssets.treatmentimage,
                      fit: BoxFit.fill,
                      height: 105.h,
                      width: 151.w,
                    ),
                    SizedBox(width: 21.w),
                    Column(
                      crossAxisAlignment: .start,
                      children: [
                        Text(
                          widget.slot.appointmentDateTime,
                          style: CustomFonts.black14w500,
                        ),
                        Text(
                          "Derma Fillers - Cheeks",
                          style: CustomFonts.black14w600,
                        ),
                        Text(
                          widget.clinic.clinicName ?? "Glow Skin Clinic",
                          style: CustomFonts.black14w400,
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.attach_file,
                              size: 12.sp,
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
                ),
              ),
              SizedBox(height: 22.h),
              Divider(height: 0, color: Colors.grey.shade300),
              SizedBox(height: 22.h),
              Text("Select Your Payment Mode", style: CustomFonts.black22w600),
              SizedBox(height: 20.h),
              for (final paymentOption in state.$1)
                paymentTile(
                  price: paymentOption.amount ?? 0,
                  paymentOption: paymentOption,
                  title: paymentOption.title ?? 'N/A',
                  description: paymentOption.description ?? 'N/A',
                ),
              SizedBox(height: 22.h),
              Divider(height: 0, color: Colors.grey.shade300),
              SizedBox(height: 14.h),
              Row(
                mainAxisAlignment: .spaceBetween,
                children: [
                  Text("Total Amount", style: CustomFonts.black16w600),
                  Text("\$ 550", style: CustomFonts.black16w600),
                ],
              ),
              SizedBox(height: 24.h),
            ],
          ),
        );
      },
    );
  }

  Widget paymentTile({
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
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
        margin: EdgeInsets.only(bottom: 15.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.r),
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
                  SizedBox(height: 2.h),
                  Text(description, style: CustomFonts.black12w400),
                ],
              ),
            ),

            /// Radio icon
            Column(
              children: [
                Text("\$ $price", style: CustomFonts.red13w500),
                SizedBox(height: 5.h),
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

class CustomSizedSwitch extends StatefulWidget {
  const CustomSizedSwitch({super.key});

  @override
  State<CustomSizedSwitch> createState() => _CustomSizedSwitchState();
}

class _CustomSizedSwitchState extends State<CustomSizedSwitch> {
  bool isOn = false;

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: 0.8,
      child: SwitchTheme(
        data: SwitchThemeData(
          thumbColor: WidgetStateProperty.all(Colors.white),
          trackColor: WidgetStateProperty.all(
            isOn ? CustomColors.lightBlueColor : Colors.grey.shade400,
          ),
          trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: Switch(
          value: isOn,
          onChanged: (value) {
            setState(() {
              isOn = value;
            });
          },
        ),
      ),
    );
  }
}
