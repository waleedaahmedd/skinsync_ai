import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utills/color_constant.dart';
import '../utills/custom_fonts.dart';
import '../view_models/appointment_view_model.dart';
import '../view_models/checkout_view_model.dart';
import '../widgets/app_loader.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/treatment_container.dart';
import 'doctors_screen.dart';

import 'select_date_time_screen.dart';

class SelectAppointmentTypeScreen extends ConsumerStatefulWidget {
  static const routeName = '/select_appointment_type_screen';

  const SelectAppointmentTypeScreen({super.key});

  @override
  ConsumerState<SelectAppointmentTypeScreen> createState() =>
      _SelectAppointmentTypeScreenState();
}

class _SelectAppointmentTypeScreenState
    extends ConsumerState<SelectAppointmentTypeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(appointmentProvider.notifier).getAppointmentTypes();
    });
  }

  @override
  Widget build(BuildContext context) {
    final appointmentState = ref.watch(appointmentProvider);

    return Scaffold(
      backgroundColor: CustomColors.whiteColor,
      appBar: const CustomAppBar(showTitle: true, title: "Select Appointment"),
      body: Container(
        decoration: const BoxDecoration(
          gradient: CustomColors.whiteBlueGradient,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 24.h),
              Text("Choose Appointment Type", style: CustomFonts.black22w600),
              SizedBox(height: 8.h),
              Text(
                "Select whether you want to book a direct treatment or schedule a general medical spa consultation.",
                style: CustomFonts.grey14w400,
              ),
              SizedBox(height: 24.h),
              Expanded(
                child:
                    appointmentState.loading
                        ? const AppLoader()
                        : appointmentState.errorMessage != null
                        ? Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  appointmentState.errorMessage!,
                                  style: CustomFonts.red16w400,
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 16.h),
                                ElevatedButton(
                                  onPressed: () => ref
                                      .read(appointmentProvider.notifier)
                                      .getAppointmentTypes(),
                                  child: const Text("Retry"),
                                ),
                              ],
                            ),
                          ),
                        )
                        : appointmentState.appointmentTypes.isEmpty
                        ? Center(
                          child: Text(
                            "No appointment types found",
                            style: CustomFonts.grey14w400,
                          ),
                        )
                        : ListView.builder(
                          itemCount: appointmentState.appointmentTypes.length,
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            final typeData =
                                appointmentState.appointmentTypes[index];

                            return TreatmentContainer(
                              imageHeight: 180.h,
                              customTitle: typeData.title ?? '',
                              customSubtitle: typeData.description ?? '',
                              customImageUrl: typeData.image ?? '',
                              customOnTap: () {
                                // Save selection in CheckoutState
                                ref
                                    .read(checkoutViewModel.notifier)
                                    .setSelectedAppointmentType(typeData);

                                if (ref.read(checkoutViewModel).isInviteClinic) {
                                  Navigator.pushNamed(
                                    context,
                                    SelectDateTimeScreen.routeName,
                                  );
                                } else {
                                  Navigator.pushNamed(
                                    context,
                                    DoctorsScreen.routeName,
                                  );
                                }
                              },
                            );
                          },
                        ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
