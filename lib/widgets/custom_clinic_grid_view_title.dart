import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../models/responses/get_clinic_response.dart';
import '../utils/assets.dart';
import '../utils/color_constant.dart';
import '../utils/custom_fonts.dart';

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
              // height: context.h(150),
              width: double.infinity,
              child: Stack(
                children: [
                  // ClipRRect(
                  //   borderRadius: BorderRadius.vertical(
                  //     top: Radius.circular(context.r(16)),
                  //   ),
                  //   child: CachedNetworkImage(
                  //     imageUrl: clinicData?.logo ?? "",
                  //     height: context.h(150),
                  //     width: double.infinity,
                  //     fit: BoxFit.cover,
                  //     placeholder: (context, url) => Container(
                  //       color: Colors.grey.shade100,
                  //       child: const Center(
                  //         child: CupertinoActivityIndicator(),
                  //       ),
                  //     ),
                  //     errorWidget: (context, url, error) {
                  //       return Container(
                  //         height: context.h(150),
                  //         width: double.infinity,
                  //         color: Colors.grey.shade100,
                  //         child: Icon(
                  //           Icons.storefront_rounded,
                  //           size: context.sp(32),
                  //           color: Colors.grey.shade400,
                  //         ),
                  //       );
                  //     },
                  //   ),
                  // ),
                  ClipRRect(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(context.r(16)),
                    ),
                    child: CachedNetworkImage(
                      // Banner is not available here yet.
                      imageUrl: clinicData?.banner ?? '',
                      height: context.h(100),
                      width: double.infinity,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: Colors.grey.shade100,
                        child: const Center(
                          child: CupertinoActivityIndicator(),
                        ),
                      ),
                      errorWidget: (_, _, _) => DecoratedBox(
                        decoration: const BoxDecoration(
                          gradient: CustomColors.purpleBlueGradient,
                        ),
                        child: Image.asset(
                          PngAssets.splashLogo,
                          opacity: const AlwaysStoppedAnimation(0.4),
                          fit: .cover,
                        ),
                      ),
                      // errorWidget: (context, url, error) => Container(
                      //   color: Colors.grey.shade100,
                      //   child: const Icon(
                      //     Icons.storefront_rounded,
                      //     size: 30,
                      //     color: Colors.grey,
                      //   ),
                      // ),
                    ),
                  ),
                  Positioned(
                    top: context.h(8),
                    left: context.w(8),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: CachedNetworkImage(
                          imageUrl: clinicData?.logo ?? '',
                          height: context.w(40),
                          width: context.w(40),
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            height: context.w(40),
                            width: context.w(40),
                            color: Colors.grey.shade100,
                            child: const CupertinoActivityIndicator(radius: 8),
                          ),
                          errorWidget: (context, url, error) => Container(
                            height: context.w(40),
                            width: context.w(40),
                            color: Colors.grey.shade100,
                            child: Icon(
                              Icons.storefront_rounded,
                              size: context.w(20),
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // "Top Choice" Flame Badge
                  // Positioned(
                  //   top: context.h(8),
                  //   left: context.w(8),
                  //   child: FrostedContainer(
                  //     borderRadius: context.r(8),
                  //     padding: EdgeInsets.symmetric(
                  //       horizontal: context.w(8),
                  //       vertical: context.h(4),
                  //     ),
                  //     child: Row(
                  //       mainAxisSize: MainAxisSize.min,
                  //       children: [
                  //         SvgPicture.asset(
                  //           SvgAssets.flame,
                  //           height: context.h(11),
                  //           width: context.w(9),
                  //           colorFilter: const ColorFilter.mode(
                  //             CustomColors.pinkColor,
                  //             BlendMode.srcIn,
                  //           ),
                  //         ),
                  //         SizedBox(width: context.w(4)),
                  //         Text(
                  //           "Top Choice",
                  //           style: CustomFonts.black10w600.copyWith(
                  //             color: CustomColors.pinkColor,
                  //             fontSize: context.sp(10),
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  // // Rating Star Badge
                  // Positioned(
                  //   bottom: context.h(8),
                  //   right: context.w(8),
                  //   child: FrostedContainer(
                  //     borderRadius: context.r(8),
                  //     padding: EdgeInsets.symmetric(
                  //       horizontal: context.w(8),
                  //       vertical: context.h(4),
                  //     ),
                  //     child: Row(
                  //       mainAxisSize: MainAxisSize.min,
                  //       children: [
                  //         Icon(
                  //           Icons.star_rounded,
                  //           color: Colors.amber,
                  //           size: context.sp(14),
                  //         ),
                  //         SizedBox(width: context.w(3)),
                  //         Text(
                  //           '${clinicData?.place?.rating ?? 0.0}',
                  //           style: CustomFonts.black10w600.copyWith(
                  //             fontSize: context.sp(10),
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  // // Favorite Badge Icon
                  // Positioned(
                  //   top: context.h(8),
                  //   right: context.w(8),
                  //   child: Container(
                  //     padding: EdgeInsets.all(context.w(5)),
                  //     decoration: BoxDecoration(
                  //       shape: BoxShape.circle,
                  //       color: Colors.black.withValues(alpha: 0.25),
                  //     ),
                  //     child: Icon(
                  //       Icons.favorite_border_rounded,
                  //       color: Colors.white,
                  //       size: context.sp(15),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
            // Bottom Details Info
            Padding(
              padding: EdgeInsets.fromLTRB(
                context.w(12),
                context.h(8),
                context.w(12),
                context.h(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    clinicData?.name ?? "Clinic Name",
                    style: CustomFonts.black16w600.copyWith(
                      fontSize: context.sp(14),
                      height: 1.1,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: context.h(4)),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: context.w(8),
                      vertical: context.h(3),
                    ),
                    decoration: BoxDecoration(
                      color: CustomColors.purpleColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(context.r(20)),
                    ),
                    child: Text(
                      // Doctor count is not available here yet.
                      "0 Doctors",
                      style: CustomFonts.darkPurple12w600.copyWith(
                        fontSize: context.sp(10),
                      ),
                    ),
                  ),
                  if (clinicData?.address != null) ...[
                    SizedBox(height: context.h(4)),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: context.sp(11),
                          color: Colors.grey,
                        ),
                        SizedBox(width: context.w(4)),
                        Expanded(
                          child: Text(
                            clinicData!.address!,
                            style: CustomFonts.grey13w400.copyWith(
                              fontSize: context.sp(10),
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
                    SizedBox(height: context.h(3)),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time_rounded,
                          size: context.sp(11),
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
                              fontSize: context.sp(10),
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
