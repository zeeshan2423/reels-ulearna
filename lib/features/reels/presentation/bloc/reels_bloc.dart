import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';

import '../../../../core/constants/api_constants.dart';
import '../../domain/entities/reel.dart';
import '../../domain/usecases/get_reels.dart';
import 'reels_event.dart';
import 'reels_state.dart';

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

  Future<void> _onRefreshReels(
    RefreshReelsEvent event,
    Emitter<ReelsState> emit,
  ) async {
    currentPage = 1;
    add(LoadReelsEvent(page: currentPage, isRefresh: true));
  }

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
