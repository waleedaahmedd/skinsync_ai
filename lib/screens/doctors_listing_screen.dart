import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
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
      backgroundColor: CustomColors.whiteColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(CupertinoIcons.arrow_left, color: Colors.black, size: 22),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("Our Specialists", style: CustomFonts.black24w600),
      ),
      body: GridView.builder(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
        physics: const BouncingScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.74,
          crossAxisSpacing: 14.w,
          mainAxisSpacing: 14.h,
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
        border: Border.all(
          color: CustomColors.greyColor.withValues(alpha: 0.5),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SizedBox(
              width: double.infinity,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
                      child: CachedNetworkImage(
                        imageUrl: doctor.image,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: Colors.grey.shade100,
                          child: const Center(
                            child: CupertinoActivityIndicator(),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: Colors.grey.shade100,
                          child: Icon(
                            Icons.person_outline_rounded,
                            size: 32.sp,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Star Rating Badge Layered on top-right of image (Frosted Glass style)
                  Positioned(
                    bottom: 8.h,
                    right: 8.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.45),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.star_rounded, color: Colors.amber, size: 12.sp),
                          SizedBox(width: 2.w),
                          Text(
                            doctor.rating.toString(),
                            style: CustomFonts.white10w600,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
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
                  style: CustomFonts.black13w600,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.h),
                Text(
                  doctor.specialization,
                  style: CustomFonts.grey700_10w400,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 6.h),
                Text(
                  doctor.clinicName,
                  style: CustomFonts.darkPurple12w600,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
