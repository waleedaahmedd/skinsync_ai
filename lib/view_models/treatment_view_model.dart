import 'dart:async';
import 'dart:convert';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../models/base_state_model.dart';
import '../models/requests/save_history_request.dart';
import '../models/responses/materials_response.dart';
import '../models/responses/simulation_history_response.dart';
import '../models/responses/treatment_area_list_response.dart';
import '../models/responses/treatment_list_response.dart';
import '../repositories/treatment_repository.dart';
import '../services/api_base_helper.dart';
import '../services/media_service.dart';
import '../services/treatment_services.dart';
import '../utills/image_utills.dart';
import '../utills/list_utils.dart';
import 'auth_view_model.dart';
import 'base_view_model.dart';
import 'checkout_view_model.dart';
import 'treatment_area_view_model.dart';

final treatmentViewModel = NotifierProvider(
  () =>
      TreatmentViewModel._(repo: TreatmentService(apiClient: ApiBaseHelper())),
);

class TreatmentViewModel extends BaseViewModel<TreatmentsState> {
  TreatmentViewModel._({required this._repo})
    : super(initialState: const TreatmentsState());

  final TreatmentRepository _repo;

  Future<void> initializeSimulation(SimulationData simulation) async {
    state = state.copyWith(isAiImageGenerated: false);
    clearAiImage();
    if (state.treatments.isEmpty) {
      await loadTreatments();
    }
    final treatment = state.treatments.firstWhereOrNull(
      (treatment) => treatment.id == simulation.treatmentId,
    );
    if (treatment != null) {
      await onTapTreatment(treatmentModel: treatment, isCallPredictAPI: true);
      await ref
          .read(treatmentAreaProvider.notifier)
          .fetchAreasByTreatment(treatment.id ?? 0);
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
    final subAreas = ref.read(checkoutViewModel).selectedAreas?.subAreas ?? [];
    for (final subArea in subAreas) {
      final selectedSubArea = simulation.subsections?.firstWhereOrNull(
        (subSection) => subSection.sectionId == subArea.id,
      );
      if (selectedSubArea != null) {
        ref
            .read(checkoutViewModel.notifier)
            .onTapTreatmentSubArea(subArea: subArea);
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

  void removeSubArea(int id) {
    state = state.copyWith(isAiImageGenerated: false);
  }

  void toggleIsBefore() => state = state.copyWith(isBefore: !state.isBefore);

  void setCapturedImage(XFile? image) =>
      state = state.copyWith(capturedImage: image);

  void setAiImage(XFile? image) => state = state.copyWith(aiImage: image);

  void clearAiImage() => state = state.copyWith(clearAiImage: true);

  Future<void> onTapTreatment({
    required TreatmentData treatmentModel,
    required bool isCallPredictAPI,
  }) async {
    state = state.copyWith(areaNavigationStack: const []);
    clearAiImage();
    ref.read(checkoutViewModel.notifier).setSelectedTreatments(treatmentModel);
    ref.read(checkoutViewModel.notifier).clearAreaSelection();
    state = state.copyWith(isBefore: true);
  }

  void onTapTreatmentArea(TreatmentAreaModel treatmentArea) {
    final updatedStack = [...state.areaNavigationStack, treatmentArea];
    ref.read(checkoutViewModel.notifier).setSelectedAreas(treatmentArea);
    state = state.copyWith(areaNavigationStack: updatedStack);
  }

  void popAreaNavigationStack() {
    if (state.areaNavigationStack.isNotEmpty) {
      final updatedStack = List<TreatmentAreaModel>.from(
        state.areaNavigationStack,
      )..removeLast();
      final previousArea = updatedStack.isNotEmpty ? updatedStack.last : null;
      ref.read(checkoutViewModel.notifier).setSelectedAreas(previousArea);
      state = state.copyWith(areaNavigationStack: updatedStack);
    }
  }

  void resetAreaNavigationStack() {
    ref.read(checkoutViewModel.notifier).clearAreaSelection();
    state = state.copyWith(areaNavigationStack: const []);
  }

  void clearAllSelectedTreatments() {
    state = TreatmentsState(
      loading: state.loading,
      errorMessage: state.errorMessage,
      treatments: state.treatments,
      areaNavigationStack: const [],
      isBefore: true,
      capturedImage: state.capturedImage,
      aiImage: null,
      isAiImageGenerated: false,
      materials: state.materials,
      materialsLoading: state.materialsLoading,
    );
  }

  Future<List<TreatmentData>?> loadTreatments({
    int page = 1,
    int? categoryId,
    int? areaId,
    String? search,
    bool? isSimulator,
  }) async {
    return await runSafely(() async {
      state = state.copyWith(loading: true, errorMessage: null, treatments: []);
      final response = await _repo.getTreatments(
        search: search,
        categoryId: categoryId,
        areaId: areaId,
        page: page,
        limit: 10,
        isSimulator: isSimulator,
      );
      state = state.copyWith(loading: false, treatments: response.data ?? []);
      return response.data ?? [];
    });
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

    final checkoutState = ref.read(checkoutViewModel);
    final selectedTreatmentsAndAreas = checkoutState.selectedTreatmentsAndAreas;

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
        : (checkoutState.selectedTreatments?.globalSku ?? '');

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
    print(
      "Files: ${request.files.map((f) => '${f.field}: ${f.filename} (${f.length} bytes)').toList()}",
    );
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

      final selectedTreatmentsAndAreas = ref
          .read(checkoutViewModel)
          .selectedTreatmentsAndAreas;
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

      final areaId =
          firstTreatment.selectedAreas.first.target.areaId ??
          firstTreatment.selectedAreas.first.target.id;
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
    state = state.copyWith(loading: false, materialsLoading: false);
    super.onError(message);
    EasyLoading.showError(message);
  }
}

@immutable
class TreatmentsState extends BaseStateModel {
  final List<TreatmentData> treatments;
  final List<TreatmentAreaModel> areaNavigationStack;
  final bool isBefore;
  final XFile? capturedImage;
  final XFile? aiImage;
  final bool isAiImageGenerated;
  final List<MaterialData> materials;
  final bool materialsLoading;

  const TreatmentsState({
    super.loading = false,
    super.errorMessage,
    this.treatments = const [],
    this.materials = const [],
    this.materialsLoading = false,
    this.areaNavigationStack = const [],
    this.isBefore = false,
    this.capturedImage,
    this.aiImage,
    this.isAiImageGenerated = false,
  });

  @override
  TreatmentsState copyWith({
    bool? loading,
    String? errorMessage,
    List<TreatmentData>? treatments,
    List<TreatmentAreaModel>? areaNavigationStack,
    bool? isBefore,
    XFile? capturedImage,
    XFile? aiImage,
    bool clearAiImage = false,
    bool? isAiImageGenerated,
    List<MaterialData>? materials,
    bool? materialsLoading,
  }) {
    return TreatmentsState(
      loading: loading ?? this.loading,
      errorMessage: errorMessage ?? this.errorMessage,
      treatments: treatments ?? this.treatments,
      areaNavigationStack: areaNavigationStack ?? this.areaNavigationStack,
      isBefore: isBefore ?? this.isBefore,
      capturedImage: capturedImage ?? this.capturedImage,
      aiImage: clearAiImage ? null : (aiImage ?? this.aiImage),
      isAiImageGenerated: isAiImageGenerated ?? this.isAiImageGenerated,
      materials: materials ?? this.materials,
      materialsLoading: materialsLoading ?? this.materialsLoading,
    );
  }
}
