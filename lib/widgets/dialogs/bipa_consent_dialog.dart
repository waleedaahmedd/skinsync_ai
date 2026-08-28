import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:iconsax/iconsax.dart';
import '../../utils/custom_fonts.dart';
import '../custom_button.dart';

void showBipaConsentDialog({
  required BuildContext context,
  required VoidCallback onAccepted,
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
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: context.w(20),
            vertical: context.h(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      "BIPA Disclosure",
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
              SizedBox(height: context.h(16)),
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.5,
                ),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Biometric Information Privacy Act Disclosure",
                        style: CustomFonts.black14w700,
                      ),
                      SizedBox(height: context.h(12)),
                      Text(
                        "I authorize SkinSync AI Inc. to collect, capture, receive, process, store, use, and, only as described below, disclose my facial photographs, facial scans, facial landmarks, facial mapping or geometry, skin-surface characteristics, treatment simulation images, and any related biometric information generated from them. SkinSync will use this data only to create and maintain my scan, generate AI-assisted analysis and illustrative simulations, build and revise my Treatment Journey, support a consultation with a clinic I select, provide requested platform features, maintain security, and perform quality assurance. SkinSync will not sell, lease, trade, or otherwise profit from my biometric data. SkinSync may disclose this data to the clinic I affirmatively select and to service providers that are contractually restricted to providing the Platform. SkinSync will retain covered biometric identifiers or information only until the first of: the purpose is satisfied; my valid deletion request can be honored; or three years after my last interaction with SkinSync, unless another law requires a different period. I have received the public retention and destruction policy and electronically sign this release.",
                        style: CustomFonts.black14w400.copyWith(
                          height: 1.5,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: context.h(24)),
              CustomButton(
                text: "Continue",
                onPressed: () {
                  onAccepted();
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      );
    },
  );
}
