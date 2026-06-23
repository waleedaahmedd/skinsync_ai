import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:skinsync_ai/models/responses/get_clinic_response.dart';
import 'package:skinsync_ai/utills/assets.dart';
import 'package:skinsync_ai/utills/color_constant.dart';
import 'package:skinsync_ai/utills/custom_fonts.dart';
import 'package:skinsync_ai/widgets/frosted_container.dart';

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
      onTap: onTap,
      child: Container(
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
            // Top Image with Badges
            SizedBox(
              height: 150.h,
              width: double.infinity,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
                    child: CachedNetworkImage(
                      imageUrl: clinicData?.logo ?? "",
                      height: 150.h,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: Colors.grey.shade100,
                        child: const Center(
                          child: CupertinoActivityIndicator(),
                        ),
                      ),
                      errorWidget: (context, url, error) {
                        return Container(
                          height: 150.h,
                          width: double.infinity,
                          color: Colors.grey.shade100,
                          child: Icon(
                            Icons.storefront_rounded,
                            size: 32.sp,
                            color: Colors.grey.shade400,
                          ),
                        );
                      },
                    ),
                  ),
                  // "Top Choice" Flame Badge
                  Positioned(
                    top: 8.h,
                    left: 8.w,
                    child: FrostedContainer(
                      borderRadius: 8.r,
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 4.h,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset(
                            SvgAssets.flame,
                            height: 11.h,
                            width: 9.w,
                            colorFilter: const ColorFilter.mode(
                              CustomColors.pinkColor,
                              BlendMode.srcIn,
                            ),
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            "Top Choice",
                            style: CustomFonts.black10w600.copyWith(
                              color: CustomColors.pinkColor,
                              fontSize: 10.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Rating Star Badge
                  Positioned(
                    bottom: 8.h,
                    right: 8.w,
                    child: FrostedContainer(
                      borderRadius: 8.r,
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 4.h,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.star_rounded, color: Colors.amber, size: 14.sp),
                          SizedBox(width: 3.w),
                          Text(
                            '${clinicData?.place?.rating ?? 0.0}',
                            style: CustomFonts.black10w600.copyWith(fontSize: 10.sp),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Favorite Badge Icon
                  Positioned(
                    top: 8.h,
                    right: 8.w,
                    child: Container(
                      padding: EdgeInsets.all(5.w),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black.withValues(alpha: 0.25),
                      ),
                      child: Icon(
                        Icons.favorite_border_rounded,
                        color: Colors.white,
                        size: 15.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Bottom Details Info
            Padding(
              padding: EdgeInsets.all(12.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    clinicData?.clinicName ?? "Clinic Name",
                    style: CustomFonts.black16w600.copyWith(
                      fontSize: 14.sp,
                      height: 1.2,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (clinicData?.address != null) ...[
                    SizedBox(height: 5.h),
                    Row(
                      children: [
                        Icon(Icons.location_on_outlined, size: 12.sp, color: Colors.grey),
                        SizedBox(width: 4.w),
                        Expanded(
                          child: Text(
                            clinicData!.address!,
                            style: CustomFonts.grey13w400.copyWith(
                              fontSize: 11.sp,
                              color: CustomColors.textGreyColor.withValues(alpha: 0.8),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                  if (clinicData?.place?.currentOpeningHours != null) ...[
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        Icon(Icons.access_time_rounded, size: 12.sp, color: Colors.grey),
                        SizedBox(width: 4.w),
                        Expanded(
                          child: Text(
                            clinicData!.place!.currentOpeningHours!.todayOpeningHours,
                            style: CustomFonts.grey13w400.copyWith(
                              fontSize: 11.sp,
                              color: Colors.grey.shade600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
