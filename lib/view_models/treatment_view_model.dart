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
import 'face_scan_provider.dart';

final treatmentViewModel = NotifierProvider(
  () => TreatmentViewModel(
    treatmentRepository: TreatmentService(apiClient: ApiBaseHelper()),
  ),
);

class TreatmentViewModel extends BaseViewModel<TreatmentsState> {
  TreatmentViewModel({required TreatmentRepository treatmentRepository})
    : _treatmentRepository = treatmentRepository,
      super(initialState: TreatmentsState());

  // void setTreatmentMainScreen({required bool value}) {
  //   state = value;
  // }
  final TreatmentRepository _treatmentRepository;

  void updateSyringeLevel(int syringeLevel) {
    state = state.copyWith(syringeLevel: syringeLevel);
  }

  void onTapTreatment({
    required TreatmentsModel treatmentModel,
    required bool isCallPredictAPI,
  }) {
    state = state.copyWith(treatmentId: treatmentModel.id);
    if (state.treatmentAreaResponse != null) {
      state.treatmentAreaResponse!.data = null;
      state = state.copyWith(clearSelectSectionId: true);
    }
    if (state.treatmentsSubAreaResponse != null) {
      state.treatmentsSubAreaResponse!.data = null;
      state = state.copyWith(clearSubSectionId: true);
    }
    if (treatmentModel.isArea == true) {
      getSelectSectionApi(sectionId: treatmentModel.id ?? 0);
    } else {
      if (isCallPredictAPI) {
        callPredictAPI();
      }
    }
  }

  void onTapTreatmentArea({
    required SelectSection treatmentArea,
    required bool isCallPredictAPI,
  }) {
    state = state.copyWith(selectSectionId: treatmentArea.id);
    if (state.treatmentsSubAreaResponse != null) {
      state.treatmentsSubAreaResponse!.data = null;
      state = state.copyWith(clearSubSectionId: true);
    }
    if (treatmentArea.isSidearea == true) {
      getSubSectionApi(
        sectionId: state.treatmentId!,
        subSectionId: treatmentArea.id ?? 0,
      );
    } else {
      if (isCallPredictAPI) {
        callPredictAPI();
      }
    }
  }

