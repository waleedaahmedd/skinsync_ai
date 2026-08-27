import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/base_state_model.dart';
import '../models/responses/notification_response.dart';
import '../repositories/notification_repository.dart';
import '../services/api_base_helper.dart';
import '../services/notification_service.dart';
import 'base_view_model.dart';

final notificationViewModel =
    NotifierProvider<NotificationViewModel, NotificationState>(() {
      final apiBaseHelper = ApiBaseHelper();
      final exploreService = NotificationService(apiClient: apiBaseHelper);
      return NotificationViewModel(repository: exploreService);
    });

class NotificationState extends BaseStateModel {
  final List<NotificationData> notification;

  final int totalPages;

  final int currentPage;

  final int pageSize;

  const NotificationState({
    super.loading,
    super.errorMessage,
    this.notification = const [],

    this.totalPages = 1,

    this.currentPage = 1,

    this.pageSize = 20,
  });

  @override
  NotificationState copyWith({
    bool? loading,
    String? errorMessage,
    List<NotificationData>? notification,
    int? totalPages,
    int? currentPage,
    int? pageSize,
  }) {
    return NotificationState(
      loading: loading ?? this.loading,
      errorMessage: errorMessage ?? this.errorMessage,
      notification: notification ?? this.notification,
      totalPages: totalPages ?? this.totalPages,
      currentPage: currentPage ?? this.currentPage,
      pageSize: pageSize ?? this.pageSize,
    );
  }

  NotificationState clearFiles() {
    return NotificationState(
      loading: loading,
      errorMessage: errorMessage,
      notification: notification,
      totalPages: totalPages,
      currentPage: currentPage,
      pageSize: pageSize,
    );
  }
}

class NotificationViewModel extends BaseViewModel<NotificationState> {
  final NotificationRepository _repository;
  NotificationViewModel({required this._repository})
    : super(initialState: const NotificationState());

 Future<List<NotificationData>> fetchNotifications({int page = 1}) async {
  state = state.copyWith(loading: true);

  List<NotificationData> fetchedPage = <NotificationData>[];

  await runSafely(() async {
    final response = await _repository.fetchNotification(
      page: page,
      limit: state.pageSize,
    );

    fetchedPage = response.data ?? <NotificationData>[];

    final List<NotificationData> newNotification = page == 1
        ? fetchedPage
        : <NotificationData>[
            ...state.notification,
            ...fetchedPage,
          ];

    state = state.copyWith(
      notification: newNotification,
      totalPages: response.totalPages,
      currentPage: response.page,
      loading: false,
    );
  });

  if (state.loading) {
    state = state.copyWith(loading: false);
  }

  return fetchedPage;
}
  @override
  void onError(String message) {
    state = state.copyWith(loading: false);
    super.onError(message);
  }
}
