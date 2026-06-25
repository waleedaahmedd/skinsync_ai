import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/base_state_model.dart';
import '../models/responses/treatment_category_list_response.dart';
import '../repositories/treatment_category_repository.dart';
import '../services/api_base_helper.dart';
import '../services/treatment_category_service.dart';
import 'base_view_model.dart';

final treatmentCategoryProvider = NotifierProvider<TreatmentCategoryViewModel, TreatmentCategoryState>(
  () => TreatmentCategoryViewModel(
    treatmentCategoryRepository: TreatmentCategoryService(apiClient: ApiBaseHelper()),
  ),
);

class TreatmentCategoryViewModel extends BaseViewModel<TreatmentCategoryState> {
  TreatmentCategoryViewModel({required TreatmentCategoryRepository treatmentCategoryRepository})
    : _repo = treatmentCategoryRepository,
      super(initialState: const TreatmentCategoryState());

  final TreatmentCategoryRepository _repo;

  // Direct getters to maintain properties
  List<TreatmentCategoryModel> get categories => state.categories;
  bool get isLoading => state.loading;
  String? get errorMessage => state.errorMessage;

  Future<void> fetchCategories() async {
    await runSafely(() async {
      state = state.copyWith(loading: true, errorMessage: null);
      final response = await _repo.getCategoriesApi();
      state = state.copyWith(
        loading: false,
        categories: response.data ?? [],
        errorMessage: null,
      );
    });
  }

  @override
  void onError(String message) {
    state = state.copyWith(loading: false, errorMessage: message);
    super.onError(message);
  }
}

class TreatmentCategoryState extends BaseStateModel {
  final List<TreatmentCategoryModel> categories;

  const TreatmentCategoryState({
    this.categories = const [],
    super.loading = false,
    super.errorMessage,
  });

  @override
  TreatmentCategoryState copyWith({
    List<TreatmentCategoryModel>? categories,
    bool? loading,
    String? errorMessage,
  }) {
    return TreatmentCategoryState(
      categories: categories ?? this.categories,
      loading: loading ?? this.loading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
