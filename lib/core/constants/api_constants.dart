// File: api_constants.dart
// Location: lib/core/constants/
//
// Purpose:
// This file stores static constants related to API configuration and network timeouts.
// These values are kept in a central location to promote consistency, easy updates, and cleaner code.
//
// Clean Architecture Note:
// This belongs to the **Core Layer**, which holds utilities and values shared across the app.

class ApiConstants {
  /// Base URL of the backend API.
  static const String baseUrl = 'https://backend-cj4o057m.fctl.app';

  /// Endpoint for fetching reels (used in network requests).
  static const String reelsEndpoint = '/bytes/scroll';

  /// 🔢 Default number of items to fetch per page (pagination).
  static const int defaultLimit = 10;

  /// ⏱ Connection timeout for API requests.
  static const Duration connectionTimeout = Duration(seconds: 30);

  /// ⏱ Receive timeout for getting data from the server.
  static const Duration receiveTimeout = Duration(seconds: 30);
}
