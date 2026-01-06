import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:skinsync_ai/screens/explore_clinics_screen.dart';
import 'package:skinsync_ai/utills/assets.dart';
import 'package:skinsync_ai/utills/color_constant.dart';
import 'package:skinsync_ai/utills/custom_fonts.dart';
import 'package:skinsync_ai/utills/image_utills.dart';
import 'package:skinsync_ai/view_models/face_scan_provider.dart';
import 'package:skinsync_ai/widgets/grey_container.dart';
import 'package:skinsync_ai/widgets/service_type_button.dart';

class ArFaceModelPreviewScreen extends ConsumerStatefulWidget {
  const ArFaceModelPreviewScreen({super.key});
  static const String routeName = '/ArFaceModelPreviewScreen';

  @override
  ConsumerState<ArFaceModelPreviewScreen> createState() => _ArFaceModelPreviewScreenState();
}

class _ArFaceModelPreviewScreenState extends ConsumerState<ArFaceModelPreviewScreen> {
  bool _isLoading = false;
  String? _errorMessage;
  bool _hasInitialized = false;

  @override
  void initState() {
    super.initState();
    // Call API when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _callPredictAPI();
    });
  }

  Future<Map<String, dynamic>?> _uploadCapturedImage({
    required XFile image,
    required String apiUrl,
  }) async {
    try {
      final uri = Uri.parse(apiUrl);
      final request = http.MultipartRequest('POST', uri);

      // Attach image
      request.files.add(
        await http.MultipartFile.fromPath(
          'image',
          image.path,
          filename: image.name,
        ),
      );

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      final responseData = jsonDecode(responseBody);

      // Check if server returned an error response
      if (responseData['success'] == false) {
        final errorMessage = responseData['message'] ?? 'Upload failed';
        throw Exception(errorMessage);
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        return responseData;
      } else {
        final errorMessage = responseData['message'] ?? 'Upload failed';
        throw Exception(errorMessage);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> _callPredictAPI() async {
    final state = ref.read(faceScanProvider);
    if (state.capturedImage == null) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final jsonRes = await _uploadCapturedImage(
        image: state.capturedImage!,
        apiUrl: 'http://18.116.65.70/api/predict/',
      );

      if (jsonRes == null) {
        throw Exception('Failed to upload image');
      }

      // Generate unique filename to ensure each API call creates a new file
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final ximage = await base64ToXFile(
        jsonRes["image_base64"],
        fileName: 'ai_image_$timestamp.jpg',
      );
      await ref.read(faceScanProvider.notifier).setAiImage(ximage);

      setState(() {
        _isLoading = false;
        _errorMessage = null;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString().replaceFirst('Exception: ', '');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Ensure default shows "before" tab (only once)
    if (!_hasInitialized) {
      _hasInitialized = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final state = ref.read(faceScanProvider);
        if (!state.isBefore) {
          ref.read(faceScanProvider.notifier).toggleIsBefore();
        }
      });
    }

    return Scaffold(
      appBar: AppBar(
        leadingWidth: 80.w,
        centerTitle: false,
        leading: Padding(
          padding: EdgeInsets.only(left: 10.w),
          child: InkWell(
            onTap: () => Navigator.pop(context),
            child: GreyContainer(
              icon: Icons.arrow_back,
              shape: BoxShape.circle,
              onTap: () => Navigator.pop(context),
            ),
          ),
        ),
        title: Text("AR Face Model Preview", style: CustomFonts.black26w600),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 13.w),
            child: Text("Reset", style: CustomFonts.pinkunderlined20w600),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _facePreview(),
              SizedBox(height: 18.h),
              _accuracyRate(),
              SizedBox(height: 36.h),
              _treatmentSection(area: 'Under-Eyes', syringes: '01 Syringe'),
              SizedBox(height: 50.h),
              _treatmentSection(area: 'Under-Nose', syringes: '01 Syringe'),
              SizedBox(height: 50.h),
              _addMoreService(),
              SizedBox(height: 50.h),
              _bottomButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _facePreview() {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(20.r),
          child: Consumer(
            builder: (context, ref, _) {
              final isBefore = ref.watch(
                faceScanProvider.select((state) => state.isBefore),
              );
              final image = ref.watch(
                faceScanProvider.select((state) => state.isBefore ? state.capturedImage : state.aiImage),
              );

              // Show loading indicator
              if (_isLoading) {
                return Container(
                  width: double.infinity,
                  height: 326.h,
                  color: CustomColors.greyColor.withOpacity(0.3),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: CustomColors.lightBlueColor,
                    ),
                  ),
                );
              }

              // Show error message if API failed and on After tab
              if (!isBefore && _errorMessage != null) {
                return Container(
                  width: double.infinity,
                  height: 326.h,
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          color: Colors.red,
                          size: 48.sp,
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          'Error',
                          style: CustomFonts.black20w600.copyWith(color: Colors.red),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          _errorMessage!,
                          textAlign: TextAlign.center,
                          style: CustomFonts.black16w400.copyWith(color: Colors.red.shade700),
                        ),
                      ],
                    ),
                  ),
                );
              }

              // Show image if available
              if (image != null) {
                return Image.file(
                  File(image.path),
                  fit: BoxFit.fitHeight,
                  width: double.infinity,
                  height: 326.h,
                );
              }

              // Fallback
              return Container(
                width: double.infinity,
                height: 326.h,
                color: CustomColors.greyColor.withOpacity(0.3),
                child: Center(
                  child: Text(
                    'No image available',
                    style: CustomFonts.black16w400,
                  ),
                ),
              );
            },
          ),
        ),
        Positioned(
          top: 13.h,
          left: 23.w,
          child: Consumer(
            builder: (context, ref, _) {
              final isBefore = ref.watch(
                faceScanProvider.select((state) => state.isBefore),
              );
              return Text(
                isBefore ? 'Before' : 'After',
                style: CustomFonts.black20w600,
              );
            },
          ),
        ),
        Positioned(
          top: 13.h,
          right: 23.w,
          child: Consumer(
            builder: (context, ref, _) {
              final isBefore = ref.watch(
                faceScanProvider.select((state) => state.isBefore),
              );
              return GestureDetector(
                onTap: () {
                  // Toggle the state
                  ref.read(faceScanProvider.notifier).toggleIsBefore();
                },
                child: CircleAvatar(
                  backgroundColor: CustomColors.greyColor,
                  child: Image.asset(PngAssets.beforeAfter, width: 18.w),
                ),
              );
            },
          ),
        ),

        Positioned(
          bottom: 16.h,
          left: 16.w,
          right: 16.w,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 8.w),
            decoration: BoxDecoration(
              color: CustomColors.blackColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'See How 2 Syringes Will Look On Your Under Eyes',
              textAlign: TextAlign.center,
              style: CustomFonts.white14w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _accuracyRate() {
    return Row(
      children: [
        SvgPicture.asset(SvgAssets.dail),
        SizedBox(width: 5.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Accuracy Rate', style: CustomFonts.black20w600),
            Text(
              'This score is based on your Face analysis',
              style: CustomFonts.black16w400,
            ),
          ],
        ),
      ],
    );
  }

  // ================= Treatment Section =================

  Widget _treatmentSection({required String area, required String syringes}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Treatment Selection', style: CustomFonts.black18w600),
        SizedBox(height: 8.h),
        Row(
          children: [
            ServiceTypeButton(
              icon: Image.asset(PngAssets.syringe, width: 21.w),
              text: "Dermal Fillers",
              selected: true,
              frosted: false,
            ),
            //         Container(
            //   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            //   decoration: BoxDecoration(
            //     color: ,
            //     borderRadius: BorderRadius.circular(12.r),
            //   ),
            //   child: Row(
            //     children: [

            //        SizedBox(width: 8.w),
            //       Text(
            //         "Dermal Fillers",
            //         style: CustomFonts.white17w500
            //       ),
            //     ],
            //   ),
            // ),
            SizedBox(width: 10.w),
            ServiceTypeButton(
              icon: Image.asset(PngAssets.hand, width: 21.w),
              text: "Botox",
              selected: false,
            ),
          ],
        ),
        SizedBox(height: 16.h),
        Text('Area Selection', style: CustomFonts.black18w600),
        SizedBox(height: 8.h),
        DropdownButtonFormField(
          value: area,
          items: [area]
              .map(
                (e) => DropdownMenuItem(
                  value: e,
                  child: Text(e, style: CustomFonts.black16w500),
                ),
              )
              .toList(),
          onChanged: (_) {},
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderSide: BorderSide(color: CustomColors.blackColor),
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
        ),
        SizedBox(height: 16.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Adjustable Parameters:', style: CustomFonts.black18w600),
            Text(syringes, style: CustomFonts.black14w500),
          ],
        ),
        Slider(
          activeColor: CustomColors.lightBlueColor,
          value: 1,
          min: 0,
          max: 2,
          onChanged: (_) {},
        ),
      ],
    );
  }

  // ================= Add More =================

  Widget _addMoreService() {
    return Center(
      child: TextButton.icon(
        onPressed: () {},
        icon: Container(
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: CustomColors.blackColor,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: const Icon(Icons.add, color: Colors.white),
        ),
        label: Text(
          'Add More Service',
          style: CustomFonts.black20w600Underlined,
        ),
      ),
    );
  }

  // ================= Bottom Buttons =================

  Widget _bottomButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.r),
              ),
              padding: EdgeInsets.symmetric(vertical: 19.h),
            ),
            child: Text('Save', style: CustomFonts.black22w600),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, ExploreClinicsScreen.routeName);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.r),
              ),
              padding: EdgeInsets.symmetric(vertical: 19.h),
            ),
            child: Text('Explore Clinics', style: CustomFonts.white22w600),
          ),
        ),
      ],
    );
  }
}
