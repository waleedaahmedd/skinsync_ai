import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_glass_morphism/flutter_glass_morphism.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../models/responses/get_clinic_response.dart';
import '../models/responses/get_doctor_response.dart';
import '../view_models/clinlic_doctor_view_model.dart';
import '../widgets/app_loader.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/time_container.dart';
import '../widgets/treatment_price_container.dart';

import '../utills/assets.dart';
import '../utills/color_constant.dart';
import '../utills/custom_fonts.dart';
import '../utills/date_time_utills.dart';
import '../view_models/checkout_view_model.dart';
import '../view_models/treatment_view_model.dart';
import 'payment_screen.dart';

class ClinicServiceScreen extends ConsumerStatefulWidget {
  final Clinic? clinic;
  const ClinicServiceScreen({super.key, this.clinic});
  static const String routeName = '/ClinicServiceScreen';

  @override
  ConsumerState<ClinicServiceScreen> createState() =>
      _ClinicServiceScreenState();
}

class _ClinicServiceScreenState extends ConsumerState<ClinicServiceScreen> {
  DateTime selectedDate = DateTime.now();
  int? selectedFilterIndex;
  int? selectedTime;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final treatment = ref.read(
        treatmentViewModel.select((state) => state.selectedTreatment),
      );
      final subAreas = ref.read(
        treatmentViewModel.select((state) => state.selectedSubAreasList),
      );

      final subAreaIds = subAreas.map((e) => e.id).whereType<int>().toList();

      if (widget.clinic?.clinicId != null) {
        ref
            .read(clinicDoctorProvider.notifier)
            .setClinicId(widget.clinic!.clinicId!);
      }

