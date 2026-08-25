import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../utils/color_constant.dart';
import '../utils/custom_fonts.dart';

import '../models/responses/treatment_list_response.dart';
import '../view_models/treatment_view_model.dart';
import '../widgets/app_loader.dart';

class TreatmentDetailScreen extends ConsumerStatefulWidget {
  final TreatmentData treatments;

  const TreatmentDetailScreen({super.key, required this.treatments});

  static const String routeName = '/TreatmentDetailScreen';

  @override
  ConsumerState<TreatmentDetailScreen> createState() =>
      _TreatmentDetailScreenState();
}

class _TreatmentDetailScreenState extends ConsumerState<TreatmentDetailScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.treatments.id != null) {
        ref
            .read(treatmentViewModel.notifier)
            .calltreatmentDetail(id: widget.treatments.id!);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: CustomColors.whiteColor,
      body: Consumer(
        builder: (context, ref, _) {
          final loading = ref.watch(treatmentViewModel).loading;
          final detail = ref.watch(treatmentViewModel).treatmentDetail;

          if (loading) {
            return const Center(child: AppLoader());
          }

          if (detail == null) {
            return Center(
              child: Text('No detail found', style: CustomFonts.black16w400),
            );
          }

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Premium Curved Image Banner with Overlays
                Stack(
                  children: [
                    Hero(
                      tag: 'treatment_image_${detail.id}',
                      child: ClipRRect(
                        borderRadius: BorderRadius.vertical(
                          bottom: Radius.circular(context.r(32)),
                        ),
                        child: Container(
                          height: context.h(310),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: CachedNetworkImage(
                            imageUrl: detail.image ?? '',
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              decoration: const BoxDecoration(
                                gradient: CustomColors.purpleBlueGradient,
                              ),
                              child: const Center(
                                child: CupertinoActivityIndicator(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              decoration: const BoxDecoration(
                                gradient: CustomColors.purpleBlueGradient,
                              ),
                              child: const Icon(
                                Icons.broken_image_rounded,
                                color: Colors.white38,
                                size: 40,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Translucent Top & Bottom Gradients for Button readability
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

                    // Floating Actions (Back and Favorite buttons)
                    Positioned(
                      top: MediaQuery.paddingOf(context).top + context.h(10),
                      left: context.w(24),
                      right: context.w(24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Back Button
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              height: context.w(42),
                              width: context.w(42),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.black.withValues(alpha: 0.35),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.2),
                                  width: 1.5,
                                ),
                              ),
                              child: Center(
                                child: Icon(
                                  CupertinoIcons.arrow_left,
                                  size: context.sp(20),
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),

                          // Favorite Button
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: context.h(24)),

                // 2. Title & Reviews Section
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: context.w(24)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CachedNetworkImage(
                            height: context.h(30),
                            width: context.w(30),
                            imageUrl: detail.icon ?? '',
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              decoration: const BoxDecoration(
                                gradient: CustomColors.purpleBlueGradient,
                              ),
                              child: const Center(
                                child: CupertinoActivityIndicator(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              decoration: const BoxDecoration(
                                gradient: CustomColors.purpleBlueGradient,
                              ),
                              child: const Icon(
                                Icons.broken_image_rounded,
                                color: Colors.white38,
                                size: 40,
                              ),
                            ),
                          ),
                          SizedBox(width: 6.w),
                          Text(
                            detail.name ?? "",
                            style: CustomFonts.black28w600,
                          ),
                        ],
                      ),

                      // Rating and review count
                    ],
                  ),
                ),

                SizedBox(height: context.h(20)),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: context.w(24)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        detail.shortDescription ?? '',
                        style: CustomFonts.textGrey16w400,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
