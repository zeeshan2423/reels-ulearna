// File: reels_repository_impl.dart
// Location: features/reels/data/repositories/
//
// Purpose:
// Implements the `ReelsRepository` interface defined in the domain layer.
// It fetches data from remote sources if connected, otherwise falls back to local cache.
//
// Layer: Data Layer
// Bridges Domain Layer ↔ Data Sources (Remote & Local)

import 'package:reels_ulearna/core/constants/imports.dart';

class ReelsRepositoryImpl implements ReelsRepository {
  final ReelsRemoteDataSource remoteDataSource;
  final ReelsLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  ReelsRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  /// Retrieves reels from remote if online.
  /// Falls back to local cache if offline or remote fails.
  @override
  Future<Either<Failure, List<Reel>>> getReels({
    required int page,
    required int limit,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteReels = await remoteDataSource.getReels(
          page: page,
          limit: limit,
        );
        await localDataSource.cacheReels(remoteReels, page);
        return Right(remoteReels);
      } on ServerException catch (e) {
        try {
          final cachedReels = await localDataSource.getCachedReels(page);
          return Right(cachedReels);
        } on CacheException {
          return Left(ServerFailure(e.message));
        }
      }
    } else {
      try {
        final cachedReels = await localDataSource.getCachedReels(page);
        return Right(cachedReels);
      } on CacheException catch (e) {
        return Left(
          NetworkFailure(
            'No internet connection and no cached data available: ${e.message}',
          ),
        );
      }
    }
  }
}
