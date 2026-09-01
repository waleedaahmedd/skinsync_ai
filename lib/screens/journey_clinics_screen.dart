import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../models/responses/get_clinic_response.dart';
import '../utils/color_constant.dart';
import '../utils/custom_fonts.dart';
import '../view_models/clinic_view_model.dart';
import '../widgets/app_loader.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_clinic_grid_view_title.dart';
import '../widgets/custom_search_field.dart';
import 'journey_clinic_detail_screen.dart';

class JourneyClinicsScreen extends ConsumerStatefulWidget {
  const JourneyClinicsScreen({super.key});

  static const String routeName = '/JourneyClinicsScreen';

  @override
  ConsumerState<JourneyClinicsScreen> createState() =>
      _JourneyClinicsScreenState();
}

class _JourneyClinicsScreenState extends ConsumerState<JourneyClinicsScreen> {
  Timer? _timer;
  final _searchController = TextEditingController();
  bool _switchedToMapSource = false;
  Future<void>? _mapClinicsFuture;

  late final _pagingController = PagingController<int, Clinic>(
    getNextPageKey: (state) {
      final lastPageLength = state.pages?.lastOrNull?.length;
      if (lastPageLength == null) {
        return 1;
      }
      // Once we've switched to (and appended) map results within a page,
      // there's nothing more to fetch — map results aren't paginated.
      if (_switchedToMapSource) {
        return null;
      }
      return state.nextIntPageKey;
    },
    fetchPage: (page) async {
      final search = _searchController.text.trim();
      if (!ref.context.mounted) {
        return [];
      }
      final clinics =
          await ref
              .read(clinicProvider.notifier)
              .getClinic(page: page, search: search) ??
          [];

      // getClinic API had fewer than a full page (or none) — append map
      // results into THIS SAME page, instead of waiting for another
      // fetchPage call that scroll might never trigger.
      if (clinics.length < 10) {
        _switchedToMapSource = true;
        if (!ref.context.mounted) {
          return [];
        }
        _mapClinicsFuture ??= ref
            .read(clinicProvider.notifier)
            .fetchClinicsFromMap(search: search);
        await _mapClinicsFuture;
        if (!ref.context.mounted) {
          return [];
        }
        final mapClinics = ref.read(clinicProvider).clinicsToInvite;
        return [...clinics, ...mapClinics];
      }

      return clinics;
    },
  );

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      _mapClinicsFuture = ref
          .read(clinicProvider.notifier)
          .fetchClinicsFromMap();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _searchController.dispose();
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(clinicProvider);

    return Scaffold(
      backgroundColor: CustomColors.whiteColor,
      appBar: const CustomAppBar(showTitle: true, title: "Select Clinic"),
      body: Column(
        children: [
          SizedBox(height: context.h(20)),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: context.w(24)),
            child: CustomSearchField(
              controller: _searchController,
              hintText: "Search Clinics...",
              onChanged: (query) {
                _timer?.cancel();
                _timer = Timer(const Duration(milliseconds: 500), () {
                  _switchedToMapSource = false;
                  _mapClinicsFuture = null; // fresh map fetch for new search
                  _pagingController.refresh();
                });
              },
            ),
          ),
          SizedBox(height: context.h(16)),
          Expanded(
            child: PagingListener<int, Clinic>(
              controller: _pagingController,
              builder: (_, state, fetchNextPage) {
                return PagedGridView<int, Clinic>(
                  padding: EdgeInsets.only(
                    left: context.w(24),
                    right: context.w(24),
                    top: context.h(8),
                    bottom: context.h(
                      MediaQuery.paddingOf(context).bottom + 20,
                    ),
                  ),
                  state: state,
                  fetchNextPage: fetchNextPage,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: context.isLessThan(Breakpoint.md)
                        ? 0.90
                        : 1.65,
                    crossAxisSpacing: context.w(14),
                    mainAxisSpacing: context.h(14),
                  ),
                  builderDelegate: PagedChildBuilderDelegate(
                    noItemsFoundIndicatorBuilder: (_) =>
                        _buildEmptyClinicsView(),
                    firstPageErrorIndicatorBuilder: (_) =>
                        _buildEmptyClinicsView(),
                    firstPageProgressIndicatorBuilder: (_) => const AppLoader(),
                    newPageProgressIndicatorBuilder: (_) => const AppLoader(),
                    itemBuilder: (_, clinic, _) {
                      return CustomClinicGridViewTile(
                        clinicData: clinic,
                        onTap: () {
                          ref.read(clinicProvider.notifier).setClinic(clinic);
                          Navigator.pushNamed(
                            context,
                            JourneyClinicDetailScreen.routeName,
                            arguments: clinic,
                          );
                        },
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Center _buildEmptyClinicsView() {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: context.w(40)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.storefront_rounded,
              size: context.sp(64),
              color: Colors.grey.shade300,
            ),
            SizedBox(height: context.h(16)),
            Text("No Clinics Found", style: CustomFonts.grey800_20w600),
            SizedBox(height: context.h(6)),
            Text(
              "Try searching for a different keyword or check back later.",
              textAlign: TextAlign.center,
              style: CustomFonts.textGrey14w400,
            ),
          ],
        ),
      ),
    );
  }
}
