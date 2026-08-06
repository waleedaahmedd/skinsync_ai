import 'package:flutter_riverpod/flutter_riverpod.dart';

enum ExploreViewType { community, reels }

final exploreViewModel = NotifierProvider<ExploreViewModel, ExploreViewType>(() => ExploreViewModel());

class ExploreViewModel extends Notifier<ExploreViewType> {
  @override
  ExploreViewType build() {
    return ExploreViewType.community;
  }

  void setViewType(ExploreViewType type) {
    state = type;
  }

  void toggleViewType() {
    state = state == ExploreViewType.community 
        ? ExploreViewType.reels 
        : ExploreViewType.community;
  }
}
