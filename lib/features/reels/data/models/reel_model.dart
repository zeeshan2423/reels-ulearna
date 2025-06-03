import '../../domain/entities/reel.dart';

class ReelModel extends Reel {
  const ReelModel({
    required super.id,
    required super.title,
    required super.description,
    required super.videoUrl,
    required super.thumbnailUrl,
    required super.creator,
    required super.likes,
    required super.views,
    required super.createdAt,
    super.category,
    super.creatorProfilePicture,
  });

  factory ReelModel.fromJson(Map<String, dynamic> json) {
    final user = json['user'] as Map<String, dynamic>?;
    final category = json['category'] as Map<String, dynamic>?;

    return ReelModel(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      videoUrl: json['cdn_url']?.toString() ?? json['url']?.toString() ?? '',
      thumbnailUrl: json['thumb_cdn_url']?.toString() ?? '',
      creator:
          user?['fullname']?.toString() ?? user?['username']?.toString() ?? '',
      likes: int.tryParse(json['total_likes']?.toString() ?? '0') ?? 0,
      views: int.tryParse(json['total_views']?.toString() ?? '0') ?? 0,
      createdAt:
          DateTime.tryParse(json['byte_added_on']?.toString() ?? '') ??
          DateTime.now(),
      category: category?['title']?.toString(),
      creatorProfilePicture:
          user?['profile_picture_cdn']?.toString() ??
          user?['profile_picture']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'cdn_url': videoUrl,
      'thumb_cdn_url': thumbnailUrl,
      'creator': creator,
      'total_likes': likes,
      'total_views': views,
      'byte_added_on': createdAt.toIso8601String(),
      'category': category,
      'creator_profile_picture': creatorProfilePicture,
    };
  }
}
