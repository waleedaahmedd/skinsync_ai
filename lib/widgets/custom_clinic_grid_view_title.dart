import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../models/responses/get_clinic_response.dart';
import '../utills/assets.dart';
import '../utills/custom_fonts.dart';
import 'frosted_container.dart';

class CustomClinicGridViewTile extends StatelessWidget {
  final Clinic? clinicData;
  const CustomClinicGridViewTile({
    super.key,
    required this.onTap,
    required this.clinicData,
  });
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 174.h,
            width: double.infinity,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.r),
                  child: CachedNetworkImage(
                    imageUrl: clinicData?.logo ?? "",
                    height: 174.h,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorWidget: (context, error, stackTrace) {
                      return Container(
                        height: 174.h,
                        width: double.infinity,
                        color: Colors.grey.shade200,
                        child: Icon(Icons.broken_image, size: 40.sp),
                      );
                    },
                  ),
                ),
                Positioned(
                  top: 6.h,
                  left: 5.w,
                  child: FrostedContainer(
                    borderRadius: 8.r,
                    padding: EdgeInsets.symmetric(
                      horizontal: 6.w,
                      vertical: 4.h,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset(SvgAssets.flame),
                        SizedBox(width: 7.w),
                        Text("Top Choice", style: CustomFonts.black12w600),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 6.h,
                  right: 5.w,
                  child: FrostedContainer(
                    borderRadius: 8.r,
                    padding: EdgeInsets.symmetric(
                      horizontal: 6.w,
                      vertical: 4.h,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.star, color: const Color(0XFFF68712), size: 16.sp),
                        SizedBox(width: 4.w),
                        Text(
                          '${clinicData?.place?.rating ?? 0}',
                          style: CustomFonts.black12w600,
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 6.h,
                  right: 5.w,
                  child: FrostedContainer(
                    borderRadius: 50.r,
                    padding: EdgeInsets.symmetric(
                      horizontal: 6.w,
                      vertical: 4.h,
                    ),
                    child: Icon(
                      Icons.favorite_border,
                      color: Colors.white,
                      size: 19.sp,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Text(clinicData?.clinicName ?? "", style: CustomFonts.black18w600),
          if (clinicData?.address != null)
            Text(clinicData!.address!, style: CustomFonts.black14w400),
          if (clinicData?.place?.currentOpeningHours != null)
            Text(
              clinicData!.place!.currentOpeningHours!.todayOpeningHours,
              style: CustomFonts.black14w400,
            ),
        ],
      ),
    );
  }
}
