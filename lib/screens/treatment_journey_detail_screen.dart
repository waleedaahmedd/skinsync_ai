import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../utills/color_constant.dart';
import '../utills/custom_fonts.dart';
import '../view_models/checkout_view_model.dart';
import '../view_models/treatment_journey_view_model.dart';
import '../view_models/treatment_view_model.dart';
import '../widgets/app_loader.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/simulation_card.dart';
import 'face_pose_capture_screen.dart';
import 'journey_clinics_screen.dart';

class TreatmentJourneyDetailScreen extends ConsumerStatefulWidget {
  final int groupId;
  final String groupName;

  const TreatmentJourneyDetailScreen({
    super.key,
    required this.groupId,
    required this.groupName,
  });

  static const String routeName = '/TreatmentJourneyDetailScreen';

  @override
  ConsumerState<TreatmentJourneyDetailScreen> createState() =>
      _TreatmentJourneyDetailScreenState();
}

class _TreatmentJourneyDetailScreenState
    extends ConsumerState<TreatmentJourneyDetailScreen>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  void _setupTabController(int length) {
    if (_tabController == null || _tabController!.length != length) {
      _tabController?.dispose();
      _tabController = TabController(length: length, vsync: this);
      _tabController!.addListener(() {
        if (!_tabController!.indexIsChanging) {
          final options = ref.read(treatmentJourneyProvider).options;
          if (options.isNotEmpty) {
            ref
                .read(treatmentJourneyProvider.notifier)
                .fetchSimulations(options[_tabController!.index].id!);
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(treatmentJourneyProvider);

    if (state.options.isNotEmpty) {
      _setupTabController(state.options.length);
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        showTitle: true,
        title: widget.groupName,
        actions: [
          IconButton(
            onPressed: () {
              ref.read(checkoutViewModel.notifier).clearState();
              ref
                  .read(treatmentViewModel.notifier)
                  .clearAllSelectedTreatments();
              ref.read(treatmentViewModel.notifier).clearAiImage();
              Navigator.of(context).pushNamed(FacePoseCaptureScreen.routeName);
            },
            icon: const Icon(
              Icons.add_circle_outline_rounded,
              color: Colors.black,
            ),
            tooltip: "Add More Options",
          ),
        ],
      ),
      body: state.loading
          ? const Center(child: AppLoader())
          : state.options.isEmpty
          ? Center(
              child: Text(
                state.errorMessage ?? "No options available",
                style: CustomFonts.grey16w400,
              ),
            )
          : Column(
              children: [
                TabBar(
                  controller: _tabController,
                  isScrollable: state.options.length > 3,
                  indicatorColor: CustomColors.darkPurple,
                  indicatorSize: TabBarIndicatorSize.label,
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.grey.shade500,
                  labelStyle: CustomFonts.black16w600,
                  unselectedLabelStyle: CustomFonts.grey16w500,
                  dividerColor: Colors.transparent,
                  tabs: state.options
                      .map((opt) => Tab(text: opt.name))
                      .toList(),
                ),
                Expanded(
                  child: state.isSimulationsLoading
                      ? const Center(child: AppLoader())
                      : TabBarView(
                          controller: _tabController,
                          children: state.options.map((opt) {
                            return _buildSimulationsList(context, state);
                          }).toList(),
                        ),
                ),
              ],
            ),
    );
  }

  Widget _buildSimulationsList(
    BuildContext context,
    TreatmentJourneyState state,
  ) {
    if (state.simulations.isEmpty) {
      return Center(
        child: Text(
          "No simulations for this option",
          style: CustomFonts.grey16w400,
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(
        horizontal: context.w(24),
        vertical: context.h(20),
      ),
      itemCount: state.simulations.length,
      itemBuilder: (context, index) {
        final sim = state.simulations[index];
        final isLast = index == state.simulations.length - 1;
        return SimulationCard(
          sim: sim,
          price: isLast ? state.price : null,
          showActionButton: true,
          actionButtonText: "Select this Option",
          onActionButtonPressed: () {
            Navigator.pushNamed(context, JourneyClinicsScreen.routeName);
          },
        );
      },
    );
  }
}
