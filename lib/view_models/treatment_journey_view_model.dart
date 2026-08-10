import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/base_state_model.dart';
import '../models/responses/groups_list_response.dart';
import '../models/responses/tj_options_list_response.dart';
import '../models/responses/simulation_history_response.dart';
import '../models/requests/create_group_request.dart';
import 'base_view_model.dart';

final treatmentJourneyProvider =
    NotifierProvider<TreatmentJourneyViewModel, TreatmentJourneyState>(
  () => TreatmentJourneyViewModel(),
);

class TreatmentJourneyViewModel extends BaseViewModel<TreatmentJourneyState> {
  TreatmentJourneyViewModel()
    : super(initialState: const TreatmentJourneyState());

  Future<void> fetchTreatmentJourneyGroups() async {
    state = state.copyWith(loading: true, errorMessage: null);

    // Dummy data as requested
    await Future.delayed(const Duration(milliseconds: 800));

    final dummyGroups = [
      TreatmentJourneyGroup(
        id: 1,
        name: "Face Scan",
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        simulationCount: 3,
      ),
      TreatmentJourneyGroup(
        id: 2,
        name: "Acne Treatment",
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        simulationCount: 5,
      ),
      TreatmentJourneyGroup(
        id: 3,
        name: "Anti-Aging Journey",
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
        simulationCount: 2,
      ),
    ];

    state = state.copyWith(loading: false, groups: dummyGroups);
  }

  Future<bool> createGroup(String name) async {
    return await runSafely(() async {
      state = state.copyWith(loading: true, errorMessage: null);
      
      // Simulate API call with request model
      final request = CreateGroupRequest(name: name);
      debugPrint("Creating group with request: ${request.toJson()}");
      
      await Future.delayed(const Duration(seconds: 1));

      final newGroup = TreatmentJourneyGroup(
        id: state.groups.length + 1,
        name: name,
        createdAt: DateTime.now(),
        simulationCount: 0,
      );

      state = state.copyWith(
        loading: false,
        groups: [newGroup, ...state.groups],
      );
      
      return true;
    }) ?? false;
  }

  Future<void> fetchOptions(int groupId) async {
    state = state.copyWith(loading: true, errorMessage: null);

    await Future.delayed(const Duration(milliseconds: 600));

    final dummyOptions = [
      const TJOption(id: 1, name: "Option 1"),
      const TJOption(id: 2, name: "Option 2"),
    ];

    state = state.copyWith(loading: false, options: dummyOptions);
    
    if (dummyOptions.isNotEmpty) {
      fetchSimulations(dummyOptions.first.id!);
    }
  }

  Future<void> fetchSimulations(int optionId) async {
    state = state.copyWith(isSimulationsLoading: true, selectedOptionId: optionId);

    await Future.delayed(const Duration(milliseconds: 800));

    final List<SimulationData> dummySims = [
      SimulationData(
        id: 101,
        frontImageBefore: "https://picsum.photos/200/300?random=1",
        frontImageAfter: "https://picsum.photos/200/300?random=2",
        rightImageBefore: "https://picsum.photos/200/300?random=3",
        rightImageAfter: "https://picsum.photos/200/300?random=4",
        leftImageBefore: "https://picsum.photos/200/300?random=5",
        leftImageAfter: "https://picsum.photos/200/300?random=6",
        createdAt: DateTime.now(),
        treatments: [
          const SimulationTreatment(
            id: 1,
            name: "Full Facial Rejuvenation",
            areas: [
              SimulationArea(id: "1", name: "Cheeks", materials: [
                SimulationMaterial(id: 1, name: "Hyaluronic Acid", selectedQuantity: 2)
              ]),
              SimulationArea(id: "2", name: "Forehead", materials: [
                SimulationMaterial(id: 2, name: "Botox", selectedQuantity: 1)
              ])
            ],
          )
        ],
      ),
    ];

    state = state.copyWith(
      isSimulationsLoading: false,
      simulations: dummySims,
      price: optionId == 1 ? "\$500" : "\$850",
    );
  }

  @override
  void onError(String message) {
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
  final List<SimulationData> simulations;
  final bool isSimulationsLoading;
  final int? selectedOptionId;
  final String? price;

  const TreatmentJourneyState({
    super.loading = false,
    super.errorMessage,
    this.groups = const [],
    this.options = const [],
    this.simulations = const [],
    this.isSimulationsLoading = false,
    this.selectedOptionId,
    this.price,
  });

  @override
  TreatmentJourneyState copyWith({
    bool? loading,
    String? errorMessage,
    List<TreatmentJourneyGroup>? groups,
    List<TJOption>? options,
    List<SimulationData>? simulations,
    bool? isSimulationsLoading,
    int? selectedOptionId,
    String? price,
  }) {
    return TreatmentJourneyState(
      loading: loading ?? this.loading,
      errorMessage: errorMessage ?? this.errorMessage,
      groups: groups ?? this.groups,
      options: options ?? this.options,
      simulations: simulations ?? this.simulations,
      isSimulationsLoading: isSimulationsLoading ?? this.isSimulationsLoading,
      selectedOptionId: selectedOptionId ?? this.selectedOptionId,
      price: price ?? this.price,
    );
  }
}
