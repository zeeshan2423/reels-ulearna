import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/reel.dart';
import '../../domain/repositories/reels_repository.dart';
import '../datasources/reels_local_data_source.dart';
import '../datasources/reels_remote_data_source.dart';

class ReelsRepositoryImpl implements ReelsRepository {
  final ReelsRemoteDataSource remoteDataSource;
  final ReelsLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  ReelsRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

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
