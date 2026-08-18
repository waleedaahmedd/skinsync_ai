import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/base_state_model.dart';
import '../models/requests/create_group_request.dart';
import '../models/requests/save_history_request.dart';
import '../models/requests/share_treatment_request.dart';
import '../models/requests/tj_options_request.dart';
import '../models/responses/groups_list_response.dart';
import '../models/responses/simulation_history_response.dart';
import '../models/responses/tj_options_list_response.dart';
import '../repositories/treatment_journey_repository.dart';
import '../services/api_base_helper.dart';
import '../services/treatment_journey_service.dart';
import '../utils/simulation_utils.dart';
import 'auth_view_model.dart';
import 'base_view_model.dart';
import 'checkout_view_model.dart';
import 'clinic_view_model.dart';
import 'treatment_view_model.dart';

final treatmentJourneyProvider =
    NotifierProvider.autoDispose<
      TreatmentJourneyViewModel,
      TreatmentJourneyState
    >(() => TreatmentJourneyViewModel());

class TreatmentJourneyViewModel extends BaseViewModel<TreatmentJourneyState> {
  final TreatmentJourneyRepository _repo;

  TreatmentJourneyViewModel({TreatmentJourneyRepository? repo})
    : _repo = repo ?? TreatmentJourneyService(apiClient: ApiBaseHelper()),
      super(initialState: const TreatmentJourneyState());

  Future<String?> fetchTreatmentJourneyGroups([bool loading = true]) async {
    return await runSafely(() async {
      if (loading) {
        state = state.copyWith(loading: true, errorMessage: null);
      }
      final response = await _repo.getGroups();
      if (!ref.mounted) return null;
      state = state.copyWith(loading: false, groups: response.data ?? []);
      if (state.groups.isEmpty) {
        return 'show';
      }
      return null;
    });
  }

  Future<bool?> createGroup(String name) async {
    return await runSafely(() async {
      EasyLoading.show(status: 'Creating group...');
      final request = CreateGroupRequest(name: name);
      await _repo.createGroup(request);
      if (!ref.mounted) return null;
      await fetchTreatmentJourneyGroups(false);
      EasyLoading.dismiss();
      return true;
    });
  }

  Future<bool?> callShareTreatmentRequest() async {
    return await runSafely(() async {
      final clinicId = ref.read(clinicProvider).clinicId;
      if (state.selectedOptionId == null || clinicId == null) {
        EasyLoading.showError('Select a journey option to share!');
        return false;
      }
      EasyLoading.show(status: 'Loading');
      final request = ShareTreatmentRequest(
        clinicId: clinicId,
        optionId: state.selectedOptionId!,
      );

      await _repo.shareTreatmentRequest(request: request);
      await ref.read(authViewModel.notifier).callGetMe();
      if (!ref.mounted) return null;
      EasyLoading.dismiss();
      return true;
    });
  }

  void setOptionId(int id) {
    state = state.copyWith(selectedOptionId: id);
  }

  Future<bool?> fetchOptions(int groupId, {bool showloading = true}) async {
    return await runSafely(() async {
      if (showloading) {
        EasyLoading.show(status: 'Fetching Journey...');
      }

      final response = await _repo.getOptions(groupId);

      if (!ref.mounted) return null;
      state = state.copyWith(loading: false, options: response.data ?? []);
      if (state.options.isNotEmpty) {
        setOptionId(state.options.first.id!);
        await fetchOptionsDetail(state.options.first.id!,showLoading: false);
      }
      if (showloading) {
        EasyLoading.dismiss();
      }
      return true;
    });
  }

  Future<bool?> fetchOptionsDetail(
    int optionId, {
    bool showLoading = true,
  }) async {
    return await runSafely(() async {
      // EasyLoading.show(status: 'Fetching Options...');
      state = state.copyWith(isSimulationsLoading: true);
      final response = await _repo.getOptionsDetail(optionId);
      if (!ref.mounted) return null;
      state = state.copyWith(
        loading: false,
        simulations: response.data,
        isSimulationsLoading: false,
      );
      EasyLoading.dismiss();
      return true;
    });
  }

  Future<bool?> callDeleteGroup(int groupId) async {
    return await runSafely(() async {
      EasyLoading.show(status: 'Deleting Group...');
      final response = await _repo.deleteGroup(groupId);
      if (!ref.mounted) return null;
      if (response.isSuccess == true) {
        await fetchTreatmentJourneyGroups(false);
      }
      EasyLoading.dismiss();
      return true;
    });
  }

