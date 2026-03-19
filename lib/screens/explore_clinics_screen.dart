import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:skinsync_ai/utills/color_constant.dart';
import 'package:skinsync_ai/view_models/auth_view_model.dart';
import 'package:skinsync_ai/view_models/clinlic_doctor_view_model.dart';
import 'package:skinsync_ai/widgets/custom_app_bar.dart';
import 'package:skinsync_ai/widgets/custom_clinic_grid_view_title.dart';

import '../models/responses/get_clinic_response.dart';
import '../utills/assets.dart';
import '../utills/custom_fonts.dart';
import '../utills/enums.dart';
import 'clinics_detail_screen.dart';

class ExploreClinicsScreen extends ConsumerWidget {
  const ExploreClinicsScreen({super.key});
  static const String routeName = '/ExploreClinicsScreen';

  @override
  Widget build(BuildContext context, ref) {
    final state = ref.watch(clincDoctorProvider);
    return Scaffold(
      appBar: CustomAppBar(showTitle: true, title: "Explore clinics"),

      body: Stack(
        children: [
          Column(
            children: [
              SizedBox(height: 28.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.w),
                child: TextField(
                  style: CustomFonts.black18w400,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    hintText: "Search doctor, injector, treatment & clinic",
                  ),
                ),
              ),
              SizedBox(height: 15.h),
              SizedBox(height: 20.h),

              if (state.clinicLoading)
                const Expanded(
                  child: Center(
                    child: CircularProgressIndicator(
                      color: CustomColors.lightPurpleColor,
                    ),
                  ),
                )
              else if (state.clinicResponse?.data != null &&
                  state.clinicResponse!.data!.isNotEmpty)
                Expanded(
                  child: _buildViewType(
                    ref: ref,
                    viewType: state.viewType,
                    clinics: state.clinicResponse!.data!,
                  ),
                )
              else
                Expanded(
                  child: Center(
                    child: Text(
                      "No Clinic Found",
                      style: CustomFonts.black18w600,
                    ),
                  ),
                ),
            ],
          ),
          if (state.clinicResponse?.data?.isNotEmpty ?? false)
            Positioned(
              left: 0,
              right: 0,
              bottom: MediaQuery.paddingOf(context).bottom + 10.h,
              child: Center(
                child: FloatingActionButton.extended(
                  onPressed: ref
                      .read(clincDoctorProvider.notifier)
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
    return switch (viewType) {
      ViewType.grid => Padding(
        padding: EdgeInsets.symmetric(horizontal: 30.w),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 18.w,
            mainAxisSpacing: 18.h,
            childAspectRatio: 0.7,
          ),
          itemCount: clinics.length,
          itemBuilder: (context, index) {
            return CustomClinicGridViewTile(
              clinicData: clinics[index],
              onTap: () {
                ref
                    .read(clincDoctorProvider.notifier)
                    .setClinicId(clinics[index].clinicId!);
                Navigator.pushNamed(context, ClinicsDetailScreen.routeName,
                arguments: clinics[index]);
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
            target: addressData?.latLng ?? LatLng(24.9211313, 67.0708059),
            zoom: 13,
          );
          log('ADDRESS: ${addressData?.address}');
          return GoogleMap(
            initialCameraPosition: position,
            padding: MediaQuery.paddingOf(ref.context),
            markers: clinics.map((clinic) {
              return Marker(
                markerId: MarkerId('${clinic.clinicId}'),
                position: position.target,
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
