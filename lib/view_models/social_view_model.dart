import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/social_post_model.dart';
import '../models/base_state_model.dart';

final socialViewModel = NotifierProvider<SocialViewModel, SocialState>(() => SocialViewModel());

class SocialViewModel extends Notifier<SocialState> {
  @override
  SocialState build() {
    // Initial dummy data
    return SocialState(
      posts: [
        SocialPost(
          id: '1',
          userName: 'Sarah Jenkins',
          userProfileImage: 'https://i.pravatar.cc/150?u=sarah',
          contentText: 'Just finished my third session of laser treatment. The results are starting to show! Super happy with the progress. #SkinSync #GlowUp',
          imageUrls: ['https://images.unsplash.com/photo-1522335789203-aabd1fc54bc9?w=500&auto=format&fit=crop&q=60'],
          likesCount: 24,
          commentsCount: 5,
          createdAt: DateTime.now().subtract(const Duration(hours: 2)),
          isLiked: true,
        ),
        SocialPost(
          id: '2',
          userName: 'Michael Chen',
          userProfileImage: 'https://i.pravatar.cc/150?u=michael',
          contentText: 'Highly recommend Dr. Smith at the Serene Excellence clinic. Very professional and helpful.',
          imageUrls: ['https://images.unsplash.com/photo-1612349317150-e413f6a5b16d?w=500&auto=format&fit=crop&q=60'],
          likesCount: 15,
          commentsCount: 2,
          createdAt: DateTime.now().subtract(const Duration(hours: 5)),
        ),
        SocialPost(
          id: '3',
          userName: 'Emma Watson',
          userProfileImage: 'https://i.pravatar.cc/150?u=emma',
          contentText: 'My morning routine with the products recommended by the AI. It really understands my skin type!',
          imageUrls: [
            'https://images.unsplash.com/photo-1556228720-195a672e8a03?w=500&auto=format&fit=crop&q=60',
            'https://images.unsplash.com/photo-1570172619644-dfd03ed5d881?w=500&auto=format&fit=crop&q=60'
          ],
          likesCount: 42,
          commentsCount: 12,
          createdAt: DateTime.now().subtract(const Duration(days: 1)),
        ),
      ],
    );
  }

  void toggleLike(String postId) {
    state = state.copyWith(
      posts: state.posts.map((post) {
        if (post.id == postId) {
          return post.copyWith(
            isLiked: !post.isLiked,
            likesCount: post.isLiked ? post.likesCount - 1 : post.likesCount + 1,
          );
        }
        return post;
      }).toList(),
    );
  }

  void addPost(SocialPost post) {
    state = state.copyWith(posts: [post, ...state.posts]);
  }
}

class SocialState extends BaseStateModel {
  final List<SocialPost> posts;

  const SocialState({
    super.loading = false,
    super.errorMessage,
    this.posts = const [],
  });

  @override
  SocialState copyWith({
    bool? loading,
    String? errorMessage,
    List<SocialPost>? posts,
  }) {
    return SocialState(
      loading: loading ?? this.loading,
      errorMessage: errorMessage ?? this.errorMessage,
      posts: posts ?? this.posts,
    );
  }
}
