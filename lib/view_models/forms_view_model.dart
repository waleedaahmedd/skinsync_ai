import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../models/base_state_model.dart';
import '../models/requests/sign_form_request.dart';
import '../models/responses/consent_form_response.dart';
import '../repositories/forms_repository.dart';
import '../services/api_base_helper.dart';
import '../services/forms_service.dart';
import '../services/media_service.dart';
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
        final List<Document> allUnSigned = response.data?.unSignedDocuments ?? [];
        
        final List<Document> compliance =
            allUnSigned.where((doc) => doc.type == 'compliance').toList();
        final List<Document> otherUnSigned =
            allUnSigned.where((doc) => doc.type != 'compliance').toList();

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
    required int formId,
    required Uint8List pdfBytes,
    required String fileName,
  }) async {
    return await runSafely(() async {
      EasyLoading.show(status: 'Uploading signed document...');

      // 1. Save locally first to get a path (MediaService.uploadMedia handles Uint8List for XFile/PlatformFile)
      // Actually MediaService.uploadMedia can take XFile which we can create from bytes if we save it.
      final directory = await getTemporaryDirectory();
      final file = File('${directory.path}/$fileName');
      await file.writeAsBytes(pdfBytes);

      // 2. Upload to Firebase
      final String? firebaseUrl = await MediaService().uploadMedia(
        path: 'signed_forms',
        file: XFile(file.path),
      );

      if (firebaseUrl == null) {
        throw Exception('Failed to upload signed document to storage');
      }

      // 3. Call Sign Form API
      final request = SignFormRequest(formId: formId, url: firebaseUrl);
      final response = await _repository.signForm(request);

      if (response.isSuccess == true) {
        EasyLoading.showSuccess(
          response.message ?? 'Document signed successfully',
        );
        await fetchForms(); // Refresh lists
        return true;
      }
      return false;
    }) ??
    false;
  }

  @override
  void onError(String message) {
    state = state.copyWith(loading: false);
    super.onError(message);
  }
}
