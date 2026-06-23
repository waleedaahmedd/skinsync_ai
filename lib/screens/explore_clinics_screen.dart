import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:skinsync_ai/main.dart';
import 'package:skinsync_ai/view_models/auth_view_model.dart';
import 'package:skinsync_ai/view_models/clinlic_doctor_view_model.dart';
import 'package:skinsync_ai/widgets/app_loader.dart';
import 'package:skinsync_ai/widgets/custom_app_bar.dart';
import 'package:skinsync_ai/widgets/custom_clinic_grid_view_title.dart';

import '../models/responses/get_clinic_response.dart';
import '../utills/assets.dart';
import '../utills/color_constant.dart';
import '../utills/custom_fonts.dart';
import '../utills/enums.dart';
import 'clinics_detail_screen.dart';

class ExploreClinicsScreen extends ConsumerStatefulWidget {
  final int? treatmentId;
  final List<int>? sideAreaIds;

  const ExploreClinicsScreen({super.key, this.treatmentId, this.sideAreaIds});

  static const String routeName = '/ExploreClinicsScreen';

  @override
  ConsumerState<ExploreClinicsScreen> createState() =>
      _ExploreClinicsScreenState();
}

class _ExploreClinicsScreenState extends ConsumerState<ExploreClinicsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.trim();
      });
      ref.read(clinicDoctorProvider.notifier).onSearchChanged(_searchController.text);
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (isDeploymentMode) {
        ref.read(clinicDoctorProvider.notifier).fetchClinicsFromMap();
      } else {
        ref
            .read(clinicDoctorProvider.notifier)
            .getClinic(
              treatmentId: widget.treatmentId,
              sideAreaIds: widget.sideAreaIds,
            );
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(clinicDoctorProvider);
    return Scaffold(
      backgroundColor: CustomColors.whiteColor,
      appBar: const CustomAppBar(showTitle: true, title: "Explore Clinics"),
      body: Stack(
        children: [
          DefaultTabController(
            length: isDeploymentMode ? 1 : 2,
            child: Column(
              children: [
                SizedBox(height: 20.h),
                // Premium Styled Search Bar
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: TextField(
                    controller: _searchController,
                    style: CustomFonts.black18w400,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search, color: Colors.grey),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear, color: Colors.grey),
                              onPressed: () {
                                _searchController.clear();
                              },
                            )
                          : null,
                      hintText: "Search Clinics...",
                      contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.r),
                        borderSide: BorderSide(color: CustomColors.greyColor),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.r),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.r),
                        borderSide: BorderSide(color: CustomColors.purpleColor),
                      ),
                      fillColor: Colors.white,
                      filled: true,
                    ),
                  ),
                ),
                SizedBox(height: 16.h),

                // Premium Styled TabBar
                if (!isDeploymentMode)
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: TabBar(
                      indicatorColor: CustomColors.darkPurple,
                      indicatorSize: TabBarIndicatorSize.label,
                      labelColor: Colors.black,
                      unselectedLabelColor: Colors.grey.shade500,
                      labelStyle: CustomFonts.black16w600,
                      unselectedLabelStyle: CustomFonts.grey16w500,
                      dividerColor: Colors.transparent,
                      onTap: (index) {
                        if (index == 0) {
                          ref
                              .read(clinicDoctorProvider.notifier)
                              .getClinic(
                                treatmentId: widget.treatmentId,
                                sideAreaIds: widget.sideAreaIds,
                              );
                        } else {
                          ref
                              .read(clinicDoctorProvider.notifier)
                              .fetchClinicsFromMap();
                        }
                      },
                      tabs: const [
                        Tab(text: 'Clinics'),
                        Tab(text: 'Invite Clinics'),
                      ],
                    ),
                  ),
                SizedBox(height: 16.h),

                if (state.clinicLoading)
                  const Expanded(child: AppLoader())
                else
                  Expanded(
                    child: TabBarView(
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        if (!isDeploymentMode)
                          _buildViewType(
                            ref: ref,
                            viewType: state.viewType,
                            clinics: state.clinics,
                          ),
                        _buildViewType(
                          ref: ref,
                          viewType: state.viewType,
                          clinics: state.clinicsToInvite,
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),

          // Floating Action Button for Map/Grid View Toggle
          if (state.clinicsToInvite.isNotEmpty)
            Positioned(
              left: 0,
              right: 0,
              bottom: MediaQuery.paddingOf(context).bottom + 20.h,
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.15),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: FloatingActionButton.extended(
                    onPressed: ref
                        .read(clinicDoctorProvider.notifier)
                        .toggleViewType,
                    backgroundColor: Colors.black,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50.r),
                    ),
                    icon: Image.asset(
                      switch (state.viewType) {
                        ViewType.grid => PngAssets.mapIcon,
                        ViewType.map => PngAssets.syringe,
                      },
                      height: 20.h,
                      width: 20.w,
                      color: Colors.white,
                    ),
                    label: Text(
                      switch (state.viewType) {
                        ViewType.grid => "Map View",
                        ViewType.map => 'Grid View',
                      },
                      style: CustomFonts.white18w600.copyWith(fontSize: 15.sp),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildViewType({
    required WidgetRef ref,
    required ViewType viewType,
    required List<Clinic> clinics,
  }) {
    // Beautiful Empty State Design
    if (clinics.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 40.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.storefront_rounded,
                size: 64.sp,
                color: Colors.grey.shade300,
              ),
              SizedBox(height: 16.h),
              Text(
                "No Clinics Found",
                style: CustomFonts.black20w600.copyWith(
                  color: Colors.grey.shade800,
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                "Try searching for a different keyword or check back later.",
                textAlign: TextAlign.center,
                style: CustomFonts.grey14w400.copyWith(height: 1.3),
              ),
            ],
          ),
        ),
      );
    }

    return switch (viewType) {
      ViewType.grid => Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: MasonryGridView.count(
          crossAxisCount: 2,
          itemCount: clinics.length,
          crossAxisSpacing: 14.w,
          mainAxisSpacing: 14.h,
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            return CustomClinicGridViewTile(
              clinicData: clinics[index],
              onTap: () {
                ref
                    .read(clinicDoctorProvider.notifier)
                    .setClinicId(clinics[index].clinicId!);
                Navigator.pushNamed(
                  context,
                  ClinicsDetailScreen.routeName,
                  arguments: clinics[index],
                );
              },
            );
          },
        ),
      ),
      ViewType.map => Consumer(
        builder: (_, ref, _) {
          final addressData = ref.watch(
            authViewModel.select((s) => s.addressData),
          );
          final position = CameraPosition(
            target: addressData?.latLng ?? const LatLng(24.9211313, 67.0708059),
            zoom: 13,
          );
          log('ADDRESS: ${addressData?.address}');
          return GoogleMap(
            key: ValueKey(clinics.length),
            initialCameraPosition: position,
            padding: MediaQuery.paddingOf(ref.context),
            markers: clinics.where((clinic) => clinic.location != null).map((
              clinic,
            ) {
              return Marker(
                markerId: MarkerId('${clinic.clinicId}'),
                position: clinic.location!,
                icon: AssetMapBitmap(
                  PngAssets.customMarker,
                  width: 50.w,
                  height: 50.w,
                ),
              );
            }).toSet(),
            onMapCreated: (controller) async {
              await controller.animateCamera(
                CameraUpdate.newCameraPosition(position),
              );
            },
          );
        },
      ),
    };
  }
}
