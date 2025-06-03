// File: reels_repository.dart
// Layer: Domain -> Repositories
//
// Purpose:
// This file defines the abstract `ReelsRepository` contract that the application depends on.
// In Clean Architecture, the domain layer should not depend on external data sources.
// Instead, it depends on abstract interfaces (repositories), which will later be implemented in the data layer.

import 'package:reels_ulearna/core/constants/imports.dart';

/// Abstract class defining the contract for Reels-related data operations.
/// This is part of the Domain Layer and should contain **no implementation logic**.
///
/// The implementation will be provided in the Data Layer (e.g., via API, database, etc.).
/// This promotes the Dependency Inversion Principle (DIP), keeping the domain layer decoupled from details.
abstract class ReelsRepository {
  /// Fetches a list of reels using pagination (page and limit).
  ///
  /// Returns:
  /// - `Right(List<Reel>)` on success.
  /// - `Left(Failure)` on error.
  Future<Either<Failure, List<Reel>>> getReels({
    required int page,
    required int limit,
  });
}
