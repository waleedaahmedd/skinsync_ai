import 'dart:convert';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../models/base_state_model.dart';
import '../models/requests/save_history_request.dart';
import '../models/responses/simulation_history_response.dart';
import 'dart:async';
import '../models/responses/treatment_list_response.dart';
import '../models/responses/treatment_area_list_response.dart';
import '../models/responses/materials_response.dart';
import '../repositories/treatment_repository.dart';
import '../services/api_base_helper.dart';
import '../services/media_service.dart';
import '../services/treatment_services.dart';
import '../utills/image_utills.dart';
import '../utills/list_utils.dart';
import 'auth_view_model.dart';
import 'treatment_area_view_model.dart';
import 'checkout_view_model.dart';
import 'base_view_model.dart';

final treatmentViewModel = NotifierProvider(
  () => TreatmentViewModel._(
    treatmentRepository: TreatmentService(apiClient: ApiBaseHelper()),
  ),
);

class TreatmentViewModel extends BaseViewModel<TreatmentsState> {
  TreatmentViewModel._({required TreatmentRepository treatmentRepository})
    : _repo = treatmentRepository,
      super(initialState: const TreatmentsState());

  final TreatmentRepository _repo;

  Future<void> initializeSimulation(SimulationData simulation) async {
    state = state.copyWith(isAiImageGenerated: false);
    clearAiImage();
    if (state.treatments.isEmpty) {
      await getTreatments();
    }
    final treatment = state.treatments.firstWhereOrNull(
      (treatment) => treatment.id == simulation.treatmentId,
    );
    if (treatment != null) {
      await onTapTreatment(treatmentModel: treatment, isCallPredictAPI: true);
    }
    final rootAreas = ref.read(treatmentAreaProvider).areas;
    final area = rootAreas.firstWhereOrNull((area) {
      final found = simulation.subsections?.any(
        (subSection) => subSection.areaId == area.id,
      );
      return found ?? false;
    });
    if (area != null) {
      onTapTreatmentArea(area);
    }
    final subAreas = state.selectTreatmentArea?.subAreas ?? <TreatmentAreaModel>[];
    for (final subArea in subAreas) {
      final selectedSubArea = simulation.subsections?.firstWhereOrNull(
        (subSection) => subSection.sectionId == subArea.id,
      );
      if (selectedSubArea != null) {
        onTapTreatmentSubArea(
          subArea: subArea,
        );
      }
    }
    EasyLoading.show(status: 'Downloading images...');
    final beforeImage = await MediaService().downloadSimulationImage(
      simId: simulation.id!,
      isBefore: true,
      imageUrl: simulation.beforeImage,
    );
    setCapturedImage(beforeImage);
    final afterImage = await MediaService().downloadSimulationImage(
      simId: simulation.id!,
      isBefore: false,
      imageUrl: simulation.afterImage,
    );
    setAiImage(afterImage);
    EasyLoading.dismiss();
    state = state.copyWith(
      loading: false,
      isAiImageGenerated: true,
      isBefore: false,
    );
  }

  void updateSyringeLevel({required TreatmentAreaModel subArea}) {
    state = state.copyWith(
      selectedSubAreasList: state.selectedSubAreasList.map((s) {
        if (s.id == subArea.id) {
          return subArea;
        }
        return s;
      }).toList(),
    );
  }

  void removeSubArea(int id) {
    state = state.copyWith(
      selectedSubAreasList: state.selectedSubAreasList
          .where((element) => element.id != id)
          .toList(),
      isAiImageGenerated: false,
    );
  }

  void toggleIsBefore() => state = state.copyWith(isBefore: !state.isBefore);

  void setCapturedImage(XFile? image) =>
      state = state.copyWith(capturedImage: image);

  void setAiImage(XFile? image) => state = state.copyWith(aiImage: image);

  void clearAiImage() => state = state.copyWith(clearAiImage: true);

  void _clearAreaSelection() {
    state = state.copyWith(clearSelectSectionId: true);
  }

  Future<void> onTapTreatment({
    required TreatmentData treatmentModel,
    required bool isCallPredictAPI,
  }) async {
    state = state.copyWith(
      selectedTreatment: treatmentModel,
      clearSubSectionIds: true,
      areaNavigationStack: const [],
    );
    clearAiImage();
    _clearAreaSelection();
    state = state.copyWith(isBefore: true);
    if (treatmentModel.isArea == true && isCallPredictAPI) {
      await ref.read(treatmentAreaProvider.notifier).fetchAreasByTreatment(treatmentModel.id ?? 0);
    }
  }

