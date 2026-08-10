import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/base_state_model.dart';
import '../models/explore_models.dart';
import '../repositories/explore_repository.dart';
import '../services/api_base_helper.dart';
import '../services/explore_service.dart';
import 'base_view_model.dart';

enum ExploreViewType { community, reels }

final exploreViewModel = NotifierProvider<ExploreViewModel, ExploreState>(() {
  final apiBaseHelper = ApiBaseHelper();
  final exploreService = ExploreService(apiClient: apiBaseHelper);
  return ExploreViewModel(repository: exploreService);
});

class ExploreState extends BaseStateModel {
  final List<ReelModel> reels;
  final List<CommunityPostModel> posts;

  final int reelsTotalPages;
  final int postsTotalPages;

  final int reelsCurrentPage;
  final int postsCurrentPage;

  final int pageSize;

  final ExploreViewType viewType;

  const ExploreState({
    super.loading,
    super.errorMessage,
    this.reels = const [],
    this.posts = const [],
    this.reelsTotalPages = 1,
    this.postsTotalPages = 1,
    this.reelsCurrentPage = 1,
    this.postsCurrentPage = 1,
    this.pageSize = 20,
    this.viewType = ExploreViewType.community,
  });

  @override
  ExploreState copyWith({
    bool? loading,
    String? errorMessage,
    List<ReelModel>? reels,
    List<CommunityPostModel>? posts,
    int? reelsTotalPages,
    int? postsTotalPages,
    int? reelsCurrentPage,
    int? postsCurrentPage,
    int? pageSize,
    ExploreViewType? viewType,
  }) {
    return ExploreState(
      loading: loading ?? this.loading,
      errorMessage: errorMessage ?? this.errorMessage,
      reels: reels ?? this.reels,
      posts: posts ?? this.posts,
      reelsTotalPages: reelsTotalPages ?? this.reelsTotalPages,
      postsTotalPages: postsTotalPages ?? this.postsTotalPages,
      reelsCurrentPage: reelsCurrentPage ?? this.reelsCurrentPage,
      postsCurrentPage: postsCurrentPage ?? this.postsCurrentPage,
      pageSize: pageSize ?? this.pageSize,
      viewType: viewType ?? this.viewType,
    );
  }

  ExploreState clearFiles() {
    return ExploreState(
      loading: loading,
      errorMessage: errorMessage,
      reels: reels,
      posts: posts,
      reelsTotalPages: reelsTotalPages,
      postsTotalPages: postsTotalPages,
      reelsCurrentPage: reelsCurrentPage,
      postsCurrentPage: postsCurrentPage,
      pageSize: pageSize,
      viewType: viewType,
    );
  }
}

class ExploreViewModel extends BaseViewModel<ExploreState> {
  final ExploreRepository _repository;
  ExploreViewModel({required ExploreRepository repository})
    : _repository = repository,
      super(initialState: const ExploreState());
  Future<void> fetchReels({int page = 1}) async {
    await runSafely(() async {
      final response = await _repository.fetchReels(
        page: page,
        limit: state.pageSize,
      );
      state = state.copyWith(
        reels: response.data ?? [],
        reelsTotalPages: response.totalPages,
        reelsCurrentPage: response.page,
      );
    });
  }

  void setViewType(ExploreViewType type) {
    state = state.copyWith(viewType: type);
  }

  void toggleViewType() {
    state = state.copyWith(
      viewType: state.viewType == ExploreViewType.community
          ? ExploreViewType.reels
          : ExploreViewType.community,
    );
  }
}
