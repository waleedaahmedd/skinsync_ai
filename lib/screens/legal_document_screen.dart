import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '../widgets/bottom_sheets/signature_bottom_sheet.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_button.dart';

class LegalDocumentArgs {
  final String title;
  final String? assetPath;
  final String? url;
  final String storageFileName;
  final int? formId;

  LegalDocumentArgs({
    required this.title,
    this.assetPath,
    this.url,
    required this.storageFileName,
    this.formId,
  });
}

class LegalDocumentScreen extends ConsumerStatefulWidget {
  final LegalDocumentArgs args;

  const LegalDocumentScreen({super.key, required this.args});

  static const String routeName = '/LegalDocumentScreen';

  @override
  ConsumerState<LegalDocumentScreen> createState() =>
      _LegalDocumentScreenState();
}

class _LegalDocumentScreenState extends ConsumerState<LegalDocumentScreen> {
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
    final path = '${directory.path}/${widget.args.storageFileName}';
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

  void _showSignatureBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SignatureBottomSheet(
        args: widget.args,
        onSigned: (signedPath) {
          setState(() {
            _pdfPath = signedPath;
            _isSigned = true;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: widget.args.title),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _isSigned
              ? SfPdfViewer.file(File(_pdfPath!))
              : _buildDocumentPreview(),
      bottomNavigationBar: (!_isLoading && !_isSigned)
          ? Padding(
              padding: EdgeInsets.fromLTRB(
                20.w,
                10.h,
                20.w,
                20.h + MediaQuery.paddingOf(context).bottom,
              ),
              child: CustomButton(
                onPressed: _showSignatureBottomSheet,
                text: "Sign and Save",
              ),
            )
          : null,
    );
  }

  Widget _buildDocumentPreview() {
    if (widget.args.assetPath != null) {
      return SfPdfViewer.asset(widget.args.assetPath!);
    } else if (widget.args.url != null) {
      return SfPdfViewer.network(widget.args.url!);
    } else {
      return const Center(child: Text("Document not found"));
    }
  }
}