  void onTapTreatmentArea(TreatmentAreaModel treatmentArea) {
    final updatedStack = [...state.areaNavigationStack, treatmentArea];
    state = state.copyWith(
      selectedTreatmentArea: treatmentArea,
      areaNavigationStack: updatedStack,
    );
  }

  void popAreaNavigationStack() {
    if (state.areaNavigationStack.isNotEmpty) {
      final updatedStack = List<TreatmentAreaModel>.from(state.areaNavigationStack)..removeLast();
      final previousArea = updatedStack.isNotEmpty ? updatedStack.last : null;
      state = state.copyWith(
        selectedTreatmentArea: previousArea,
        areaNavigationStack: updatedStack,
      );
    }
  }

  void resetAreaNavigationStack() {
    state = state.copyWith(
      selectedTreatmentArea: null,
      areaNavigationStack: const [],
    );
  }

  void onTapTreatmentSubArea({required TreatmentAreaModel subArea}) {
    final treatmentSubArea = subArea.copyWith(
      areaId: state.selectTreatmentArea!.id!,
    );
    final id = treatmentSubArea.id;
    final alreadySelected =
        id != null && state.selectedSubAreasList.any((e) => e.id == id);
    final updatedList = alreadySelected
        ? state.selectedSubAreasList
        : [...state.selectedSubAreasList, treatmentSubArea];

    state = state.copyWith(
      selectedTreatmentSubArea: treatmentSubArea,
      selectedSubAreasList: updatedList,
      isAiImageGenerated: false,
    );
  }

  void clearAllSelectedTreatments() {
    state = TreatmentsState(
      loading: state.loading,
      errorMessage: state.errorMessage,
      treatments: state.treatments,
      arTreatments: state.arTreatments,
      treatmentsLoading: state.treatmentsLoading,
      selectedTreatment: null,
      selectTreatmentArea: null,
      selectedSubAreasList: const [],
      areaNavigationStack: const [],
      isBefore: true,
      capturedImage: state.capturedImage,
      aiImage: null,
      isAiImageGenerated: false,
      isLoading: state.isLoading,
      isLoadingMore: state.isLoadingMore,
      hasMoreData: state.hasMoreData,
      currentPage: state.currentPage,
      totalPages: state.totalPages,
      searchQuery: state.searchQuery,
      categoryId: state.categoryId,
      areaId: state.areaId,
      isSimulator: state.isSimulator,
      isArLoading: state.isArLoading,
      isArLoadingMore: state.isArLoadingMore,
      hasMoreArData: state.hasMoreArData,
      arCurrentPage: state.arCurrentPage,
      arTotalPages: state.arTotalPages,
      arSearchQuery: state.arSearchQuery,
      arAreaId: state.arAreaId,
      materials: state.materials,
      materialsLoading: state.materialsLoading,
    );
  }

  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  Future<void> loadTreatments({
    int? categoryId,
    int? areaId,
    bool clearSearch = false,
    bool? isSimulator,
  }) async {
    state = state.copyWith(
      isLoading: true,
      treatmentsLoading: true,
      errorMessage: null,
      currentPage: 1,
      categoryId: categoryId,
      clearCategoryId: categoryId == null,
      areaId: areaId,
      clearAreaId: areaId == null,
      isSimulator: isSimulator,
      clearIsSimulator: isSimulator == null,
      searchQuery: clearSearch ? "" : state.searchQuery,
      treatments: [],
    );
    await runSafely(() async {
      final response = await _repo.getTreatments(
        search: state.searchQuery.isEmpty ? null : state.searchQuery,
        categoryId: state.categoryId,
        areaId: state.areaId,
        page: 1,
        limit: 10,
        isSimulator: state.isSimulator,
      );

      final hasMore = (response.page ?? 1) < (response.totalPages ?? 1);
      state = state.copyWith(
        isLoading: false,
        treatmentsLoading: false,
        treatments: response.data ?? [],
        currentPage: response.page ?? 1,
        totalPages: response.totalPages ?? 1,
        hasMoreData: hasMore,
      );
    });
  }

