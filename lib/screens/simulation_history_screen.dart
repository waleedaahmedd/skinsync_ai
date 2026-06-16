import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../models/responses/simulation_history_response.dart';
import 'ar_face_model_Preview_screen.dart';
import '../utills/color_constant.dart';
import '../utills/custom_fonts.dart';
import '../utills/date_time_utills.dart';
import '../view_models/appointment_view_model.dart';
import '../widgets/app_loader.dart';
import '../widgets/custom_app_bar.dart';

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
    final dateFormat = DateFormat('MMMM dd, yyyy');
    for (var sim in simulations) {
      if (sim.createdAt != null) {
        final dateKey = dateFormat.format(sim.createdAt!);
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
          : ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              itemCount: sortedKeys.length,
              itemBuilder: (context, index) {
                final date = sortedKeys[index];
                final sims = groupedSimulations[date]!;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 15.h),
                      child: Text(date, style: CustomFonts.black18w600),
                    ),
                    ...sims.map((sim) => _buildSimulationCard(sim)),
                  ],
                );
              },
            ),
    );
  }

  Widget _buildSimulationCard(SimulationData sim) {
    return Container(
      margin: EdgeInsets.only(bottom: 20.h),
      padding: EdgeInsets.all(15.w),
      decoration: BoxDecoration(
        color: CustomColors.whiteColor,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
        border: Border.all(
          color: CustomColors.greyColor.withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  sim.treatmentName ?? "Unnamed Treatment",
                  style: CustomFonts.black16w600,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (sim.createdAt != null)
                Text(
                  sim.createdAt!.formattedTime,
                  style: CustomFonts.grey13w400,
                ),
            ],
          ),
          SizedBox(height: 15.h),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Before", style: CustomFonts.grey14w400),
                    SizedBox(height: 8.h),
                    _buildImage(sim.beforeImage),
                  ],
                ),
              ),
              SizedBox(width: 15.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("After", style: CustomFonts.grey14w400),
                    SizedBox(height: 8.h),
                    _buildImage(sim.afterImage),
                  ],
                ),
              ),
            ],
          ),
          if (sim.subsections != null && sim.subsections!.isNotEmpty) ...[
            SizedBox(height: 12.h),
            Wrap(
              spacing: 8.w,
              runSpacing: 5.h,
              children: sim.subsections!.map((sub) {
                return Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color: CustomColors.greyColor.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    "${sub.sectionName} (${sub.syringesQuantity})",
                    style: CustomFonts.black12w500,
                  ),
                );
              }).toList(),
            ),
          ],
          SizedBox(height: 10.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pushReplacementNamed(
                context,
                ArFaceModelPreviewScreen.routeName,
                arguments: sim,
              ),
              child: const Text('Use this simulation'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImage(String? imageUrl) {
    final image = CachedNetworkImage(
      imageUrl: imageUrl ?? '',
      // height: 140.h,
      width: double.infinity,
      fit: BoxFit.cover,
      placeholder: (context, url) => Container(
        height: 140.h,
        color: CustomColors.greyColor.withValues(alpha: 0.2),
        child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
      ),
      errorWidget: (context, url, error) => Container(
        height: 140.h,
        color: CustomColors.greyColor.withValues(alpha: 0.2),
        child: const Icon(
          Icons.broken_image,
          color: CustomColors.silverColor,
          size: 30,
        ),
      ),
    );
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: CustomColors.greyColor.withValues(alpha: 0.3),
        ),
      ),
      height: 140.h,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.r),
        child: InkWell(
          onTap: () => Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (_) => Scaffold(
                appBar: const CustomAppBar(showTitle: true, title: 'Image Viewer'),
                body: InteractiveViewer(
                  clipBehavior: Clip.none,
                  boundaryMargin: EdgeInsets.zero,
                  child: Center(child: image),
                ),
              ),
            ),
          ),
          child: image,
        ),
      ),
    );
  }
}
