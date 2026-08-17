import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../models/responses/simulation_history_response.dart';
import '../screens/ar_face_model_preview_screen.dart';
import '../utils/color_constant.dart';
import '../utils/custom_fonts.dart';
import '../utils/date_time_utils.dart';
import '../view_models/treatment_view_model.dart';
import 'custom_app_bar.dart';
import 'custom_button.dart';

class SimulationCard extends ConsumerWidget {
  final SimulationData sim;
  final bool showActionButton;
  final String? actionButtonText;
  final VoidCallback? onActionButtonPressed;
  final String? price;
  final bool showImages;
  final bool showTreatments;

  const SimulationCard({
    super.key,
    required this.sim,
    this.showActionButton = true,
    this.actionButtonText,
    this.onActionButtonPressed,
    this.price,
    this.showImages = true,
    this.showTreatments = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: EdgeInsets.only(bottom: context.h(20)),
      padding: EdgeInsets.all(context.w(15)),
      decoration: BoxDecoration(
        color: CustomColors.whiteColor,
        borderRadius: BorderRadius.circular(context.r(20)),
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
                  sim.treatments?.firstOrNull?.name ?? "Unnamed Treatment",
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
          if (showImages) ...[
            SizedBox(height: context.h(15)),
            _buildImagePair(
              context,
              "Front View",
              sim.frontImageBefore,
              sim.frontImageAfter,
            ),
            _buildImagePair(
              context,
              "Right View",
              sim.rightImageBefore,
              sim.rightImageAfter,
            ),
            _buildImagePair(
              context,
              "Left View",
              sim.leftImageBefore,
              sim.leftImageAfter,
            ),
          ],
          if (showTreatments &&
              sim.treatments != null &&
              sim.treatments!.isNotEmpty) ...[
            SizedBox(height: context.h(12)),
            Wrap(
              spacing: context.w(8),
              runSpacing: context.h(5),
              children: sim.treatments!
                  .expand((t) => t.areas ?? <SimulationArea>[])
                  .map((area) {
                    final material = area.materials?.firstOrNull;
                    final materialText = material != null
                        ? " (${material.selectedQuantity})"
                        : "";
                    return Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: context.w(10),
                        vertical: context.h(4),
                      ),
                      decoration: BoxDecoration(
                        color: CustomColors.greyColor.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(context.r(20)),
                      ),
                      child: Text(
                        "${area.name}$materialText",
                        style: CustomFonts.black12w500,
                      ),
                    );
                  })
                  .toList(),
            ),
          ],
          if (price != null) ...[
            SizedBox(height: context.h(15)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Total Price:", style: CustomFonts.grey14w400),
                Text(
                  price!,
                  style: CustomFonts.black18w600.copyWith(
                    color: CustomColors.darkPurple,
                  ),
                ),
              ],
            ),
          ],
          if (showActionButton) ...[
            SizedBox(height: context.h(10)),
            CustomButton(
              onPressed:
                  onActionButtonPressed ??
                  () async {
                    await ref
                        .read(treatmentViewModel.notifier)
                        .initializeSimulation(sim);
                    if (context.mounted) {
                      Navigator.pushNamed(
                        context,
                        ArFaceModelPreviewScreen.routeName,
                      );
                    }
                  },
              text: actionButtonText ?? 'Use this simulation',
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildImagePair(
    BuildContext context,
    String label,
    String? before,
    String? after,
  ) {
    if (before == null && after == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: context.h(8), top: context.h(5)),
          child: Text(label, style: CustomFonts.black14w600),
        ),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Before", style: CustomFonts.grey12w400),
                  SizedBox(height: context.h(6)),
                  _buildImage(context, before),
                ],
              ),
            ),
            SizedBox(width: context.w(15)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("After", style: CustomFonts.grey12w400),
                  SizedBox(height: context.h(6)),
                  _buildImage(context, after),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: context.h(10)),
      ],
    );
  }

  Widget _buildImage(BuildContext context, String? imageUrl) {
    final image = CachedNetworkImage(
      imageUrl: imageUrl ?? '',
      width: double.infinity,
      fit: BoxFit.cover,
      placeholder: (context, url) => Container(
        height: context.h(140),
        color: CustomColors.greyColor.withValues(alpha: 0.2),
        child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
      ),
      errorWidget: (context, url, error) => Container(
        height: context.h(140),
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
        borderRadius: BorderRadius.circular(context.r(12)),
        border: Border.all(
          color: CustomColors.greyColor.withValues(alpha: 0.3),
        ),
      ),
      height: context.h(140),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(context.r(12)),
        child: InkWell(
          onTap: () => Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (_) => Scaffold(
                appBar: const CustomAppBar(
                  showTitle: true,
                  title: 'Image Viewer',
                ),
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