  void onTapTreatmentSubArea({
    required TreatmentSubAreaModel treatmentSubArea,
    required bool isCallPredictAPI,
  }) {
    state = state.copyWith(subSectionId: treatmentSubArea.id);
    if (isCallPredictAPI) {
      callPredictAPI();
    }
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
      syringeLevel: null,
    );
  }

  Future<bool?> getTreatments() async {
    state = state.copyWith(treatmentsLoading: true);
    return await runSafely(() async {
      final TreatmentResponse response = await _treatmentRepository
          .getTreatmentsApi();
      state = state.copyWith(
        treatmentsLoading: false,
        treatmentResponse: response,
      );
      return response.isSuccess == true;
    });
  }

  Future<void> callPredictAPI({int? syringeLevel}) async {
    final faceScanState = ref.read(faceScanProvider);
    if (faceScanState.capturedImage == null) {
      // No captured image available - show error
      state = state.copyWith(
        loading: false,
        errorMessage:
            'No captured image available. Please capture your face first.',
      );
      EasyLoading.showError(
        'No captured image available. Please capture your face first.',
      );
      return;
    }

    // Store isBefore state before API call to check if we need to toggle after success
    final wasBefore = faceScanState.isBefore;

    // Use syringeLevel from parameter or from state, default to 1
    final syringeLevelValue = syringeLevel ?? state.syringeLevel ?? 1;

    state = state.copyWith(loading: true, errorMessage: null);
    EasyLoading.show(status: 'Processing image...');

    try {
      final jsonRes = await _uploadCapturedImage(
        image: faceScanState.capturedImage!,
        syringeLevel: syringeLevelValue,
      );

      if (jsonRes == null) {
        throw Exception('Failed to upload image');
      }

      // Check if output_image exists in response (new API uses output_image instead of image_base64)
      final outputImage = jsonRes["output_image"];
      print('output_image value type: ${outputImage.runtimeType}');
      print('output_image is null: ${outputImage == null}');

      if (outputImage == null) {
        print('output_image is null, checking response structure');
        print('Response keys: ${jsonRes.keys.toList()}');
        print('Full response: $jsonRes');
        throw Exception(
          'No image data received from server: output_image field is null',
        );
      }

      // Handle both String and dynamic types
      String outputImageString;
      if (outputImage is String) {
        outputImageString = outputImage;
      } else {
        outputImageString = outputImage.toString();
      }

      if (outputImageString.isEmpty || outputImageString.trim().isEmpty) {
        throw Exception(
          'No image data received from server: output_image field is empty',
        );
      }

      print('output_image string length: ${outputImageString.length}');
      print(
        'output_image first 50 chars: ${outputImageString.substring(0, outputImageString.length > 50 ? 50 : outputImageString.length)}',
      );

      // Generate unique filename to ensure each API call creates a new file
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      XFile ximage;
      try {
        ximage = await base64ToXFile(
          outputImageString,
          fileName: 'ai_image_$timestamp.jpg',
        );
      } catch (e) {
        print('Error converting base64 to XFile: $e');
        throw Exception('Failed to process image data: $e');
      }

      await ref.read(faceScanProvider.notifier).setAiImage(ximage);

      // If isBefore was true, toggle it to false to show the "After" image immediately
      if (wasBefore) {
        ref.read(faceScanProvider.notifier).toggleIsBefore();
      }

      // Clear error message and loading state on success - do this synchronously
      state = state.copyWith(loading: false, errorMessage: null);
      EasyLoading.dismiss();
      EasyLoading.showSuccess('Image processed successfully!');
    } catch (e) {
      final errorMsg = e.toString().replaceFirst('Exception: ', '');
      state = state.copyWith(loading: false, errorMessage: errorMsg);
      EasyLoading.dismiss();
      EasyLoading.showError(errorMsg);
      print('Error in callPredictAPI: $e');
    }
  }

  Future<Map<String, dynamic>?> _uploadCapturedImage({
    required XFile image,
    required int syringeLevel,
  }) async {
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('http://18.116.65.70/api/'),
      );

      // Match curl: form fields as string values (no literal "null" for missing IDs)
      request.fields.addAll({
        'treatment_id': (state.treatmentId ?? 0).toString(),
        'treatment_section_id': (state.selectSectionId ?? 0).toString(),
        'treatment_sub_section_id': (state.subSectionId ?? 0).toString(),
        'syringes': syringeLevel.toString(),
      });

      // Attach image: use path if valid, otherwise read bytes (e.g. content URI / web)
      final path = image.path;
      if (path.isNotEmpty) {
        try {
          request.files.add(await http.MultipartFile.fromPath('image', path));
        } catch (_) {
          request.files.add(
            http.MultipartFile.fromBytes(
              'image',
              await image.readAsBytes(),
              filename: 'image.jpg',
            ),
          );
        }
      } else {
        request.files.add(
          http.MultipartFile.fromBytes(
            'image',
            await image.readAsBytes(),
            filename: 'image.jpg',
          ),
        );
      }

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode != 200) {
        print('Upload failed: ${response.statusCode} ${response.reasonPhrase}');
        print('Response body: $responseBody');
      }

      if (response.statusCode == 200) {
        final responseData = jsonDecode(responseBody) as Map<String, dynamic>;
        // Log response structure for debugging
        print('API Response keys: ${responseData.keys.toList()}');
        print('API Response success: ${responseData["success"]}');
        print(
          'API Response has output_image: ${responseData.containsKey("output_image")}',
        );
        if (responseData.containsKey("output_image")) {
          final outputImage = responseData["output_image"];
          print('output_image type: ${outputImage.runtimeType}');
          print(
            'output_image length: ${outputImage is String ? outputImage.length : "N/A"}',
          );
        }
        return responseData;
      } else {
        try {
          final responseData =
              jsonDecode(responseBody) as Map<String, dynamic>?;
          final errorMessage =
              (responseData?['message'] as String?) ??
              (response.reasonPhrase ?? 'Upload failed');
          throw Exception(errorMessage);
        } catch (e) {
          if (e is Exception) {
            rethrow;
          }
          throw Exception(response.reasonPhrase ?? 'Upload failed');
        }
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<bool?> getSelectSectionApi({required int sectionId}) async {
    return await runSafely(() async {
      state = state.copyWith(treatmentAreaLoading: true);
      final TreatmentAreaResponse response = await _treatmentRepository
          .getSelectSectionApi(sectionId: sectionId);
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
    return await runSafely(() async {
      state = state.copyWith(treatmentSubAreaLoading: true);
      final TreatmentSubAreaResponse response = await _treatmentRepository
          .getSubSectionApi(sectionId: sectionId, subSectionId: subSectionId);
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
  final int? syringeLevel;

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
    this.syringeLevel,
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
    int? syringeLevel,
    bool clearSelectSectionId = false,
    bool clearSubSectionId = false,
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
      selectSectionId: clearSelectSectionId ? null : (selectSectionId ?? this.selectSectionId),
      subSectionId: clearSubSectionId ? null : (subSectionId ?? this.subSectionId),
      syringeLevel: syringeLevel ?? this.syringeLevel,
    );
  }
}
