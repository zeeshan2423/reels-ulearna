import 'package:equatable/equatable.dart';

class Reel extends Equatable {
  final String id;
  final String title;
  final String description;
  final String videoUrl;
  final String thumbnailUrl;
  final String creator;
  final int likes;
  final int views;
  final DateTime createdAt;
  final String? category;
  final String? creatorProfilePicture;

  const Reel({
    required this.id,
    required this.title,
    required this.description,
    required this.videoUrl,
    required this.thumbnailUrl,
    required this.creator,
    required this.likes,
    required this.views,
    required this.createdAt,
    this.category,
    this.creatorProfilePicture,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    videoUrl,
    thumbnailUrl,
    creator,
    likes,
    views,
    createdAt,
    category,
    creatorProfilePicture,
  ];
}
