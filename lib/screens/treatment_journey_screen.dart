import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:iconsax/iconsax.dart';

import '../models/responses/groups_list_response.dart';
import '../utills/color_constant.dart';
import '../utills/custom_fonts.dart';
import '../utills/date_time_utills.dart';
import '../view_models/treatment_journey_view_model.dart';
import '../widgets/app_loader.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_button.dart';
import 'treatment_journey_detail_screen.dart';

class TreatmentJourneyScreen extends ConsumerStatefulWidget {
  const TreatmentJourneyScreen({super.key});
  static const String routeName = '/TreatmentJourneyScreen';

  @override
  ConsumerState<TreatmentJourneyScreen> createState() =>
      _TreatmentJourneyScreenState();
}

class _TreatmentJourneyScreenState
    extends ConsumerState<TreatmentJourneyScreen> {
  final TextEditingController _groupNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(treatmentJourneyProvider.notifier).fetchTreatmentJourneyGroups();
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
              // Icon Container
              Container(
                height: context.w(72),
                width: context.w(72),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: CustomColors.lightBlueBackground,
                ),
                child: Center(
                  child: Icon(
                    Iconsax.add_square,
                    size: context.sp(32),
                    color: CustomColors.darkPurple,
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
          // EasyLoading.show(status: 'Loading options...');
          final success = await ref
              .read(treatmentJourneyProvider.notifier)
              .fetchOptions(group.id!);
          // EasyLoading.dismiss();

          if (success ?? false) {
            if(group.id != null){
              ref.read(treatmentJourneyProvider.notifier).setGroupId(group.id!);
            }
            
            Navigator.pushNamed(
              context,
              TreatmentJourneyDetailScreen.routeName,
              arguments: {'groupId': group.id, 'groupName': group.name},
            );
          }
        },
        borderRadius: BorderRadius.circular(context.r(16)),
        child: Padding(
          padding: EdgeInsets.all(context.w(16)),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(context.w(12)),
                decoration: const BoxDecoration(
                  color: CustomColors.lightBlueBackground,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.auto_graph_rounded,
                  color: CustomColors.darkPurple,
                  size: context.w(24),
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
                      "${group.simulationCount ?? 0} Simulations • ${group.createdAt?.formattedDate ?? ''}",
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