  Future<void> loadMoreTreatments() async {
    if (state.isLoadingMore || !state.hasMoreData) return;

    state = state.copyWith(isLoadingMore: true);

    await runSafely(() async {
      final nextPage = state.currentPage + 1;
      final response = await _repo.getTreatments(
        search: state.searchQuery.isEmpty ? null : state.searchQuery,
        categoryId: state.categoryId,
        areaId: state.areaId,
        page: nextPage,
        limit: 10,
        isSimulator: state.isSimulator,
      );

      final hasMore = (response.page ?? nextPage) < (response.totalPages ?? 1);
      final List<TreatmentData> updatedTreatments = [
        ...state.treatments,
        ...(response.data ?? []),
      ];

      state = state.copyWith(
        isLoadingMore: false,
        treatments: updatedTreatments,
        currentPage: response.page ?? nextPage,
        totalPages: response.totalPages ?? 1,
        hasMoreData: hasMore,
      );
    });
  }

Future<void> loadArTreatments({
    int? categoryId,
    int? areaId,
    bool clearSearch = false,
    bool? isSimulator,
  }) async {
    state = state.copyWith(
      isArLoading: true,
      isArLoadingMore: true,
      errorMessage: null,
      arCurrentPage: 1,
      categoryId: categoryId,
      clearCategoryId: categoryId == null,
      arAreaId: areaId,
      clearArAreaId: areaId == null,
      isSimulator: isSimulator,
      clearIsSimulator: isSimulator == null,
      arSearchQuery: clearSearch ? "" : state.arSearchQuery,
      arTreatments: [],
    );

    await runSafely(() async {
      final response = await _repo.getTreatments(
        search: state.arSearchQuery.isEmpty ? null : state.arSearchQuery,
        categoryId: state.categoryId,
        areaId: state.arAreaId,
        page: 1,
        limit: 10,
        isSimulator: state.isSimulator,
      );

      final hasMore = (response.page ?? 1) < (response.totalPages ?? 1);
      state = state.copyWith(
        isArLoading: false,
        isArLoadingMore: false,
        arTreatments: response.data ?? [],
        arCurrentPage: response.page ?? 1,
        arTotalPages: response.totalPages ?? 1,
        hasMoreArData: hasMore,
      );
    });
  }

  Future<void> loadMoreArTreatments() async {
    if (state.isArLoadingMore || !state.hasMoreArData) return;

    state = state.copyWith(isArLoadingMore: true);

    await runSafely(() async {
      final nextPage = state.arCurrentPage + 1;
      final response = await _repo.getTreatments(
        search: state.arSearchQuery.isEmpty ? null : state.arSearchQuery,
        categoryId: state.categoryId,
        areaId: state.arAreaId,
        page: nextPage,
        limit: 10,
        isSimulator: state.isSimulator,
      );

      final hasMore = (response.page ?? nextPage) < (response.totalPages ?? 1);
      final List<TreatmentData> updatedTreatments = [
        ...state.arTreatments,
        ...(response.data ?? []),
      ];

      state = state.copyWith(
        isArLoadingMore: false,
        arTreatments: updatedTreatments,
        arCurrentPage: response.page ?? nextPage,
        arTotalPages: response.totalPages ?? 1,
        hasMoreArData: hasMore,
      );
    });
  }


  Future<void> refreshTreatments() async {
    await loadTreatments(
      categoryId: state.categoryId,
      areaId: state.areaId,
      isSimulator: state.isSimulator,
    );
  }

