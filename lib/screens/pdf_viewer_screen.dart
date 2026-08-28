import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '../widgets/custom_app_bar.dart';

class PdfViewerScreen extends StatelessWidget {
  final String title;
  final String url;

  const PdfViewerScreen({super.key, required this.title, required this.url});

  static const String routeName = "/PdfViewerScreen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: title),
      body: url.isNotEmpty
          ? SizedBox.expand(
              child: SfPdfViewer.network(
                url,
                key: ValueKey(url),
              ),
            )
          : const Center(child: Text("Invalid document URL")),
    );
  }
}
