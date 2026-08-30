import 'dart:io';
import 'dart:ui' as ui;
import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';
import '../../screens/legal_document_screen.dart';
import '../../utils/custom_fonts.dart';
import '../../view_models/forms_view_model.dart';
import '../custom_button.dart';

class SignatureBottomSheet extends ConsumerStatefulWidget {
  final LegalDocumentArgs args;
  final Function(String) onSigned;

  const SignatureBottomSheet({
    super.key,
    required this.args,
    required this.onSigned,
  });

  @override
  ConsumerState<SignatureBottomSheet> createState() =>
      _SignatureBottomSheetState();
}

class _SignatureBottomSheetState extends ConsumerState<SignatureBottomSheet> {
  final GlobalKey<SfSignaturePadState> _signaturePadKey = GlobalKey();
  bool _isSigned = false;

  Future<void> _handleSubmit() async {
    try {
      EasyLoading.show(status: 'Signing...');
      
      // 1. Get signature image
      final ui.Image signatureImage =
          await _signaturePadKey.currentState!.toImage(pixelRatio: 3.0);
      final byteData =
          await signatureImage.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) {
        EasyLoading.dismiss();
        return;
      }
      final Uint8List signatureBytes = byteData.buffer.asUint8List();

      // 2. Load original PDF
      Uint8List originalBytes;
      if (widget.args.assetPath != null) {
        final data = await rootBundle.load(widget.args.assetPath!);
        originalBytes = data.buffer.asUint8List();
      } else if (widget.args.url != null) {
        final response = await http.get(Uri.parse(widget.args.url!));
        originalBytes = response.bodyBytes;
      } else {
        throw Exception('No source PDF provided');
      }

      // 3. Load existing PDF document and add signature
      final PdfDocument document = PdfDocument(inputBytes: originalBytes);
      
      // Add a dedicated signature page at the end
      final PdfPage lastPage = document.pages.add();

      final PdfFont boldFont =
          PdfStandardFont(PdfFontFamily.helvetica, 14, style: PdfFontStyle.bold);

      lastPage.graphics.drawString(
        "Signature Confirmation (${widget.args.title})",
        boldFont,
        bounds: const Rect.fromLTWH(0, 20, 0, 0),
      );

      lastPage.graphics.drawString(
        "Signed on: ${DateTime.now().toString().split('.').first}",
        PdfStandardFont(PdfFontFamily.helvetica, 12),
        bounds: const Rect.fromLTWH(0, 50, 0, 0),
      );

      // Draw the signature image
      lastPage.graphics.drawImage(
        PdfBitmap(signatureBytes),
        const Rect.fromLTWH(0, 80, 300, 120),
      );

      // 4. Save the merged document
      final List<int> pdfBytesList = await document.save();
      final Uint8List pdfBytes = Uint8List.fromList(pdfBytesList);
      document.dispose(); // Back to dispose() as PdfDocument doesn't have close() in this version

      // 5. If formId exists, upload to Firebase and call API
      if (widget.args.formId != null) {
        final success = await ref.read(formsViewModel.notifier).signForm(
              title: widget.args.title,
              type: widget.args.type ?? '',
              globalSku: widget.args.globalSku ?? '',
              pdfBytes: pdfBytes,
              fileName: widget.args.storageFileName,
            );
        
        if (success) {
          if (mounted) {
            Navigator.pop(context); // Close bottom sheet
            Navigator.pop(context, true); // Go back from LegalDocumentScreen
          }
          return;
        } else {
           EasyLoading.dismiss();
           return;
        }
      }

      // 6. Save locally for persistence (fallback)
      final directory = await getApplicationDocumentsDirectory();
      final path = '${directory.path}/${widget.args.storageFileName}';
      final file = File(path);
      await file.writeAsBytes(pdfBytes, flush: true);

      EasyLoading.dismiss();
      widget.onSigned(path);
      if (mounted) Navigator.pop(context);
      
    } catch (e) {
      EasyLoading.dismiss();
      debugPrint("Error signing PDF: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error signing document: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        20.w,
        20.h,
        20.w,
        20.h + MediaQuery.viewInsetsOf(context).bottom,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Please Sign Below", style: CustomFonts.black18w600),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          Container(
            height: 200.h,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(12.r),
              color: Colors.grey.shade50,
            ),
            child: SfSignaturePad(
              key: _signaturePadKey,
              backgroundColor: Colors.transparent,
              onDrawStart: () {
                if (!_isSigned) {
                  setState(() => _isSigned = true);
                }
                return false; // Return false to continue drawing
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  _signaturePadKey.currentState!.clear();
                  setState(() => _isSigned = false);
                },
                child: const Text("Clear Signature"),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          if (_isSigned)
            CustomButton(
              onPressed: _handleSubmit,
              text: "Submit",
            )
          else
            Container(
              width: double.infinity,
              height: 52.h,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(30.r),
              ),
              child: Center(
                child: Text(
                  "Sign to Submit",
                  style: CustomFonts.black14w600.copyWith(color: Colors.grey),
                ),
              ),
            ),
          SizedBox(height: 10.h),
        ],
      ),
    );
  }
}
