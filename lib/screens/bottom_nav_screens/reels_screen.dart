import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../../view_models/explore_view_model.dart';
import '../../widgets/app_loader.dart';
import '../../widgets/reel_card.dart';
import '../../widgets/social_toggle_button.dart';

class ReelsScreen extends ConsumerStatefulWidget {
  const ReelsScreen({super.key});

  static const String routeName = '/ReelsScreen';

  @override
  ConsumerState<ReelsScreen> createState() => _ReelsScreenState();
}

class _ReelsScreenState extends ConsumerState<ReelsScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    // Fetch reels once the widget is mounted
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(exploreViewModel.notifier).fetchReels();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(exploreViewModel);

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            // Loading state (initial load only)
            if (state.reelsLoading && state.reels.isEmpty)
              const Center(
                child: AppLoader(),
              )
            // Empty state
            else if (state.reels.isEmpty)
              const Center(
                child: Text(
                  'No reels found',
                  style: TextStyle(color: Colors.white70),
                ),
              )
            // Infinite Vertical PageView
            else
              Stack(
                children: [
                  PageView.builder(
                    controller: _pageController,
                    scrollDirection: Axis.vertical,
                    itemCount: state.reels.length,
                    onPageChanged: (index) {
                      setState(() {
                        _currentIndex = index;
                      });

                      // Pagination: fetch next page when nearing the end
                      if (index >= state.reels.length - 3 &&
                          state.reelsCurrentPage < state.reelsTotalPages &&
                          !state.reelsLoading) {
                        ref
                            .read(exploreViewModel.notifier)
                            .fetchReels(page: state.reelsCurrentPage + 1);
                      }
                    },
                    itemBuilder: (context, index) {
                      return ReelCard(
                        reel: state.reels[index],
                        isActive: _currentIndex == index,
                      );
                    },
                  ),

                  // Pagination loading indicator (bottom overlay)
                  if (state.reelsLoading)
                    Positioned(
                      bottom: context.h(24),
                      left: 0,
                      right: 0,
                      child: const Center(
                        child: SizedBox(
                          width: 28,
                          height: 28,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.5,
                          ),
                        ),
                      ),
                    ),
                ],
              ),

            // Header with Icons and Tabs
            SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: context.w(12),
                  vertical: context.h(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        SizedBox(width: context.w(4)),
                        SocialToggleButton(
                          onTap: () => ref
                              .read(exploreViewModel.notifier)
                              .toggleViewType(),
                          icon: Icons.grid_view_rounded,
                          isReels: true,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Usage tracking container at the bottom
            // Positioned(
            //   bottom: 85.h,
            //   left: 0,
            //   right: 0,
            //   child: const PostUsageContainer(isDark: true),
            // ),
          ],
        ),
      ),
    );
  }
}