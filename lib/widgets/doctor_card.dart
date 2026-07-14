import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../models/dummy_list_model.dart';
import '../utills/color_constant.dart';
import '../utills/custom_fonts.dart';

class DoctorCard extends StatelessWidget {
  final DummyDoctor doctor;
  final double? width;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? margin;

  const DoctorCard({
    super.key,
    required this.doctor,
    this.width,
    this.onTap,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width ?? 165.w,
        margin: margin ?? EdgeInsets.only(right: 16.w, bottom: 8.h, top: 4.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(color: CustomColors.greyColor.withValues(alpha: 0.6)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
              child: CachedNetworkImage(
                imageUrl: doctor.image,
                height: 100.h,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: Colors.grey.shade100,
                  child: const Center(child: CupertinoActivityIndicator()),
                ),
                errorWidget: (context, url, error) => Container(
                  color: Colors.grey.shade100,
                  child: const Icon(Icons.person_outline_rounded, size: 30, color: Colors.grey),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          doctor.name,
                          style: CustomFonts.black12w600,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.star_rounded, color: Colors.amber, size: 14),
                          SizedBox(width: 2.w),
                          Text(
                            doctor.rating.toString(),
                            style: CustomFonts.black10w600,
                          ),
                        ],
                      ),
                    ],
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
      ),
    );
  }
}
