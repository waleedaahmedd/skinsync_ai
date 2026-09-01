import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../models/responses/auth_response.dart';
import '../view_models/clinic_view_model.dart';
import '../widgets/app_loader.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_search_field.dart';
import '../widgets/requested_clinic_treatment_widget.dart';
import 'patient_treatment_requests_screen.dart';

class SharedTreatmentRequestsScreen extends ConsumerStatefulWidget {
  static const String routeName = '/shared-treatment-requests';

  final String? title;

  const SharedTreatmentRequestsScreen({super.key, this.title});

  @override
  ConsumerState<SharedTreatmentRequestsScreen> createState() =>
      _SharedTreatmentRequestsScreenState();
}

class _SharedTreatmentRequestsScreenState
    extends ConsumerState<SharedTreatmentRequestsScreen> {
  late final PagingController<int, RequestClinicTreatmentModel>
  _pagingController;
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  int _totalPages = 1;

  @override
  void initState() {
    super.initState();
    _pagingController = PagingController<int, RequestClinicTreatmentModel>(
      getNextPageKey: (state) {
        if (state.lastPageIsEmpty) return null;
        final nextKey = (state.keys?.last ?? 0) + 1;
        return nextKey > _totalPages ? null : nextKey;
      },
      fetchPage: (pageKey) => _fetchPage(pageKey),
    );
  }

  @override
  void dispose() {
    _pagingController.dispose();
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  Future<List<RequestClinicTreatmentModel>> _fetchPage(int pageKey) async {
  final notifier = ref.read(clinicProvider.notifier);
  final newItems = await notifier.fetchSharedClinic(
    pageKey,
    search: _searchController.text.trim(),
  );
  final apiTotalPages = ref.read(clinicProvider).totalPages ?? 1;
  _totalPages = apiTotalPages < 1 ? 1 : apiTotalPages;
  return newItems ?? [];
}
  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _pagingController.refresh();
    });
  }

@override
Widget build(BuildContext context) {
  final isLoading = ref.watch(clinicProvider.select((s) => s.loading));
  final argsTitle = ModalRoute.of(context)?.settings.arguments as String?;
  final screenTitle =
      widget.title ?? argsTitle ?? 'Shared Treatment Request';

  return Scaffold(
    appBar: CustomAppBar(
      showTitle: true,
      title: screenTitle,
    ),
    body: Stack(
      children: [
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: CustomSearchField(
                controller: _searchController,
                hintText: "Search Groups...",
                onChanged: _onSearchChanged,
              ),
            ),
            Expanded(
              child: PagingListener<int, RequestClinicTreatmentModel>(
                controller: _pagingController,
                builder: (context, state, fetchNextPage) => RefreshIndicator(
                  onRefresh: () => Future.sync(_pagingController.refresh),
                  child: PagedListView<int, RequestClinicTreatmentModel>(
                    state: state,
                    fetchNextPage: fetchNextPage,
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    builderDelegate:
                        PagedChildBuilderDelegate<RequestClinicTreatmentModel>(
                      itemBuilder: (context, request, index) {
                        return SizedBox(
                          width: double.infinity,
                          child: RequestClinicTreatmentCard(
                            data: request,
                            onTap: () {
                              if (request.id != null) {
                                Navigator.pushNamed(
                                  context,
                                  PatientTreatmentRequestsScreen.routeName,
                                  arguments: request.id,
                                );
                              }
                            },
                          ),
                        );
                      },
                      // first/new page indicators unchanged
                      firstPageProgressIndicatorBuilder: (context) =>
                          const Center(child: CircularProgressIndicator()),
                      newPageProgressIndicatorBuilder: (context) => const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                      noItemsFoundIndicatorBuilder: (context) => Center(
                        child: Text(
                          'No treatment requests found.',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ),
                      firstPageErrorIndicatorBuilder: (context) => Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Failed to load requests.',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            ElevatedButton(
                              onPressed: () => fetchNextPage(),
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        if (isLoading) const AppLoader(),
      ],
    ),
  );
}
}
