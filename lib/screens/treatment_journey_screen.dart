import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:iconsax/iconsax.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../models/responses/groups_list_response.dart';
import '../utils/assets.dart';
import '../utils/color_constant.dart';
import '../utils/custom_fonts.dart';
import '../utils/date_time_utils.dart';
import '../view_models/treatment_journey_view_model.dart';
import '../widgets/app_loader.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_search_field.dart';
import '../widgets/dialogs/delete_confirmation_dialog.dart';
import 'treatment_journey_detail_screen.dart';

class TreatmentJourneyScreen extends ConsumerStatefulWidget {
  final bool isTreatmentJourney;
  final bool isFromBottomNav;
  const TreatmentJourneyScreen({
    super.key,
    this.isFromBottomNav = false,
    this.isTreatmentJourney = true,
  });
  static const String routeName = '/TreatmentJourneyScreen';

  @override
  ConsumerState<TreatmentJourneyScreen> createState() =>
      _TreatmentJourneyScreenState();
}

class _TreatmentJourneyScreenState
    extends ConsumerState<TreatmentJourneyScreen> {
  final TextEditingController _groupNameController = TextEditingController();
  late bool isTreatmentJourney;
  late final PagingController<int, TreatmentJourneyGroup> _pagingController;
  bool _hasCheckedEmptyState = false;

  @override
  void initState() {
    super.initState();
    isTreatmentJourney = widget.isTreatmentJourney;
    _pagingController = ref
        .read(treatmentJourneyProvider.notifier)
        .pagingController;
    _pagingController.addListener(_maybeShowCreateDialogOnEmpty);
  }

  void _maybeShowCreateDialogOnEmpty() {
    if (_hasCheckedEmptyState) return;

    final state = _pagingController.value;
    // Wait until the first page has actually finished loading (not still
    // fetching, no error) before deciding it's empty.
    final firstPageLoaded =
        (state.pages?.isNotEmpty ?? false) &&
        !state.isLoading &&
        state.error == null;
    if (!firstPageLoaded) return;

    _hasCheckedEmptyState = true;
    if ((state.items?.isEmpty ?? true)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _showCreateGroupDialog();
      });
    }
  }

  @override
  void dispose() {
    _pagingController.removeListener(_maybeShowCreateDialogOnEmpty);
    _groupNameController.dispose();
    super.dispose();
  }

  void _showCreateGroupDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(context.r(24)),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: context.w(24),
            vertical: context.h(32),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon Container with Gradient Border
              Container(
                height: context.w(72),
                width: context.w(72),
                padding: EdgeInsets.all(context.w(2)),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: CustomColors.purpleBlueGradient,
                ),
                child: Container(
                  decoration: const BoxDecoration(
                    color: CustomColors.whiteColor,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(
                      Iconsax.add_square,
                      size: context.sp(32),
                      color: CustomColors.darkPurple,
                    ),
                  ),
                ),
              ),
              SizedBox(height: context.h(24)),

              // Title
              Text(
                "Create New Group",
                textAlign: TextAlign.center,
                style: CustomFonts.black20w600,
              ),
              SizedBox(height: context.h(20)),

              // TextFormField (inheriting theme)
              TextFormField(
                controller: _groupNameController,
                style: CustomFonts.black18w400,
                decoration: const InputDecoration(hintText: "Enter group name"),
              ),
              SizedBox(height: context.h(28)),

              // Action Button
              CustomButton(
                onPressed: () async {
                  if (_groupNameController.text.trim().isNotEmpty) {
                    final success = await ref
                        .read(treatmentJourneyProvider.notifier)
                        .createGroup(_groupNameController.text.trim());
                    if (!mounted) return;
                    if (success ?? false) {
                      _groupNameController.clear();
                      Navigator.pop(context);
                    }
                  }
                },
                text: "Create",
              ),
              SizedBox(height: context.h(12)),

              // Cancel Button
              SizedBox(
                width: double.infinity,
                height: context.h(52),
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    side: BorderSide(color: Colors.grey.shade300),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(context.r(26)),
                    ),
                  ),
                  child: Text(
                    "Cancel",
                    style: CustomFonts.black14w600.copyWith(
                      color: Colors.black54,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    
    ref.watch(treatmentJourneyProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        showTitle: true,
        showBackButton: !widget.isFromBottomNav,
        title: 'Treatment Journey',
        actions: [
          IconButton(
            onPressed: _showCreateGroupDialog,
            icon: const Icon(
              Icons.add_circle_outline_rounded,
              color: Colors.black,
            ),
            tooltip: "Create New Group",
          ),
        ],
      ),
      body: SafeArea(
        child: PagingListener<int, TreatmentJourneyGroup>(
          controller: _pagingController,
          builder: (context, state, fetchNextPage) {
            final items = state.items ?? const [];
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: context.w(24)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (items.isNotEmpty)
                    Padding(
                      padding: EdgeInsets.only(
                        top: context.h(10),
                        bottom: context.w(24),
                      ),
                      child: Text(
                        "Create a new journey group or select an existing one to manage your simulations and share them with clinics.",
                        style: CustomFonts.grey14w400.copyWith(height: 1.4),
                      ),
                    ),
                 
                  CustomSearchField(
                    
                    controller: ref
                        .read(treatmentJourneyProvider.notifier)
                        .searchController,
                    hintText: "Search Groups...",
                    onChanged: (query) {
                      ref
                          .read(treatmentJourneyProvider.notifier)
                          .searchGroups(query);
                    },
                  ),
                  SizedBox(height: context.h(20)),
                  Expanded(
                    child: SlidableAutoCloseBehavior(
                      child: PagedListView<int, TreatmentJourneyGroup>(
                        state: state,
                        fetchNextPage: fetchNextPage,
                        physics: const BouncingScrollPhysics(),
                        padding: EdgeInsets.only(
                        
                          bottom: context.h(20),
                        ),
                        builderDelegate:
                            PagedChildBuilderDelegate<TreatmentJourneyGroup>(
                              itemBuilder: (context, group, index) =>
                                  _buildGroupCard(context, group, index),
                              firstPageProgressIndicatorBuilder: (context) =>
                                  const Center(child: AppLoader()),
                              newPageProgressIndicatorBuilder: (context) =>
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: context.h(16),
                                    ),
                                    child: const Center(child: AppLoader()),
                                  ),
                              noItemsFoundIndicatorBuilder: (context) =>
                                  _buildEmptyGroupsView(),
                              firstPageErrorIndicatorBuilder: (context) =>
                                  _buildEmptyGroupsView(),
                            ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Center _buildEmptyGroupsView() {
    return Center(
      child: Text(
        ref.read(treatmentJourneyProvider).errorMessage ?? "No journeys found",
        style: CustomFonts.grey16w400,
      ),
    );
  }

  Widget _buildGroupCard(
    BuildContext context,
    TreatmentJourneyGroup group,
    int index,
  ) {
    return Slidable(
      key: ValueKey(group.id ?? 'group_$index'),
      groupTag: 'treatment_journey_groups',
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        extentRatio: 0.22,
        children: [
          CustomSlidableAction(
            alignment: .center,
            onPressed: (_) {
              if (group.id != null) {
                showDeleteConfirmationDialog(
                  context: context,
                  title: "Delete Group?",
                  description:
                      "Are you sure you want to delete '${group.name}'? This action cannot be undone.",
                  onDelete: () {
                    ref
                        .read(treatmentJourneyProvider.notifier)
                        .callDeleteGroup(group.id!);
                  },
                );
              }
            },
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.white,

            padding: EdgeInsets.only(bottom: 10.h),
            child: Icon(
              Icons.delete_outline_rounded,
              color: Colors.red,
              size: context.sp(24),
            ),
          ),
        ],
      ),
      child: Container(
        margin: EdgeInsets.only(bottom: context.h(16)),
        decoration: BoxDecoration(
          color: CustomColors.whiteColor,
          borderRadius: BorderRadius.circular(context.r(16)),
          border: Border.all(
            color: CustomColors.greyColor.withValues(alpha: 0.5),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: InkWell(
          onTap: () async {
            if (group.id != null) {
              ref.read(treatmentJourneyProvider.notifier).setGroup(group);
            }
            if (!isTreatmentJourney) {
              final success = await ref
                  .read(treatmentJourneyProvider.notifier)
                  .fetchOptions(group.id!);
              if (!mounted) return;
              if (success ?? false) {
                final result = await ref
                    .read(treatmentJourneyProvider.notifier)
                    .createTjOptions();
                if (!mounted) return;
                if (result == true) {
                  isTreatmentJourney = true;
                  final refetchSuccess = await ref
                      .read(treatmentJourneyProvider.notifier)
                      .fetchOptions(group.id!);
                  if (!mounted) return;
                  if (refetchSuccess ?? false) {
                    Navigator.pushNamed(
                      context,
                      TreatmentJourneyDetailScreen.routeName,
                      arguments: {'groupId': group.id, 'groupName': group.name},
                    );
                  }
                }
              }
            } else {
              final success = await ref
                  .read(treatmentJourneyProvider.notifier)
                  .fetchOptions(group.id!);
              if (!mounted) return;
              if (success ?? false) {
                Navigator.pushNamed(
                  context,
                  TreatmentJourneyDetailScreen.routeName,
                  arguments: {'groupId': group.id, 'groupName': group.name},
                );
              }
            }
          },
          borderRadius: BorderRadius.circular(context.r(16)),
          child: Padding(
            padding: EdgeInsets.all(context.w(16)),
            child: Row(
              children: [
                Container(
                  height: context.w(50),
                  width: context.w(50),
                  padding: EdgeInsets.all(
                    context.w(1.5),
                  ), // Gradient Border thickness
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: CustomColors.purpleBlueGradient,
                  ),
                  child: Container(
                    padding: EdgeInsets.all(context.w(8)),
                    decoration: const BoxDecoration(
                      color: CustomColors.whiteColor,
                      shape: BoxShape.circle,
                    ),
                    child: Image.asset(
                      PngAssets.splashLogo,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                SizedBox(width: context.w(16)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        group.name ?? "Unnamed Journey",
                        style: CustomFonts.black18w600,
                      ),
                      SizedBox(height: context.h(4)),
                      Text(
                        "${group.totalOptions ?? 0} Simulations • ${group.createdAt?.formattedDate ?? ''}",
                        style: CustomFonts.grey14w400,
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: Colors.grey.shade400,
                  size: context.sp(24),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
