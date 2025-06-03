import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reels_ulearna/core/extensions/context_extension.dart';

import '../bloc/reels_bloc.dart';
import '../bloc/reels_event.dart';
import '../bloc/reels_state.dart';
import '../widgets/loading_indicator.dart';
import '../widgets/reel_item.dart';

class ReelsPage extends StatefulWidget {
  const ReelsPage({super.key});

  @override
  State<ReelsPage> createState() => _ReelsPageState();
}

class _ReelsPageState extends State<ReelsPage> {
  @override
  void initState() {
    super.initState();
    context.reelsBloc.scrollController.addListener(_onScroll);
    context.read<ReelsBloc>().add(const LoadReelsEvent(page: 1));
  }

  @override
  void dispose() {
    context.reelsBloc.scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<ReelsBloc>().add(LoadMoreReelsEvent());
    }
  }

  bool get _isBottom {
    if (!context.reelsBloc.scrollController.hasClients) return false;
    final maxScroll =
        context.reelsBloc.scrollController.position.maxScrollExtent;
    final currentScroll = context.reelsBloc.scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Reels',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: BlocBuilder<ReelsBloc, ReelsState>(
        builder: (context, state) {
          if (state is ReelsInitial || state is ReelsLoading) {
            return const Center(child: LoadingIndicator());
          } else if (state is ReelsLoaded || state is ReelsLoadingMore) {
            final reels = state is ReelsLoaded
                ? state.reels
                : (state as ReelsLoadingMore).reels;
            final hasReachedMax = state is ReelsLoaded
                ? state.hasReachedMax
                : false;
            return RefreshIndicator(
              onRefresh: () async {
                context.read<ReelsBloc>().add(RefreshReelsEvent());
              },
              child: PageView.builder(
                controller: context.reelsBloc.pageController,
                scrollDirection: Axis.vertical,
                itemCount: hasReachedMax ? reels.length : reels.length + 1,
                onPageChanged: (index) {
                  setState(() {
                    context.reelsBloc.currentPage = index;
                  });
                  if (!hasReachedMax && index == reels.length) {
                    context.read<ReelsBloc>().add(LoadMoreReelsEvent());
                  }
                },
                itemBuilder: (context, index) {
                  if (index < reels.length) {
                    return ReelItem(
                      reel: reels[index],
                      isActive: index == context.reelsBloc.currentPage,
                    );
                  } else {
                    return const Center(child: LoadingIndicator());
                  }
                },
              ),
            );
          } else if (state is ReelsLoadingMore) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<ReelsBloc>().add(RefreshReelsEvent());
              },
              child: PageView.builder(
                controller: context.reelsBloc.pageController,
                scrollDirection: Axis.vertical,
                itemCount: state.reels.length + 1,
                onPageChanged: (index) {
                  setState(() {
                    context.reelsBloc.currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  if (index >= state.reels.length) {
                    return const Center(child: LoadingIndicator());
                  }
                  return ReelItem(
                    reel: state.reels[index],
                    isActive: index == context.reelsBloc.currentPage,
                  );
                },
              ),
            );
          } else if (state is ReelsError) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (state.reels.isNotEmpty) ...[
                  Expanded(
                    child: PageView.builder(
                      controller: context.reelsBloc.pageController,
                      scrollDirection: Axis.vertical,
                      itemCount: state.reels.length,
                      itemBuilder: (context, index) {
                        return ReelItem(
                          reel: state.reels[index],
                          isActive: index == context.reelsBloc.currentPage,
                        );
                      },
                    ),
                  ),
                ] else
                  ...[
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.white54,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Error loading reels',
                      style: Theme
                          .of(
                        context,
                      )
                          .textTheme
                          .headlineSmall
                          ?.copyWith(color: Colors.white),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      state.message,
                      style: Theme
                          .of(
                        context,
                      )
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: Colors.white70),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        context.read<ReelsBloc>().add(RefreshReelsEvent());
                      },
                      child: const Text('Retry'),
                    ),
                  ],
              ],
            );
          }

          return const Center(child: LoadingIndicator());
        },
      ),
    );
  }
}
