import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'skin_type.dart';
import '../utils/assets.dart';
import '../utils/color_constant.dart';
import '../utils/custom_fonts.dart';
import '../view_models/sign_up_onboarding_view_model.dart';

class SignupOnboarding extends ConsumerStatefulWidget {
  const SignupOnboarding({super.key});
  static const String routeName = '/SignupOnboarding';

  @override
  ConsumerState<SignupOnboarding> createState() => _SignupOnboardingState();
}

class _SignupOnboardingState extends ConsumerState<SignupOnboarding> {
  late final PageController _pageController;

  List<Widget> _pages = [
    // SkinType(),
    // MainSkinConcernsScreen(),
    // LifeStyleHabbits(),
    // SkinAllergiesScreen(),
    // SkinGoalsScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final signupViewModel = ref.read(onBoardingViewModel.notifier);
      await signupViewModel.callOnBoardingQuestionApi();
      if (mounted) {
        signupViewModel.setPageController(_pageController);
        final questions =
            ref.read(onBoardingViewModel).onBoardingQues?.data?.questions ?? [];

        _pages = List.generate(questions.length, (index) => const SkinType());

        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(onBoardingViewModel);
    final notifier = ref.read(onBoardingViewModel.notifier);
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.paddingOf(context).bottom,
          top: MediaQuery.paddingOf(context).top,
        ),
        decoration: BoxDecoration(
          gradient: CustomColors.blueWhitePurpleGradient,
        ),
        child: Stack(
          children: [
            Positioned(
              top: -40,
              left: 0,
              right: 0,
              child: Opacity(
                opacity: 0.5,
                child: SizedBox(
                  width: double.infinity,
                  height: context.h(201),
                  child: Image.asset(PngAssets.signupVector),
                ),
              ),
            ),
            Column(
              children: [
                SizedBox(height: context.h(28)),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: context.w(30)),
                  child: Column(
                    children: [
                      // Progress Bar
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${state.currentPage + 1}/${state.totalPages}',
                            style: CustomFonts.black20w600,
                          ),
                          SizedBox(width: context.w(12)),
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(context.r(10)),
                              child: LinearProgressIndicator(
                                value: notifier.progressValue(),
                                minHeight: context.h(10),
                                backgroundColor: Colors.white,
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                  CustomColors.lightBlueColor,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: context.h(16)),

                      // Navigation Buttons Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          state.currentPage > 0
                              ? GestureDetector(
                                  onTap: () {
                                    notifier.goToPreviousPage();
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: context.w(8),
                                      vertical: context.h(10),
                                    ),
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: CustomColors.purpleColor,
                                    ),
                                    child: Icon(
                                      CupertinoIcons.arrow_left,
                                      size: context.sp(18),
                                      color: Colors.white,
                                    ),
                                  ),
                                )
                              : const SizedBox(),
                          GestureDetector(
                            onTap: () {
                              notifier.onSkipThis(context);
                            },
                            child: Row(
                              children: [
                                Text(
                                  'Skip This',
                                  style: CustomFonts.black16w400,
                                ),
                                SizedBox(width: context.w(8)),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: context.w(8),
                                    vertical: context.h(10),
                                  ),
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: CustomColors.purpleColor,
                                  ),
                                  child: Icon(
                                    CupertinoIcons.arrow_right,
                                    size: context.sp(18),
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: _pages.isEmpty
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: CustomColors.purpleColor,
                          ),
                        )
                      : PageView.builder(
                          controller: _pageController,
                          onPageChanged: (index) =>
                              notifier.onPageChanged(index),
                          itemCount: _pages.length,
                          itemBuilder: (context, index) {
                            return _pages[index];
                          },
                        ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
