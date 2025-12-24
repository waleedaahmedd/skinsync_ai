import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'base_view_model.dart';

final bottomNavViewModel = NotifierProvider(() => BottomNavViewModel());

class BottomNavViewModel extends BaseViewModel<int> {
  BottomNavViewModel() : super(initialState: 0);

  void changePage(int newPage) {
    state = newPage;
  }
}
