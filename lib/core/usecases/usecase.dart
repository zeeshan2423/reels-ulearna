// File: usecase.dart
// Location: lib/core/usecases/
//
// Purpose:
// Defines a base interface for all use cases in the Domain Layer of Clean Architecture.
// Every feature (like fetching reels, liking a video, etc.) will implement this contract.
//
// Use cases encapsulate a single unit of business logic and are independent of UI or frameworks.
//
// Also includes a `NoParams` class to handle use cases that require no input parameters.

import 'package:reels_ulearna/core/constants/imports.dart';

/// 🔁 Generic interface for all use cases.
///
/// - `Type`: the return type of the use case (e.g., `List<Reel>`)
/// - `Params`: the input parameters required to execute the use case
///
/// Usage:
/// ```dart
/// class GetReels extends UseCase<List<Reel>, ReelsParams> {
///   final ReelsRepository repository;
///
///   GetReels(this.repository);
///
///   @override
///   Future<Either<Failure, List<Reel>>> call(ReelsParams params) {
///     return repository.getReels(...);
///   }
/// }
/// ```
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

/// 🚫 Represents a no-parameter input for use cases that don’t need arguments.
///
/// Used like:
/// ```dart
/// class GetVersionNumber extends UseCase<String, NoParams> { ... }
/// ```
class NoParams {}
