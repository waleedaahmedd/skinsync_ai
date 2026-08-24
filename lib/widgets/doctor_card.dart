import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import '../models/responses/practitioner_list_response.dart';
import '../utils/color_constant.dart';
import '../utils/custom_fonts.dart';

class DoctorCard extends StatelessWidget {
  final PractitionerDoctor doctor;
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
    return Container(
      width: width ?? context.w(165),
      margin: margin ??
          EdgeInsets.only(
            bottom: context.h(20),
            top: context.h(4),
          ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(context.r(16)),
        boxShadow: CustomColors.cardShadow,
        border: Border.all(
          color: CustomColors.greyColor.withValues(alpha: 0.6),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(context.r(16)),
        child: Material(
          color: Colors.white,
          child: InkWell(
            onTap: onTap,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(context.r(16)),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: doctor.doctorImage ?? '',
                    height: context.h(80),
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: Colors.grey.shade100,
                      child: const Center(child: CupertinoActivityIndicator()),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: Colors.grey.shade100,
                      child: const Icon(
                        Icons.person_outline_rounded,
                        size: 30,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(context.w(10)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              doctor.doctorName ?? '',
                              style: CustomFonts.black12w600,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.star_rounded,
                                color: Colors.amber,
                                size: 14,
                              ),
                              SizedBox(width: context.w(2)),
                              Text(
                                doctor.doctorRating?.toString() ?? "4.5",
                                style: CustomFonts.black10w600,
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: context.h(4)),
                      Text(
                        doctor.specialization ?? '',
                        style: CustomFonts.grey700_10w400,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: context.h(6)),
                      Text(
                        doctor.clinic?.clinicName ?? "Premium Specialist",
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
        ),
      ),
    );
  }
}
