// File: get_reels.dart
// Layer: Domain -> Use Cases
//
// Purpose:
// This file contains the `GetReels` use case which encapsulates the application-specific
// logic for fetching a paginated list of reels from the repository.
//
// Use cases represent specific **business actions** or **operations** in the domain layer.
// They act as the only way the UI layer should communicate with the domain layer.

import 'package:reels_ulearna/core/constants/imports.dart';

/// `GetReels` is a use case class that fetches reels using pagination.
///
/// It depends on the abstract `ReelsRepository`, following the Dependency Inversion Principle.
/// The UI or Bloc layer will call this use case to initiate the fetch operation.
class GetReels implements UseCase<List<Reel>, ReelsParams> {
  final ReelsRepository repository;

  /// Constructor takes the repository as a dependency.
  GetReels(this.repository);

  /// Executes the use case with given [ReelsParams].
  ///
  /// Returns:
  /// - A list of `Reel` objects inside an `Either`, which wraps success or failure.
  @override
  Future<Either<Failure, List<Reel>>> call(ReelsParams params) async {
    return await repository.getReels(page: params.page, limit: params.limit);
  }
}

/// Helper class to encapsulate the parameters needed by [GetReels].
///
/// Using an object (instead of passing parameters directly) makes the code easier to extend and test.
class ReelsParams extends Equatable {
  final int page;
  final int limit;

  const ReelsParams({required this.page, required this.limit});

  @override
  List<Object> get props => [page, limit];
}
