import 'dart:developer';

import 'package:material_ui/material_ui.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iconsax/iconsax.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../utils/assets.dart';
import '../utils/biometric_helper.dart';
import '../utils/color_constant.dart';
import '../utils/custom_fonts.dart';
import '../utils/enums.dart';
import '../utils/secure_storage_service.dart';
import '../view_models/auth_view_model.dart';
import '../view_models/notification_view_model.dart';
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
    const Color unifiedColor = CustomColors.purpleColor;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(showTitle: true, title: "Settings"),
      body: Column(
        children: [
          Divider(
            color: CustomColors.greyColor.withValues(alpha: 0.6),
            height: context.h(1),
          ),
          SizedBox(height: context.h(24)),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: context.w(24)),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(context.r(24)),
                border: Border.all(
                  color: CustomColors.greyColor.withValues(alpha: 0.5),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.015),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: context.w(16),
                      vertical: context.h(12),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(context.w(8)),
                          decoration: BoxDecoration(
                            color: unifiedColor.withValues(alpha: 0.08),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Iconsax.notification,
                            size: context.sp(18),
                            color: unifiedColor,
                          ),
                        ),
                        SizedBox(width: context.w(14)),
                        Expanded(
                          child: Text(
                            "Push Notifications",
                            style: CustomFonts.black16w500,
                          ),
                        ),
                        Consumer(
                          builder: (context, ref, _) {
                            final isNotification =
                                ref
                                    .watch(authViewModel)
                                    .authData
                                    ?.pushNotification ??
                                false;
                            return CustomSizedSwitch(
                              isOn: isNotification,
                              onChanged: (val) async {
                                final status = val
                                    ? Status.active
                                    : Status.inactive;

                                ref
                                    .read(notificationViewModel.notifier)
                                    .callNotificationStatus(status: status);
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(
                      left: context.w(54),
                      right: context.w(16),
                    ),
                    child: Divider(
                      color: Colors.grey.shade100,
                      height: context.h(1),
                    ),
                  ),

                  // Biometric Authentication Setting Option
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: context.w(16),
                      vertical: context.h(12),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(context.w(8)),
                          decoration: BoxDecoration(
                            color: unifiedColor.withValues(alpha: 0.08),
                            shape: BoxShape.circle,
                          ),
                          child: SvgPicture.asset(
                            SvgAssets.biometric,
                            height: context.w(18),
                            width: context.w(18),
                            colorFilter: const ColorFilter.mode(
                              unifiedColor,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                        SizedBox(width: context.w(14)),
                        Expanded(
                          child: Text(
                            "Biometric Authentication",
                            style: CustomFonts.black16w500,
                          ),
                        ),
                        FutureBuilder<bool>(
                          key: UniqueKey(),
                          future: BiometricHelper().isBiometricAvailable(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const SizedBox();
                            } else if (snapshot.hasData &&
                                snapshot.data == true) {
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
                  ),
                ],
              ),
            ),
          ),
          const Spacer(),
          SafeArea(
            child: FutureBuilder(
              future: PackageInfo.fromPlatform(),
              builder: (_, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox.shrink();
                } else {
                  final data = snapshot.data;
                  if (data == null) {
                    return const SizedBox.shrink();
                  }
                  return Align(
                    alignment: .topCenter,
                    child: Text(
                      'Skinsync Ai ${DateTime.now().year} v${data.version} (${data.buildNumber})',
                      style: CustomFonts.grey16w400,
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class CustomSizedSwitch extends StatefulWidget {
  const CustomSizedSwitch({super.key, this.isOn = false, this.onChanged});
  final bool isOn;
  final void Function(bool)? onChanged;

  @override
  State<CustomSizedSwitch> createState() => _CustomSizedSwitchState();
}

class _CustomSizedSwitchState extends State<CustomSizedSwitch> {
  late bool _isOn;

  @override
  void initState() {
    super.initState();
    _isOn = widget.isOn;
  }

  @override
  void didUpdateWidget(CustomSizedSwitch oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isOn != widget.isOn) {
      _isOn = widget.isOn;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: 0.8,
      child: SwitchTheme(
        data: SwitchThemeData(
          thumbColor: WidgetStateProperty.all(Colors.white),
          trackColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return CustomColors.darkPurple;
            }
            return Colors.grey.shade300;
          }),
          trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: Switch(
          value: _isOn,
          onChanged: (value) {
            setState(() {
              _isOn = value;
            });
            widget.onChanged?.call(value);
          },
        ),
      ),
    );
  }
}