  void searchTreatments(String query) {
    state = state.copyWith(searchQuery: query);
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      loadTreatments(
        categoryId: state.categoryId,
        areaId: state.areaId,
        isSimulator: state.isSimulator,
      );
    });
  }

  Future<bool?> getTreatments({bool? isSimulator}) async {
    await loadTreatments(
      categoryId: state.categoryId,
      areaId: state.areaId,
      isSimulator: isSimulator,
    );
    return !state.isLoading;
  }

  Future<void> fetchingTreatmentLogic({
    required String flow,
    int? categoryId,
    int? areaId,
    bool? isSimulator,
    bool isArList = false,
  }) async {
    int? targetCategoryId;
    int? targetAreaId;
    bool? targetIsSimulator;

    switch (flow) {
      case 'allTreatments':
        targetCategoryId = null;
        targetAreaId = null;
        targetIsSimulator = null;
        break;

      case 'byCategory':
        targetCategoryId = categoryId;
        targetAreaId = null;
        targetIsSimulator = null;
        break;

      case 'scanYourFace':
        targetCategoryId = state.categoryId;
        targetAreaId = null;
        targetIsSimulator = isSimulator ?? true;
        break;

      default:
        targetCategoryId = categoryId;
        targetAreaId = areaId;
        targetIsSimulator = isSimulator;
        break;
    }

    if (isArList) {
      await loadArTreatments(
        categoryId: targetCategoryId,
        areaId: targetAreaId,
        isSimulator: targetIsSimulator,
        clearSearch: true,
      );
    } else {
      await loadTreatments(
        categoryId: targetCategoryId,
        areaId: targetAreaId,
        isSimulator: targetIsSimulator,
        clearSearch: true,
      );
    }
  }

  Future<MaterialsResponse?> getMaterials({
    required String treatmentSku,
    required String areaSku,
  }) async {
    final response = await runSafely(() async {
      state = state.copyWith(materialsLoading: true);
      final res = await _repo.getMaterials(
        treatmentSku: treatmentSku,
        areaSku: areaSku,
      );
      state = state.copyWith(
        materialsLoading: false,
        materials: res.data ?? [],
      );
      return res;
    });
    if (response == null) {
      state = state.copyWith(materialsLoading: false);
    }
    return response;
  }

  XFile? get _imageForPredict => state.capturedImage;

  String _parseOutputImageBase64(Map<String, dynamic> jsonRes) {
    final outputImage = jsonRes['output_image'];
    if (outputImage == null) {
      throw Exception(
        'No image data received from server: output_image is null',
      );
    }
    final String raw = outputImage is String
        ? outputImage
        : outputImage.toString();
    if (raw.trim().isEmpty) {
      throw Exception(
        'No image data received from server: output_image is empty',
      );
    }
    return raw;
  }

  Future<void> callPredictAPI() async {
    if (state.capturedImage == null) {
      const msg =
          'No captured image available. Please capture your face first.';
      state = state.copyWith(loading: false, errorMessage: msg);
      EasyLoading.showError(msg);
      return;
    }

    final wasBefore = state.isBefore;
    state = state.copyWith(loading: true, errorMessage: null);
    EasyLoading.show(status: 'Processing image...');

    try {
      final jsonRes = await _uploadCapturedImage(image: _imageForPredict!);
      if (jsonRes == null) throw Exception('Failed to upload image');

      final base64 = _parseOutputImageBase64(jsonRes);
      final ximage = await base64ToXFile(
        base64,
        fileName: 'ai_image_${DateTime.now().millisecondsSinceEpoch}.jpg',
      );

      setAiImage(ximage);
      if (wasBefore) toggleIsBefore();

      state = state.copyWith(
        loading: false,
        errorMessage: null,
        isAiImageGenerated: true,
      );
      EasyLoading.dismiss();
      EasyLoading.showSuccess('Image processed successfully!');
    } catch (e) {
      final errorMsg = e.toString().replaceFirst('Exception: ', '');
      state = state.copyWith(loading: false, errorMessage: errorMsg);
      EasyLoading.dismiss();
      EasyLoading.showError(errorMsg);
    }
  }

  Future<http.MultipartFile> _imageMultipartFile(XFile image) async {
    if (image.path.isNotEmpty) {
      try {
        return await http.MultipartFile.fromPath('image', image.path);
      } catch (_) {}
    }
    final bytes = await image.readAsBytes();
    return http.MultipartFile.fromBytes('image', bytes, filename: 'image.jpg');
  }

  Future<Map<String, dynamic>?> _uploadCapturedImage({
    required XFile image,
  }) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('http://18.116.65.70/api/'),
    );

    final selectedTreatmentsAndAreas = ref.read(checkoutViewModel).selectedTreatmentsAndAreas;

    final treatmentAreasJson = selectedTreatmentsAndAreas.map((item) {
      return {
        'treatment_sku': item.treatment.globalSku ?? '',
        'areas': item.selectedAreas.map((areaItem) {
          final int materialQty = areaItem.materials.isNotEmpty
              ? areaItem.materials.first.selectedQuantity
              : 0;
          return {
            'areas_sku': areaItem.target.globalSku ?? '',
            'material_quantity': materialQty,
          };
        }).toList(),
      };
    }).toList();

    final treatmentSku = selectedTreatmentsAndAreas.isNotEmpty
        ? selectedTreatmentsAndAreas.first.treatment.globalSku
        : (state.selectedTreatment?.globalSku ?? '');

    request.fields.addAll({
      'treatment_sku': treatmentSku ?? '',
      'treatments': jsonEncode(treatmentAreasJson),
    });
    request.files.add(await _imageMultipartFile(image));

    final encoded = jsonEncode(treatmentAreasJson);



    print("--- Multipart Request Debug ---");
    print(encoded);
    print("URL: ${request.url}");
    print("Fields: ${request.fields}");
    print("Files: ${request.files.map((f) => '${f.field}: ${f.filename} (${f.length} bytes)').toList()}");
    print("--------------------------------");

    final response = await request.send();
    final body = await response.stream.bytesToString();

    if (response.statusCode != 200) {
      final data = jsonDecode(body) as Map<String, dynamic>?;
      final msg =
          data?['message'] as String? ??
          response.reasonPhrase ??
          'Upload failed';
      throw Exception(msg);
    }
    return jsonDecode(body) as Map<String, dynamic>;
  }



  Future<void> saveAiImage() async {
    return await runSafely(() async {
      EasyLoading.show(status: 'Please wait...');

      final selectedTreatmentsAndAreas = ref.read(checkoutViewModel).selectedTreatmentsAndAreas;
      if (selectedTreatmentsAndAreas.isEmpty) {
        EasyLoading.showError('No treatment selected');
        return;
      }

      final firstTreatment = selectedTreatmentsAndAreas.first;
      final treatmentId = firstTreatment.treatment.id;
      if (treatmentId == null) {
        EasyLoading.showError('No treatment selected');
        return;
      }

      if (firstTreatment.selectedAreas.isEmpty) {
        EasyLoading.showError('No treatment area selected');
        return;
      }

      final areaId = firstTreatment.selectedAreas.first.target.areaId ?? firstTreatment.selectedAreas.first.target.id;
      if (areaId == null) {
        EasyLoading.showError('No treatment area selected');
        return;
      }

      final beforeImage = state.capturedImage?.path;
      final afterImage = state.aiImage?.path;

      final subSections = firstTreatment.selectedAreas.map((selectedArea) {
        final subArea = selectedArea.target;
        return SubSectionRequest(
          areaId: subArea.areaId ?? subArea.id!,
          sectionId: subArea.id!,
          syringesQuantity: 0,
        );
      }).toList();
      if (beforeImage == null || afterImage == null) {
        EasyLoading.showError('Both images need to be selected!');
        return;
      }
      final mediaService = MediaService();
      final userId = ref.read(authViewModel).authData!.user!.id!;
      final beforeUrl = await mediaService.uploadImage(
        '$userId/appointments/before/',
        XFile(beforeImage),
      );
      if (beforeUrl == null) {
        EasyLoading.showError('Failed to upload before image');
        return;
      }
      final afterUrl = await mediaService.uploadImage(
        '$userId/appointments/after/',
        XFile(afterImage),
      );
      if (afterUrl == null) {
        EasyLoading.showError('Failed to upload after image');
        return;
      }
      final request = SaveHistoryRequest(
        treatmentId: treatmentId,
        beforeImage: beforeUrl,
        afterImage: afterUrl,
        subSections: subSections,
      );
      await _repo.saveAiHistory(request);
      EasyLoading.showSuccess('Image saved!');
    });
  }

  @override
  void onError(String message) {
    state = state.copyWith(
      treatmentsLoading: false,
    
    );
    super.onError(message);
    EasyLoading.showError(message);
  }
}

