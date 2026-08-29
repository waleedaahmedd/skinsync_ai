import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';

import '../utils/color_constant.dart';
import '../utils/custom_fonts.dart';
import '../utils/secure_storage_service.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_button.dart';

class BiometricConsentScreen extends StatefulWidget {
  final VoidCallback? onConsentCompleted;

  const BiometricConsentScreen({super.key, this.onConsentCompleted});

  static const String routeName = "/BiometricConsentScreen";

  /// Helper to check consent and proceed with the action
  static Future<void> checkAndProceed({
    required BuildContext context,
    required VoidCallback onProceed,
  }) async {
    final bool hasConsented = await SecureStorage().getBiometricConsent();
    if (hasConsented) {
      onProceed();
    } else {
      if (context.mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BiometricConsentScreen(
              onConsentCompleted: onProceed,
            ),
          ),
        );
      }
    }
  }

  @override
  State<BiometricConsentScreen> createState() => _BiometricConsentScreenState();
}

class _BiometricConsentScreenState extends State<BiometricConsentScreen> {
  // Section 5 Checkboxes State
  bool _checkReceivedAndReviewed = false;
  bool _checkAuthorizeCollectionAndStorage = false;
  bool _checkUnderstandNoClinicAutomaticShare = false;
  bool _checkUnderstandIllustrativeSimulations = false;
  bool _checkUnderstandWithdrawalAndDeletion = false;

  // Form Controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<SfSignaturePadState> _signaturePadKey = GlobalKey();
  bool _isSignatureEmpty = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  bool get _isFormValid {
    return _checkReceivedAndReviewed &&
        _checkAuthorizeCollectionAndStorage &&
        _checkUnderstandNoClinicAutomaticShare &&
        _checkUnderstandIllustrativeSimulations &&
        _checkUnderstandWithdrawalAndDeletion &&
        _nameController.text.trim().isNotEmpty &&
        _emailController.text.trim().isNotEmpty &&
        !_isSignatureEmpty;
  }

  Future<void> _submitConsent() async {
    final ui.Image image = await _signaturePadKey.currentState!.toImage(pixelRatio: 3.0);
    final ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    final Uint8List? signatureBytes = byteData?.buffer.asUint8List();

    if (signatureBytes == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please provide a valid signature")),
      );
      return;
    }

