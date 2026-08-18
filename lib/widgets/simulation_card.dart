import 'package:before_after/before_after.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../models/responses/simulation_history_response.dart';
import '../models/responses/treatment_list_response.dart';
import '../screens/ar_face_model_preview_screen.dart';
import '../screens/treatment_detail_screen.dart';
import '../utils/assets.dart';
import '../utils/color_constant.dart';
import '../utils/custom_fonts.dart';
import '../utils/date_time_utils.dart';
import '../view_models/treatment_view_model.dart';
import 'custom_app_bar.dart';
import 'custom_button.dart';
import 'simulation_treatment_area_chip.widget.dart';

class SimulationCard extends ConsumerStatefulWidget {
  final SimulationData sim;
  final bool showActionButton;
  final String? actionButtonText;
  final VoidCallback? onActionButtonPressed;
  final String? price;
  final bool showImages;
  final bool showTreatments;
  final bool showCreatedAt;
  final VoidCallback? onDelete;
  final double? width;

  const SimulationCard({
    super.key,
    required this.sim,
    this.showActionButton = true,
    this.actionButtonText,
    this.onActionButtonPressed,
    this.price,
    this.showImages = true,
    this.showTreatments = true,
    this.showCreatedAt = true,
    this.onDelete,
    this.width,
  });

  @override
  ConsumerState<SimulationCard> createState() => _SimulationCardState();
}

