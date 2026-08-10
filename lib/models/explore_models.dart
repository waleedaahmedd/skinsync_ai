class ReelModel {
  final int? id;
  final String title;
  final String? description;
  final String videoUrl;
  final String? thumbnail;
  final List<String> tags;
  final DateTime? createdAt;
  final String? profileLogo;
  final String? profileName;
  final String status;

  ReelModel({
    this.id,
    required this.title,
    this.description,
    required this.videoUrl,
    this.thumbnail,
    this.tags = const [],
    this.createdAt,
    this.profileLogo,
    this.profileName,
    this.status = 'Active',
  });

  factory ReelModel.fromJson(Map<String, dynamic> json) {
    return ReelModel(
      id: json['id'],
      title: json['title'] ?? '',
      description: json['description'],
      videoUrl: json['video_url'] ?? '',
      thumbnail: json['thumbnail'],
      tags: json['tags'] != null ? List<String>.from(json['tags']) : [],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      profileLogo: json['profile_logo'] ?? '',
      profileName: json['profile_name'] ?? '',
      status: json['status'] ?? 'Active',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'video_url': videoUrl,
      'thumbnail': thumbnail,
      'tags': tags,
      'status': status,
    };
  }
}

class CommunityPostModel {
  final int? id;
  final String title;
  final String content;
  final String? imageUrl;
  final String? category;
  final List<String> tags;
  final DateTime? createdAt;
  final String? profileLogo;
  final String? profileName;
  final String status;

  CommunityPostModel({
    this.id,
    required this.title,
    required this.content,
    this.imageUrl,
    this.category,
    this.tags = const [],
    this.createdAt,
    this.profileLogo,
    this.profileName,
    this.status = 'Active',
  });

  factory CommunityPostModel.fromJson(Map<String, dynamic> json) {
    return CommunityPostModel(
      id: json['id'],
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      imageUrl: json['image_url'] ?? '',
      category: json['category'] ?? '',
      tags: json['tags'] is List ? List<String>.from(json['tags']) : [],
      createdAt:
          json['created_at'] != null && json['created_at'].toString().isNotEmpty
          ? DateTime.parse(json['created_at'])
          : null,
      profileLogo: json['profile_logo'] ?? '',
      profileName: json['profile_name'] ?? '',
      status: json['status'] ?? 'Active',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'image_url': imageUrl,
      'category': category,
      'tags': tags,
      'created_at': createdAt?.toIso8601String(),
      'profile_logo': profileLogo,
      'profile_name': profileName,
      'status': status,
    };
  }
}
