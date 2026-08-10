import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/base_state_model.dart';
import '../models/responses/groups_list_response.dart';
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

  @override
  void onError(String message) {
    state = state.copyWith(loading: false, errorMessage: message);
    super.onError(message);
  }
}

@immutable
class TreatmentJourneyState extends BaseStateModel {
  final List<TreatmentJourneyGroup> groups;

  const TreatmentJourneyState({
    super.loading = false,
    super.errorMessage,
    this.groups = const [],
  });

  @override
  TreatmentJourneyState copyWith({
    bool? loading,
    String? errorMessage,
    List<TreatmentJourneyGroup>? groups,
  }) {
    return TreatmentJourneyState(
      loading: loading ?? this.loading,
      errorMessage: errorMessage ?? this.errorMessage,
      groups: groups ?? this.groups,
    );
  }
}
