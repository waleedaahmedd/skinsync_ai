
class SocialPost {
  final String id;
  final String userName;
  final String userProfileImage;
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
    this.contentText,
    required this.imageUrls,
    this.videoUrl,
    this.likesCount = 0,
    this.commentsCount = 0,
    required this.createdAt,
    this.isLiked = false,
  });

  SocialPost copyWith({
    String? id,
    String? userName,
    String? userProfileImage,
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
