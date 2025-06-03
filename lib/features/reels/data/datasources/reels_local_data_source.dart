// File: reels_local_data_source.dart
// Location: features/reels/data/datasources/
//
// Purpose:
// Handles local data storage using SharedPreferences for offline access.
// Includes methods to cache, retrieve, and clear reels data.
//
// Layer: Data Layer
// Local (Persistence) Source

import 'package:reels_ulearna/core/constants/imports.dart';

abstract class ReelsLocalDataSource {
  Future<List<ReelModel>> getCachedReels(int page);

  Future<void> cacheReels(List<ReelModel> reels, int page);

  Future<void> clearCache();
}

class ReelsLocalDataSourceImpl implements ReelsLocalDataSource {
  final SharedPreferences sharedPreferences;

  ReelsLocalDataSourceImpl({required this.sharedPreferences});

  /// Loads cached reels for the given page from local storage.
  @override
  Future<List<ReelModel>> getCachedReels(int page) async {
    try {
      final jsonString = sharedPreferences.getString('CACHED_REELS_$page');
      if (jsonString != null) {
        final jsonList = json.decode(jsonString) as List<dynamic>;
        return jsonList
            .map((json) => ReelModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw const CacheException('No cached data found');
      }
    } catch (e) {
      throw CacheException('Cache error: $e');
    }
  }

  /// Stores reels into local cache for the specified page.
  @override
  Future<void> cacheReels(List<ReelModel> reels, int page) async {
    try {
      final jsonList = reels.map((reel) => reel.toJson()).toList();
      final jsonString = json.encode(jsonList);
      await sharedPreferences.setString('CACHED_REELS_$page', jsonString);
    } catch (e) {
      throw CacheException('Failed to cache data: $e');
    }
  }

  /// Removes all locally cached reel data.
  @override
  Future<void> clearCache() async {
    try {
      final keys = sharedPreferences.getKeys();
      final reelKeys = keys.where((key) => key.startsWith('CACHED_REELS_'));
      for (final key in reelKeys) {
        await sharedPreferences.remove(key);
      }
    } catch (e) {
      throw CacheException('Failed to clear cache: $e');
    }
  }
}
