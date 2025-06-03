// File: reels_bloc.dart
// Location: features/reels/presentation/bloc/
//
// Purpose:
// Implements the BLoC (Business Logic Component) that manages the state of reels in the UI.
// Coordinates between UI events and domain use cases (`GetReels`).
// Handles loading, refreshing, and pagination of reels.
//
// Layer: Presentation Layer (State Management / BLoC)
//
// Responsibilities:
// - Responds to UI events by fetching reels from the use case.
// - Emits states to update the UI accordingly (loading, loaded, error, loading more).
// - Maintains current page and manages pagination for infinite scroll or paging.
// - Manages controllers for scrolling, paging, and video playback UI interactions.
// - Provides ValueNotifiers for UI feedback such as showing play icon or error state.
import 'package:reels_ulearna/core/constants/imports.dart';

class ReelsBloc extends Bloc<ReelsEvent, ReelsState> {
  final GetReels getReels;
  int currentPage = 1;
  final ScrollController scrollController = ScrollController();
  final PageController pageController = PageController();
  late VideoPlayerController controller;
  final ValueNotifier<bool> showPlayIcon = ValueNotifier<bool>(false);
  final ValueNotifier<bool> hasError = ValueNotifier<bool>(false);

  ReelsBloc({required this.getReels}) : super(ReelsInitial()) {
    on<LoadReelsEvent>(_onLoadReels);
    on<RefreshReelsEvent>(_onRefreshReels);
    on<LoadMoreReelsEvent>(_onLoadMoreReels);
  }

  /// Handles loading reels.
  /// Emits different states based on whether it's an initial load, refresh, or pagination.
  Future<void> _onLoadReels(
    LoadReelsEvent event,
    Emitter<ReelsState> emit,
  ) async {
    if (event.isRefresh) {
      currentPage = 1;
    }

    if (state is ReelsLoaded && !event.isRefresh) {
      emit(ReelsLoadingMore(reels: (state as ReelsLoaded).reels));
    } else {
      emit(ReelsLoading());
    }

    final failureOrReels = await getReels(
      ReelsParams(page: event.page, limit: ApiConstants.defaultLimit),
    );

    failureOrReels.fold(
      (failure) {
        final currentReels = state is ReelsLoaded
            ? (state as ReelsLoaded).reels
            : state is ReelsLoadingMore
            ? (state as ReelsLoadingMore).reels
            : <Reel>[];

        emit(ReelsError(message: failure.message, reels: currentReels));
      },
      (reels) {
        if (event.isRefresh || state is ReelsLoading) {
          emit(
            ReelsLoaded(
              reels: reels,
              hasReachedMax: reels.length < ApiConstants.defaultLimit,
            ),
          );
        } else if (state is ReelsLoaded || state is ReelsLoadingMore) {
          final currentReels = state is ReelsLoaded
              ? (state as ReelsLoaded).reels
              : (state as ReelsLoadingMore).reels;

          final allReels = [...currentReels, ...reels];
          emit(
            ReelsLoaded(
              reels: allReels,
              hasReachedMax: reels.length < ApiConstants.defaultLimit,
            ),
          );
        }
      },
    );
  }

  /// Refreshes reels by resetting currentPage and loading fresh data.
  Future<void> _onRefreshReels(
    RefreshReelsEvent event,
    Emitter<ReelsState> emit,
  ) async {
    currentPage = 1;
    add(LoadReelsEvent(page: currentPage, isRefresh: true));
  }

  /// Loads more reels for pagination if not at max data.
  Future<void> _onLoadMoreReels(
    LoadMoreReelsEvent event,
    Emitter<ReelsState> emit,
  ) async {
    if (state is ReelsLoaded && !(state as ReelsLoaded).hasReachedMax) {
      currentPage++;
      add(LoadReelsEvent(page: currentPage));
    }
  }
}
