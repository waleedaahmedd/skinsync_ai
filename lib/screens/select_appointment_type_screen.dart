import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skinsync_ai/models/dummy_list_model.dart';
import 'package:skinsync_ai/models/responses/get_clinic_response.dart';
import 'package:skinsync_ai/utills/color_constant.dart';
import 'package:skinsync_ai/utills/custom_fonts.dart';
import 'package:skinsync_ai/utills/enums.dart';
import 'package:skinsync_ai/widgets/custom_app_bar.dart';
import 'package:skinsync_ai/widgets/treatment_container.dart';
import 'package:skinsync_ai/view_models/checkout_view_model.dart';
import 'clinic_service_screen.dart';
import 'doctors_screen.dart';

class SelectAppointmentTypeScreen extends ConsumerWidget {
  static const routeName = '/select_appointment_type_screen';

  final Clinic clinic;

  const SelectAppointmentTypeScreen({
    super.key,
    required this.clinic,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
              Text(
                "Choose Appointment Type",
                style: CustomFonts.black22w600,
              ),
              SizedBox(height: 8.h),
              Text(
                "Select whether you want to book a direct treatment or schedule a general medical spa consultation.",
                style: CustomFonts.grey14w400,
              ),
              SizedBox(height: 24.h),
              Expanded(
                child: ListView.builder(
                  itemCount: dummyAppointmentTypes.length,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    final appointmentType = dummyAppointmentTypes[index];

                    return TreatmentContainer(
                      imageHeight: 180.h,
                      customTitle: appointmentType.title,
                      customSubtitle: appointmentType.description,
                      customImageUrl: appointmentType.imageUrl,
                      customOnTap: () {
                        // Save selection in CheckoutState
                        ref.read(checkoutViewModel.notifier).setSelectedAppointmentType(appointmentType.type);

                        Navigator.pushNamed(
                          context,
                          DoctorsScreen.routeName,
                        );
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
