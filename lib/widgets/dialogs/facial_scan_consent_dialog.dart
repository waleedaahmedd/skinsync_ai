import 'package:material_ui/material_ui.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:iconsax/iconsax.dart';
import '../../models/requests/preferred_slot.dart';
import '../../models/responses/simulation_history_response.dart';
import '../../utils/color_constant.dart';
import '../../utils/custom_fonts.dart';
import '../custom_button.dart';

void showFacialScanConsentDialog({
  required BuildContext context,
  SimulationData? simulationData,
  List<PreferredSlot>? preferredSlots,
  required VoidCallback onConfirm,
}) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Colors.white,
        insetPadding: EdgeInsets.symmetric(horizontal: context.w(20)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(context.r(24)),
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.sizeOf(context).height * 0.8,
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: context.w(20),
              vertical: context.h(24),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        "Confirmation",
                        style: CustomFonts.black20w600,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Iconsax.close_circle, color: Colors.grey),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
                SizedBox(height: context.h(20)),
                Flexible(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        if (simulationData != null) ...[
                          _buildReceipt(context, simulationData),
                          SizedBox(height: context.h(16)),
                        ],
                        if (preferredSlots != null &&
                            preferredSlots.isNotEmpty) ...[
                          _buildSlotsSummary(context, preferredSlots),
                          SizedBox(height: context.h(20)),
                        ],
                        Text(
                          "By continuing, you confirm that you are voluntarily submitting new facial images for SkinSync’s facial-analysis, simulation, treatment-planning, and progress-tracking features under your existing Facial Scan and Biometric Consent. Do not continue if you have withdrawn that consent.",
                          style: CustomFonts.black14w400.copyWith(
                            height: 1.5,
                            color: Colors.black87,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: context.h(28)),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          padding:
                              EdgeInsets.symmetric(vertical: context.h(14)),
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
                        onPressed: () {
                          Navigator.pop(context);
                          onConfirm();
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

Widget _buildReceipt(BuildContext context, SimulationData simulationData) {
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
            const Icon(Iconsax.receipt, size: 20, color: CustomColors.purpleColor),
            SizedBox(width: context.w(8)),
            Text("Treatment Request Details", style: CustomFonts.black16w600),
          ],
        ),
        const Divider(height: 24),
        if (simulationData.treatments != null)
          ...simulationData.treatments!.map((treatment) {
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
                      final material =
                          (area.materials != null && area.materials!.isNotEmpty)
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

Widget _buildSlotsSummary(
  BuildContext context,
  List<PreferredSlot> preferredSlots,
) {
  return Container(
    width: double.infinity,
    padding: EdgeInsets.all(context.w(16)),
    decoration: BoxDecoration(
      color: CustomColors.purpleColor.withValues(alpha: 0.04),
      borderRadius: BorderRadius.circular(context.r(16)),
      border: Border.all(color: CustomColors.purpleColor.withValues(alpha: 0.1)),
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
