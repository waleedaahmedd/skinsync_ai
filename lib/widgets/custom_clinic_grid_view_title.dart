import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_svg/svg.dart';

import '../models/responses/get_clinic_response.dart';
import '../utills/assets.dart';
import '../utills/color_constant.dart';
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
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(context.r(16)),
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
              height: context.h(150),
              width: double.infinity,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(context.r(16)),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: clinicData?.logo ?? "",
                      height: context.h(150),
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
                          height: context.h(150),
                          width: double.infinity,
                          color: Colors.grey.shade100,
                          child: Icon(
                            Icons.storefront_rounded,
                            size: context.sp(32),
                            color: Colors.grey.shade400,
                          ),
                        );
                      },
                    ),
                  ),
                  // "Top Choice" Flame Badge
                  Positioned(
                    top: context.h(8),
                    left: context.w(8),
                    child: FrostedContainer(
                      borderRadius: context.r(8),
                      padding: EdgeInsets.symmetric(
                        horizontal: context.w(8),
                        vertical: context.h(4),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset(
                            SvgAssets.flame,
                            height: context.h(11),
                            width: context.w(9),
                            colorFilter: const ColorFilter.mode(
                              CustomColors.pinkColor,
                              BlendMode.srcIn,
                            ),
                          ),
                          SizedBox(width: context.w(4)),
                          Text(
                            "Top Choice",
                            style: CustomFonts.black10w600.copyWith(
                              color: CustomColors.pinkColor,
                              fontSize: context.sp(10),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Rating Star Badge
                  Positioned(
                    bottom: context.h(8),
                    right: context.w(8),
                    child: FrostedContainer(
                      borderRadius: context.r(8),
                      padding: EdgeInsets.symmetric(
                        horizontal: context.w(8),
                        vertical: context.h(4),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.star_rounded,
                            color: Colors.amber,
                            size: context.sp(14),
                          ),
                          SizedBox(width: context.w(3)),
                          Text(
                            '${clinicData?.place?.rating ?? 0.0}',
                            style: CustomFonts.black10w600.copyWith(
                              fontSize: context.sp(10),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Favorite Badge Icon
                  Positioned(
                    top: context.h(8),
                    right: context.w(8),
                    child: Container(
                      padding: EdgeInsets.all(context.w(5)),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black.withValues(alpha: 0.25),
                      ),
                      child: Icon(
                        Icons.favorite_border_rounded,
                        color: Colors.white,
                        size: context.sp(15),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Bottom Details Info
            Padding(
              padding: EdgeInsets.all(context.w(12)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    clinicData?.name ?? "Clinic Name",
                    style: CustomFonts.black16w600.copyWith(
                      fontSize: context.sp(14),
                      height: 1.2,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (clinicData?.address != null) ...[
                    SizedBox(height: context.h(5)),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: context.sp(12),
                          color: Colors.grey,
                        ),
                        SizedBox(width: context.w(4)),
                        Expanded(
                          child: Text(
                            clinicData!.address!,
                            style: CustomFonts.grey13w400.copyWith(
                              fontSize: context.sp(11),
                              color: CustomColors.textGreyColor.withValues(
                                alpha: 0.8,
                              ),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                  if (clinicData?.place?.currentOpeningHours != null) ...[
                    SizedBox(height: context.h(4)),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time_rounded,
                          size: context.sp(12),
                          color: Colors.grey,
                        ),
                        SizedBox(width: context.w(4)),
                        Expanded(
                          child: Text(
                            clinicData!
                                .place!
                                .currentOpeningHours!
                                .todayOpeningHours,
                            style: CustomFonts.grey13w400.copyWith(
                              fontSize: context.sp(11),
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
