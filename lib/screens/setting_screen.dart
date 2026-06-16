import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iconsax/iconsax.dart';
import '../utills/assets.dart';
import '../utills/color_constant.dart';
import '../utills/custom_fonts.dart';
import '../utills/secure_storage_service.dart';

import '../utills/biometric_helper.dart';
import '../utills/enums.dart';
import '../view_models/auth_view_model.dart';
import '../widgets/custom_app_bar.dart';

class SettingScreen extends ConsumerStatefulWidget {
  const SettingScreen({super.key});
  static const String routeName = '/SettingScreen';

  @override
  ConsumerState<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends ConsumerState<SettingScreen> {
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

  Future<void> _onBiometricChanged(bool value) async {
    if (isLoading) return;
    setState(() => isLoading = true);

    if (value) {
      // Check biometric support
      final isAvailable = await BiometricHelper().isBiometricAvailable();
      if (!isAvailable) {
        EasyLoading.showError("Device does not support biometric");
        setState(() {
          isBiometricEnabled = false;
          isLoading = false;
        });
        return;
      }

      // Authenticate directly
      final isAuthenticated = await BiometricHelper().authenticate();
      if (isAuthenticated) {
        setState(() => isBiometricEnabled = true);
        final success = await ref
            .read(authViewModel.notifier)
            .callBiometricRegisterApi();
        if (success ?? false) {
          EasyLoading.showSuccess("Biometric enabled successfully");
        }
      } else {
        setState(() => isBiometricEnabled = false);
        EasyLoading.showError("Biometric authentication failed");
      }
    } else {
      await BiometricHelper.clearSignature();
      final success = await ref
          .read(authViewModel.notifier)
          .callBiometricUnregisterApi(showLoader: true);
      if (success ?? false) {
        setState(() => isBiometricEnabled = false);
      }
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(showTitle: true, title: "Settings"),

      body: Column(
        children: [
          const Divider(color: CustomColors.greyColor),
          SizedBox(height: 32.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.w),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(
                      Iconsax.notification,
                      size: 24.sp,
                      color: Colors.black,
                    ),
                    SizedBox(width: 16.w),
                    Text(
                      "Push Notifications Off",
                      style: CustomFonts.black22w500,
                    ),
                    const Spacer(),
                    CustomSizedSwitch(),
                  ],
                ),
                /*SizedBox(height: 37.h),
                Row(
                  children: [
                    SvgPicture.asset(
                      SvgAssets.authentication,
                      height: 24.h,
                      width: 24.w,
                    ),

                    SizedBox(width: 16.w),
                    Text(
                      "Two-Factor Authentication",
                      style: CustomFonts.black22w500,
                    ),
                    Spacer(),
                    CustomSizedSwitch(),
                  ],
                ),*/
                SizedBox(height: 37.h),
                Row(
                  children: [
                    SvgPicture.asset(
                      SvgAssets.biometric,
                      height: 24.h,
                      width: 24.w,
                      color: Colors.black,
                    ),
                    SizedBox(width: 16.w),
                    Text(
                      "Biometric Authentication",
                      style: CustomFonts.black22w500,
                    ),
                    const Spacer(),
                    FutureBuilder<bool>(
                      key: UniqueKey(),
                      future: BiometricHelper().isBiometricAvailable(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const SizedBox();
                        } else if (snapshot.hasData && snapshot.data == true) {
                          return CustomSizedSwitch(
                            isOn: isBiometricEnabled,
                            onChanged: _onBiometricChanged,
                          );
                        } else {
                          return const SizedBox.shrink();
                        }
                      },
                    ),
                  ],
                ),
                SizedBox(height: 37.h),
                /*   Row(
                  children: [
                    SvgPicture.asset(SvgAssets.card, height: 24.h, width: 24.w),
                    SizedBox(width: 16.w),
                    Text("Payments & Wallets", style: CustomFonts.black22w500),
                  ],
                ),*/
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CustomSizedSwitch extends StatefulWidget {
  CustomSizedSwitch({super.key, this.isOn = false, this.onChanged});
  bool isOn;
  void Function(bool)? onChanged;

  @override
  State<CustomSizedSwitch> createState() => _CustomSizedSwitchState();
}

class _CustomSizedSwitchState extends State<CustomSizedSwitch> {
  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: 0.8,
      child: SwitchTheme(
        data: SwitchThemeData(
          thumbColor: WidgetStateProperty.all(Colors.white),
          trackColor: WidgetStateProperty.all(Colors.black),
          trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: Switch(
          value: widget.isOn,
          onChanged: (value) {
            setState(() {
              widget.isOn = value;
            });
            widget.onChanged?.call(value);
          },
        ),
      ),
    );
  }
}
