import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import 'bottom_nav_page.dart';
import '../utils/assets.dart';
import '../utils/biometric_helper.dart';
import '../utils/custom_fonts.dart';
import '../utils/enums.dart';
import '../utils/secure_storage_service.dart';
import '../view_models/auth_view_model.dart';
import '../widgets/custom_button.dart';

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
        padding: EdgeInsets.symmetric(horizontal: context.w(30.0)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(),
            Image.asset(PngAssets.biometricImage, height: context.h(400)),
            const Spacer(),
            Text("Biometric Authentication", style: CustomFonts.black30w600),
            SizedBox(height: context.h(2)),
            Center(
              child: Text(
                "Secure your account and personalize your experience. Biometric data allows for safe access to your private skin analysis, treatment simulations, and progress tracking.",
                style: CustomFonts.black16w500,
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: context.h(49)),
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
                        child: CustomButton(
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
                                  BottomNavPage.routeName,
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
                          text: "I understand and Agree",
                        ),
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                );
              },
            ),

            SizedBox(height: context.h(24)),
            GestureDetector(
              onTap: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  BottomNavPage.routeName,
                  (Route<dynamic> route) => false,
                );
              },
              child: Text("Skip", style: CustomFonts.black20w600),
            ),
            Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.paddingOf(context).bottom + context.h(60),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
