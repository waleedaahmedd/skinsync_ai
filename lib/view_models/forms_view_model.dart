import 'dart:typed_data';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../app_init.dart';
import '../models/base_state_model.dart';
import '../models/requests/sign_form_request.dart';
import '../models/responses/consent_form_response.dart';
import '../repositories/forms_repository.dart';
import '../screens/legal_document_screen.dart';
import '../services/api_base_helper.dart';
import '../services/forms_service.dart';
import '../services/media_service.dart';
import '../utils/list_utils.dart';
import 'auth_view_model.dart';
import 'base_view_model.dart';

final formsViewModel = NotifierProvider<FormsViewModel, FormsState>(() {
  final apiBaseHelper = ApiBaseHelper();
  final formService = FormsService(apiClient: apiBaseHelper);
  return FormsViewModel(repository: formService);
});

class FormsState extends BaseStateModel {
  final List<Document> signDocument;
  final List<Document> unSignDocument;
  final List<Document> complianceDocuments;

  const FormsState({
    super.loading,
    super.errorMessage,
    this.signDocument = const [],
    this.unSignDocument = const [],
    this.complianceDocuments = const [],
  });

  @override
  FormsState copyWith({
    bool? loading,
    String? errorMessage,
    List<Document>? signDocument,
    List<Document>? unSignDocument,
    List<Document>? complianceDocuments,
  }) {
    return FormsState(
      loading: loading ?? this.loading,
      errorMessage: errorMessage ?? this.errorMessage,
      signDocument: signDocument ?? this.signDocument,
      unSignDocument: unSignDocument ?? this.unSignDocument,
      complianceDocuments: complianceDocuments ?? this.complianceDocuments,
    );
  }

  FormsState clearFiles() {
    return FormsState(
      loading: loading,
      errorMessage: errorMessage,
      signDocument: signDocument,
      unSignDocument: unSignDocument,
      complianceDocuments: complianceDocuments,
    );
  }
}

class FormsViewModel extends BaseViewModel<FormsState> {
  final FormsRepository _repository;
  FormsViewModel({required this._repository})
    : super(initialState: const FormsState());

  Future<void> fetchForms({int page = 1}) async {
    // Explicitly reset all lists to empty before fetching new data
    state = state.copyWith(
      loading: true,
      signDocument: [],
      unSignDocument: [],
      complianceDocuments: [],
    );

    await runSafely(() async {
      final response = await _repository.fetchConsentForm();
      if (response.isSuccess == true) {
        final List<Document> allSigned = response.data?.signedDocuments ?? [];
        final List<Document> allUnSigned =
            response.data?.unSignedDocuments ?? [];

        final List<Document> compliance = allUnSigned
            .where((doc) => doc.type == 'compliance')
            .toList();
        final List<Document> otherUnSigned = allUnSigned
            .where((doc) => doc.type != 'compliance')
            .toList();

        state = state.copyWith(
          signDocument: allSigned,
          unSignDocument: otherUnSigned,
          complianceDocuments: compliance,
          loading: false,
        );
      }
    });

    if (state.loading) {
      state = state.copyWith(loading: false);
    }
  }

  Future<bool> signForm({
    required String title,
    required String type,
    required String globalSku,
    required Uint8List pdfBytes,
    required String fileName,
    String? loadingStatus,
    String? successStatus,
  }) async {
    return await runSafely(() async {
          EasyLoading.show(
            status: loadingStatus ?? 'Uploading signed document...',
          );

          // 1. Generate a unique filename using timestamp to avoid caching and ensure fresh URL
          final uniqueFileName =
              '${DateTime.now().millisecondsSinceEpoch}_$fileName';
          final user =
              ref.read(authViewModel).authData?.user?.primaryEmail ?? '';
          final file = XFile.fromData(
            Uint8List.fromList(pdfBytes),
            name: uniqueFileName,
            mimeType: 'application/pdf',
          );
          final String? firebaseUrl = await MediaService().uploadMedia(
            path: 'signed_forms/$user/$title',
            file: file,
            fileNameOverride: uniqueFileName,
          );

          if (firebaseUrl == null) {
            throw Exception('Failed to upload signed document to storage');
          }

          // 2. Call Sign Form API
          final request = SignFormRequest(
            title: title,
            url: firebaseUrl,
            type: type,
            globalSku: globalSku,
          );
          final response = await _repository.signForm(request);

          if (response.isSuccess == true) {
            EasyLoading.showSuccess(
              successStatus ??
                  response.message ??
                  'Document signed successfully',
            );
            await fetchForms(); // Refresh lists
            return true;
          }
          return false;
        }) ??
        false;
  }

  Future<bool> checkAndOpenDocumentBySku(String sku) async {
    // 1. Check in signed documents
    final signedDoc = state.signDocument.firstWhereOrNull(
      (doc) => doc.globalSku == sku,
    );
    if (signedDoc != null) {
      final res =
          await navigatorKey.currentState?.pushNamed(
                LegalDocumentScreen.routeName,
                arguments: LegalDocumentArgs(
                  title: signedDoc.title ?? '',
                  url: signedDoc.url,
                  storageFileName: 'signed_form_${signedDoc.id}.pdf',
                  formId: signedDoc.id,
                  isAlreadySigned: true,
                  type: signedDoc.type,
                  globalSku: signedDoc.globalSku,
                ),
              )
              as bool?;
      return res ?? false;
    }

    // 2. Check in unsigned documents
    final unSignedDoc = state.unSignDocument.firstWhereOrNull(
      (doc) => doc.globalSku == sku,
    );
    if (unSignedDoc != null) {
      final res =
          await navigatorKey.currentState?.pushNamed(
                LegalDocumentScreen.routeName,
                arguments: LegalDocumentArgs(
                  title: unSignedDoc.title ?? '',
                  url: unSignedDoc.url,
                  storageFileName: 'signed_form_${unSignedDoc.id}.pdf',
                  formId: unSignedDoc.id,
                  isAlreadySigned: false,
                  type: unSignedDoc.type,
                  globalSku: unSignedDoc.globalSku,
                ),
              )
              as bool?;
      return res ?? false;
    }
    return true; // No document to open, safe to proceed
  }

  @override
  void onError(String message) {
    state = state.copyWith(loading: false);
    super.onError(message);
  }
}
