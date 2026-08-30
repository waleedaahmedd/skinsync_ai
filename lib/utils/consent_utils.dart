import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../screens/pdf_viewer_screen.dart';
import '../view_models/forms_view_model.dart';
import '../widgets/already_consented_dialog.dart';

class ConsentUtils {
  /// Checks if a document with the given SKU is already signed.
  /// If signed, shows a dialog with options to view the PDF or continue.
  /// If not signed, executes [onNotSigned].
  static Future<void> checkAndProceed({
    required BuildContext context,
    required WidgetRef ref,
    required String sku,
    required String dialogTitle,
    required String dialogMessage,
    required VoidCallback onProceed,
    required VoidCallback onNotSigned,
  }) async {
    final formsState = ref.read(formsViewModel);
    final signedDoc = formsState.signDocument
        .where((doc) => doc.globalSku == sku)
        .firstOrNull;

    if (signedDoc != null) {
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (context) => AlreadyConsentedDialog(
            title: dialogTitle,
            message: dialogMessage,
            onContinue: () {
              Navigator.pop(context); // Close dialog
              onProceed();
            },
            onViewPdf: () {
              Navigator.pushNamed(
                context,
                PdfViewerScreen.routeName,
                arguments: {
                  'title': signedDoc.title ?? 'Signed Document',
                  'url': signedDoc.url ?? '',
                },
              );
            },
          ),
        );
      }
      return;
    }

    onNotSigned();
  }
}
