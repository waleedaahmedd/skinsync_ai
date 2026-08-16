import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_glass_morphism/flutter_glass_morphism.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../models/responses/practitioner_list_response.dart';
import '../utils/assets.dart';
import '../utils/color_constant.dart';
import '../utils/custom_fonts.dart';
import '../utils/date_time_utills.dart';
import '../view_models/checkout_view_model.dart';
import '../view_models/clinic_view_model.dart';
import '../view_models/doctor_view_model.dart';
import '../widgets/app_loader.dart';
import '../widgets/app_network_image.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/time_container.dart';
import '../widgets/treatment_price_container.dart';
import 'treatment_payment_screen.dart';

class ClinicServiceScreen extends ConsumerStatefulWidget {
  const ClinicServiceScreen({super.key});
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
        checkoutViewModel.select((state) => state.selectedTreatments),
      );
      final subAreas = ref.read(
        checkoutViewModel.select(
          (state) => state.selectedAreas?.subAreas ?? [],
        ),
      );

      final subAreaIds = subAreas.map((e) => e.id).whereType<int>().toList();

      final selectedClinic = ref.read(checkoutViewModel).selectedClinic;
      if (selectedClinic?.id != null) {
        ref.read(clinicProvider.notifier).setClinicId(selectedClinic!.id!);
      }

      await ref
          .read(doctorProvider.notifier)
          .getDoctors(
            treatmentId: treatment?.id ?? 0,
            sideAreaIds: subAreaIds,
            date: selectedDate,
            clinicId: selectedClinic?.id,
          );
      if (selectedClinic?.id != null) {
        await ref
            .read(doctorProvider.notifier)
            .fetchAvailability(
              date: selectedDate,
              clinicId: selectedClinic!.id!,
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
      final selectedClinic = ref.read(checkoutViewModel).selectedClinic;
      log('CLINIC ID: ${selectedClinic?.id}');
      if (selectedClinic?.id != null) {
        ref
            .read(doctorProvider.notifier)
            .fetchAvailability(date: picked, clinicId: selectedClinic!.id!);
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
        decoration: const BoxDecoration(
          gradient: CustomColors.whiteBlueGradient,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: context.h(25)),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: context.w(30.0)),
                child: Text(
                  "Select Dr / Injector",
                  style: CustomFonts.black22w600,
                ),
              ),
              SizedBox(height: context.h(23)),

              Consumer(
                builder: (context, ref, _) {
                  final state = ref.watch(doctorProvider);
                  final doctors = state.doctorResponse?.data?.doctors;
                  if (state.doctorLoading) {
                    return SizedBox(
                      height: context.h(150), // same height as doctor list
                      child: const AppLoader(),
                    );
                  } else if (doctors?.isEmpty ?? true) {
                    return SizedBox(
                      height: context.h(150),
                      child: Center(
                        child: Text(
                          "No Doctor Found",
                          style: CustomFonts.black18w600,
                        ),
                      ),
                    );
                  }
                  return SizedBox(
                    height: context.h(150),
                    child: ListView.builder(
                      itemCount: doctors!.length,
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final isSelected =
                            doctors[index].doctorId == state.selectedDoctor?.doctorId;
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
              SizedBox(height: context.h(21)),
              const Divider(height: 0, color: CustomColors.greyColor),
              SizedBox(height: context.h(25)),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: context.w(30)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Selected Services", style: CustomFonts.black22w600),
                    SizedBox(height: context.h(17)),
                    Text(
                      "Review your selected treatments and details.\nEverything is tailored for your personalized care.",
                      style: CustomFonts.grey13w400,
                    ),
                    SizedBox(height: context.h(10)),
                    Consumer(
                      builder: (context, ref, _) {
                        return TreatmentPriceContainer(
                          isSelected: true,
                          selectedTreatment: ref
                              .watch(checkoutViewModel)
                              .selectedTreatments,
                          selectedSubAreasList: [
                            if (ref.watch(checkoutViewModel).selectedAreas !=
                                null)
                              ref.watch(checkoutViewModel).selectedAreas!,
                          ],

                          image: DummyAssets.treatmentimage,
                        );
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: context.h(25)),
              const Divider(height: 0, color: CustomColors.greyColor),
              SizedBox(height: context.h(25)),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: context.w(30)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Select a Date & Time",
                      style: CustomFonts.black30w600,
                    ),
                    SizedBox(height: context.h(2)),
                    Text(
                      "we’ll notify you in advance so you’re always prepared. Your journey to glowing skin is just a tap away!",
                      style: CustomFonts.black16w400,
                    ),
                    SizedBox(height: context.h(11)),
                    Container(
                      padding: EdgeInsets.all(context.w(14)),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(context.r(12)),
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
                              SizedBox(height: context.h(3.45)),
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
                              padding: EdgeInsets.all(context.w(10)),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(context.r(10)),
                                color: Colors.lightBlue.withValues(alpha: 0.5),
                              ),
                              child: SvgPicture.asset(
                                SvgAssets.edit,
                                height: context.h(14.5),
                                width: context.w(14.5),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: context.h(25)),
                    Row(
                      children: [
                        statusHint(status: "Booked", color: Colors.grey),
                        SizedBox(width: context.w(16)),
                        statusHint(
                          status: "Available",
                          color: CustomColors.greyColor,
                        ),
                        SizedBox(width: context.w(16)),
                        statusHint(status: "Selected", color: Colors.green),
                      ],
                    ),
                    SizedBox(height: context.h(25)),
                    Consumer(
                      builder: (_, ref, _) {
                        final state = ref.watch(
                          doctorProvider.select((s) => (s.slots, s.loading)),
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
                            height: context.h(60),
                            child: const Center(
                              child: CircularProgressIndicator(
                                color: CustomColors.pinkColor,
                              ),
                            ),
                          );
                        }
                        return Wrap(
                          spacing: context.w(12),
                          runSpacing: context.h(12.0),
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
                    SizedBox(height: context.h(25)),
                    Divider(
                      color: CustomColors.blackColor.withValues(alpha: 0.2),
                      height: 0,
                    ),
                    SizedBox(height: context.h(15)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: context.w(206),
                          child: Text(
                            "Derma Fillers - Cheeks By Glow Skin Clinic  ",
                            style: CustomFonts.black12w600,
                          ),
                        ),
                        Text("\$ 550", style: CustomFonts.black12w600),
                      ],
                    ),
                    SizedBox(height: context.h(15)),
                    Divider(
                      color: CustomColors.blackColor.withValues(alpha: 0.2),
                      height: 0,
                    ),
                    SizedBox(height: context.h(15)),
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
              SizedBox(height: context.h(170)),
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
          height: context.h(144),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: context.h(12)),
                color: CustomColors.lightPurpleColor,
                child: Center(
                  child: Text(
                    "Complete The Appointment Timing Slot To View Full Price",
                    style: CustomFonts.black14w600,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: context.h(10)),
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
                      SizedBox(width: context.h(47)),
                      GestureDetector(
                        onTap: () {
                          final state = ref.read(doctorProvider);
                          if (state.selectedDoctor == null) {
                            EasyLoading.showError('Select a doctor first!');
                            return;
                          }
                          if (selectedTime == null) {
                            EasyLoading.showError('Select a slot first!');
                            return;
                          }
                          // final selectedClinic =
                          //     ref.read(checkoutViewModel).selectedClinic;

                          final checkoutNotifier =
                              ref.read(checkoutViewModel.notifier);
                          checkoutNotifier.setSelectedDoctorObject(
                            state.selectedDoctor!,
                          );
                          checkoutNotifier.setSelectedSlotObject(
                            state.slots[selectedTime!],
                          );

                          Navigator.pushNamed(
                            context,
                            TreatmentPaymentScreen.routeName,
                          );
                        },
                        child: Container(
                          width: context.w(187),
                          height: context.h(60),
                          alignment: Alignment.center,

                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(context.r(50)),
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

  Widget _buildDoctorCard(PractitionerDoctor doctor, int index, bool isSelected) {
    return GestureDetector(
      onTap: () {
        ref.read(doctorProvider.notifier).setSelectedDoctor(doctor);
        final selectedClinic = ref.read(checkoutViewModel).selectedClinic;
        if (selectedClinic?.id != null) {
          ref
              .read(doctorProvider.notifier)
              .fetchAvailability(
                date: selectedDate,
                clinicId: selectedClinic!.id!,
              );
        }
        setState(() {
          selectedTime = null;
        });
      },
      child: Padding(
        padding: EdgeInsets.only(left: index == 0 ? context.w(30) : 0, right: context.w(15)),
        child: Container(
          padding: EdgeInsets.only(
            top: context.h(21),
            bottom: context.h(12),
            left: context.w(25),
            right: context.w(25),
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(context.r(15)),
            border: Border.all(
              color: isSelected
                  ? CustomColors.pinkColor
                  : CustomColors.lightPurpleColor,
              width: context.w(2),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipOval(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: AppNetworkImage(
                  imageUrl: doctor.doctorImage ?? "",
                  fit: BoxFit.cover,
                  height: context.w(57.67),
                  width: context.w(58.39),
                  errorIconSize: context.sp(57),
                ),
              ),
              SizedBox(height: context.h(6.23)),
              Text(doctor.doctorName ?? "", style: CustomFonts.black18w600),
              SizedBox(height: context.h(3.32)),
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
          height: context.h(11.02),
          width: context.w(11.02),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(context.r(3)),
          ),
        ),
        SizedBox(width: context.w(6.78)),
        Text(status, style: CustomFonts.black14w500),
      ],
    );
  }
}