@immutable
class TreatmentsState extends BaseStateModel {
  final List<TreatmentData> treatments;
  final List<TreatmentData> arTreatments;
  final bool treatmentsLoading;

  final TreatmentData? selectedTreatment;
  final TreatmentAreaModel? selectTreatmentArea;
  final List<TreatmentAreaModel> selectedSubAreasList;
  final List<TreatmentAreaModel> areaNavigationStack;

  final bool isBefore;
  final XFile? capturedImage;
  final XFile? aiImage;
  final bool isAiImageGenerated;

  // New fields for Treatment Listing API migration
  final bool isLoading;
  final bool isLoadingMore;
  final bool hasMoreData;
  final int currentPage;
  final int totalPages;
  final String searchQuery;
  final int? categoryId;
  final int? areaId;
  final bool? isSimulator;
  final bool isArLoading;
  final bool isArLoadingMore;
  final bool hasMoreArData;
  final int arCurrentPage;
  final int arTotalPages;
  final String arSearchQuery;
  final int? arAreaId;

  // New fields for Materials API
  final List<MaterialData> materials;
  final bool materialsLoading;

  const TreatmentsState({
    super.loading = false,
    super.errorMessage,
    this.treatments = const [],
    this.arTreatments = const [],
    this.treatmentsLoading = false,
    this.selectedTreatment,
    this.selectTreatmentArea,
    this.materials = const [],
    this.materialsLoading = false,
    this.selectedSubAreasList = const [],
    this.areaNavigationStack = const [],
    this.isBefore = false,
    this.capturedImage,
    this.aiImage,
    this.isAiImageGenerated = false,
    this.isLoading = false,
    this.isLoadingMore = false,
    this.hasMoreData = false,
    this.currentPage = 1,
    this.totalPages = 1,
    this.searchQuery = "",
    this.categoryId,
    this.areaId,
    this.isSimulator,
    this.isArLoading = false,
    this.isArLoadingMore = false,
    this.hasMoreArData = false,
    this.arCurrentPage = 1,
    this.arTotalPages = 1,
    this.arSearchQuery = "",
    this.arAreaId,
  });

