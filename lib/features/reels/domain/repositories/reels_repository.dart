import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/reel.dart';

abstract class ReelsRepository {
  Future<Either<Failure, List<Reel>>> getReels({
    required int page,
    required int limit,
  });
}
