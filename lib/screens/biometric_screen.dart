import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skinsync_ai/utills/assets.dart';
import 'package:skinsync_ai/utills/biometric_helper.dart';
import 'package:skinsync_ai/utills/custom_fonts.dart';
import 'package:skinsync_ai/utills/enums.dart';
import 'package:skinsync_ai/utills/shared_pref.dart';
import 'package:skinsync_ai/view_models/auth_view_model.dart';

class BiometricScreen extends StatefulWidget {
  static const String routeName = '/biometricScreen';
  const BiometricScreen({super.key});

  @override
  State<BiometricScreen> createState() => _BiometricScreenState();
}

class _BiometricScreenState extends State<BiometricScreen> {
  bool isBiometricEnabled = false;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    isBiometricEnabled =
        SharedPref().readBool(
          SharedPreferencesKeys.biometricEnabledKey.keyText,
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30.0.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Spacer(),
            Image.asset(PngAssets.biometricImage, height: 400.h),
            Spacer(),
            Text("Biometric Authentication", style: CustomFonts.black30w600),
            SizedBox(height: 2.h),
            Center(
              child: Text(
                "We’ll scan your face and create a cool model just for you to enhance your experience!",
                style: CustomFonts.black16w500,
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 49.h),
            Consumer(
              builder: (context, ref, _) {
                return FutureBuilder(
                  future: BiometricHelper().isBiometricAvailable(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const SizedBox();
                    } else if (snapshot.hasData && snapshot.data == true) {
                      return SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (isLoading) return;

                            if (isBiometricEnabled) {
                              EasyLoading.showSuccess(
                                "Biometric is already enabled",
                              );
                              return;
                            }

                            isLoading = true;

                            final success = await ref
                                .read(authViewModel.notifier)
                                .callBiometricRegisterApi();

                            if (success ?? false) {
                              isBiometricEnabled = true;
                              SharedPref().saveBool(
                                SharedPreferencesKeys
                                    .biometricEnabledKey
                                    .keyText,
                                true,
                              );
                              EasyLoading.showSuccess("Biometric enabled");
                              Navigator.pop(context);
                            }

                            isLoading = false;
                          },
                          child: Text("I understand and Agree"),
                        ),
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                );
              },
            ),

            SizedBox(height: 24.h),
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Text("Back to Settings", style: CustomFonts.black20w600),
            ),
            Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.paddingOf(context).bottom + 60.h,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
