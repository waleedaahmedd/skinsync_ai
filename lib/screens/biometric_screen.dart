import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'face_scan_screen.dart';
import '../utills/assets.dart';
import '../utills/biometric_helper.dart';
import '../utills/custom_fonts.dart';
import '../utills/enums.dart';
import '../view_models/auth_view_model.dart';

import '../utills/secure_storage_service.dart';

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
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final authKey = await SecureStorage().getSecureString(
        key: SharedPreferencesKeys.biometricAuthKey.keyText,
      );
      isBiometricEnabled = authKey != null;
      log('IS ENABLED: $isBiometricEnabled');
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30.0.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(),
            Image.asset(PngAssets.biometricImage, height: 400.h),
            const Spacer(),
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

                            setState(() => isLoading = true);

                            // Check device support
                            final isAvailable = await BiometricHelper()
                                .isBiometricAvailable();

                            if (!isAvailable) {
                              EasyLoading.showError(
                                "Device does not support biometric authentication",
                              );
                              setState(() => isLoading = false);
                              return;
                            }

                            // Authenticate
                            final isAuthenticated = await BiometricHelper()
                                .authenticate();

                            if (!isAuthenticated) {
                              EasyLoading.showError(
                                "Biometric authentication failed",
                              );
                              setState(() => isLoading = false);
                              return;
                            }

                            // Call register API
                            final success = await ref
                                .read(authViewModel.notifier)
                                .callBiometricRegisterApi();

                            if (success ?? false) {
                              setState(() => isBiometricEnabled = true);
                              EasyLoading.showSuccess(
                                "Biometric enabled successfully",
                              );

                              if (mounted) {
                                Navigator.pushNamedAndRemoveUntil(
                                  context,
                                  FaceScanScreen.routeName,
                                  (Route<dynamic> route) => false,
                                );
                              }
                            } else {
                              EasyLoading.showError(
                                "Failed to register biometric",
                              );
                            }

                            setState(() => isLoading = false);
                          },
                          child: const Text("I understand and Agree"),
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
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  FaceScanScreen.routeName,
                  (Route<dynamic> route) => false,
                );
              },
              child: Text("Skip", style: CustomFonts.black20w600),
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
