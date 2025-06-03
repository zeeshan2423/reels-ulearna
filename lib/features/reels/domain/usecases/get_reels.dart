import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/reel.dart';
import '../repositories/reels_repository.dart';

class GetReels implements UseCase<List<Reel>, ReelsParams> {
  final ReelsRepository repository;

  GetReels(this.repository);

  @override
  Future<Either<Failure, List<Reel>>> call(ReelsParams params) async {
    return await repository.getReels(page: params.page, limit: params.limit);
  }
}

class ReelsParams extends Equatable {
  final int page;
  final int limit;

  const ReelsParams({required this.page, required this.limit});

  @override
  List<Object> get props => [page, limit];
}
