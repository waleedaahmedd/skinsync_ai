import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skinsync_ai/utills/assets.dart';
import 'package:skinsync_ai/utills/custom_fonts.dart';

class ScheduledAppointmentTile extends StatelessWidget {
  const ScheduledAppointmentTile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start  ,
      children: [
        Image.asset(PngAssets.image,  width: 287.w,),
        Text("Glow Skin Clinic", style: CustomFonts.black18w600),
        Text("Dermal Fillers – Cheeks", style: CustomFonts.black14w400),
        Text("Glow Skin Clinic", style: CustomFonts.black14w400),
      ],
    );
  }
}
