// File: reels_remote_data_source.dart
// Location: features/reels/data/datasources/
//
// Purpose:
// Handles fetching reel data from the backend API.
// Parses and returns a list of `ReelModel` from the HTTP response.
//
// Layer: Data Layer
// Remote (Network) Source

import 'package:http/http.dart' as http;
import 'package:reels_ulearna/core/constants/imports.dart';

/// Parses HTTP response body into a list of [ReelModel].
List<ReelModel> parseReels(String responseBody) {
  final jsonData = json.decode(responseBody);
  final reelsJson = jsonData['data']['data'] as List<dynamic>;
  return reelsJson.map((json) => ReelModel.fromJson(json)).toList();
}

abstract class ReelsRemoteDataSource {
  Future<List<ReelModel>> getReels({required int page, required int limit});
}

class ReelsRemoteDataSourceImpl implements ReelsRemoteDataSource {
  final http.Client client;

  ReelsRemoteDataSourceImpl({required this.client});

  /// Calls the reels API, parses response, and returns a list of [ReelModel].
  @override
  Future<List<ReelModel>> getReels({
    required int page,
    required int limit,
  }) async {
    try {
      final url = Uri.parse(
        '${ApiConstants.baseUrl}${ApiConstants.reelsEndpoint}?page=$page&limit=$limit',
      );

      final response = await client
          .get(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          )
          .timeout(ApiConstants.connectionTimeout);

      if (response.statusCode == 200) {
        return compute(parseReels, response.body);
      } else {
        throw ServerException('Server error: ${response.statusCode}');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Network error: $e');
    }
  }
}
