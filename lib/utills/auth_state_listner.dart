import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../models/base_state_model.dart';

void authStateListener(BaseStateModel? previous, BaseStateModel next) {
  // Show / dismiss loading
  if (next.loading && !EasyLoading.isShow) {
    EasyLoading.show(status: "Loading...");
  } else if (!next.loading && EasyLoading.isShow) {
    EasyLoading.dismiss();
  }

  // Show error if exists and changed
  if (next.errorMessage != null &&
      next.errorMessage != previous?.errorMessage) {
    EasyLoading.showError(next.errorMessage!);
  }
}
