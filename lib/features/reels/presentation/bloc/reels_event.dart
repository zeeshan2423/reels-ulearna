// File: reels_event.dart
// Location: features/reels/presentation/bloc/
//
// Purpose:
// Defines all possible events related to reels that the BLoC listens for.
// Events represent user actions or UI triggers, initiating state changes.
//
// Layer: Presentation Layer (State Management)
//
// Events:
// - LoadReelsEvent: Fetch reels for a page, optionally a refresh.
// - RefreshReelsEvent: Explicitly trigger a refresh of the reels list.
// - LoadMoreReelsEvent: Trigger loading the next page for pagination.
import 'package:reels_ulearna/core/constants/imports.dart';

abstract class ReelsEvent extends Equatable {
  const ReelsEvent();

  @override
  List<Object> get props => [];
}

class LoadReelsEvent extends ReelsEvent {
  final int page;
  final bool isRefresh;

  const LoadReelsEvent({required this.page, this.isRefresh = false});

  @override
  List<Object> get props => [page, isRefresh];
}

class RefreshReelsEvent extends ReelsEvent {}

class LoadMoreReelsEvent extends ReelsEvent {}