  Future<bool?> callDeleteOption(int optionId) async {
    return await runSafely(() async {
      EasyLoading.show(status: 'Deleting Option...');
      final response = await _repo.deleteOption(optionId);
      if (!ref.mounted) return null;
      if (response.isSuccess == true) {
        if (state.selectedGroup?.id != null) {
          await fetchOptions(state.selectedGroup!.id!);
        }
      }
      EasyLoading.dismiss();
      return true;
    });
  }

  void setGroup(TreatmentJourneyGroup group) {
    state = state.copyWith(selectedGroup: group);
  }

  Future<bool?> createTjOptions() async {
    return await runSafely(() async {
      EasyLoading.show(status: 'Creating Option...');
      final selectedTreatmentsAndAreas = ref
          .read(checkoutViewModel)
          .selectedTreatmentsAndAreas;
      if (selectedTreatmentsAndAreas.isEmpty) {
        EasyLoading.showError('No treatment selected');
        return false;
      }
      final treatmentState = ref.read(treatmentViewModel);
      if (treatmentState.frontPoseImage != null) {
        if (treatmentState.frontAiImage == null) {
          throw Exception('No AI image captured for front Pose!');
        }
      }
      if (treatmentState.rightPoseImage != null) {
        if (treatmentState.rightAiImage == null) {
          throw Exception('No AI image captured for right Pose!');
        }
      }
      if (treatmentState.leftPoseImage != null) {
        if (treatmentState.leftAiImage == null) {
          throw Exception('No AI image captured for left Pose!');
        }
      }

      final userId = ref.read(authViewModel).authData!.user!.id!;

      final uploadResults = await uploadSimulationImages(
        userId: userId,
        images: SimulationImages(
          frontBefore: treatmentState.frontPoseImage,
          frontAfter: treatmentState.frontAiImage,
          rightBefore: treatmentState.rightPoseImage,
          rightAfter: treatmentState.rightAiImage,
          leftBefore: treatmentState.leftPoseImage,
          leftAfter: treatmentState.leftAiImage,
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
              areaId: (area.id ?? 0),
              areaName: area.name ?? '',
              materials: historyMaterials,
            );
          }).toList(),
        );
      }).toList();
      final opitionNumber = state.options.length + 1;
      final request = TjOptionsRequest(
        groupId: state.selectedGroup!.id!,
        name: 'Option $opitionNumber',
        frontImageBefore: uploadResults.frontBefore,
        frontImageAfter: uploadResults.frontAfter,
        rightImageBefore: uploadResults.rightBefore,
        rightImageAfter: uploadResults.rightAfter,
        leftImageBefore: uploadResults.leftBefore,
        leftImageAfter: uploadResults.leftAfter,
        treatments: historyTreatments,
      );
      final response = await _repo.createTjOptions(request);
      if (response.isSuccess == true) {
        await EasyLoading.showSuccess('Option created successfully');
      }
      return true;
    });
  }

  @override
  void onError(String message) {
    EasyLoading.dismiss();
    state = state.copyWith(
      loading: false,
      errorMessage: message,
      isSimulationsLoading: false,
    );
    super.onError(message);
  }
}

@immutable
class TreatmentJourneyState extends BaseStateModel {
  final List<TreatmentJourneyGroup> groups;

  final List<TJOption> options;
  final SimulationData? simulations;
  final bool isSimulationsLoading;
  final int? selectedOptionId;
  final TreatmentJourneyGroup? selectedGroup;
  final String? price;

  const TreatmentJourneyState({
    super.loading = false,
    super.errorMessage,
    this.selectedGroup,
    this.groups = const [],
    this.options = const [],
    this.simulations,
    this.isSimulationsLoading = false,
    this.selectedOptionId,
    this.price,
  });

  @override
  TreatmentJourneyState copyWith({
    bool? loading,
    String? errorMessage,
    TreatmentJourneyGroup? selectedGroup,
    List<TreatmentJourneyGroup>? groups,
    List<TJOption>? options,
    SimulationData? simulations,
    bool? isSimulationsLoading,
    int? selectedOptionId,
    String? price,
  }) {
    return TreatmentJourneyState(
      loading: loading ?? this.loading,
      errorMessage: errorMessage ?? this.errorMessage,
      groups: groups ?? this.groups,
      selectedGroup: selectedGroup ?? this.selectedGroup,
      options: options ?? this.options,
      simulations: simulations ?? this.simulations,
      isSimulationsLoading: isSimulationsLoading ?? this.isSimulationsLoading,
      selectedOptionId: selectedOptionId ?? this.selectedOptionId,
      price: price ?? this.price,
    );
  }
}
