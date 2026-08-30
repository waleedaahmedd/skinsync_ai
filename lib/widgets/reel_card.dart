import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:cached_video_player_plus/cached_video_player_plus.dart';
import 'package:video_player/video_player.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../models/explore_models.dart';
import '../utils/custom_fonts.dart';
import 'reels/reel_content_overlay.dart';

class ReelCard extends ConsumerStatefulWidget {
  final ReelModel reel;
  final bool isActive;

  const ReelCard({super.key, required this.reel, required this.isActive});

  @override
  ConsumerState<ReelCard> createState() => _ReelCardState();
}

class _ReelCardState extends ConsumerState<ReelCard> {
  late CachedVideoPlayerPlus _controller;
  bool _initialized = false;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  void _initializeVideo() {
    _controller =
        CachedVideoPlayerPlus.networkUrl(Uri.parse(widget.reel.videoUrl))
          ..initialize().then((_) {
            if (mounted) {
              setState(() {
                _initialized = true;
              });
              if (widget.isActive) {
                _controller.controller.play();
                _controller.controller.setLooping(true);
                WakelockPlus.enable();
              }
            }
          });
  }

  @override
  void didUpdateWidget(ReelCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_initialized) {
      if (widget.isActive && !oldWidget.isActive) {
        _controller.controller.play();
        WakelockPlus.enable();
      } else if (!widget.isActive && oldWidget.isActive) {
        _controller.controller.pause();
      }
    }
  }

  @override
  void dispose() {
    if (widget.isActive) {
      WakelockPlus.disable();
    }
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.black,
      child: Stack(
        children: [
          // Video Player
          Center(
            child: _initialized
                ? AspectRatio(
                    aspectRatio: _controller.controller.value.aspectRatio,
                    child: VideoPlayer(_controller.controller),
                  )
                : const CircularProgressIndicator(color: Colors.white),
          ),

          // Overlay for interactions
          GestureDetector(
            onTap: () {
              if (!_initialized) return;
              if (_controller.controller.value.isPlaying) {
                _controller.controller.pause();
                WakelockPlus.disable();
              } else {
                _controller.controller.play();
                WakelockPlus.enable();
              }
              setState(() {});
            },
            child: Container(
              color: Colors.transparent,
              width: double.infinity,
              height: double.infinity,
            ),
          ),

          // Play/Pause icon overlay on tap
          if (_initialized && !_controller.controller.value.isPlaying)
            Center(
              child: Icon(
                Icons.play_arrow_rounded,
                size: context.sp(80),
                color: Colors.white.withValues(alpha: 0.5),
              ),
            ),

          // Bottom Content with Gradient and Toggle
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.fromLTRB(
                context.w(16),
                context.h(80),
                context.w(16),
                context.h(20),
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.7),
                    Colors.transparent,
                  ],
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: ReelContentOverlay(
                      userName: widget.reel.profileName ?? 'N/A',
                      userProfileImage: widget.reel.profileLogo ?? '',
                      caption: widget.reel.description,
                      isExpanded: _isExpanded,
                      // musicTitle: widget.reel.musicTitle,
                    ),
                  ),
                  SizedBox(width: context.w(40)),
                  // Hide/Show Toggle Button
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isExpanded = !_isExpanded;
                      });
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _isExpanded ? 'Hide' : 'Show',
                          style: CustomFonts.white12w400,
                        ),
                        Icon(
                          _isExpanded
                              ? Icons.keyboard_arrow_down_rounded
                              : Icons.keyboard_arrow_up_rounded,
                          color: Colors.white,
                          size: context.sp(20),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Right Sidebar Actions
          // Positioned(
          //   bottom: context.h(100),
          //   right: context.w(12),
          //   child: ReelSidebar(
          //     likesCount: widget.reel.likesCount,
          //     commentsCount: widget.reel.commentsCount,
          //     sharesCount: widget.reel.sharesCount,
          //     isLiked: widget.reel.isLiked,
          //     isSaved: widget.reel.isSaved,
          //     onLike: () => ref.read(reelsViewModel.notifier).toggleLike(widget.reel.id),
          //     onComment: () {},
          //     onShare: () {},
          //     onSave: () => ref.read(reelsViewModel.notifier).toggleSave(widget.reel.id),
          //     onMore: () {},
          //   ),
          // ),
        ],
      ),
    );
  }
}
