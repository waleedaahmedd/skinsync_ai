import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../models/responses/simulation_history_response.dart';
import '../utils/color_constant.dart';
import '../utils/custom_fonts.dart';
import '../utils/date_time_utils.dart';
import '../view_models/appointment_view_model.dart';
import '../widgets/app_loader.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_button.dart';
import '../widgets/medical_disclaimer_banner.dart';
import '../widgets/simulation_card.dart';
import 'face_pose_capture_screen.dart';

  class SimulationHistoryScreen extends ConsumerStatefulWidget {
  static const String routeName = "/simulation_history_screen";
  const SimulationHistoryScreen({super.key});

  @override
  ConsumerState<SimulationHistoryScreen> createState() =>
      _SimulationHistoryScreenState();
}

class _SimulationHistoryScreenState
    extends ConsumerState<SimulationHistoryScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(appointmentProvider.notifier).fetchSimulationHistory();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(appointmentProvider);
    final simulations = state.simulations;
    final Map<String, List<SimulationData>> groupedSimulations = {};
    for (var sim in simulations) {
      if (sim.createdAt != null) {
        final dateKey = sim.createdAt!.formattedFullDate;
        if (groupedSimulations.containsKey(dateKey)) {
          groupedSimulations[dateKey]!.add(sim);
        } else {
          groupedSimulations[dateKey] = [sim];
        }
      }
    }

    final sortedKeys = groupedSimulations.keys.toList();

    return Scaffold(
      backgroundColor: CustomColors.whiteColor,
      appBar: const CustomAppBar(showTitle: true, title: 'Simulation History'),
      body: state.loading
          ? const Center(child: AppLoader())
          : simulations.isEmpty
          ? Center(
              child: Text(
                state.errorMessage ?? "No history found",
                style: CustomFonts.grey16w400,
              ),
            )
          : Column(
              children: [
                const MedicalDisclaimerBanner(),
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(
                      horizontal: context.w(20),
                      vertical: context.h(10),
                    ),
                    itemCount: sortedKeys.length,
                    itemBuilder: (context, index) {
                      final date = sortedKeys[index];
                      final sims = groupedSimulations[date]!;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: context.h(15),
                            ),
                            child: Text(date, style: CustomFonts.black18w600),
                          ),
                          ...sims.map((sim) => SimulationCard(sim: sim)),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
      bottomNavigationBar: Padding(
        padding: .all(context.w(20)),
        child: CustomButton(
          text: 'Try another pose',
          onPressed: () => Navigator.pushReplacementNamed(
            context,
            FacePoseCaptureScreen.routeName,
          ),
        ),
      ),
    );
  }
}
