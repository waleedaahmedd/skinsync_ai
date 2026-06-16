import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../main.dart';
import '../view_models/auth_view_model.dart';
import '../view_models/clinlic_doctor_view_model.dart';
import '../widgets/app_loader.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_clinic_grid_view_title.dart';

import '../models/responses/get_clinic_response.dart';
import '../utills/assets.dart';
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
  @override
  void initState() {
    super.initState();
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
  Widget build(BuildContext context) {
    final state = ref.watch(clinicDoctorProvider);
    return Scaffold(
      appBar: const CustomAppBar(showTitle: true, title: "Explore clinics"),

      body: Stack(
        children: [
          DefaultTabController(
            length: isDeploymentMode ? 1 : 2,
            child: Column(
              children: [
                SizedBox(height: 28.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30.w),
                  child: TextField(
                    style: CustomFonts.black18w400,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      hintText: "Search clinics",
                    ),
                    onChanged: ref
                        .read(clinicDoctorProvider.notifier)
                        .onSearchChanged,
                  ),
                ),
                SizedBox(height: 15.h),
                if (!isDeploymentMode)
                  TabBar(
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
                    tabs: [
                      if (!isDeploymentMode) const Tab(child: Text('Clinics')),
                      const Tab(child: Text('Invite Clinics')),
                    ],
                  ),
                SizedBox(height: 20.h),

                if (state.clinicLoading)
                  const Expanded(child: AppLoader())
                else
                  Expanded(
                    child: TabBarView(
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        // Center(
                        //   child: Text(
                        //     "No Clinic Found",
                        //     style: CustomFonts.black18w600,
                        //   ),
                        // ),
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
          if (state.clinicsToInvite.isNotEmpty)
            Positioned(
              left: 0,
              right: 0,
              bottom: MediaQuery.paddingOf(context).bottom + 10.h,
              child: Center(
                child: FloatingActionButton.extended(
                  onPressed: ref
                      .read(clinicDoctorProvider.notifier)
                      .toggleViewType,

                  backgroundColor: Colors.black,
                  elevation: 6,

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50.r),
                  ),

                  icon: Image.asset(
                    switch (state.viewType) {
                      ViewType.grid => PngAssets.mapIcon,
                      ViewType.map => PngAssets.syringe,
                    },
                    height: 22.h,
                    width: 22.w,
                    color: Colors.white, // optional if icon is black
                  ),

                  label: Text(switch (state.viewType) {
                    ViewType.grid => "Map View",
                    ViewType.map => 'Grid View',
                  }, style: CustomFonts.white18w600),
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
    if (clinics.isEmpty) {
      return Center(
        child: Text("No Clinic Found", style: CustomFonts.black18w600),
      );
    }
    return switch (viewType) {
      ViewType.grid => Padding(
        padding: EdgeInsets.symmetric(horizontal: 30.w),
        child: MasonryGridView.count(
          crossAxisCount: 2,
          itemCount: clinics.length,
          crossAxisSpacing: 18.w,
          mainAxisSpacing: 18.h,
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
