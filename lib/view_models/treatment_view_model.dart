import 'dart:async';
import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
import '../utills/simulation_generator.dart';
import '../utills/simulation_utils.dart';
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

  Future<void> initializeSimulation(SimulationData? simulation) async {
    if (simulation == null) return;

    state = state.copyWith(isAiImageGenerated: false);
    clearAiImage();

    final checkoutNotifier = ref.read(checkoutViewModel.notifier);
    checkoutNotifier.clearSelectedTreatments();

    if (state.treatments.isEmpty) {
      await loadTreatments();
    }

    final simTreatments = simulation.treatments;
    if (simTreatments != null) {
      for (final simTreatment in simTreatments) {
        final treatment = state.treatments.firstWhereOrNull(
          (t) => t.id == simTreatment.id,
        );

        if (treatment != null) {
          // Add treatment to selection list
          checkoutNotifier.addSelectedTreatment(treatment);

          // Fetch areas for this treatment
          await ref
              .read(treatmentAreaProvider.notifier)
              .fetchAreasByTreatment(treatment.id!);

          final treatmentAreas = ref.read(treatmentAreaProvider).areas;

          if (simTreatment.areas != null) {
            for (final simArea in simTreatment.areas!) {
              // Find the Area model from fetched areas
              final areaId = int.tryParse(simArea.id ?? '');
              TreatmentAreaModel? targetArea;

              // Helper to find area in tree
              TreatmentAreaModel? findArea(List<TreatmentAreaModel> list) {
                for (final a in list) {
                  if (a.id == areaId) return a;
                  if (a.subAreas != null) {
                    final found = findArea(a.subAreas!);
                    if (found != null) return found;
                  }
                }
                return null;
              }

              targetArea = findArea(treatmentAreas);

              if (targetArea != null) {
                // Add area to selection
                checkoutNotifier.addSelectedArea(targetArea);

                // Restore material if any
                final simMaterial = simArea.materials?.firstOrNull;
                if (simMaterial != null) {
                  checkoutNotifier.saveMaterialForArea(
                    treatment: treatment,
                    area: targetArea,
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
          }
        }
      }
    }

    EasyLoading.show(status: 'Fetching AI Images...');
    log('INITIALIZING SIMULATION');
    try {
      final service = MediaService();
      final frontImageBefore = await service.downloadSimulationImage(
        imageUrl: simulation.frontImageBefore,
        pose: 'front-before',
        simId: simulation.id,
      );
      final frontImageAfter = await service.downloadSimulationImage(
        imageUrl: simulation.frontImageAfter,
        pose: 'front-after',
        simId: simulation.id,
      );
      final rightImageBefore = await service.downloadSimulationImage(
        imageUrl: simulation.rightImageBefore,
        pose: 'right-before',
        simId: simulation.id,
      );
      final rightImageAfter = await service.downloadSimulationImage(
        imageUrl: simulation.rightImageAfter,
        pose: 'right-after',
        simId: simulation.id,
      );
      final leftImageBefore = await service.downloadSimulationImage(
        imageUrl: simulation.leftImageBefore,
        pose: 'left-before',
        simId: simulation.id,
      );
      final leftImageAfter = await service.downloadSimulationImage(
        imageUrl: simulation.leftImageAfter,
        pose: 'left-after',
        simId: simulation.id,
      );
      state = state.copyWith(
        loading: false,
        isAiImageGenerated: true,
        isBefore: false,
        frontPoseImage: frontImageBefore,
        frontAiImage: frontImageAfter,
        rightPoseImage: rightImageBefore,
        rightAiImage: rightImageAfter,
        leftPoseImage: leftImageBefore,
        leftAiImage: leftImageAfter,
      );
    } catch (e) {
      log('Error downloading simulation images: $e');
    } finally {
      EasyLoading.dismiss();
    }
  }

  void removeSubArea(int id) {
    state = state.copyWith(isAiImageGenerated: false);
  }

  void toggleIsBefore() => state = state.copyWith(isBefore: !state.isBefore);

  void setCapturedImage(XFile? image, {String pose = 'front'}) {
    if (pose == 'left') {
      state = state.copyWith(leftPoseImage: image);
    } else if (pose == 'right') {
      state = state.copyWith(rightPoseImage: image);
    } else {
      state = state.copyWith(frontPoseImage: image, capturedImage: image);
    }
  }

  void clearAiImage() {
    state = state.copyWith(
      clearAiImage: true,
      isAiImageGenerated: false,
      frontAiImage: null,
      leftAiImage: null,
      rightAiImage: null,
    );
  }

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

  void clearAllSelectedTreatments({bool capturedImage = false}) {
    state = TreatmentsState(
      loading: state.loading,
      errorMessage: state.errorMessage,
      treatments: state.treatments,
      areaNavigationStack: const [],
      isBefore: true,
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
      state = state.copyWith(materialsLoading: false, material: res.data);
      return res;
    });
    if (response == null) {
      state = state.copyWith(materialsLoading: false);
    }
    return response;
  }

  Future<void> callPredictAPI() async {
    if (state.capturedImagesNull) {
      const msg =
          'No captured image available. Please capture your face first.';
      state = state.copyWith(loading: false, errorMessage: msg);
      EasyLoading.showError(msg);
      return;
    }

    final wasBefore = state.isBefore;
    state = state.copyWith(loading: true, errorMessage: null);
    EasyLoading.show(status: 'Processing images with AI...');

    try {
      final results = await SimulationGenerator().generateAllSimulations(
        front: state.frontPoseImage,
        left: state.leftPoseImage,
        right: state.rightPoseImage,
        ref: ref,
      );

      XFile? imageFront;
      XFile? imageRight;
      XFile? imageLeft;

      final timestamp = DateTime.now().millisecondsSinceEpoch;

      if (results.images.containsKey('front')) {
        imageFront = await bytesToXFile(
          results.images['front']!,
          'ai_front_$timestamp.jpg',
        );
      }
      if (results.images.containsKey('right')) {
        imageRight = await bytesToXFile(
          results.images['right']!,
          'ai_right_$timestamp.jpg',
        );
      }
      if (results.images.containsKey('left')) {
        imageLeft = await bytesToXFile(
          results.images['left']!,
          'ai_left_$timestamp.jpg',
        );
      }

      if (imageFront == null && imageRight == null && imageLeft == null) {
        String errorMsg = results.errors.join('\n');
        if (errorMsg.isEmpty)
          errorMsg = 'AI failed to generate valid images. Please try again.';
        log('SIMULATION FAILED: $errorMsg');
        throw Exception(errorMsg);
      }

      if (wasBefore) toggleIsBefore();

      state = state.copyWith(
        loading: false,
        errorMessage: null,
        isAiImageGenerated: true,
        frontAiImage: imageFront,
        rightAiImage: imageRight,
        leftAiImage: imageLeft,
      );
      EasyLoading.dismiss();

      String successMsg = 'Simulations generated successfully!';
      if (results.errors.isNotEmpty) {
        successMsg += '\nNote: Some poses failed to generate.';
        log('SIMULATION PARTIAL SUCCESS. Errors: ${results.errors.join(', ')}');
      } else {
        log('SIMULATION FULL SUCCESS');
      }
      EasyLoading.showSuccess(successMsg);
    } catch (e, s) {
      final errorMsg = e.toString().replaceFirst('Exception: ', '');
      log('SIMULATION ERROR: $errorMsg', stackTrace: s);
      state = state.copyWith(loading: false, errorMessage: errorMsg);
      EasyLoading.dismiss();
      EasyLoading.showError(errorMsg);
    }
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

      if (state.frontPoseImage != null) {
        if (state.frontAiImage == null) {
          throw Exception('No AI image captured for front Pose!');
        }
      }
      if (state.rightPoseImage != null) {
        if (state.rightAiImage == null) {
          throw Exception('No AI image captured for right Pose!');
        }
      }
      if (state.leftPoseImage != null) {
        if (state.leftAiImage == null) {
          throw Exception('No AI image captured for left Pose!');
        }
      }

      final userId = ref.read(authViewModel).authData!.user!.id!;

      final uploadResults = await uploadSimulationImages(
        userId: userId,
        images: SimulationImages(
          frontBefore: state.frontPoseImage,
          frontAfter: state.frontAiImage,
          rightBefore: state.rightPoseImage,
          rightAfter: state.rightAiImage,
          leftBefore: state.leftPoseImage,
          leftAfter: state.leftAiImage,
        ),
      );

      final historyTreatments = selectedTreatmentsAndAreas.map((item) {
        return HistoryTreatmentRequest(
          treatmentId: item.treatment.id ?? 0,
          treatmentName: item.treatment.name ?? '',
          areas: item.selectedAreas.map((areaItem) {
            final area = areaItem.target;
            final List<HistoryMaterialRequest> historyMaterials = [];
            if (areaItem.material != null) {
              historyMaterials.add(
                HistoryMaterialRequest(
                  id: areaItem.material!.id,
                  name: areaItem.material!.name,
                  selectedQuantity: areaItem.material!.selectedQuantity,
                ),
              );
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
        frontImageBefore: uploadResults.frontBefore,
        frontImageAfter: uploadResults.frontAfter,
        rightImageBefore: uploadResults.rightBefore,
        rightImageAfter: uploadResults.rightAfter,
        leftImageBefore: uploadResults.leftBefore,
        leftImageAfter: uploadResults.leftAfter,
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
  final XFile? frontPoseImage;
  final XFile? leftPoseImage;
  final XFile? rightPoseImage;

  final XFile? frontAiImage;
  final XFile? leftAiImage;
  final XFile? rightAiImage;

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
    this.frontPoseImage,
    this.leftPoseImage,
    this.rightPoseImage,
    this.frontAiImage,
    this.leftAiImage,
    this.rightAiImage,
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
    XFile? frontPoseImage,
    XFile? leftPoseImage,
    XFile? rightPoseImage,
    XFile? frontAiImage,
    XFile? leftAiImage,
    XFile? rightAiImage,
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
      frontPoseImage: frontPoseImage ?? this.frontPoseImage,
      leftPoseImage: leftPoseImage ?? this.leftPoseImage,
      rightPoseImage: rightPoseImage ?? this.rightPoseImage,
      frontAiImage: clearAiImage ? null : (frontAiImage ?? this.frontAiImage),
      leftAiImage: clearAiImage ? null : (leftAiImage ?? this.leftAiImage),
      rightAiImage: clearAiImage ? null : (rightAiImage ?? this.rightAiImage),
      isAiImageGenerated: isAiImageGenerated ?? this.isAiImageGenerated,
      material: material ?? this.material,
      materialsLoading: materialsLoading ?? this.materialsLoading,
    );
  }

  bool get aiImagesNull {
    return frontAiImage == null && leftAiImage == null && rightAiImage == null;
  }

  bool get capturedImagesNull {
    return frontPoseImage == null &&
        leftPoseImage == null &&
        rightPoseImage == null;
  }
}
