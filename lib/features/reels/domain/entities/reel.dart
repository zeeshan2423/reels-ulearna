// File: reel.dart
// Layer: Domain -> Entities
//
// Purpose:
// This file defines the `Reel` entity class for the application, which is part of the Domain layer in Clean Architecture.
// Entities represent the core business objects and rules of the application, independent of any specific framework or technology.
//
// 🔍 Description:
// The `Reel` class models a short video content item (similar to Instagram Reels or TikTok videos).
// It holds only essential data and business rules, without any dependencies on external packages (except Equatable for value equality).
// This makes the entity reusable across the app and testable in isolation.

import 'package:reels_ulearna/core/constants/imports.dart'; // Common imports (may include Equatable, etc.)

/// The `Reel` entity represents a short video post in the system.
/// This is a pure data model with no business logic attached.
/// It implements `Equatable` to allow easy comparison (useful in Bloc/Cubit state changes).
class Reel extends Equatable {
  /// Unique identifier of the reel.
  final String id;

  /// Title of the reel (used for display/search).
  final String title;

  /// Description or caption of the reel.
  final String description;

  /// URL pointing to the video content.
  final String videoUrl;

  /// URL for the thumbnail image preview of the reel.
  final String thumbnailUrl;

  /// Username or ID of the content creator.
  final String creator;

  /// Number of likes this reel has received.
  final int likes;

  /// Total number of views this reel has accumulated.
  final int views;

  /// Timestamp when this reel was created.
  final DateTime createdAt;

  /// (Optional) Category tag for filtering/grouping reels.
  final String? category;

  /// (Optional) Profile picture URL of the creator.
  final String? creatorProfilePicture;

  /// Constructor to create an immutable instance of `Reel`.
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

  /// 🟰 Allows comparison of `Reel` instances by value rather than reference.
  /// This is especially useful in state management and testing.
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
