import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/error/exceptions.dart';
import '../models/reel_model.dart';

abstract class ReelsLocalDataSource {
  Future<List<ReelModel>> getCachedReels(int page);

  Future<void> cacheReels(List<ReelModel> reels, int page);

  Future<void> clearCache();
}

class ReelsLocalDataSourceImpl implements ReelsLocalDataSource {
  final SharedPreferences sharedPreferences;

  ReelsLocalDataSourceImpl({required this.sharedPreferences});

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
