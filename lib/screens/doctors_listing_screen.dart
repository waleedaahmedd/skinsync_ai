import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../models/dummy_list_model.dart';
import '../utills/color_constant.dart';
import '../utills/custom_fonts.dart';

class DoctorsListingScreen extends StatelessWidget {
  const DoctorsListingScreen({super.key});
  static const String routeName = "/DoctorsListingScreen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("Our Specialists", style: CustomFonts.black22w600),
      ),
      body: GridView.builder(
        padding: EdgeInsets.all(20.w),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          crossAxisSpacing: 15.w,
          mainAxisSpacing: 15.h,
        ),
        itemCount: dummyDoctors.length,
        itemBuilder: (context, index) {
          final doctor = dummyDoctors[index];
          return _buildDoctorCard(doctor);
        },
      ),
    );
  }

  Widget _buildDoctorCard(DummyDoctor doctor) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
              child: CachedNetworkImage(
                imageUrl: doctor.image,
                fit: BoxFit.cover,
                width: double.infinity,
                placeholder: (context, url) => Container(color: Colors.grey.shade100),
                errorWidget: (context, url, error) => const Icon(Icons.person),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(12.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  doctor.name,
                  style: CustomFonts.black14w600,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.h),
                Text(
                  doctor.specialization,
                  style: CustomFonts.grey14w400.copyWith(fontSize: 11.sp),
                ),
                SizedBox(height: 4.h),
                Text(
                  doctor.clinicName,
                  style: CustomFonts.black12w400.copyWith(color: CustomColors.darkPurple, fontSize: 10.sp, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 14),
                    SizedBox(width: 4.w),
                    Text(
                      doctor.rating.toString(),
                      style: CustomFonts.black12w600.copyWith(fontSize: 11.sp),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
