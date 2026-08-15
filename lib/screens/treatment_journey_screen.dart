import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:iconsax/iconsax.dart';

import '../models/responses/groups_list_response.dart';
import '../utills/assets.dart';
import '../utills/color_constant.dart';
import '../utills/custom_fonts.dart';
import '../utills/date_time_utills.dart';
import '../view_models/treatment_journey_view_model.dart';
import '../widgets/app_loader.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_button.dart';
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
  @override
  void initState() {
    super.initState();
    isTreatmentJourney = widget.isTreatmentJourney;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final result = await ref
          .read(treatmentJourneyProvider.notifier)
          .fetchTreatmentJourneyGroups();
      if (result == 'show') {
        _showCreateGroupDialog();
      }
    });
  }

  @override
  void dispose() {
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
    final state = ref.watch(treatmentJourneyProvider);

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
      body: state.loading
          ? const Center(child: AppLoader())
          : state.groups.isEmpty
          ? Center(
              child: Text(
                state.errorMessage ?? "No journeys found",
                style: CustomFonts.grey16w400,
              ),
            )
          : ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(
                horizontal: context.w(24),
                vertical: context.h(20),
              ),
              itemCount: state.groups.length,
              itemBuilder: (context, index) {
                final group = state.groups[index];
                return _buildGroupCard(context, group);
              },
            ),
    );
  }

  Widget _buildGroupCard(BuildContext context, TreatmentJourneyGroup group) {
    return Container(
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
            if (success ?? false) {
              final result = await ref
                  .read(treatmentJourneyProvider.notifier)
                  .createTjOptions();
              if (result == true) {
                Navigator.pop(context);
              }
            }
          } else {
            final success = await ref
                .read(treatmentJourneyProvider.notifier)
                .fetchOptions(group.id!);
            // EasyLoading.dismiss();

            if (success ?? false) {
              Navigator.pushNamed(
                context,
                TreatmentJourneyDetailScreen.routeName,
                arguments: {'groupId': group.id, 'groupName': group.name},
              );
            }
          }
          // EasyLoading.show(status: 'Loading options...');
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
                  child: Image.asset(PngAssets.splashLogo, fit: BoxFit.contain),
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
    );
  }
}
