import 'package:equatable/equatable.dart';
import '../../domain/entities/reel.dart';

abstract class ReelsState extends Equatable {
  const ReelsState();

  @override
  List<Object> get props => [];
}

class ReelsInitial extends ReelsState {}

class ReelsLoading extends ReelsState {}

class ReelsLoadingMore extends ReelsState {
  final List<Reel> reels;

  const ReelsLoadingMore({required this.reels});

  @override
  List<Object> get props => [reels];
}

class ReelsLoaded extends ReelsState {
  final List<Reel> reels;
  final bool hasReachedMax;

  const ReelsLoaded({required this.reels, required this.hasReachedMax});

  ReelsLoaded copyWith({List<Reel>? reels, bool? hasReachedMax}) {
    return ReelsLoaded(
      reels: reels ?? this.reels,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object> get props => [reels, hasReachedMax];
}

class ReelsError extends ReelsState {
  final String message;
  final List<Reel> reels;

  const ReelsError({required this.message, this.reels = const []});

  @override
  List<Object> get props => [message, reels];
}