      await ref
          .read(clinicDoctorProvider.notifier)
          .getDoctors(
            treatmentId: treatment?.id ?? 0,
            sideAreaIds: subAreaIds,
            date: selectedDate,
            clinicId: widget.clinic?.clinicId,
          );
      if (widget.clinic?.clinicId != null) {
        await ref
            .read(clinicDoctorProvider.notifier)
            .fetchAvailability(
              date: selectedDate,
              clinicId: widget.clinic!.clinicId!,
            );
      }
    });
  }

  Future<void> _pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      selectedTime = null;
      log('CLINIC ID: ${widget.clinic?.clinicId}');
      if (widget.clinic?.clinicId != null) {
        ref
            .read(clinicDoctorProvider.notifier)
            .fetchAvailability(
              date: picked,
              clinicId: widget.clinic!.clinicId!,
            );
      }
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: const CustomAppBar(showTitle: false),
      body: Container(
        decoration: const BoxDecoration(gradient: CustomColors.whiteBlueGradient),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 25.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.0.w),
                child: Text(
                  "Select Dr / Injector",
                  style: CustomFonts.black22w600,
                ),
              ),
              SizedBox(height: 23.h),

              Consumer(
                builder: (context, ref, _) {
                  final state = ref.watch(clinicDoctorProvider);
                  final doctors = state.doctorResponse?.data;
                  if (state.doctorLoading) {
                    return SizedBox(
                      height: 150.h, // same height as doctor list
                      child: const AppLoader(),
                    );
                  } else if (doctors?.isEmpty ?? true) {
                    return SizedBox(
                      height: 150.h,
                      child: Center(
                        child: Text(
                          "No Doctor Found",
                          style: CustomFonts.black18w600,
                        ),
                      ),
                    );
                  }
                  return SizedBox(
                    height: 150.h,
                    child: ListView.builder(
                      itemCount: doctors!.length,
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final isSelected =
                            doctors[index].id == state.selectedDoctor?.id;
                        return _buildDoctorCard(
                          doctors[index],
                          index,
                          isSelected,
                        );
                      },
                    ),
                  );
                },
              ),
              SizedBox(height: 21.h),
              const Divider(height: 0, color: CustomColors.greyColor),
              SizedBox(height: 25.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Selected Services", style: CustomFonts.black22w600),
                    SizedBox(height: 17.h),
                    Text(
                      "Review your selected treatments and details.\nEverything is tailored for your personalized care.",
                      style: CustomFonts.grey13w400,
                    ),
                    SizedBox(height: 10.h),
                    Consumer(
                      builder: (context, ref, _) {
                        return TreatmentPriceContainer(
                          isSelected: true,
                          selectedTreatment: ref
                              .watch(checkoutViewModel)
                              .selectedTreatment,
                          selectedSubAreasList:
                              ref
                                  .watch(checkoutViewModel)
                                  .selectedSubAreasList ??
                              [],

                          image: DummyAssets.treatmentimage,
                        );
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 25.h),
              const Divider(height: 0, color: CustomColors.greyColor),
              SizedBox(height: 25.h),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Select a Date & Time",
                      style: CustomFonts.black30w600,
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      "we’ll notify you in advance so you’re always prepared. Your journey to glowing skin is just a tap away!",
                      style: CustomFonts.black16w400,
                    ),
                    SizedBox(height: 11.h),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.r),
                        color: CustomColors.lightBlueColor.withValues(
                          alpha: 0.4,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Appointment Date",
                                style: CustomFonts.black12w400,
                              ),
                              SizedBox(height: 3.45.h),
                              Text(
                                selectedDate.formattedDate,
                                style: CustomFonts.black12w600,
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () {
                              _pickDate();
                            },
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.r),
                                color: Colors.lightBlue.withValues(alpha: 0.5),
                              ),
                              child: SvgPicture.asset(
                                SvgAssets.edit,
                                height: 14.5,
                                width: 14.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 25.h),
                    Row(
                      children: [
                        statusHint(status: "Booked", color: Colors.grey),
                        SizedBox(width: 16.w),
                        statusHint(
                          status: "Available",
                          color: CustomColors.greyColor,
                        ),
                        SizedBox(width: 16.w),
                        statusHint(status: "Selected", color: Colors.green),
                      ],
                    ),
                    SizedBox(height: 25.h),
                    Consumer(
                      builder: (_, ref, _) {
                        final state = ref.watch(
                          clinicDoctorProvider.select(
                            (s) => (s.slots, s.loading),
                          ),
                        );
                        if (state.$1.isEmpty) {
                          return Center(
                            child: Text(
                              'No slots available!',
                              style: CustomFonts.black14w600,
                            ),
                          );
                        }
                        if (state.$2) {
                          return SizedBox(
                            height: 60.h,
                            child: const Center(
                              child: CircularProgressIndicator(
                                color: CustomColors.pinkColor,
                              ),
                            ),
                          );
                        }
                        return Wrap(
                          spacing: 12.w,
                          runSpacing: 12.0.h,
                          children: List.generate(state.$1.length, (index) {
                            final slot = state.$1[index];
                            return TimeContainer(
                              onTap: () {
                                setState(() {
                                  selectedTime = index;
                                });
                              },
                              time: slot.formattedTime,
                              isAvailable: !slot.isBooked,
                              isBooked: slot.isBooked,
                              isSelected: selectedTime == index,
                            );
                          }),
                        );
                      },
                    ),
                    SizedBox(height: 25.h),
                    Divider(
                      color: CustomColors.blackColor.withValues(alpha: 0.2),
                      height: 0,
                    ),
                    SizedBox(height: 15.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 206.w,
                          child: Text(
                            "Derma Fillers - Cheeks By Glow Skin Clinic  ",
                            style: CustomFonts.black12w600,
                          ),
                        ),
                        Text("\$ 550", style: CustomFonts.black12w600),
                      ],
                    ),
                    SizedBox(height: 15.h),
                    Divider(
                      color: CustomColors.blackColor.withValues(alpha: 0.2),
                      height: 0,
                    ),
                    SizedBox(height: 15.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Total Amount", style: CustomFonts.black12w600),
                        Text("\$ 550", style: CustomFonts.black12w600),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 170.h),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.paddingOf(context).bottom),
        child: GlassMorphismContainer(
          blurIntensity: 30.0,
          opacity: 0.10,
          glassThickness: 1.0,

          // tintColor: Colors.white.withOpacity(0.15),
          enableBackgroundDistortion: true,
          enableGlassBorder: true,
          height: 144.h,
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 12.h),
                color: CustomColors.lightPurpleColor,
                child: Center(
                  child: Text(
                    "Complete The Appointment Timing Slot To View Full Price",
                    style: CustomFonts.black14w600,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.h),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Text("\$ 650", style: CustomFonts.black28w600),

                          Text(
                            "View Pricing Policy",
                            style: CustomFonts.black14w500Underline,
                          ),
                        ],
                      ),
                      SizedBox(width: 47.h),
                      GestureDetector(
                        onTap: () {
                          final state = ref.read(clinicDoctorProvider);
                          if (state.selectedDoctor == null) {
                            EasyLoading.showError('Select a doctor first!');
                            return;
                          }
                          if (selectedTime == null) {
                            EasyLoading.showError('Select a slot first!');
                            return;
                          }
                          Navigator.pushNamed(
                            context,
                            PaymentScreen.routeName,
                            arguments: {
                              'clinic': widget.clinic!,
                              'doctor': state.selectedDoctor!,
                              'slot': state.slots[selectedTime!],
                            },
                          );
                        },
                        child: Container(
                          width: 187.w,
                          height: 60.h,
                          alignment: Alignment.center,

                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50.r),
                            color: Colors.black,
                          ),
                          child: Center(
                            child: Text(
                              "Book Now",
                              style: CustomFonts.white22w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDoctorCard(Doctor doctor, int index, bool isSelected) {
    return GestureDetector(
      onTap: () {
        ref.read(clinicDoctorProvider.notifier).setSelectedDoctor(doctor);
        if (widget.clinic?.clinicId != null) {
          ref
              .read(clinicDoctorProvider.notifier)
              .fetchAvailability(
                date: selectedDate,
                clinicId: widget.clinic!.clinicId!,
              );
        }
        setState(() {
          selectedTime = null;
        });
      },
      child: Padding(
        padding: EdgeInsets.only(left: index == 0 ? 30.w : 0, right: 15.w),
        child: Container(
          padding: EdgeInsets.only(
            top: 21.h,
            bottom: 12.h,
            left: 25.w,
            right: 25.w,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.r),
            border: Border.all(
              color: isSelected
                  ? CustomColors.pinkColor
                  : CustomColors.lightPurpleColor,
              width: 2.w,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipOval(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: Image.network(
                  doctor.image ?? "",
                  fit: BoxFit.cover,
                  height: 57.67.w,
                  width: 58.39.w,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(Icons.broken_image, size: 57.sp);
                  },
                ),
              ),
              SizedBox(height: 6.23.h),
              Text(doctor.name ?? "", style: CustomFonts.black18w600),
              SizedBox(height: 3.32.h),
              Text(doctor.specialization ?? "", style: CustomFonts.black14w400),
            ],
          ),
        ),
      ),
    );
  }

  Row statusHint({required String status, required Color color}) {
    return Row(
      children: [
        Container(
          height: 11.02.h,
          width: 11.02.w,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3.r),
          ),
        ),
        SizedBox(width: 6.78.w),
        Text(status, style: CustomFonts.black14w500),
      ],
    );
  }
}
