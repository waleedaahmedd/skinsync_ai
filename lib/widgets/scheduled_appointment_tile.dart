import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import '../models/responses/appointments_list_response.dart';
import '../utills/assets.dart';
import '../utills/custom_fonts.dart';

class ScheduledAppointmentTile extends StatelessWidget {
  final AppointmentItem appointment;
  const ScheduledAppointmentTile({super.key, required this.appointment});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.asset(PngAssets.image, width: context.w(287)),
        Text(appointment.clinic?.clinicName ?? 'N/A', style: CustomFonts.black18w600),
        Text(appointment.treatments?.firstOrNull?.treatmentName ?? "Consultation", style: CustomFonts.black14w400),
        Text(appointment.clinic?.clinicName ?? "Medical Spa", style: CustomFonts.black14w400),
      ],
    );
  }
}
