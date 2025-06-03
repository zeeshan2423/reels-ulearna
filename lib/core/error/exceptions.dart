// File: exceptions.dart
// Location: lib/core/error/
//
// Purpose:
// Defines **low-level technical exceptions** that occur while accessing APIs, databases, or the network.
// These are used in the **Data Layer** (e.g., repositories, data sources) when something goes wrong.
//
// These are converted into domain-level `Failure` objects before returning to the UI or Domain Layer.

/// Thrown when the server returns an error or an invalid response.
class ServerException implements Exception {
  final String message;

  const ServerException(this.message);
}

/// Thrown when there’s an issue with reading/writing from local cache (e.g., SharedPreferences, database).
class CacheException implements Exception {
  final String message;

  const CacheException(this.message);
}

/// Thrown when the device has no internet or a connection issue occurs.
class NetworkException implements Exception {
  final String message;

  const NetworkException(this.message);
}
