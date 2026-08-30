import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:iconsax/iconsax.dart';

import '../models/requests/preferred_slot.dart';
import '../models/responses/get_clinic_response.dart';
import '../models/responses/simulation_history_response.dart';
import '../utils/color_constant.dart';
import '../utils/custom_fonts.dart';
import '../view_models/treatment_journey_view_model.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_button.dart';
import '../widgets/dialogs/success_dialogs.dart';

class TreatmentReviewScreen extends ConsumerWidget {
  final SimulationData? simulationData;
  final List<PreferredSlot> preferredSlots;
  final Clinic clinic;

  const TreatmentReviewScreen({
    super.key,
    this.simulationData,
    required this.preferredSlots,
    required this.clinic,
  });

  static const String routeName = '/TreatmentReviewScreen';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(
        showTitle: true,
        title: "Review Treatment Request",
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(context.w(20)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildClinicInfo(context),
            SizedBox(height: context.h(24)),
            if (simulationData != null) ...[
              _buildTreatmentDetails(context),
              SizedBox(height: context.h(24)),
              Text("Simulation Images", style: CustomFonts.black18w600),
              SizedBox(height: context.h(12)),
              _buildSimulationImages(context),
              SizedBox(height: context.h(24)),
            ],
            if (preferredSlots.isNotEmpty) ...[
              _buildSlotsSummary(context),
              SizedBox(height: context.h(24)),
            ],
            Text(
              "By continuing, you confirm that you are voluntarily submitting new facial images for SkinSync’s facial-analysis, simulation, treatment-planning, and progress-tracking features under your existing Facial Scan and Biometric Consent. Do not continue if you have withdrawn that consent.",
              style: CustomFonts.black14w400.copyWith(
                height: 1.5,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: context.h(120)),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomBar(context, ref),
    );
  }

  Widget _buildClinicInfo(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(context.w(16)),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(context.r(16)),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                height: context.h(60),
                width: context.h(60),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: clinic.logo ?? "",
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        const CupertinoActivityIndicator(),
                    errorWidget: (context, url, error) => Icon(
                      Icons.storefront_rounded,
                      size: context.h(30),
                      color: Colors.grey.shade400,
                    ),
                  ),
                ),
              ),
              SizedBox(width: context.w(16)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      clinic.name ?? "Clinic Name",
                      style: CustomFonts.black18w600,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: context.h(16)),
          const Divider(height: 1),
          SizedBox(height: context.h(16)),
          if (clinic.address != null)
            _buildClinicDetailRow(
              context,
              Icons.location_on_outlined,
              clinic.address!,
            ),
          if (clinic.phone != null) ...[
            SizedBox(height: context.h(8)),
            _buildClinicDetailRow(
              context,
              Icons.phone_outlined,
              clinic.phone!,
            ),
          ],
          if (clinic.email != null) ...[
            SizedBox(height: context.h(8)),
            _buildClinicDetailRow(
              context,
              Icons.email_outlined,
              clinic.email!,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildClinicDetailRow(BuildContext context, IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 18,
          color: CustomColors.purpleColor,
        ),
        SizedBox(width: context.w(12)),
        Expanded(
          child: Text(
            text,
            style: CustomFonts.grey14w400,
          ),
        ),
      ],
    );
  }

  Widget _buildSimulationImages(BuildContext context) {
    return Column(
      children: [
        _buildImagePair(
          context,
          "Front View",
          simulationData?.frontImageBefore,
          simulationData?.frontImageAfter,
        ),
        SizedBox(height: context.h(12)),
        _buildImagePair(
          context,
          "Right View",
          simulationData?.rightImageBefore,
          simulationData?.rightImageAfter,
        ),
        SizedBox(height: context.h(12)),
        _buildImagePair(
          context,
          "Left View",
          simulationData?.leftImageBefore,
          simulationData?.leftImageAfter,
        ),
      ],
    );
  }

  Widget _buildImagePair(
    BuildContext context,
    String label,
    String? before,
    String? after,
  ) {
    if (before == null && after == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: CustomFonts.black14w600),
        SizedBox(height: context.h(8)),
        Row(
          children: [
            Expanded(
              child: _buildSingleImage(context, "Before", before),
            ),
            SizedBox(width: context.w(12)),
            Expanded(
              child: _buildSingleImage(context, "After", after),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSingleImage(BuildContext context, String title, String? url) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: CustomFonts.grey12w400),
        SizedBox(height: context.h(4)),
        Container(
          height: context.h(120),
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(context.r(12)),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(context.r(12)),
            child: CachedNetworkImage(
              imageUrl: url ?? "",
              fit: BoxFit.cover,
              placeholder: (context, url) => const Center(
                child: CupertinoActivityIndicator(),
              ),
              errorWidget: (context, url, error) => const Icon(
                Icons.broken_image,
                color: Colors.grey,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTreatmentDetails(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(context.w(16)),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(context.r(16)),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Iconsax.receipt,
                size: 20,
                color: CustomColors.purpleColor,
              ),
              SizedBox(width: context.w(8)),
              Text("Treatment Details", style: CustomFonts.black16w600),
            ],
          ),
          const Divider(height: 24),
          if (simulationData?.treatments != null)
            ...simulationData!.treatments!.map((treatment) {
              return Padding(
                padding: EdgeInsets.only(bottom: context.h(12)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      treatment.name ?? "N/A",
                      style: CustomFonts.black14w600,
                    ),
                    SizedBox(height: context.h(4)),
                    if (treatment.areas != null)
                      ...treatment.areas!.map((area) {
                        final material = (area.materials != null &&
                                area.materials!.isNotEmpty)
                            ? area.materials!.first
                            : null;
                        return Padding(
                          padding: EdgeInsets.only(
                            left: context.w(12),
                            top: context.h(2),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "• ${area.name ?? "N/A"}",
                                style: CustomFonts.grey12w400,
                              ),
                              if (material != null)
                                Text(
                                  "${material.selectedQuantity ?? 0} Syringes",
                                  style: CustomFonts.black12w600.copyWith(
                                    color: CustomColors.purpleColor,
                                  ),
                                ),
                            ],
                          ),
                        );
                      }),
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }

  Widget _buildSlotsSummary(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(context.w(16)),
      decoration: BoxDecoration(
        color: CustomColors.purpleColor.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(context.r(16)),
        border: Border.all(
          color: CustomColors.purpleColor.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Iconsax.calendar_tick,
                size: 20,
                color: CustomColors.purpleColor,
              ),
              SizedBox(width: context.w(8)),
              Text("Preferred Slots", style: CustomFonts.black16w600),
            ],
          ),
          const Divider(height: 24),
          ...preferredSlots.asMap().entries.map((entry) {
            final index = entry.key;
            final slot = entry.value;
            return Padding(
              padding: EdgeInsets.only(
                bottom: index != preferredSlots.length - 1 ? context.h(10) : 0,
              ),
              child: Row(
                children: [
                  Text(
                    "${index + 1}. ",
                    style: CustomFonts.darkPurple12w600.copyWith(
                      fontSize: context.sp(14),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      "${slot.date} at ${slot.time}",
                      style: CustomFonts.black13w500,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context, WidgetRef ref) {
    return Container(
      padding: EdgeInsets.only(
        left: context.w(24),
        right: context.w(24),
        bottom: MediaQuery.paddingOf(context).bottom + context.h(20),
        top: context.h(20),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: context.h(14)),
                side: BorderSide(color: Colors.grey.shade300),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(context.r(30)),
                ),
              ),
              child: Text(
                "No",
                style: CustomFonts.black14w600.copyWith(
                  color: Colors.black54,
                ),
              ),
            ),
          ),
          SizedBox(width: context.w(12)),
          Expanded(
            child: CustomButton(
              text: "Continue",
              height: context.h(52),
              onPressed: () async {
                bool? success;
                if (clinic.place != null) {
                  success = await ref
                      .read(treatmentJourneyProvider.notifier)
                      .callShareMapTreatmentRequest(clinic, preferredSlots);
                } else {
                  success = await ref
                      .read(treatmentJourneyProvider.notifier)
                      .callShareTreatmentRequest(preferredSlots);
                }

                if (success == true) {
                  if (context.mounted) {
                    showShareJourneySuccessDialog(context);
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