  @override
  TreatmentsState copyWith({
    bool? loading,
    String? errorMessage,
    List<TreatmentData>? treatments,
   List<TreatmentData>? arTreatments,
    bool? treatmentsLoading,
    TreatmentData? selectedTreatment,
    TreatmentAreaModel? selectedTreatmentArea,
    TreatmentAreaModel? selectedTreatmentSubArea,
    List<TreatmentAreaModel>? selectedSubAreasList,
    List<TreatmentAreaModel>? areaNavigationStack,
    bool? isBefore,
    XFile? capturedImage,
    XFile? aiImage,
    bool clearSelectSectionId = false,
    bool clearSubSectionId = false,
    bool clearSubSectionIds = false,
    bool clearAiImage = false,
    bool? isAiImageGenerated,
    bool? isLoading,
    bool? isLoadingMore,
    bool? hasMoreData,
    int? currentPage,
    int? totalPages,
    String? searchQuery,
    int? categoryId,
    int? areaId,
    bool clearCategoryId = false,
    bool clearAreaId = false,
    bool? isSimulator,
    bool clearIsSimulator = false,
    bool? isArLoading,
    bool? isArLoadingMore,
    bool? hasMoreArData,
    int? arCurrentPage,
    int? arTotalPages,
    String? arSearchQuery,
    int? arAreaId,
    bool clearArAreaId = false,
    List<MaterialData>? materials,
    bool? materialsLoading,
  }) {
    return TreatmentsState(
      loading: loading ?? this.loading,
      errorMessage: errorMessage ?? this.errorMessage,
      treatments: treatments ?? this.treatments,
      arTreatments: arTreatments?? this.arTreatments,
      treatmentsLoading: treatmentsLoading ?? this.treatmentsLoading,
      selectedTreatment: selectedTreatment ?? this.selectedTreatment,
      selectTreatmentArea: clearSelectSectionId
          ? null
          : (selectedTreatmentArea ?? selectTreatmentArea),
      selectedSubAreasList: clearSubSectionIds
          ? const []
          : (selectedSubAreasList ?? this.selectedSubAreasList),
      areaNavigationStack: areaNavigationStack ?? this.areaNavigationStack,
      isBefore: isBefore ?? this.isBefore,
      capturedImage: capturedImage ?? this.capturedImage,
      aiImage: clearAiImage ? null : (aiImage ?? this.aiImage),
      isAiImageGenerated: isAiImageGenerated ?? this.isAiImageGenerated,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMoreData: hasMoreData ?? this.hasMoreData,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      searchQuery: searchQuery ?? this.searchQuery,
      categoryId: clearCategoryId ? null : (categoryId ?? this.categoryId),
      areaId: clearAreaId ? null : (areaId ?? this.areaId),
      isSimulator: clearIsSimulator ? null : (isSimulator ?? this.isSimulator),
         isArLoading: isArLoading ?? this.isArLoading,
      isArLoadingMore: isArLoadingMore ?? this.isArLoadingMore,
      hasMoreArData: hasMoreArData ?? this.hasMoreArData,
      arCurrentPage: arCurrentPage ?? this.arCurrentPage,
      arTotalPages: arTotalPages ?? this.arTotalPages,
      arSearchQuery: arSearchQuery ?? this.arSearchQuery,
      arAreaId: clearArAreaId ? null : (arAreaId ?? this.arAreaId),
      materials: materials ?? this.materials,
      materialsLoading: materialsLoading ?? this.materialsLoading,
    );
  }
}
