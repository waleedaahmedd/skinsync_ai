import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/base_state_model.dart';
import '../models/responses/consent_form_response.dart';
import '../repositories/forms_repository.dart';
import '../services/api_base_helper.dart';
import '../services/forms_service.dart';
import 'base_view_model.dart';

final formsViewModel = NotifierProvider<FormsViewModel, FormsState>(() {
  final apiBaseHelper = ApiBaseHelper();
  final formService = FormsService(apiClient: apiBaseHelper);
  return FormsViewModel(repository: formService);
});

class FormsState extends BaseStateModel {
  final List<Document> signDocument;
  final List<Document> unSignDocument;

  const FormsState({
    super.loading,
    super.errorMessage,
    this.signDocument = const [],
    this.unSignDocument = const [],
  });

  @override
  FormsState copyWith({
    bool? loading,
    String? errorMessage,
    List<Document>? signDocument,
    List<Document>? unSignDocument,
  }) {
    return FormsState(
      loading: loading ?? this.loading,
      errorMessage: errorMessage ?? this.errorMessage,
      signDocument: signDocument ?? this.signDocument,
      unSignDocument: unSignDocument ?? this.unSignDocument,
    );
  }

  FormsState clearFiles() {
    return FormsState(
      loading: loading,
      errorMessage: errorMessage,
      signDocument: signDocument,
      unSignDocument: unSignDocument,
    );
  }
}

class FormsViewModel extends BaseViewModel<FormsState> {
  final FormsRepository _repository;
  FormsViewModel({required this._repository})
    : super(initialState: const FormsState());

  Future<void> fetchForms({int page = 1}) async {
    state = state.copyWith(loading: true);

    await runSafely(() async {
      final response = await _repository.fetchConsentForm();
      if (response.isSuccess == true) {
        state = state.copyWith(
          signDocument: response.data?.signedDocuments,
          unSignDocument: response.data?.unSignedDocuments,
        );
      }
    });

    if (state.loading) {
      state = state.copyWith(loading: false);
    }
  }

  @override
  void onError(String message) {
    state = state.copyWith(loading: false);
    super.onError(message);
  }
}
