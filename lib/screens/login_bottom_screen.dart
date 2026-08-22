import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../main.dart';
import '../utils/assets.dart';
import '../utils/biometric_helper.dart';
import '../utils/color_constant.dart';
import '../utils/custom_fonts.dart';
import '../utils/enums.dart';
import '../view_models/auth_view_model.dart';
import '../widgets/app_loader.dart';
import 'bottom_nav_page.dart';
import 'face_scan_screen.dart';
import 'login_screen.dart';

class LoginBottomScreen extends ConsumerWidget {
  static const String routeName = '/login_bottom_screen';
  const LoginBottomScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loading = ref.watch(authViewModel.select((s) => s.loading));
    final bottom = MediaQuery.viewInsetsOf(context).bottom;
    return PopScope(
      canPop: !loading,
      child: SafeArea(
        child: GestureDetector(
          behavior: .translucent,
          onTap: () {
            if (!loading) {
              Navigator.pop(context);
            }
          },
          child: Align(
            alignment: .bottomCenter,
            child: BackdropFilter(
              filter: .blur(sigmaX: 2, sigmaY: 2),
              child: Material(
                type: .transparency,
                child: Container(
                  color: Colors.transparent,
                  padding: EdgeInsets.only(
                    top: context.h(10),
                    left: context.w(10),
                    right: context.w(10),
                    bottom: context.h(10) + bottom,
                  ),
                  child: _buildBody(ref, loading),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(WidgetRef ref, bool loading) {
    final context = ref.context;
    return GestureDetector(
      behavior: .opaque,
      onTap: () {
        log('TAP ON CARD');
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(context.r(44)),
            topRight: Radius.circular(context.r(44)),
            bottomLeft: Radius.circular(context.r(55)),
            bottomRight: Radius.circular(context.r(55)),
          ),
          boxShadow: kElevationToShadow[2],
        ),
        padding: EdgeInsets.only(
          left: context.w(20),
          right: context.w(20),
          top: context.h(28),
          bottom: context.h(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: .min,
          children: [
            Text(
              "Get Started",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: context.sp(30),
                color: Colors.black,
              ),
            ),
            SizedBox(height: context.h(4)),
            Text(
              "Smart skincare powered by AI.\nSign in to get personalized insights.",
              style: TextStyle(
                fontSize: context.sp(16),
                fontWeight: FontWeight.w400,
                color: const Color(0xff494949),
              ),
            ),
            SizedBox(height: context.h(18)),
            if (loading)
              const Center(child: AppLoader())
            else ...{
              SizedBox(
                width: double.infinity,
                child: InkWell(
                  onTap: () {
                    ref.read(authViewModel.notifier).clearData();
                    Navigator.pushNamed(
                      context,
                      LoginScreen.routeName,
                      arguments: LoginProviders.email,
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: context.h(16)),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(context.r(10)),
                      color: CustomColors.greyColor,
                    ),
                    child: Row(
                      spacing: 10.w,
                      mainAxisAlignment: .center,
                      children: [
                        Image.asset(
                          PngAssets.email,
                          height: context.h(32),
                          width: context.w(32),
                          fit: BoxFit.contain,
                        ),
                        Text(
                          "Continue With Email",
                          style: CustomFonts.black18w600,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: context.h(10)),
              _buildSocialSignIns(context, ref),
              SizedBox(height: context.h(20)),
              _buildBiometricButton(context, ref),
            },
            SizedBox(height: context.h(10)),
          ],
        ),
      ),
    );
  }

  Row _buildSocialSignIns(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () async {
              final success = await ref
                  .read(authViewModel.notifier)
                  .callGoogleSignInApi();
              if (success ?? false) {
                if (isDeploymentMode) {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    BottomNavPage.routeName,
                    (Route<dynamic> route) => false,
                  );
                } else {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    FaceScanScreen.routeName,
                    (Route<dynamic> route) => false,
                  );
                }
              }
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: context.h(16)),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(context.r(10)),
                color: CustomColors.greyColor,
              ),
              child: Row(
                spacing: 10.w,
                mainAxisAlignment: .center,
                children: [
                  Image.asset(
                    PngAssets.google,
                    height: context.h(32),
                    width: context.w(32),
                    fit: BoxFit.contain,
                  ),
                  if (Platform.isAndroid)
                    Text(
                      'Continue With Google',
                      style: CustomFonts.black18w600,
                    ),
                ],
              ),
            ),
          ),
        ),
        if (Platform.isIOS) ...[
          const SizedBox(width: 8),
          Expanded(
            child: GestureDetector(
              onTap: () async {
                final success = await ref
                    .read(authViewModel.notifier)
                    .callAppleSignInApi();
                if (success ?? false) {
                  if (isDeploymentMode) {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      BottomNavPage.routeName,
                      (Route<dynamic> route) => false,
                    );
                  } else {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      FaceScanScreen.routeName,
                      (Route<dynamic> route) => false,
                    );
                  }
                }
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: context.h(16)),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(context.r(10)),
                  color: CustomColors.greyColor,
                ),
                child: Center(
                  child: Image.asset(
                    PngAssets.apple,
                    height: context.h(32),
                    width: context.w(32),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildBiometricButton(BuildContext context, WidgetRef ref) {
    final state = ref.watch(authViewModel);

    // Decides whether to show the button based on state
    if (!state.isBiometricAvailable || state.biometricIcon == null) {
      return const SizedBox.shrink();
    }

    return Center(
      child: InkWell(
        onTap: () async {
          bool authenticated = await BiometricHelper().authenticate(
            reason: 'Login with Biometrics',
          );
          if (authenticated && context.mounted) {
            final success = await ref
                .read(authViewModel.notifier)
                .callBiometricLoginApi();

            if (success == true) {
              Navigator.pushNamedAndRemoveUntil(
                context,
                BottomNavPage.routeName,
                (route) => false,
              );
            }
          }
        },
        child: Icon(state.biometricIcon, size: context.h(60)),
      ),
    );
  }
}
