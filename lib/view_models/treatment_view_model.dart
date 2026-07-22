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
import '../models/selected_treatment_and_areas_model.dart';
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

    final firstSimTreatment = simulation.treatments?.firstOrNull;
    if (firstSimTreatment == null) return;

    final treatment = state.treatments.firstWhereOrNull(
      (treatment) => treatment.id == firstSimTreatment.id,
    );

    if (treatment != null) {
      await onTapTreatment(treatmentModel: treatment, isCallPredictAPI: false);
      await ref
          .read(treatmentAreaProvider.notifier)
          .fetchAreasByTreatment(treatment.id ?? 0);
    }

    final rootAreas = ref.read(treatmentAreaProvider).areas;
    // Find a root area that contains one of the simulated areas
    final rootArea = rootAreas.firstWhereOrNull((area) {
      return firstSimTreatment.areas?.any((simArea) {
            // Check if simArea is this root area or a child of it
            final simAreaId = int.tryParse(simArea.id ?? '');
            if (area.id == simAreaId) return true;
            return area.subAreas?.any((sub) => sub.id == simAreaId) ?? false;
          }) ??
          false;
    });

    if (rootArea != null) {
      onTapTreatmentArea(rootArea);
    }

    final subAreas = ref.read(checkoutViewModel).selectedAreas?.subAreas ?? [];
    for (final subArea in subAreas) {
      final selectedSimArea = firstSimTreatment.areas?.firstWhereOrNull(
        (simArea) => int.tryParse(simArea.id ?? '') == subArea.id,
      );
      if (selectedSimArea != null) {
        ref
            .read(checkoutViewModel.notifier)
            .onTapTreatmentSubArea(subArea: subArea);

        // Restore material if any
        final simMaterial = selectedSimArea.materials?.firstOrNull;
        if (simMaterial != null && treatment != null) {
          ref.read(checkoutViewModel.notifier).saveMaterialForArea(
                treatment: treatment,
                area: subArea,
                material: SelectedMaterialModel(
                  id: simMaterial.id ?? 0,
                  name: simMaterial.name ?? '',
                  selectedQuantity: simMaterial.selectedQuantity ?? 0,
                  minQty: 0,
                  maxQty: 0,
                ),
              );
        }
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

  void clearAiImage() =>
      state = state.copyWith(clearAiImage: true, isAiImageGenerated: false);

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
      material: state.material,
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
        material: res.data,
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
          final int materialQty = areaItem.material?.selectedQuantity ?? 0;
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

      final selectedTreatmentsAndAreas =
          ref.read(checkoutViewModel).selectedTreatmentsAndAreas;
      if (selectedTreatmentsAndAreas.isEmpty) {
        EasyLoading.showError('No treatment selected');
        return;
      }

      final beforeImage = state.capturedImage?.path;
      final afterImage = state.aiImage?.path;

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

      final historyTreatments = selectedTreatmentsAndAreas.map((item) {
        return HistoryTreatmentRequest(
          treatmentId: item.treatment.id ?? 0,
          treatmentName: item.treatment.name ?? '',
          areas: item.selectedAreas.map((areaItem) {
            final area = areaItem.target;
            final List<HistoryMaterialRequest> historyMaterials = [];
            if (areaItem.material != null) {
              historyMaterials.add(HistoryMaterialRequest(
                id: areaItem.material!.id,
                name: areaItem.material!.name,
                selectedQuantity: areaItem.material!.selectedQuantity,
              ));
            }
            return HistoryAreaRequest(
              areaId: (area.id ?? area.areaId ?? 0),
              areaName: area.name ?? '',
              materials: historyMaterials,
            );
          }).toList(),
        );
      }).toList();

      final request = SaveHistoryRequest(
        beforeImage: beforeUrl,
        afterImage: afterUrl,
        treatments: historyTreatments,
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
  final MaterialData? material;
  final bool materialsLoading;

  const TreatmentsState({
    super.loading = false,
    super.errorMessage,
    this.treatments = const [],
    this.material,
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
    MaterialData? material,
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
      material: material ?? this.material,
      materialsLoading: materialsLoading ?? this.materialsLoading,
    );
  }
}
