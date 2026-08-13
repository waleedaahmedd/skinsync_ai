import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/base_state_model.dart';
import '../models/requests/create_group_request.dart';
import '../models/requests/save_history_request.dart';
import '../models/requests/tj_options_request.dart';
import '../models/responses/groups_list_response.dart';
import '../models/responses/simulation_history_response.dart';
import '../models/responses/tj_options_list_response.dart';
import '../repositories/treatment_journey_repository.dart';
import '../services/api_base_helper.dart';
import '../services/treatment_journey_service.dart';
import '../utills/simulation_utils.dart';
import 'auth_view_model.dart';
import 'base_view_model.dart';
import 'checkout_view_model.dart';
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

  Future<void> fetchTreatmentJourneyGroups([bool loading = true]) async {
    await runSafely(() async {
      if (loading) {
        state = state.copyWith(loading: true, errorMessage: null);
      }
      final response = await _repo.getGroups();
      state = state.copyWith(loading: false, groups: response.data ?? []);
    });
  }

  Future<bool?> createGroup(String name) async {
    return await runSafely(() async {
      // state = state.copyWith(loading: true, errorMessage: null);
      EasyLoading.show(status: 'Creating group...');
      final request = CreateGroupRequest(name: name);
      await _repo.createGroup(request);
      await fetchTreatmentJourneyGroups(false);
      EasyLoading.dismiss();
      return true;
    });
  }

  Future<bool?> fetchOptions(int groupId) async {
    return await runSafely(() async {
      EasyLoading.show(status: 'Fetching Journey...');
      final response = await _repo.getOptions(groupId);
     
      state = state.copyWith(loading: false, options: response.data ?? []);
       if (state.options.isNotEmpty) {
       await fetchOptionsDetail(state.options.first.id!);
      }
      EasyLoading.dismiss();
      return true;
    });
  }

  Future<bool?> fetchOptionsDetail(int optionId) async {
    return await runSafely(() async {
      EasyLoading.show(status: 'Fetching Journey...');
      final response = await _repo.getOptionsDetail(optionId);
      state = state.copyWith(loading: false, simulations: response.data);
      EasyLoading.dismiss();
      return true;
    });
  }

  void setGroupId(int groupID) {
    state = state.copyWith(groupId: groupID);
  }
 

  // Future<void> fetchSimulations(int optionId) async {
  //   state = state.copyWith(
  //     isSimulationsLoading: true,
  //     selectedOptionId: optionId,
  //   );

  //   await Future.delayed(const Duration(milliseconds: 800));

  //   final List<SimulationData> dummySims = [
  //     SimulationData(
  //       id: 101,
  //       frontImageBefore: "https://picsum.photos/200/300?random=1",
  //       frontImageAfter: "https://picsum.photos/200/300?random=2",
  //       rightImageBefore: "https://picsum.photos/200/300?random=3",
  //       rightImageAfter: "https://picsum.photos/200/300?random=4",
  //       leftImageBefore: "https://picsum.photos/200/300?random=5",
  //       leftImageAfter: "https://picsum.photos/200/300?random=6",
  //       createdAt: DateTime.now(),
  //       treatments: [
  //         const SimulationTreatment(
  //           id: 1,
  //           name: "Full Facial Rejuvenation",
  //           areas: [
  //             SimulationArea(
  //               id: "1",
  //               name: "Cheeks",
  //               materials: [
  //                 SimulationMaterial(
  //                   id: 1,
  //                   name: "Hyaluronic Acid",
  //                   selectedQuantity: 2,
  //                 ),
  //               ],
  //             ),
  //             SimulationArea(
  //               id: "2",
  //               name: "Forehead",
  //               materials: [
  //                 SimulationMaterial(id: 2, name: "Botox", selectedQuantity: 1),
  //               ],
  //             ),
  //           ],
  //         ),
  //       ],
  //     ),
  //   ];

  //   state = state.copyWith(
  //     isSimulationsLoading: false,
  //     simulations: dummySims,
  //     price: optionId == 1 ? "\$500" : "\$850",
  //   );
  // }

  Future<bool?> createTjOptions() async {
    return await runSafely(() async {
      EasyLoading.show(status: 'Please wait...');
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
        groupId: state.groupId,
        name: 'Option $opitionNumber',
        frontImageBefore: uploadResults.frontBefore,
        frontImageAfter: uploadResults.frontAfter,
        rightImageBefore: uploadResults.rightBefore,
        rightImageAfter: uploadResults.rightAfter,
        leftImageBefore: uploadResults.leftBefore,
        leftImageAfter: uploadResults.leftAfter,
        treatments: historyTreatments,
      );
      final reesponse = await _repo.createTjOptions(request);
      if (reesponse.isSuccess == true) {

        EasyLoading.showSuccess('Option created successfully');
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
  final int? groupId;
  final String? price;

  const TreatmentJourneyState({
    super.loading = false,
    super.errorMessage,
    this.groupId,
  
    this.groups = const [],
    this.options = const [],
    this.simulations ,
    this.isSimulationsLoading = false,
    this.selectedOptionId,
    this.price,
  });

  @override
  TreatmentJourneyState copyWith({
    bool? loading,
    String? errorMessage,
    int? groupId,
   
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
      groupId: groupId ?? this.groupId,
      options: options ?? this.options,
      simulations: simulations ?? this.simulations,
      isSimulationsLoading: isSimulationsLoading ?? this.isSimulationsLoading,
      selectedOptionId: selectedOptionId ?? this.selectedOptionId,
      price: price ?? this.price,
   
    );
  }
}
