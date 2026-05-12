import 'dart:convert';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:skinsync_ai/models/requests/save_history_request.dart';
import 'package:skinsync_ai/models/responses/treatment_area_response.dart';
import 'package:skinsync_ai/models/responses/treatment_sub_area_response.dart';
import 'package:skinsync_ai/services/api_base_helper.dart';

import '../models/base_state_model.dart';
import '../models/responses/treatment_response_model.dart';
import '../repositories/treatment_repository.dart';
import '../services/media_service.dart';
import '../services/treatment_services.dart';
import '../utills/image_utills.dart';
import 'auth_view_model.dart';
import 'base_view_model.dart';

final treatmentViewModel = NotifierProvider(
  () => TreatmentViewModel._(
    treatmentRepository: TreatmentService(apiClient: ApiBaseHelper()),
  ),
);

class TreatmentViewModel extends BaseViewModel<TreatmentsState> {
  TreatmentViewModel._({required TreatmentRepository treatmentRepository})
    : _repo = treatmentRepository,
      super(initialState: TreatmentsState());

  final TreatmentRepository _repo;

  void updateSyringeLevel({required TreatmentSubAreaModel subArea}) {
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

  Future<void> setCapturedImage(XFile image) async =>
      runSafely(() async => state = state.copyWith(capturedImage: image));

  void setAiImage(XFile image) => state = state.copyWith(aiImage: image);

  void clearAiImage() => state = state.copyWith(clearAiImage: true);

  void _clearAreaSelection() {
    state.treatmentAreaResponse?.data = null;
    state = state.copyWith(clearSelectSectionId: true);
  }

  void _clearSubSectionSelection() {
    state.treatmentsSubAreaResponse?.data = null;
    state = state.copyWith(clearSubSectionId: true);
  }

  Future<void> onTapTreatment({
    required TreatmentsModel treatmentModel,
    required bool isCallPredictAPI,
  }) async {
    state = state.copyWith(
      selectedTreatment: treatmentModel,
      clearSubSectionIds: true,
    );
    clearAiImage();
    if (state.treatmentAreaResponse != null) _clearAreaSelection();
    if (state.treatmentsSubAreaResponse != null) _clearSubSectionSelection();
    state = state.copyWith(isBefore: true);
    if (treatmentModel.isArea == true) {
      getSelectSectionApi(sectionId: treatmentModel.id ?? 0);
    } else if (isCallPredictAPI) {
      // callPredictAPI();
    }
  }

  void onTapTreatmentArea({
    required TreatmentAreaModel treatmentArea,
    required bool isCallPredictAPI,
  }) {
    state = state.copyWith(selectedTreatmentArea: treatmentArea);
    //if (state.treatmentsSubAreaResponse != null) _clearSubSectionSelection();
    if (treatmentArea.isSidearea == true) {
      final treatment = state.selectedTreatment;
      if (treatment != null) {
        getSubSectionApi(
          sectionId: treatment.id ?? 0,
          subSectionId: treatmentArea.id ?? 0,
        );
      }
    } else if (isCallPredictAPI) {
      _clearSubSectionSelection();
      // callPredictAPI();
    }
  }

  void onTapTreatmentSubArea({
    required TreatmentSubAreaModel treatmentSubArea,
  }) {
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
    //if (isCallPredictAPI) callPredictAPI();
  }

  void clearAllSelectedTreatments() {
    state = TreatmentsState(
      loading: state.loading,
      errorMessage: state.errorMessage,
      treatmentResponse: state.treatmentResponse,
      treatmentAreaResponse: null,
      treatmentsSubAreaResponse: null,
      treatmentsLoading: state.treatmentsLoading,
      treatmentAreaLoading: state.treatmentAreaLoading,
      treatmentSubAreaLoading: state.treatmentSubAreaLoading,
      selectedTreatment: null,
      selectTreatmentArea: null,
      selectedSubAreasList: const [],
      isBefore: true,
      capturedImage: state.capturedImage,
      aiImage: null,
      isAiImageGenerated: false,
    );
  }

  Future<bool?> getTreatments() async {
    state = state.copyWith(treatmentsLoading: true);
    return runSafely(() async {
      final response = await _repo.getTreatmentsApi();
      state = state.copyWith(
        treatmentsLoading: false,
        treatmentResponse: response,
      );
      return response.isSuccess == true;
    });
  }

  XFile? get _imageForPredict => //state.aiImage ??
      state.capturedImage;

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

    final subSectionData = state.selectedSubAreasList.map((e) {
      return {'sub_section_id': e.id, 'syringe': e.currentSyringe};
    }).toList();

    request.fields.addAll({
      'treatment_id': (state.selectedTreatment?.id ?? 0).toString(),
      'treatment_section_id': (state.selectTreatmentArea?.id ?? 0).toString(),
      'treatment_sub_section': jsonEncode(subSectionData),
    });
    request.files.add(await _imageMultipartFile(image));

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

  Future<bool?> getSelectSectionApi({required int sectionId}) async {
    state = state.copyWith(treatmentAreaLoading: true);
    return runSafely(() async {
      final response = await _repo.getSelectSectionApi(sectionId: sectionId);
      state = state.copyWith(
        treatmentAreaLoading: false,
        selectSelectionResponse: response,
      );
      return response.isSuccess == true;
    });
  }

  Future<bool?> getSubSectionApi({
    required int sectionId,
    required int subSectionId,
  }) async {
    state = state.copyWith(treatmentSubAreaLoading: true);
    return runSafely(() async {
      final response = await _repo.getSubSectionApi(
        sectionId: sectionId,
        subSectionId: subSectionId,
      );
      state = state.copyWith(
        treatmentSubAreaLoading: false,
        subSelectionResponse: response,
      );
      return response.isSuccess == true;
    });
  }

  Future<void> saveAiImage() async {
    return await runSafely(() async {
      EasyLoading.show(status: 'Please wait...');
      final treatmentId = state.selectedTreatment?.id;
      if (treatmentId == null) {
        EasyLoading.showError('No treatment selected');
        return;
      }
      final beforeImage = state.capturedImage?.path;
      final afterImage = state.aiImage?.path;
      final subSections = state.selectedSubAreasList.map((subArea) {
        return SubSectionRequest(
          sectionId: subArea.id!,
          syringesQuantity: subArea.currentSyringe,
        );
      }).toList();
      if (beforeImage == null || afterImage == null) {
        EasyLoading.showError('Both images need to be selected!');
        return;
      }
      final mediaService = MediaService();
      final userId = ref.read(authViewModel).authResponse!.data!.user!.id!;
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
      treatmentAreaLoading: false,
      treatmentsLoading: false,
      treatmentSubAreaLoading: false,
    );
    super.onError(message);
    EasyLoading.showError(message);
  }
}

@immutable
class TreatmentsState extends BaseStateModel {
  final TreatmentResponse? treatmentResponse;
  final TreatmentSubAreaResponse? treatmentsSubAreaResponse;
  final TreatmentAreaResponse? treatmentAreaResponse;
  final bool treatmentsLoading;
  final bool treatmentAreaLoading;
  final bool treatmentSubAreaLoading;

  final TreatmentsModel? selectedTreatment;
  final TreatmentAreaModel? selectTreatmentArea;
  final List<TreatmentSubAreaModel> selectedSubAreasList;

  final bool isBefore;
  final XFile? capturedImage;
  final XFile? aiImage;
  final bool isAiImageGenerated;

  const TreatmentsState({
    super.loading = false,
    super.errorMessage,
    this.treatmentResponse,
    this.treatmentAreaResponse,
    this.treatmentsSubAreaResponse,
    this.treatmentsLoading = false,
    this.treatmentAreaLoading = false,
    this.treatmentSubAreaLoading = false,
    this.selectedTreatment,
    this.selectTreatmentArea,
    this.selectedSubAreasList = const [],
    this.isBefore = false,
    this.capturedImage,
    this.aiImage,
    this.isAiImageGenerated = false,
  });

  @override
  TreatmentsState copyWith({
    bool? loading,
    String? errorMessage,
    TreatmentResponse? treatmentResponse,
    TreatmentSubAreaResponse? subSelectionResponse,
    TreatmentAreaResponse? selectSelectionResponse,
    bool? treatmentsLoading,
    bool? treatmentAreaLoading,
    bool? treatmentSubAreaLoading,
    TreatmentsModel? selectedTreatment,
    TreatmentAreaModel? selectedTreatmentArea,
    TreatmentSubAreaModel? selectedTreatmentSubArea,
    List<TreatmentSubAreaModel>? selectedSubAreasList,
    bool? isBefore,
    XFile? capturedImage,
    XFile? aiImage,
    bool clearSelectSectionId = false,
    bool clearSubSectionId = false,
    bool clearSubSectionIds = false,
    bool clearAiImage = false,
    bool? isAiImageGenerated,
  }) {
    return TreatmentsState(
      loading: loading ?? this.loading,
      errorMessage: errorMessage ?? this.errorMessage,
      treatmentResponse: treatmentResponse ?? this.treatmentResponse,
      treatmentAreaResponse: selectSelectionResponse ?? treatmentAreaResponse,
      treatmentsSubAreaResponse:
          subSelectionResponse ?? treatmentsSubAreaResponse,
      treatmentsLoading: treatmentsLoading ?? this.treatmentsLoading,
      treatmentAreaLoading: treatmentAreaLoading ?? this.treatmentAreaLoading,
      treatmentSubAreaLoading:
          treatmentSubAreaLoading ?? this.treatmentSubAreaLoading,
      selectedTreatment: selectedTreatment ?? this.selectedTreatment,
      selectTreatmentArea: clearSelectSectionId
          ? null
          : (selectedTreatmentArea ?? selectTreatmentArea),
      selectedSubAreasList: clearSubSectionIds
          ? const []
          : (selectedSubAreasList ?? this.selectedSubAreasList),
      isBefore: isBefore ?? this.isBefore,
      capturedImage: capturedImage ?? this.capturedImage,
      aiImage: clearAiImage ? null : (aiImage ?? this.aiImage),
      isAiImageGenerated: isAiImageGenerated ?? this.isAiImageGenerated,
    );
  }
}
