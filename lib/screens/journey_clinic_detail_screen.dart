import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../models/responses/get_clinic_response.dart';
import '../utils/app_lunach_utils.dart';
import '../utils/color_constant.dart';
import '../utils/custom_fonts.dart';
import '../view_models/clinic_view_model.dart';
import '../view_models/treatment_journey_view_model.dart';
import '../widgets/app_loader.dart';
import '../widgets/custom_button.dart';
import '../widgets/dialogs/success_dialogs.dart';
import 'treatment_journey_screen.dart';

class JourneyClinicDetailScreen extends ConsumerStatefulWidget {
  final Clinic? clinic;
  const JourneyClinicDetailScreen({super.key, this.clinic});

  static const String routeName = '/JourneyClinicDetailScreen';

  @override
  ConsumerState<JourneyClinicDetailScreen> createState() =>
      _JourneyClinicDetailScreenState();
}

class _JourneyClinicDetailScreenState
    extends ConsumerState<JourneyClinicDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => ref
          .read(clinicProvider.notifier)
          .fetchClinicDetail(widget.clinic?.id),
    );
  }

  @override
  Widget build(BuildContext context) {
    final clinicDetail = ref.watch(
      clinicProvider.select((s) => s.clinicDetail),
    );
    final isLoading = ref.watch(clinicProvider.select((s) => s.loading));

    return Scaffold(
      backgroundColor: CustomColors.whiteColor,
      body: Stack(
        children: [
          if (isLoading || clinicDetail == null)
            const AppLoader()
          else
            Positioned.fill(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.vertical(
                            bottom: Radius.circular(context.r(32)),
                          ),
                          child: Container(
                            height: context.h(310),
                            width: double.infinity,
                            decoration: const BoxDecoration(
                              gradient: CustomColors.purpleBlueGradient,
                            ),
                            child: clinicDetail.logo != null
                                ? CachedNetworkImage(
                                    imageUrl: clinicDetail.logo!,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => const Center(
                                      child: CupertinoActivityIndicator(
                                        color: Colors.white,
                                      ),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        const Icon(
                                          Icons.broken_image_rounded,
                                          color: Colors.white38,
                                          size: 40,
                                        ),
                                  )
                                : const Icon(
                                    Icons.storefront_rounded,
                                    size: 60,
                                    color: Colors.white70,
                                  ),
                          ),
                        ),
                        Positioned.fill(
                          child: ClipRRect(
                            borderRadius: BorderRadius.vertical(
                              bottom: Radius.circular(context.r(32)),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.black.withValues(alpha: 0.45),
                                    Colors.transparent,
                                    Colors.black.withValues(alpha: 0.3),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top:
                              MediaQuery.paddingOf(context).top + context.h(10),
                          left: context.w(24),
                          right: context.w(24),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () => Navigator.pop(context),
                                child: Container(
                                  height: context.w(42),
                                  width: context.w(42),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.black.withValues(alpha: 0.35),
                                    border: Border.all(
                                      color: Colors.white.withValues(
                                        alpha: 0.2,
                                      ),
                                      width: 1.5,
                                    ),
                                  ),
                                  child: const Center(
                                    child: Icon(
                                      CupertinoIcons.arrow_left,
                                      size: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: context.h(24)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: context.w(24)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            clinicDetail.name ?? 'N/A',
                            style: CustomFonts.black28w600,
                          ),
                          SizedBox(height: context.h(10)),
                          Row(
                            children: [
                              const Icon(
                                Icons.star_rounded,
                                size: 20,
                                color: Colors.amber,
                              ),
                              SizedBox(width: context.w(4)),
                              Text(
                                '${widget.clinic?.place?.rating ?? 0}',
                                style: CustomFonts.black16w600,
                              ),
                              SizedBox(width: context.w(8)),
                              Text(
                                "(${widget.clinic?.place?.userRatingCount ?? 0} Reviews)",
                                style: CustomFonts.textGrey14w400,
                              ),
                            ],
                          ),
                          SizedBox(height: context.h(16)),
                          Text(
                            clinicDetail.description ??
                                widget
                                    .clinic
                                    ?.place
                                    ?.primaryTypeDisplayName
                                    ?.text ??
                                "Achieve a youthful appearance with our aesthetic treatments to highlight your features.",
                            style: CustomFonts.textGrey16w400,
                          ),
                          if (clinicDetail.address != null) ...[
                            SizedBox(height: context.h(16)),
                            InkWell(
                              onTap:
                                  clinicDetail.latitude != null &&
                                      clinicDetail.longitude != null
                                  ? () => launchMap(
                                      clinicDetail.latitude!,
                                      clinicDetail.longitude!,
                                    )
                                  : null,
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.location_on_outlined,
                                    size: 18,
                                    color: CustomColors.purpleColor,
                                  ),
                                  SizedBox(width: context.w(8)),
                                  Expanded(
                                    child: Text(
                                      clinicDetail.address!,
                                      style: CustomFonts.textGrey14w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                          if (clinicDetail.phone != null) ...[
                            SizedBox(height: context.h(8)),
                            InkWell(
                              onTap: () => launchPhone(
                                "${clinicDetail.cc ?? ''}${clinicDetail.phone ?? ''}",
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.phone_outlined,
                                    size: 18,
                                    color: CustomColors.purpleColor,
                                  ),
                                  SizedBox(width: context.w(8)),
                                  Text(
                                    "${clinicDetail.cc ?? ''} ${clinicDetail.phone ?? ''}",
                                    style: CustomFonts.textGrey14w400,
                                  ),
                                ],
                              ),
                            ),
                          ],
                          if (clinicDetail.website != null) ...[
                            SizedBox(height: context.h(8)),
                            InkWell(
                              onTap: () =>
                                  launchWebsite(clinicDetail.website!),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.language_outlined,
                                    size: 18,
                                    color: CustomColors.purpleColor,
                                  ),
                                  SizedBox(width: context.w(8)),
                                  Text(
                                    clinicDetail.website!,
                                    style: CustomFonts.textGrey14w400,
                                  ),
                                ],
                              ),
                            ),
                          ],
                          if (clinicDetail.email != null) ...[
                            SizedBox(height: context.h(8)),
                            InkWell(
                              onTap: () => launchEmail(clinicDetail.email!),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.email_outlined,
                                    size: 18,
                                    color: CustomColors.purpleColor,
                                  ),
                                  SizedBox(width: context.w(8)),
                                  Text(
                                    clinicDetail.email!,
                                    style: CustomFonts.textGrey14w400,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    SizedBox(height: context.h(24)),
                    if (clinicDetail.latitude != null &&
                        clinicDetail.longitude != null)
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: context.w(24),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Location", style: CustomFonts.black18w600),
                            SizedBox(height: context.h(12)),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(
                                context.r(16),
                              ),
                              child: SizedBox(
                                height: context.h(200),
                                width: double.infinity,
                                child: GoogleMap(
                                  initialCameraPosition: CameraPosition(
                                    target: LatLng(
                                      clinicDetail.latitude!,
                                      clinicDetail.longitude!,
                                    ),
                                    zoom: 13,
                                  ),
                                  markers: {
                                    Marker(
                                      markerId: const MarkerId(
                                        "clinic_location",
                                      ),
                                      position: LatLng(
                                        clinicDetail.latitude!,
                                        clinicDetail.longitude!,
                                      ),
                                    ),
                                  },
                                  zoomControlsEnabled: false,
                                  zoomGesturesEnabled: false,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    SizedBox(height: context.h(120)),
                  ],
                ),
              ),
            ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: context.h(100) + MediaQuery.paddingOf(context).bottom,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 15,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.paddingOf(context).bottom + context.h(20),
                  left: context.w(24),
                  right: context.w(24),
                  top: context.h(20),
                ),
                child: Consumer(
                  builder: (_, ref, _) {
                    final optionId = ref.watch(
                      treatmentJourneyProvider.select(
                        (s) => s.selectedOptionId,
                      ),
                    );
                    return CustomButton(
                      text: optionId == null ? 'Select Option' : 'Share Now',
                      onPressed: () async {
                        if (optionId == null) {
                          ref
                              .read(clinicProvider.notifier)
                              .setClinicId(widget.clinic?.id);
                          Navigator.pushNamed(
                            context,
                            TreatmentJourneyScreen.routeName,
                          );
                          return;
                        }
                        final result = await ref
                            .read(treatmentJourneyProvider.notifier)
                            .callShareTreatmentRequest();
                        if (result == true) {
                          showShareJourneySuccessDialog(context);
                        }
                      },
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
