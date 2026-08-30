
import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../view_models/explore_view_model.dart';
import 'community_screen.dart';
import 'reels_screen.dart';

class ExploreScreen extends ConsumerWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(exploreViewModel);
    final viewType = state.viewType;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        top: viewType == ExploreViewType.community,
        bottom: false,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          transitionBuilder: (
            Widget child,
            Animation<double> animation,
          ) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          child: viewType == ExploreViewType.community
              ? const CommunityScreen(
                  key: ValueKey('community'),
                )
              : const ReelsScreen(
                  key: ValueKey('reels'),
                ),
        ),
      ),
    );
  }
}

