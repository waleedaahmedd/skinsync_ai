import 'explore_models.dart';

class SocialPost {
  final String id;
  final String userName;
  final String userProfileImage;
  final String? title;
  final String? contentText;
  final List<String> imageUrls;
  final String? videoUrl;
  final int likesCount;
  final int commentsCount;
  final DateTime createdAt;
  final bool isLiked;

  SocialPost({
    required this.id,
    required this.userName,
    required this.userProfileImage,
    this.title,
    this.contentText,
    required this.imageUrls,
    this.videoUrl,
    this.likesCount = 0,
    this.commentsCount = 0,
    required this.createdAt,
    this.isLiked = false,
  });

  factory SocialPost.fromCommunityPost(CommunityPostModel model) {
    return SocialPost(
      id: model.id?.toString() ?? '',
      userName: model.profileName ?? 'Community Member',
      userProfileImage: model.profileLogo ?? '',
      title: model.title,
      contentText: model.content,
      imageUrls: model.imageUrl != null && model.imageUrl!.isNotEmpty
          ? [model.imageUrl!]
          : [],
      createdAt: model.createdAt ?? DateTime.now(),
      likesCount: 0, // Placeholder as CommunityPostModel doesn't have it
      commentsCount: 0,
    );
  }

  SocialPost copyWith({
    String? id,
    String? userName,
    String? userProfileImage,
    String? title,
    String? contentText,
    List<String>? imageUrls,
    String? videoUrl,
    int? likesCount,
    int? commentsCount,
    DateTime? createdAt,
    bool? isLiked,
  }) {
    return SocialPost(
      id: id ?? this.id,
      userName: userName ?? this.userName,
      userProfileImage: userProfileImage ?? this.userProfileImage,
      title: title ?? this.title,
      contentText: contentText ?? this.contentText,
      imageUrls: imageUrls ?? this.imageUrls,
      videoUrl: videoUrl ?? this.videoUrl,
      likesCount: likesCount ?? this.likesCount,
      commentsCount: commentsCount ?? this.commentsCount,
      createdAt: createdAt ?? this.createdAt,
      isLiked: isLiked ?? this.isLiked,
    );
  }
}
