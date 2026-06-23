import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../models/requests/sign_in_request.dart';
import 'otp_screen.dart';
import '../utills/assets.dart';
import '../utills/color_constant.dart';
import '../utills/custom_fonts.dart';
import '../utills/enums.dart';
import '../view_models/auth_view_model.dart';
import '../widgets/app_loader.dart';
import '../widgets/phone_widget.dart';

import '../widgets/custom_app_bar.dart';

class LoginScreen extends ConsumerStatefulWidget {
  static const String routeName = '/LoginScreen';
  final LoginProviders loginWith;
  const LoginScreen({super.key, required this.loginWith});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  late Animation<double> _widthAnim;
  late Animation<double> _heightAnim;
  late Animation<double> _topAnim;
  late Animation<double> _leftAnim;
  late Animation<double> _radiusAnim;

  OverlayEntry? _entry;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey _buttonKey = GlobalKey();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) => _startAnimation());
  }

  void _startAnimation() {
    final overlay = Overlay.of(context);
    final size = MediaQuery.of(context).size;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      final renderBox =
          _buttonKey.currentContext?.findRenderObject() as RenderBox?;
      if (renderBox == null) return;

      final buttonPos = renderBox.localToGlobal(Offset.zero);
      final buttonSize = renderBox.size;

      // Clamp to avoid negative/zero values
      final targetWidth = buttonSize.width > 0 ? buttonSize.width : 1;
      final targetHeight = buttonSize.height > 0 ? buttonSize.height : 1;

      _topAnim =
          Tween<double>(
            begin: 0,
            end: buttonPos.dy.clamp(0, size.height),
          ).animate(
            CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
          );

      _leftAnim =
          Tween<double>(
            begin: 0,
            end: buttonPos.dx.clamp(0, size.width),
          ).animate(
            CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
          );

      _widthAnim = Tween<double>(begin: size.width, end: targetWidth.toDouble())
          .animate(
            CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
          );

      _heightAnim =
          Tween<double>(
            begin: size.height,
            end: targetHeight.toDouble(),
          ).animate(
            CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
          );

      _radiusAnim = Tween<double>(begin: 10.r.toDouble(), end: 40.r.toDouble())
          .animate(
            CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
          );

      _entry = OverlayEntry(
        builder: (context) {
          return AnimatedBuilder(
            animation: _controller,
            builder: (_, _) {
              return Positioned(
                top: _topAnim.value.toDouble(),
                left: _leftAnim.value.toDouble(),
                child: Container(
                  width: _widthAnim.value.toDouble().clamp(1, size.width),
                  height: _heightAnim.value.toDouble().clamp(1, size.height),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(
                      _radiusAnim.value.toDouble(),
                    ),
                  ),
                ),
              );
            },
          );
        },
      );

      overlay.insert(_entry!);

      _controller.forward().then((_) {
        _entry?.remove();
        _entry = null;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _entry?.remove();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ref.listen<AuthState>(authViewModel, authStateListener);
    final loginWithEmail = widget.loginWith == LoginProviders.email;

    return Scaffold(
      appBar: const CustomAppBar(showTitle: false),
      body: Padding(
        padding: EdgeInsets.only(left: 30.w, right: 30.w),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 43.h),
              Container(
                padding: EdgeInsets.all(14.w),
                height: 79.h,
                width: 79.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: CustomColors.lightBlueColor.withValues(alpha: 0.4),
                ),
                child: Image.asset(PngAssets.email, height: 50.h, width: 50.w),
              ),
              SizedBox(height: 27.h),
              Text(
                loginWithEmail ? "Continue with Email" : "Continue with Phone",
                style: CustomFonts.black30w600,
              ),
              SizedBox(height: 4.h),
              Text(
                "Sign in or sign up with your email.",
                style: CustomFonts.grey18w400,
              ),
              SizedBox(height: 22.h),
              loginWithEmail
                  ? TextFormField(
                      controller: ref
                          .read(authViewModel.notifier)
                          .emailController,
                      style: CustomFonts.black18w400,
                      decoration: const InputDecoration(hintText: "Email Address"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        final emailRegExp = RegExp(
                          r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                        );
                        if (!emailRegExp.hasMatch(value)) {
                          return 'Enter a valid email';
                        }
                        return null;
                      },
                    )
                  : PhoneWidget(
                      controller: ref
                          .read(authViewModel.notifier)
                          .phoneController,
                      filled: true,
                    ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(30.w),
          child: SizedBox(
            key: _buttonKey, // Required for animation target
            width: double.infinity,
            child: ref.watch(authViewModel).loading
                ? const AppLoader()
                : ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState?.validate() ?? false) {
                  final req = loginWithEmail
                      ? SignInWithEmailRequest(
                          email: ref
                              .read(authViewModel.notifier)
                              .emailController
                              .text,
                          provider: LoginProviders.email,
                          deviceInfo: "devicefo",
                          ipAddress: "ipAddr",
                        )
                      : SignInWithPhoneRequest(
                          phone: _phoneController.value.text,
                          provider: LoginProviders.phone,
                          deviceInfo: "deviceInfo",
                          ipAddress: "ipAddress",
                        );
                  final success = await ref
                      .read(authViewModel.notifier)
                      .callSignInApi(req);
                  if (success == true) {
                    Navigator.of(context).pushNamed(OtpScreen.routeName);
                  }
                }
              },
              child: const Text("Next"),
            ),
          ),
        ),
      ),
    );
  }
}