    await SecureStorage().saveBiometricConsent();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Biometric release consent recorded successfully."),
        backgroundColor: CustomColors.purpleColor,
      ),
    );

    if (mounted) {
      widget.onConsentCompleted?.call();
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: CustomAppBar(
        title: "Biometric Consent",
        onBackTap: () => Navigator.pop(context),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(context.w(20)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Text(
                "FACIAL SCAN AND BIOMETRIC CONSENT, WRITTEN RELEASE, AND RETENTION POLICY",
                style: CustomFonts.black16w600.copyWith(
                  letterSpacing: 0.2,
                  color: CustomColors.blackColor,
                ),
              ),
              SizedBox(height: context.h(6)),
              Text(
                "Effective date: August 23, 2026",
                style: CustomFonts.textGrey12w400.copyWith(fontStyle: FontStyle.italic),
              ),
              SizedBox(height: context.h(20)),

              // 1. Data Collected or Derived
              _buildSectionCard(
                title: "1. Data Collected or Derived",
                content:
                    "SkinSync may collect photographs or video frames and derive facial mapping, "
                    "geometry, landmarks, measurements, skin texture and surface characteristics, "
                    "visible-feature descriptions, quality data, image embeddings or other mathematical representations, "
                    "simulations, and progress images. Some categories may be biometric identifiers, biometric information, "
                    "consumer health data, sensitive data, or PHI depending on law and context.",
              ),
              SizedBox(height: context.h(12)),

              // 2. Specific Purposes
              _buildSectionCard(
                title: "2. Specific Purposes",
                content:
                    "Purposes are to perform the requested scan; describe visible characteristics without diagnosis; "
                    "create, display, compare, and revise private simulations and Treatment Journeys; maintain history; "
                    "support clinic-connected progress tracking when requested; and protect, debug, audit, and secure the service. "
                    "SkinSync does not use this data for surveillance, public-space identification, law-enforcement identification, "
                    "or generalized model training.",
              ),
              SizedBox(height: context.h(12)),

              // 3. Disclosure and Service Providers
              _buildSectionCard(
                title: "3. Disclosure and Service Providers",
                content:
                    "Contracted providers may process the minimum data necessary for hosting, storage, security, image processing, "
                    "or AI inference under written restrictions. A clinic receives only information covered by a patient share "
                    "or lawful clinic-directed workflow. SkinSync will not sell, lease, trade, or otherwise profit from a biometric "
                    "identifier or biometric information.",
              ),
              SizedBox(height: context.h(12)),

              // 4. Retention and Destruction
              _buildSectionCard(
                title: "4. Retention and Destruction",
                content:
                    "SkinSync will permanently destroy biometric identifiers and biometric information when the initial collection "
                    "purpose is satisfied or within three years after the last interaction, whichever occurs first, unless a shorter "
                    "rule controls or a clinic must lawfully retain a clinical record. Source images, derived templates, simulations, "
                    "consent evidence, and backups are separately tracked. Backups are isolated and expire on the documented cycle.",
              ),
              SizedBox(height: context.h(20)),

              // 5. Written Release (Checkboxes + Inputs + Signature)
              _buildSectionContainer(
                title: "5. Written Release",
                children: [
                  _buildCheckboxItem(
                    value: _checkReceivedAndReviewed,
                    text: "I received and reviewed this notice before collection.",
                    onChanged: (val) => setState(() => _checkReceivedAndReviewed = val ?? false),
                  ),
                  _buildCheckboxItem(
                    value: _checkAuthorizeCollectionAndStorage,
                    text:
                        "I authorize SkinSync AI Inc. and its restricted service providers to collect, derive, use, store, and destroy the described data for the specific purposes and period stated.",
                    onChanged: (val) => setState(() => _checkAuthorizeCollectionAndStorage = val ?? false),
                  ),
                  _buildCheckboxItem(
                    value: _checkUnderstandNoClinicAutomaticShare,
                    text:
                        "I understand that no clinic receives my independent consumer scan merely because a clinic is listed in the Platform.",
                    onChanged: (val) => setState(() => _checkUnderstandNoClinicAutomaticShare = val ?? false),
                  ),
                  _buildCheckboxItem(
                    value: _checkUnderstandIllustrativeSimulations,
                    text:
                        "I understand that simulations are illustrative and not diagnoses, prescriptions, clinical approval, or guaranteed outcomes.",
                    onChanged: (val) => setState(() => _checkUnderstandIllustrativeSimulations = val ?? false),
                  ),
                  _buildCheckboxItem(
                    value: _checkUnderstandWithdrawalAndDeletion,
                    text: "I understand how to withdraw consent and request deletion.",
                    onChanged: (val) => setState(() => _checkUnderstandWithdrawalAndDeletion = val ?? false),
                  ),
                  SizedBox(height: context.h(20)),

                  // Full Name Field
                  TextField(
                    controller: _nameController,
                    onChanged: (_) => setState(() {}),
                    style: CustomFonts.black14w400,
                    decoration: InputDecoration(
                      labelText: "Full Name *",
                      labelStyle: CustomFonts.textGrey14w400,
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(context.r(12)),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(context.r(12)),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(context.r(12)),
                        borderSide: const BorderSide(color: CustomColors.purpleColor),
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: context.w(16), vertical: context.h(14)),
                    ),
                  ),
                  SizedBox(height: context.h(12)),

                  // Account ID / Email Field
                  TextField(
                    controller: _emailController,
                    onChanged: (_) => setState(() {}),
                    style: CustomFonts.black14w400,
                    decoration: InputDecoration(
                      labelText: "Account ID / Email *",
                      labelStyle: CustomFonts.textGrey14w400,
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(context.r(12)),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(context.r(12)),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(context.r(12)),
                        borderSide: const BorderSide(color: CustomColors.purpleColor),
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: context.w(16), vertical: context.h(14)),
                    ),
                  ),
                  SizedBox(height: context.h(20)),

                  // Signature Controls
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Electronic Signature *",
                        style: CustomFonts.black14w600,
                      ),
                      TextButton(
                        onPressed: () {
                          _signaturePadKey.currentState!.clear();
                          setState(() {
                            _isSignatureEmpty = true;
                          });
                        },
                        child: Text("Clear", style: CustomFonts.purple14w600),
                      ),
                    ],
                  ),
                  SizedBox(height: context.h(4)),

                  // Signature Pad
                  Container(
                    height: context.h(160),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(context.r(12)),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(context.r(12)),
                      child: SfSignaturePad(
                        key: _signaturePadKey,
                        onDrawStart: () {
                          if (_isSignatureEmpty) {
                            setState(() {
                              _isSignatureEmpty = false;
                            });
                          }
                          return false;
                        },
                        backgroundColor: Colors.white,
                        strokeColor: Colors.black,
                        minimumStrokeWidth: 2.0,
                        maximumStrokeWidth: 4.0,
                      ),
                    ),
                  ),
                  SizedBox(height: context.h(12)),

                  // Timestamp
                  Text(
                    "Date/Time: ${DateTime.now().toUtc().toIso8601String().substring(0, 19)} UTC",
                    style: CustomFonts.textGrey12w400,
                  ),
                ],
              ),
              SizedBox(height: context.h(30)),

              // Action Button
              CustomButton(
                onPressed: _isFormValid ? _submitConsent : null,
                text: "Consent & Proceed to Scan",
              ),
              SizedBox(height: context.h(40)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard({required String title, required String content}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(context.w(16)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(context.r(16)),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: CustomFonts.black14w700,
          ),
          SizedBox(height: context.h(8)),
          Text(
            content,
            style: CustomFonts.black13w400.copyWith(height: 1.5, color: Colors.black87),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionContainer({required String title, required List<Widget> children}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(context.w(16)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(context.r(16)),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: CustomFonts.black14w700,
          ),
          SizedBox(height: context.h(16)),
          ...children,
        ],
      ),
    );
  }

  Widget _buildCheckboxItem({
    required bool value,
    required String text,
    required ValueChanged<bool?> onChanged,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: context.h(12)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: context.h(24),
            width: context.w(24),
            child: Checkbox(
              value: value,
              activeColor: CustomColors.purpleColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(context.r(4))),
              side: BorderSide(color: Colors.grey.shade400, width: 1.5),
              onChanged: onChanged,
            ),
          ),
          SizedBox(width: context.w(12)),
          Expanded(
            child: GestureDetector(
              onTap: () => onChanged(!value),
              child: Text(
                text,
                style: CustomFonts.black13w400.copyWith(height: 1.4, color: Colors.black87),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
