import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../models/responses/auth_response.dart';
import '../utils/color_constant.dart';
import 'app_network_image.dart';

class RequestClinicTreatmentCard extends StatelessWidget {
  final RequestClinicTreatmentModel data;
  final VoidCallback? onTap;

  const RequestClinicTreatmentCard({
    super.key,
    required this.data,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final patientName = data.clinicName ?? '';
     final address = data.address ?? '';
    final patientEmail = data.clinicEmail ?? '';

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
       width: MediaQuery.of(context).size.width * 0.78,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          // Explicit white instead of theme.cardColor — cardColor was
          // resolving to transparent here, letting the pink parent
          // background show through.
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.grey.shade200,
          ),
          boxShadow: CustomColors.cardShadow,
        ),
        child: Row(
          children: [
            // Patient Image
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: SizedBox(
                height: 52,
                width: 52,
                child: data.image != null && data.image!.isNotEmpty
                    ? AppNetworkImage(
                        imageUrl: data.image!,
                        width: 52,
                        height: 52,
                        fit: BoxFit.cover,
                        borderRadius: BorderRadius.circular(14),
                        errorIcon: Iconsax.user,
                      )
                    : Container(
                        color: theme.primaryColor.withValues(alpha: 0.08),
                        child: Icon(
                          Iconsax.user,
                          size: 25,
                          color: theme.primaryColor,
                        ),
                      ),
              ),
            ),

            const SizedBox(width: 14),

            // Patient Information
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Patient Name
                  Text(
                    patientName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      // Explicit dark color — this was unset before and
                      // was inheriting a near-white color, making the
                      // clinic name invisible against the card.
                      color: Colors.black87,
                    ),
                  ),

                  // Email
                  if (patientEmail.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(
                          Iconsax.sms,
                          size: 14,
                          color: Colors.grey.shade500,
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            patientEmail,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                    if (address.isNotEmpty) ...[
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Icon(
                          Iconsax.location,
                          size: 13,
                          color: Colors.grey.shade500,
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            address,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                  // Treatment Count
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Icon(
                        Iconsax.health,
                        size: 14,
                        color: Colors.grey.shade500,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        'Total Request: ${data.totalTreatmentCount ?? 0} ',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(width: 10),

            // Arrow
            Icon(
              Iconsax.arrow_right_3,
              size: 18,
              color: Colors.grey.shade400,
            ),
          ],
        ),
      ),
    );
  }
}