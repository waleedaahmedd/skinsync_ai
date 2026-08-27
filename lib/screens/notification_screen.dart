import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../models/responses/notification_response.dart';
import '../utils/color_constant.dart';
import '../utils/custom_fonts.dart';
import '../view_models/notification_view_model.dart';
import '../widgets/app_loader.dart';
import '../widgets/custom_app_bar.dart';

class NotificationScreen extends ConsumerStatefulWidget {
  const NotificationScreen({super.key});

  static const String routeName = '/NotificationScreen';

  @override
  ConsumerState<NotificationScreen> createState() =>
      _NotificationScreenState();
}

class _NotificationScreenState extends ConsumerState<NotificationScreen> {
  late final _pagingController = PagingController<int, NotificationData>(
    getNextPageKey: (state) {
      // First page
      if (state.keys == null || state.keys!.isEmpty) {
        return 1;
      }

      final lastPageKey = state.keys!.last;

      final viewModelState = ref.read(notificationViewModel);

      // No more pages
      if (lastPageKey >= viewModelState.totalPages) {
        return null;
      }

      return lastPageKey + 1;
    },
    fetchPage: (pageKey) async {
      final viewModel = ref.read(notificationViewModel.notifier);

      // Fetch only this page.
      // PagingController will handle accumulating the pages.
      final notifications = await viewModel.fetchNotifications(
        page: pageKey,
      );

      return notifications;
    },
  );

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        showTitle: true,
        title: 'Notifications',
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          _pagingController.refresh();
        },
        child: PagingListener<int, NotificationData>(
          controller: _pagingController,
          builder: (context, state, fetchNextPage) {
            return PagedListView<int, NotificationData>(
              state: state,
              fetchNextPage: fetchNextPage,
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              builderDelegate: PagedChildBuilderDelegate<NotificationData>(
                itemBuilder: (
                  BuildContext context,
                  NotificationData notification,
                  int index,
                ) {
                  return NotificationTile(
                    notification: notification,
                  );
                },

                // Loading first page
                firstPageProgressIndicatorBuilder: (context) {
                  return const Center(
                    child: AppLoader(),
                  );
                },

                // Loading next page
                newPageProgressIndicatorBuilder: (context) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Center(
                      child: AppLoader(),
                    ),
                  );
                },

                // Error while loading first page
                firstPageErrorIndicatorBuilder: (context) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            size: 48,
                            color: Colors.red,
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Failed to load notifications',
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 12),
                          ElevatedButton(
                            onPressed: () {
                              _pagingController.refresh();
                            },
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    ),
                  );
                },

                // Error while loading next page
                newPageErrorIndicatorBuilder: (context) {
                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: Center(
                      child: ElevatedButton(
                        onPressed: () {
                          fetchNextPage();
                        },
                        child: const Text('Retry'),
                      ),
                    ),
                  );
                },

                // Empty state
                noItemsFoundIndicatorBuilder: (context) {
                  return Center(
                    child: Text(
                      'No Notifications Yet',
                      style: CustomFonts.grey16w400,
                    ),
                  );
                },

                // End of pagination
                noMoreItemsIndicatorBuilder: (context) {
                  return const SizedBox.shrink();
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

class NotificationTile extends StatelessWidget {
  final NotificationData notification;

  const NotificationTile({
    super.key,
    required this.notification,
  });

  @override
  Widget build(BuildContext context) {
    final bool isUnread =
        notification.status?.toLowerCase() == 'unread';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
       
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color:  CustomColors.purpleColor,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isUnread
                  ? Colors.blue.shade100
                  : Colors.grey.shade100,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.notifications_outlined,
              color: CustomColors.purpleColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        notification.title ?? 'No Title',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: isUnread
                              ? FontWeight.bold
                              : FontWeight.w600,
                          color: Colors.black,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    if (notification.createdAt != null) ...[
                      const SizedBox(width: 8),
                      Text(
                        _formatTimestamp(
                          notification.createdAt!,
                        ),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ],
                ),

                const SizedBox(height: 6),

                Text(
                  notification.body ?? '',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade700,
                    height: 1.3,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(DateTime dateTime) {
    final Duration difference =
        DateTime.now().difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Just now';
    }

    if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    }

    if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    }

    if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    }

    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }
}