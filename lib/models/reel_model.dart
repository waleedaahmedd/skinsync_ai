class Reel {
  final String id;
  final String userName;
  final String userProfileImage;
  final String videoUrl;
  final String? caption;
  final String? musicTitle;
  final int likesCount;
  final int commentsCount;
  final int sharesCount;
  final int viewsCount;
  final bool isLiked;
  final bool isSaved;
  final DateTime createdAt;

  Reel({
    required this.id,
    required this.userName,
    required this.userProfileImage,
    required this.videoUrl,
    this.caption,
    this.musicTitle,
    this.likesCount = 0,
    this.commentsCount = 0,
    this.sharesCount = 0,
    this.viewsCount = 0,
    this.isLiked = false,
    this.isSaved = false,
    required this.createdAt,
  });

  Reel copyWith({
    String? id,
    String? userName,
    String? userProfileImage,
    String? videoUrl,
    String? caption,
    String? musicTitle,
    int? likesCount,
    int? commentsCount,
    int? sharesCount,
    int? viewsCount,
    bool? isLiked,
    bool? isSaved,
    DateTime? createdAt,
  }) {
    return Reel(
      id: id ?? this.id,
      userName: userName ?? this.userName,
      userProfileImage: userProfileImage ?? this.userProfileImage,
      videoUrl: videoUrl ?? this.videoUrl,
      caption: caption ?? this.caption,
      musicTitle: musicTitle ?? this.musicTitle,
      likesCount: likesCount ?? this.likesCount,
      commentsCount: commentsCount ?? this.commentsCount,
      sharesCount: sharesCount ?? this.sharesCount,
      viewsCount: viewsCount ?? this.viewsCount,
      isLiked: isLiked ?? this.isLiked,
      isSaved: isSaved ?? this.isSaved,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
