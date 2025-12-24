import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'base_view_model.dart';

final treatmentViewModel = NotifierProvider.autoDispose(
  () => TreatmentViewModel(),
);

class TreatmentViewModel extends BaseViewModel<bool> {
  TreatmentViewModel() : super(initialState: true);

  void setTreatmentMainScreen({required bool value}) {
    state = value;
  }
}
