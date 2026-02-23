import 'dart:convert';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:skinsync_ai/models/responses/treatment_area_response.dart';
import 'package:skinsync_ai/models/responses/treatment_sub_area_response.dart';
import 'package:skinsync_ai/services/api_base_helper.dart';

import '../models/base_state_model.dart';
import '../models/responses/treatment_response_model.dart';
import '../repositories/treatment_repository.dart';
import '../services/treatment_services.dart';
import '../utills/image_utills.dart';
import 'base_view_model.dart';

final treatmentViewModel = NotifierProvider(
  () => TreatmentViewModel(
    treatmentRepository: TreatmentService(apiClient: ApiBaseHelper()),
  ),
);

class TreatmentViewModel extends BaseViewModel<TreatmentsState> {
  TreatmentViewModel({required TreatmentRepository treatmentRepository})
    : _repo = treatmentRepository,
      super(initialState: TreatmentsState());

  final TreatmentRepository _repo;

  void updateSyringeLevel(int syringeLevel) =>
      state = state.copyWith(syringeLevel: syringeLevel);

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
      treatmentId: treatmentModel.id,
      clearSubSectionIds: true,
    );
    clearAiImage();
    if (state.treatmentAreaResponse != null) _clearAreaSelection();
    if (state.treatmentsSubAreaResponse != null) _clearSubSectionSelection();
    state = state.copyWith(isBefore: true);
    if (treatmentModel.isArea == true) {
      getSelectSectionApi(sectionId: treatmentModel.id ?? 0);
    } else if (isCallPredictAPI) {
      callPredictAPI();
    }
  }

  void onTapTreatmentArea({
    required SelectSection treatmentArea,
    required bool isCallPredictAPI,
  }) {
    state = state.copyWith(selectSectionId: treatmentArea.id);
    //if (state.treatmentsSubAreaResponse != null) _clearSubSectionSelection();
    if (treatmentArea.isSidearea == true) {
      getSubSectionApi(
        sectionId: state.treatmentId!,
        subSectionId: treatmentArea.id ?? 0,
      );
    } else if (isCallPredictAPI) {
      _clearSubSectionSelection();
      callPredictAPI();
    }
  }

  void onTapTreatmentSubArea({
    required TreatmentSubAreaModel treatmentSubArea,
    required bool isCallPredictAPI,
  }) {
    final id = treatmentSubArea.id;
    final ids = id != null ? [...state.subSectionIds, id] : state.subSectionIds;
    state = state.copyWith(subSectionId: id, subSectionIds: ids);
    if (isCallPredictAPI) callPredictAPI();
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
      treatmentId: null,
      selectSectionId: null,
      subSectionId: null,
      subSectionIds: const [],
      syringeLevel: null,
      isBefore: true,
      capturedImage: state.capturedImage,
      aiImage: null,
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

  XFile? get _imageForPredict => state.aiImage ?? state.capturedImage;

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

  Future<void> callPredictAPI({int? syringeLevel}) async {
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
      final jsonRes = await _uploadCapturedImage(
        image: _imageForPredict!,
        syringeLevel: syringeLevel ?? state.syringeLevel ?? 0,
      );
      if (jsonRes == null) throw Exception('Failed to upload image');

      final base64 = _parseOutputImageBase64(jsonRes);
      final ximage = await base64ToXFile(
        base64,
        fileName: 'ai_image_${DateTime.now().millisecondsSinceEpoch}.jpg',
      );

      setAiImage(ximage);
      if (wasBefore) toggleIsBefore();

      state = state.copyWith(loading: false, errorMessage: null);
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
    required int syringeLevel,
  }) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('http://18.116.65.70/api/'),
    );
    request.fields.addAll({
      'treatment_id': (state.treatmentId ?? 0).toString(),
      'treatment_section_id': (state.selectSectionId ?? 0).toString(),
      'treatment_sub_section_id': (state.subSectionId ?? 0).toString(),
      'syringes': syringeLevel.toString(),
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

  final int? treatmentId;
  final int? selectSectionId;
  final int? subSectionId;
  final List<int> subSectionIds;
  final int? syringeLevel;

  final bool isBefore;
  final XFile? capturedImage;
  final XFile? aiImage;

  const TreatmentsState({
    super.loading = false,
    super.errorMessage,
    this.treatmentResponse,
    this.treatmentAreaResponse,
    this.treatmentsSubAreaResponse,
    this.treatmentsLoading = false,
    this.treatmentAreaLoading = false,
    this.treatmentSubAreaLoading = false,
    this.treatmentId,
    this.selectSectionId,
    this.subSectionId,
    this.subSectionIds = const [],
    this.syringeLevel,
    this.isBefore = false,
    this.capturedImage,
    this.aiImage,
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
    int? treatmentId,
    int? selectSectionId,
    int? subSectionId,
    List<int>? subSectionIds,
    int? syringeLevel,
    bool? isBefore,
    XFile? capturedImage,
    XFile? aiImage,
    bool clearSelectSectionId = false,
    bool clearSubSectionId = false,
    bool clearSubSectionIds = false,
    bool clearAiImage = false,
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
      treatmentId: treatmentId ?? this.treatmentId,
      selectSectionId: clearSelectSectionId
          ? null
          : (selectSectionId ?? this.selectSectionId),
      subSectionId: clearSubSectionId
          ? null
          : (subSectionId ?? this.subSectionId),
      subSectionIds: clearSubSectionIds
          ? const []
          : (subSectionIds ?? this.subSectionIds),
      syringeLevel: syringeLevel ?? this.syringeLevel,
      isBefore: isBefore ?? this.isBefore,
      capturedImage: capturedImage ?? this.capturedImage,
      aiImage: clearAiImage ? null : (aiImage ?? this.aiImage),
    );
  }
}
