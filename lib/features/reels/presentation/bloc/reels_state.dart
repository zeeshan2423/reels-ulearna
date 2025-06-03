// File: reels_state.dart
// Location: features/reels/presentation/bloc/
//
// Purpose:
// Defines the possible states for the reels feature that the UI reacts to.
// States reflect current data and UI status, allowing reactive UI updates.
//
// Layer: Presentation Layer (State Management)
//
// States:
// - ReelsInitial: Initial state before any action.
// - ReelsLoading: Loading reels (initial load).
// - ReelsLoadingMore: Loading additional reels (pagination).
// - ReelsLoaded: Reels successfully loaded, includes data and pagination info.
// - ReelsError: Error occurred while fetching reels, can provide partial data.

import 'package:reels_ulearna/core/constants/imports.dart';

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
