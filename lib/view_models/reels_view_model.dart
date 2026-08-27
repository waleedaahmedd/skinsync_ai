import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/reel_model.dart';
import '../models/base_state_model.dart';

final reelsViewModel = NotifierProvider<ReelsViewModel, ReelsState>(() => ReelsViewModel());

class ReelsViewModel extends Notifier<ReelsState> {
  @override
  ReelsState build() {
    return ReelsState(
      reels: [
        Reel(
          id: '1',
          userName: 'Dr. Sarah Smith',
          userProfileImage: 'https://i.pravatar.cc/150?u=sarah',
          videoUrl: 'https://assets.mixkit.co/videos/preview/mixkit-girl-in-white-t-shirt-applying-face-cream-44161-large.mp4',
          caption: 'Morning skincare routine for glowing skin! ✨ #Skincare #Beauty #GlowingSkin',
          musicTitle: 'Original Audio - Dr. Sarah Smith',
          likesCount: 1250,
          commentsCount: 85,
          sharesCount: 45,
          viewsCount: 5000,
          createdAt: DateTime.now().subtract(const Duration(hours: 1)),
        ),
        Reel(
          id: '2',
          userName: 'Beauty Hub',
          userProfileImage: 'https://i.pravatar.cc/150?u=beauty',
          videoUrl: 'https://assets.mixkit.co/videos/preview/mixkit-woman-cleaning-her-face-with-a-sponge-44163-large.mp4',
          caption: 'Best way to double cleanse at night. 🧼 #DoubleCleanse #SkincareTips',
          musicTitle: 'Relaxing Vibes - Beauty Hub',
          likesCount: 850,
          commentsCount: 32,
          sharesCount: 12,
          viewsCount: 2300,
          createdAt: DateTime.now().subtract(const Duration(hours: 3)),
        ),
        Reel(
          id: '3',
          userName: 'Alex Glow',
          userProfileImage: 'https://i.pravatar.cc/150?u=alex',
          videoUrl: 'https://assets.mixkit.co/videos/preview/mixkit-young-woman-applying-moisturizer-on-her-face-44165-large.mp4',
          caption: 'Don\'t forget your neck when applying products! 💆‍♀️ #SkincareHacks',
          musicTitle: 'Lofi Beats - Chill Music',
          likesCount: 3400,
          commentsCount: 156,
          sharesCount: 230,
          viewsCount: 12000,
          createdAt: DateTime.now().subtract(const Duration(days: 1)),
        ),
      ],
    );
  }

  void toggleLike(String reelId) {
    state = state.copyWith(
      signDocument: state.reels.map((reel) {
        if (reel.id == reelId) {
          return reel.copyWith(
            isLiked: !reel.isLiked,
            likesCount: reel.isLiked ? reel.likesCount - 1 : reel.likesCount + 1,
          );
        }
        return reel;
      }).toList(),
    );
  }

  void toggleSave(String reelId) {
    state = state.copyWith(
      signDocument: state.reels.map((reel) {
        if (reel.id == reelId) {
          return reel.copyWith(isSaved: !reel.isSaved);
        }
        return reel;
      }).toList(),
    );
  }
}

class ReelsState extends BaseStateModel {
  final List<Reel> reels;

  const ReelsState({
    super.loading = false,
    super.errorMessage,
    this.reels = const [],
  });

  @override
  ReelsState copyWith({
    bool? loading,
    String? errorMessage,
    List<Reel>? signDocument,
  }) {
    return ReelsState(
      loading: loading ?? this.loading,
      errorMessage: errorMessage ?? this.errorMessage,
      reels: signDocument ?? this.reels,
    );
  }
}
