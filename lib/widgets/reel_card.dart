import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart';
import '../models/reel_model.dart';
import '../view_models/reels_view_model.dart';
import 'reels/reel_content_overlay.dart';
import 'reels/reel_sidebar.dart';

class ReelCard extends ConsumerStatefulWidget {
  final Reel reel;
  final bool isActive;

  const ReelCard({
    super.key,
    required this.reel,
    required this.isActive,
  });

  @override
  ConsumerState<ReelCard> createState() => _ReelCardState();
}

class _ReelCardState extends ConsumerState<ReelCard> {
  late VideoPlayerController _controller;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  void _initializeVideo() {
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.reel.videoUrl))
      ..initialize().then((_) {
        if (mounted) {
          setState(() {
            _initialized = true;
          });
          if (widget.isActive) {
            _controller.play();
            _controller.setLooping(true);
          }
        }
      });
  }

  @override
  void didUpdateWidget(ReelCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_initialized) {
      if (widget.isActive && !oldWidget.isActive) {
        _controller.play();
      } else if (!widget.isActive && oldWidget.isActive) {
        _controller.pause();
      }
    }
  }

  @override
  void dispose() {
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
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  )
                : const CircularProgressIndicator(color: Colors.white),
          ),

          // Overlay for interactions
          GestureDetector(
            onTap: () {
              if (_controller.value.isPlaying) {
                _controller.pause();
              } else {
                _controller.play();
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
          if (!_controller.value.isPlaying && _initialized)
            Center(
              child: Icon(
                Icons.play_arrow_rounded,
                size: 80.sp,
                color: Colors.white.withValues(alpha: 0.5),
              ),
            ),

          // Bottom Content
          Positioned(
            bottom: 100.h,
            left: 16.w,
            right: 80.w,
            child: ReelContentOverlay(
              userName: widget.reel.userName,
              userProfileImage: widget.reel.userProfileImage,
              caption: widget.reel.caption,
              musicTitle: widget.reel.musicTitle,
            ),
          ),

          // Right Sidebar Actions
          Positioned(
            bottom: 100.h,
            right: 12.w,
            child: ReelSidebar(
              likesCount: widget.reel.likesCount,
              commentsCount: widget.reel.commentsCount,
              sharesCount: widget.reel.sharesCount,
              isLiked: widget.reel.isLiked,
              isSaved: widget.reel.isSaved,
              onLike: () => ref.read(reelsViewModel.notifier).toggleLike(widget.reel.id),
              onComment: () {},
              onShare: () {},
              onSave: () => ref.read(reelsViewModel.notifier).toggleSave(widget.reel.id),
              onMore: () {},
            ),
          ),
        ],
      ),
    );
  }
}
