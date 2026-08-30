import 'dart:developer';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';

import '../../utils/color_constant.dart';
import '../../utils/consent_utils.dart';
import '../../utils/custom_fonts.dart';
import '../../view_models/auth_view_model.dart';
import '../../view_models/forms_view_model.dart';
import '../face_pose_capture_screen.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_button.dart';

class FaceConsentScreen extends ConsumerStatefulWidget {
  final VoidCallback? onConsentCompleted;

  const FaceConsentScreen({super.key, this.onConsentCompleted});

  static const String routeName = "/FaceConsentScreen";

  /// Helper to check consent and proceed with the action
  static Future<void> checkAndProceed({
    required BuildContext context,
    required WidgetRef ref,
    required VoidCallback onProceed,
  }) async {
    await ConsentUtils.checkAndProceed(
      context: context,
      ref: ref,
      sku: "FACE-SCAN-CONS",
      dialogTitle: "Facial Scan Consent Already Provided",
      dialogMessage: "We have already received your facial scan consent , Tap continue button to proceed with scan",
      onProceed: onProceed,
      onNotSigned: () async {
        if (context.mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => FaceConsentScreen(
                onConsentCompleted: onProceed,
              ),
            ),
          );
        }
      },
    );
  }

  @override
  ConsumerState<FaceConsentScreen> createState() => _FaceConsentScreenState();
}

class _FaceConsentScreenState extends ConsumerState<FaceConsentScreen> {
  // Section 5 Checkboxes State
  bool _checkReceivedAndReviewed = false;
  bool _checkAuthorizeCollectionAndStorage = false;
  bool _checkUnderstandNoClinicAutomaticShare = false;
  bool _checkUnderstandIllustrativeSimulations = false;
  bool _checkUnderstandWithdrawalAndDeletion = false;

  // Form Controllers
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  final GlobalKey<SfSignaturePadState> _signaturePadKey = GlobalKey();
  final GlobalKey _repaintKey = GlobalKey();
  bool _isSignatureEmpty = true;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    final authData = ref.read(authViewModel).authData;
    _nameController = TextEditingController(text: authData?.user?.name ?? '');
    _emailController = TextEditingController(text: authData?.user?.primaryEmail ?? '');
  }

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
        !_isSignatureEmpty &&
        !_isSubmitting;
  }

  Future<void> _submitConsent() async {
    if (_isSubmitting) return;

    setState(() {
      _isSubmitting = true;
    });

    try {
      // Small delay to ensure any pending UI updates (like button state) are settled before capture
      await Future.delayed(const Duration(milliseconds: 100));

      // 1. Capture the screen (RepaintBoundary) as an image
      final RenderRepaintBoundary? boundary = 
          _repaintKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      
      if (boundary == null) throw Exception("Boundary not found");

      // Check if the boundary is ready to be painted
      // ignore: invalid_use_of_protected_member
      if (boundary.debugNeedsPaint) {
        // If it still needs paint, wait for the next frame
        await WidgetsBinding.instance.endOfFrame;
      }

      final ui.Image screenImage = await boundary.toImage(pixelRatio: 2.0);
      final ByteData? byteData = await screenImage.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) throw Exception("Failed to capture screen image");
      final Uint8List screenBytes = byteData.buffer.asUint8List();

      // 2. Create PDF and draw the screen image
      final PdfDocument document = PdfDocument();
      
      // Calculate dimensions to fit the image on the page
      final double imageWidth = screenImage.width.toDouble();
      final double imageHeight = screenImage.height.toDouble();
      
      // Use a standard PDF width (595 points for A4) but dynamic height
      const double pageWidth = 595;
      final double renderHeight = (imageHeight * pageWidth) / imageWidth;

      // Set page settings before adding the page
      document.pageSettings.size = Size(pageWidth, renderHeight);
      document.pageSettings.margins.all = 0;

      final PdfPage page = document.pages.add();
      
      page.graphics.drawImage(
        PdfBitmap(screenBytes),
        Rect.fromLTWH(0, 0, pageWidth, renderHeight),
      );

      final List<int> pdfBytesList = await document.save();
      final Uint8List pdfBytes = Uint8List.fromList(pdfBytesList);
      document.dispose();

      // 3. Call signForm API
      final bool success = await ref.read(formsViewModel.notifier).signForm(
        title: "Biometric Consent - ${_nameController.text}",
        type: "consent",
        globalSku: "FACE-SCAN-CONS",
        pdfBytes: pdfBytes,
        fileName:
            "biometric_consent_${DateTime.now().millisecondsSinceEpoch}.pdf",
        loadingStatus: "Processing ....",
        successStatus: "Facial scan consent received successfully",
      );

      if (success) {
        if (mounted) {
          widget.onConsentCompleted?.call();
          Navigator.pushReplacementNamed(
            context,
            FacePoseCaptureScreen.routeName,
          );
        }
      }
    } catch (e) {
      if (mounted) {
        log("Error: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e")),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: CustomAppBar(
        title: "Facial Scan Consent",
        onBackTap: () => Navigator.pop(context),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              RepaintBoundary(
                key: _repaintKey,
                child: Container(
                  color: Colors.grey.shade50, // Ensure background is captured
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
                              Visibility(
                                visible: !_isSubmitting,
                                maintainSize: true,
                                maintainAnimation: true,
                                maintainState: true,
                                child: TextButton(
                                  onPressed: () {
                                    _signaturePadKey.currentState!.clear();
                                    setState(() {
                                      _isSignatureEmpty = true;
                                    });
                                  },
                                  child: Text("Clear", style: CustomFonts.purple14w600),
                                ),
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
                    ],
                  ),
                ),
              ),

              // Action Button (Outside RepaintBoundary)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: context.w(20)),
                child: Column(
                  children: [
                    CustomButton(
                      onPressed: _isFormValid ? _submitConsent : null,
                      isLoading: _isSubmitting,
                      text: "Proceed to Scan",
                    ),
                    SizedBox(height: context.h(40)),
                  ],
                ),
              ),
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
