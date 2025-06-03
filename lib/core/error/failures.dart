// File: failures.dart
// Location: lib/core/error/
//
// Purpose:
// Defines **domain-level failures** that encapsulate user-meaningful error messages.
//
// Instead of exposing raw technical exceptions to the UI or business logic,
// we convert them to `Failure` objects (part of Clean Architecture’s error model).
//
// Used primarily with `Either<Failure, T>` return types in the domain layer.

import 'package:reels_ulearna/core/constants/imports.dart';

/// Abstract base class for all failure types in the app.
abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object> get props => [message];
}

/// Failure related to server errors (e.g., 500 Internal Server Error).
class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

/// Failure related to local storage errors (e.g., cache not available).
class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

/// Failure when there's no network or unstable internet connection.
class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}