class _SimulationCardState extends ConsumerState<SimulationCard> {
  bool _isComparisonMode = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width ?? double.infinity,
      margin: EdgeInsets.only(bottom: context.h(20)),
      padding: EdgeInsets.all(context.w(20)),
      decoration: BoxDecoration(
        color: CustomColors.whiteColor,
        borderRadius: BorderRadius.circular(context.r(24)),
        boxShadow: [
          BoxShadow(
            color: CustomColors.lightBlueColor.withValues(alpha: 0.15),
            blurRadius: 25,
            offset: const Offset(-8, 10),
          ),
          BoxShadow(
            color: CustomColors.darkPurple.withValues(alpha: 0.15),
            blurRadius: 25,
            offset: const Offset(8, 10),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: CustomColors.greyColor.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.showCreatedAt && widget.sim.createdAt != null)
            Padding(
              padding: EdgeInsets.only(bottom: context.h(8)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("Created at:", style: CustomFonts.grey13w400),
                      SizedBox(width: context.w(8)),
                      Text(
                        widget.sim.createdAt!.formattedDateTime,
                        style: CustomFonts.grey13w400,
                      ),
                    ],
                  ),
                  if (widget.onDelete != null)
                    IconButton(
                      onPressed: widget.onDelete,
                      icon: const Icon(
                        Icons.delete_outline_rounded,
                        color: Colors.red,
                        size: 22,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      visualDensity: VisualDensity.compact,
                    ),
                ],
              ),
            )
          else if (widget.onDelete != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: widget.onDelete,
                  icon: const Icon(
                    Icons.delete_outline_rounded,
                    color: Colors.red,
                    size: 22,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
          if (widget.showImages) ...[
            SizedBox(height: context.h(12)),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.w(12),
                    vertical: context.h(2),
                  ),
                  decoration: BoxDecoration(
                    color: CustomColors.greyColor.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(context.r(12)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _isComparisonMode ? "Slider View" : "Side by Side",
                        style: CustomFonts.black14w600.copyWith(
                          fontSize: context.sp(12),
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(width: context.w(4)),
                      Transform.scale(
                        scale: 0.7,
                        child: Switch.adaptive(
                          value: _isComparisonMode,
                          activeTrackColor: CustomColors.lightBlueColor,
                          activeThumbColor: Colors.white,
                          inactiveTrackColor: Colors.grey.shade300,
                          onChanged: (val) {
                            setState(() {
                              _isComparisonMode = val;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: context.h(10)),
            _buildImagePair(
              context,
              "Front View",
              widget.sim.frontImageBefore,
              widget.sim.frontImageAfter,
            ),
            _buildImagePair(
              context,
              "Right View",
              widget.sim.rightImageBefore,
              widget.sim.rightImageAfter,
            ),
            _buildImagePair(
              context,
              "Left View",
              widget.sim.leftImageBefore,
              widget.sim.leftImageAfter,
            ),
          ],
          if (widget.showTreatments &&
              widget.sim.treatments != null &&
              widget.sim.treatments!.isNotEmpty) ...[
            SizedBox(height: context.h(8)),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(widget.sim.treatments!.length, (index) {
                final treatment = widget.sim.treatments![index];
                final isLast = index == widget.sim.treatments!.length - 1;
                return Padding(
                  padding: EdgeInsets.only(bottom: isLast ? 0 : context.h(12)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: context.h(6)),
                        child: Text(
                          "Treatment - ${index + 1}",
                          style: CustomFonts.black16w600,
                        ),
                      ),
                      // Treatment chip - visibility icon, tap opens TreatmentDetailScreen
                      SimulationTreatmentAreaChip(
                        icon: treatment.icon,
                        label: treatment.name ?? "Unnamed Treatment",
                        isTreatment: true,
                        imageUrl: treatment.image,
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            TreatmentDetailScreen.routeName,
                            arguments: TreatmentData(
                              id: treatment.id,
                              name: treatment.name,
                              icon: treatment.icon,
                              description: treatment.description,
                              shortDescription: treatment.description,
                              image: treatment.image,
                              imageUrl: treatment.image,
                              isArea: true,
                            ),
                          );
                        },
                      ),
                      if (treatment.areas != null &&
                          treatment.areas!.isNotEmpty) ...[
                        SizedBox(height: context.h(10)),
                        Padding(
                          padding: EdgeInsets.only(
                            left: context.w(4),
                            bottom: context.h(8),
                          ),
                          child: Text(
                            "Selected Areas",
                            style: CustomFonts.black16w600,
                          ),
                        ),
                        Wrap(
                          spacing: context.w(8),
                          runSpacing: context.h(5),
                          children: treatment.areas!.map((area) {
                            final materialCount =
                                area.materials
                                    ?.where(
                                      (m) => (m.selectedQuantity ?? 0) > 0,
                                    )
                                    .length ??
                                0;

                            return SimulationTreatmentAreaChip(
                              icon: area.icon,
                              label: area.name ?? "",
                              isTreatment: false,
                              materialCount: materialCount,
                              imageUrl: area.image,
                            );
                          }).toList(),
                        ),
                      ],
                    ],
                  ),
                );
              }),
            ),
          ],
          if (widget.price != null) ...[
            SizedBox(height: context.h(10)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Total Price:", style: CustomFonts.grey14w400),
                Text(
                  widget.price!,
                  style: CustomFonts.black18w600.copyWith(
                    color: CustomColors.darkPurple,
                  ),
                ),
              ],
            ),
          ],
          if (widget.showActionButton) ...[
            SizedBox(height: context.h(8)),
            CustomButton(
              onPressed:
                  widget.onActionButtonPressed ??
                  () async {
                    await ref
                        .read(treatmentViewModel.notifier)
                        .initializeSimulation(widget.sim);
                    if (context.mounted) {
                      Navigator.pushNamed(
                        context,
                        ArFaceModelPreviewScreen.routeName,
                      );
                    }
                  },
              text: widget.actionButtonText ?? 'Use this simulation',
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
        if (_isComparisonMode)
          _ComparisonView(before: before, after: after)
        else
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

class _ComparisonView extends StatefulWidget {
  final String? before;
  final String? after;

  const _ComparisonView({required this.before, required this.after});

  @override
  State<_ComparisonView> createState() => _ComparisonViewState();
}

class _ComparisonViewState extends State<_ComparisonView> {
  double _sliderValue = 0.5;

  @override
  Widget build(BuildContext context) {
    if (widget.before == null || widget.after == null) {
      return const SizedBox.shrink();
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(context.r(12)),
        border: Border.all(
          color: CustomColors.greyColor.withValues(alpha: 0.3),
        ),
      ),
      height: context.h(250),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(context.r(12)),
        child: Stack(
          children: [
            BeforeAfter(
              value: _sliderValue,
              onValueChanged: (value) => setState(() => _sliderValue = value),
              before: _buildComparisonImage(context, widget.before!),
              after: _buildComparisonImage(context, widget.after!),
              trackColor: Colors.white,
              trackWidth: context.w(2),
              thumbDecoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(PngAssets.customMarker),
                  fit: BoxFit.contain,
                ),
              ),
              thumbWidth: context.w(32),
              thumbHeight: context.w(32),
            ),
            Positioned(
              top: context.h(12),
              left: context.w(12),
              child: _buildBadge(
                context,
                "BEFORE",
                Colors.black.withValues(alpha: 0.6),
              ),
            ),
            Positioned(
              top: context.h(12),
              right: context.w(12),
              child: _buildBadge(
                context,
                "AFTER",
                Colors.black.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildComparisonImage(BuildContext context, String imageUrl) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: double.infinity,
      height: context.h(250),
      fit: BoxFit.cover,
      placeholder: (context, url) => Container(
        color: CustomColors.greyColor.withValues(alpha: 0.2),
        child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
      ),
      errorWidget: (context, url, error) => Container(
        color: CustomColors.greyColor.withValues(alpha: 0.2),
        child: const Icon(
          Icons.broken_image,
          color: CustomColors.silverColor,
          size: 30,
        ),
      ),
    );
  }

  Widget _buildBadge(BuildContext context, String text, Color bgColor) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.w(10),
        vertical: context.h(4),
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(context.r(4)),
      ),
      child: Text(
        text,
        style: CustomFonts.white12w600.copyWith(
          letterSpacing: 0.8,
          fontSize: context.sp(10),
        ),
      ),
    );
  }
}
