import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';
import '../utils/custom_fonts.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_button.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({super.key});

  static const String routeName = '/PrivacyPolicyScreen';

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  final GlobalKey<SfSignaturePadState> _signaturePadKey = GlobalKey();
  String? _pdfPath;
  bool _isLoading = true;
  bool _isSigned = false;

  @override
  void initState() {
    super.initState();
    _checkExistingPdf();
  }

  Future<void> _checkExistingPdf() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/signed_privacy_policy.pdf';
    final file = File(path);
    if (await file.exists()) {
      setState(() {
        _pdfPath = path;
        _isSigned = true;
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _handleSave() async {
    try {
      setState(() => _isLoading = true);

      // 1. Get signature image
      final ui.Image signatureImage = await _signaturePadKey.currentState!.toImage(pixelRatio: 3.0);
      final byteData = await signatureImage.toByteData(format: ui.ImageByteFormat.png);
      final Uint8List signatureBytes = byteData!.buffer.asUint8List();

      // 2. Load original PDF from assets
      final ByteData assetData = await rootBundle.load('assets/dummyassets/B_Privacy_Policy.pdf');
      final Uint8List originalBytes = assetData.buffer.asUint8List();

      // 3. Create PDF document and add signature
      final PdfDocument document = PdfDocument(inputBytes: originalBytes);
      final PdfPage lastPage = document.pages.add(); // Adding a new page for signature
      
      final PdfFont boldFont = PdfStandardFont(PdfFontFamily.helvetica, 14, style: PdfFontStyle.bold);
      
      lastPage.graphics.drawString(
        "Signature Confirmation (Privacy Policy)",
        boldFont,
        bounds: const Rect.fromLTWH(0, 20, 0, 0),
      );

      lastPage.graphics.drawString(
        "Signed on: ${DateTime.now().toString().split('.').first}",
        PdfStandardFont(PdfFontFamily.helvetica, 12),
        bounds: const Rect.fromLTWH(0, 50, 0, 0),
      );

      lastPage.graphics.drawImage(
        PdfBitmap(signatureBytes),
        const Rect.fromLTWH(0, 80, 300, 120),
      );

      // 4. Save the signed PDF
      final List<int> bytes = await document.save();
      document.dispose();

      final directory = await getApplicationDocumentsDirectory();
      final path = '${directory.path}/signed_privacy_policy.pdf';
      final file = File(path);
      await file.writeAsBytes(bytes, flush: true);

      setState(() {
        _pdfPath = path;
        _isSigned = true;
        _isLoading = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Privacy Policy signed and saved successfully!")),
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
      debugPrint("Error saving PDF: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e. Make sure assets/dummyassets/B_Privacy_Policy.pdf exists.")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(title: "Privacy Policy"),
      body: _isLoading 
          ? const Center(child: CircularProgressIndicator())
          : _isSigned 
              ? SfPdfViewer.file(File(_pdfPath!))
              : _buildTermsWithSignature(),
    );
  }

  Widget _buildTermsWithSignature() {
    return Column(
      children: [
        Expanded(
          flex: 2,
          child: SfPdfViewer.asset('assets/dummyassets/B_Privacy_Policy.pdf'),
        ),
        Container(
          height: 220.h,
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Please Sign Below", style: CustomFonts.black16w600),
                  TextButton(
                    onPressed: () => _signaturePadKey.currentState!.clear(),
                    child: const Text("Clear"),
                  ),
                ],
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(12.r),
                    color: Colors.grey.shade50,
                  ),
                  child: SfSignaturePad(
                    key: _signaturePadKey,
                    backgroundColor: Colors.transparent,
                  ),
                ),
              ),
              SizedBox(height: 12.h),
              CustomButton(
                onPressed: _handleSave,
                text: "Sign and Save",
              ),
            ],
          ),
        ),
      ],
    );
  }
}
