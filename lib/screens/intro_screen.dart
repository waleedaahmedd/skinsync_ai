import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../utils/assets.dart';
import '../utils/color_constant.dart';
import '../utils/custom_fonts.dart';
import '../view_models/auth_view_model.dart';
import '../widgets/custom_button.dart';
import 'get_started_screen.dart';

class IntroScreen extends ConsumerStatefulWidget {
  const IntroScreen({super.key});
  static const String routeName = '/IntroScreen';

  @override
  ConsumerState<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends ConsumerState<IntroScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  static const List<_IntroSlide> _slides = [
    _IntroSlide(
      title: 'Explore Clinics',
      description:
          'Discover highly-rated clinics, compare services, and find the right skin experts near you.',
      asset: PngAssets.beautyNear,
      topBadge: 'Local care',
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFFB9F1FF), Color(0xFFE6D8FF)],
      ),
      accent: Color(0xFF6BB3FF),
      featurePills: ['Verified clinics', 'Top ratings', 'Nearby care'],
    ),
    _IntroSlide(
      title: 'Create Simulations',
      description:
          'Preview your treatment journey with AI-powered before and after simulations built for your skin goals.',
      asset: PngAssets.beforeAfter,
      topBadge: 'AI preview',
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFFF6D9FF), Color(0xFFD9EDFF)],
      ),
      accent: Color(0xFFB56FFF),
      featurePills: ['Realistic preview', 'Skin goals', 'Smart insights'],
    ),
    _IntroSlide(
      title: 'Share Request to Clinics',
      description:
          'Send a personalized consultation request to clinics and get matched with the right treatment plan faster.',
      asset: PngAssets.notification,
      topBadge: 'Fast match',
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFFDDF5D8), Color(0xFFE7E8FF)],
      ),
      accent: Color(0xFF58C79F),
      featurePills: ['Request sent', 'Clinics matched', 'Faster access'],
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goNext() {
    if (_currentPage < _slides.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
      return;
    }

    _handleContinue();
  }

  void _handleContinue() {
    ref.read(authViewModel.notifier).checkBiometricAvailability();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const GetStartedScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        top: false,
        child: Container(
          decoration: BoxDecoration(
            gradient: CustomColors.blueWithWhiteGradient,
          ),
          child: Stack(
            children: [
              Positioned(
                top: context.h(70),
                right: context.w(0),
                left: context.w(0),
                child: Image.asset(
                  PngAssets.vector2,
                  height: context.h(552),
                  fit: BoxFit.fill,
                ),
              ),
              Positioned(
                top: context.h(70),
                right: context.w(0),
                left: context.w(0),
                child: Image.asset(
                  PngAssets.vector,
                  height: context.h(376),
                  fit: BoxFit.fill,
                  color: const Color(0xff88E3FB).withValues(alpha: 0.7),
                ),
              ),
              Positioned(
                top: context.h(432),
                child: Image.asset(PngAssets.blur, height: context.h(564)),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: context.w(20),
                  vertical: context.h(18),
                ),
                child: Column(
                  children: [
                    SizedBox(height: context.h(40)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Skinsync Ai', style: CustomFonts.grey20w500),
                        TextButton(
                          onPressed: _handleContinue,
                          style: TextButton.styleFrom(
                            foregroundColor: CustomColors.blackColor,
                          ),
                          child: Text('Skip', style: CustomFonts.black14w600),
                        ),
                      ],
                    ),
                    SizedBox(height: context.h(8)),
                    Expanded(
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: _slides.length,
                        onPageChanged: (value) {
                          setState(() => _currentPage = value);
                        },
                        itemBuilder: (context, index) {
                          final slide = _slides[index];
                          return Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: context.w(4),
                            ),
                            child: _IntroFeatureCard(slide: slide),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: context.h(18)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        _slides.length,
                        (index) => AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: _currentPage == index
                              ? context.w(20)
                              : context.w(8),
                          height: context.h(8),
                          margin: EdgeInsets.symmetric(
                            horizontal: context.w(4),
                          ),
                          decoration: BoxDecoration(
                            color: _currentPage == index
                                ? CustomColors.darkPurple
                                : Colors.white.withValues(alpha: 0.7),
                            borderRadius: BorderRadius.circular(context.r(20)),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: context.h(20)),
                    CustomButton(
                      onPressed: _goNext,
                      text: _currentPage == _slides.length - 1
                          ? 'Get Started'
                          : 'Next',
                    ),
                    SizedBox(height: context.h(12)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _IntroFeatureCard extends StatelessWidget {
  const _IntroFeatureCard({required this.slide});

  final _IntroSlide slide;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(context.w(22)),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(context.r(36)),
        gradient: slide.gradient,
        // boxShadow: CustomColors.cardShadow,
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.65),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: context.w(14),
                vertical: context.h(8),
              ),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.32),
                borderRadius: BorderRadius.circular(context.r(20)),
              ),
              child: Text(
                slide.topBadge,
                style: CustomFonts.black12w600.copyWith(
                  color: Colors.black.withValues(alpha: 0.72),
                ),
              ),
            ),
          ),
          SizedBox(height: context.h(20)),
          Center(
            child: Container(
              width: context.w(80),
              height: context.h(80),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.4),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.6),
                  width: 1.5,
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(context.w(18)),
                child: Image.asset(slide.asset, fit: BoxFit.contain),
              ),
            ),
          ),
          SizedBox(height: context.h(20)),
          Text(
            slide.title,
            textAlign: TextAlign.left,
            style: CustomFonts.black30w600,
          ),
          SizedBox(height: context.h(10)),
          Text(
            slide.description,
            style: CustomFonts.grey18w400,
            textAlign: TextAlign.left,
          ),
          SizedBox(height: context.h(18)),
          Wrap(
            spacing: context.w(8),
            runSpacing: context.h(8),
            children: slide.featurePills
                .map(
                  (pill) => Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: context.w(12),
                      vertical: context.h(7),
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.55),
                      borderRadius: BorderRadius.circular(context.r(18)),
                    ),
                    child: Text(
                      pill,
                      style: CustomFonts.black12w600.copyWith(
                        color: CustomColors.blackColor.withValues(alpha: 0.75),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          const Spacer(),
          Container(
            width: double.infinity,
            height: context.h(170),
            padding: EdgeInsets.all(context.w(16)),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(context.r(28)),
              color: Colors.white.withValues(alpha: 0.38),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.5),
                width: 1,
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  left: context.w(10),
                  top: context.h(14),
                  child: Container(
                    width: context.w(122),
                    height: context.h(72),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(context.r(18)),
                      color: Colors.white.withValues(alpha: 0.72),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${slide.title.split(' ').first}+',
                          style: CustomFonts.black18w600,
                        ),
                        Text('matched', style: CustomFonts.grey14w400),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  right: context.w(10),
                  bottom: context.h(18),
                  child: Container(
                    width: context.w(124),
                    height: context.h(72),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(context.r(18)),
                      color: slide.accent.withValues(alpha: 0.16),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.check_circle_rounded,
                          color: slide.accent,
                          size: context.sp(28),
                        ),
                        SizedBox(height: context.h(4)),
                        Text('Ready', style: CustomFonts.black14w600),
                      ],
                    ),
                  ),
                ),
                Center(
                  child: Container(
                    width: context.w(100),
                    height: context.h(100),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.65),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(context.w(16)),
                      child: Image.asset(slide.asset, fit: BoxFit.contain),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _IntroSlide {
  const _IntroSlide({
    required this.title,
    required this.description,
    required this.asset,
    required this.topBadge,
    required this.gradient,
    required this.accent,
    required this.featurePills,
  });

  final String title;
  final String description;
  final String asset;
  final String topBadge;
  final LinearGradient gradient;
  final Color accent;
  final List<String> featurePills;
}
