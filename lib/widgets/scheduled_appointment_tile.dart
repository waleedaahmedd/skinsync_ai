import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../models/responses/get_appointment_response.dart';
import '../utills/assets.dart';
import '../utills/custom_fonts.dart';

class ScheduledAppointmentTile extends StatelessWidget {
  final Appointment appointment;
  const ScheduledAppointmentTile({super.key, required this.appointment});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.asset(PngAssets.image, width: 287.w),
        Text(appointment.clinic?.name ?? 'N/A', style: CustomFonts.black18w600),
        Text("Dermal Fillers – Cheeks", style: CustomFonts.black14w400),
        Text("Glow Skin Clinic", style: CustomFonts.black14w400),
      ],
    );
  }
}