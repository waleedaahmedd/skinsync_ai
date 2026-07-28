class CreatePostRequest {
  final String contentText;
  final List<String> imageUrls;
  final String? videoUrl;

  CreatePostRequest({
    required this.contentText,
    this.imageUrls = const [],
    this.videoUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'content_text': contentText,
      'image_urls': imageUrls,
      if (videoUrl != null) 'video_url': videoUrl,
    };
  }
}
