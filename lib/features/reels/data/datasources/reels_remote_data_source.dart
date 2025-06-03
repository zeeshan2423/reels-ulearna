import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../../../../core/constants/api_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../models/reel_model.dart';

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
      if (e is ServerException) {
        rethrow;
      }
      throw ServerException('Network error: $e');
    }
  }
}
