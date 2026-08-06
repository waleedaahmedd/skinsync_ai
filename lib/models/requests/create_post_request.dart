class CreatePostRequest {
  final String? title;
  final String contentText;
  final List<String> imageUrls;
  final String? videoUrl;

  CreatePostRequest({
    this.title,
    required this.contentText,
    this.imageUrls = const [],
    this.videoUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      if (title != null) 'title': title,
      'content_text': contentText,
      'image_urls': imageUrls,
      if (videoUrl != null) 'video_url': videoUrl,
    };
  }
}
