import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skinsync_ai/models/dummy_list_model.dart';
import 'package:skinsync_ai/view_models/clinlic_doctor_view_model.dart';

import 'package:skinsync_ai/widgets/custom_app_bar.dart';
import 'package:skinsync_ai/widgets/custom_clinic_grid_view_title.dart';

import '../utills/custom_fonts.dart';

import 'clinics_detail_screen.dart';

class ExploreClinicsScreen extends ConsumerWidget {
  const ExploreClinicsScreen({super.key});
  static const String routeName = '/ExploreClinicsScreen';

  @override
  Widget build(BuildContext context, ref) {
    final isloading = ref.watch(clincDoctorProvider).clinicLoading;
    final clinicResponse = ref.watch(clincDoctorProvider).clinicResponse;
    return Scaffold(
      appBar: CustomAppBar(showTitle: true, title: "Explore clinics"),

      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30.w),
        child: Column(
          children: [
            SizedBox(height: 28.h),
            TextField(
              style: CustomFonts.black18w400,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: "Search  doctor, injector, treatment & clinic",
              ),
            ),
            SizedBox(height: 15.h),

            SizedBox(height: 20.h),
            isloading ? CircularProgressIndicator():
            clinicResponse?.data != null ?


            

            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // 2 items horizontally
                  crossAxisSpacing: 18.w,
                  mainAxisSpacing: 18.h,
                  childAspectRatio: 0.7,
                ),
                itemCount: clinicResponse?.data?.length,
                itemBuilder: (context, index) {

                  return CustomClinicGridViewTile(
                    clinicData:clinicResponse?.data?[index]  ,
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        ClinicsDetailScreen.routeName,
                      );
                    },
                  );
                },
              ),
            ):Center(child: Text("No Clinic Found",style: CustomFonts.black18w600, ),)
          ],
        ),
      ),
    );
  }
}
