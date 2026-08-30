import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:pinput/pinput.dart';
import '../utils/assets.dart';
import '../utils/color_constant.dart';
import '../utils/custom_fonts.dart';
import '../view_models/auth_view_model.dart';
import '../widgets/app_loader.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_button.dart';
import 'bottom_nav_page.dart';
import 'login_screen.dart';
import 'your_profile_screen.dart';

class OtpScreen extends StatelessWidget {
  const OtpScreen({super.key});
  static const String routeName = '/OtpScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(showTitle: false),
      body: Padding(
        padding: EdgeInsets.only(
          left: context.w(30),
          right: context.w(30),
          bottom: MediaQuery.paddingOf(context).bottom,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: context.h(43)),
            Container(
              padding: EdgeInsets.all(context.w(14)),
              height: context.h(79),
              width: context.w(79),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: CustomColors.lightBlueColor,
              ),
              child: Image.asset(
                PngAssets.email,
                height: context.h(50),
                width: context.w(50),
              ),
            ),
            SizedBox(height: context.h(27)),
            Text("Enter Your Code", style: CustomFonts.black30w600),
            SizedBox(height: context.h(4)),
            Text(
              "We sent a verification code to your email",
              style: CustomFonts.grey18w400,
            ),
            SizedBox(height: context.h(2)),
            Consumer(
              builder: (context, ref, child) {
                final email = ref
                    .read(authViewModel.notifier)
                    .emailController
                    .text;
                return Text(email, style: CustomFonts.grey18w500);
              },
            ),
            SizedBox(height: context.h(22)),
            Consumer(
              builder: (context, ref, child) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Pinput(
                        controller: ref
                            .read(authViewModel.notifier)
                            .otpController,
                        mainAxisAlignment: MainAxisAlignment.center,
                        separatorBuilder: (index) =>
                            SizedBox(width: context.w(4)),
                        length: 6,
                        defaultPinTheme: PinTheme(
                          width: context.w(82),
                          height: context.h(55),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: CustomColors.textFeildBoaderColor,
                            ),
                            borderRadius: BorderRadius.circular(context.r(10)),
                          ),
                          textStyle: TextStyle(
                            fontSize: context.sp(16),
                            color: CustomColors.blackColor,
                          ),
                        ),
                        focusedPinTheme: PinTheme(
                          width: context.w(82.5),
                          height: context.h(55),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: CustomColors.textFeildBoaderColor,
                            ),
                            borderRadius: BorderRadius.circular(context.r(10)),
                          ),
                          textStyle: TextStyle(
                            fontSize: context.sp(16),
                            color: CustomColors.blackColor,
                          ),
                        ),
                        submittedPinTheme: PinTheme(
                          width: context.w(82.5),
                          height: context.h(55),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: CustomColors.textFeildBoaderColor,
                            ),
                            borderRadius: BorderRadius.circular(context.r(10)),
                          ),
                          textStyle: TextStyle(
                            fontSize: context.sp(16),
                            color: CustomColors.blackColor,
                          ),
                        ),
                        onChanged: (pin) {},
                        onCompleted: (pin) {},
                      ),
                    ),
                    if (ref.watch(authViewModel).otpError != null)
                      Padding(
                        padding: EdgeInsets.only(top: context.h(8)),
                        child: Text(
                          ref.watch(authViewModel).otpError!,
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: context.sp(12),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
            const Spacer(),
            SizedBox(
              height: context.w(60),
              child: Center(
                child: Consumer(
                  builder: (context, ref, child) => SizedBox(
                    width: double.infinity,
                    child: ref.watch(authViewModel).loading
                        ? const AppLoader()
                        : CustomButton(
                            onPressed: () async {
                              if (ref
                                  .read(authViewModel.notifier)
                                  .validateOtp()) {
                                await ref
                                    .read(authViewModel.notifier)
                                    .callVerifyOtpApi()
                                    .then((value) async {
                                      if (value == true) {
                                        final isLoggedIn =
                                            ref
                                                .read(authViewModel)
                                                .authData
                                                ?.isFirstLogin ??
                                            false;

                                        isLoggedIn
                                            ? Navigator.pushNamedAndRemoveUntil(
                                                context,
                                                YourProfileScreen.routeName,
                                                (Route<dynamic> route) =>
                                                    route.settings.name ==
                                                    LoginScreen.routeName,
                                              )
                                            : 
                                            
                                           Navigator.pushNamedAndRemoveUntil(
                                                context,
                                                BottomNavPage.routeName,
                                                (Route<dynamic> route) => false,
                                              );
                                      }
                                    });
                              }
                            },
                            text: "Next",
                          ),
                  ),
                ),
              ),
            ),
            SizedBox(height: context.h(20)),
          ],
        ),
      ),
    );
  }
}
