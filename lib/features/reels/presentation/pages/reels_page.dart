import 'package:reels_ulearna/core/constants/imports.dart';

/// ReelsPage is the main UI screen responsible for displaying a vertically
/// scrollable list of reels (short video clips), similar to popular social
/// media apps (e.g., Instagram Reels, TikTok).
///
/// This widget follows the presentation layer responsibilities in Clean Architecture:
/// - It interacts with the ReelsBloc (business logic component) to load, refresh,
///   and paginate reels data.
/// - It listens to state changes from the Bloc and rebuilds the UI accordingly.
///
/// Features:
/// - Initial load of reels on widget initialization.
/// - Pagination/loading more reels when the user scrolls near the bottom.
/// - Pull-to-refresh functionality to reload the reels list.
/// - Uses a PageView for vertical swiping between reels.
/// - Displays appropriate UI states: loading indicator, error messages, and the reels themselves.
///
/// State Management:
/// - Utilizes BlocBuilder to respond to various ReelsState subclasses:
///   * ReelsInitial / ReelsLoading: shows a loading spinner.
///   * ReelsLoaded / ReelsLoadingMore: displays the list of reels and handles pagination.
///   * ReelsError: shows an error message with a retry button, optionally displaying existing reels if available.
///
/// Scroll & Pagination:
/// - Listens to scroll controller to detect when near the bottom and triggers loading more reels.
/// - Tracks current visible reel page to update active reel state.
///
/// UI Components:
/// - AppBar with title.
/// - PageView with vertical scroll to swipe through reels.
/// - LoadingIndicator widget is used during loading phases.
///
/// This file is part of the presentation layer and depends on the domain/entities
/// for the Reel model, and uses a Bloc for state and event management.
///
class ReelsPage extends StatefulWidget {
  const ReelsPage({super.key});

  @override
  State<ReelsPage> createState() => _ReelsPageState();
}

class _ReelsPageState extends State<ReelsPage> {
  @override
  void initState() {
    super.initState();
    // Add scroll listener for pagination
    context.reelsBloc.scrollController.addListener(_onScroll);
    // Trigger initial load of reels page 1
    context.read<ReelsBloc>().add(const LoadReelsEvent(page: 1));
  }

  @override
  void dispose() {
    // Dispose scroll controller on widget disposal to free resources
    context.reelsBloc.scrollController.dispose();
    super.dispose();
  }

  /// Scroll listener to detect when the user scrolls near the bottom
  /// of the list and requests loading more reels.
  void _onScroll() {
    if (_isBottom) {
      context.read<ReelsBloc>().add(LoadMoreReelsEvent());
    }
  }

  /// Helper getter to check if scroll position is close to bottom
  bool get _isBottom {
    if (!context.reelsBloc.scrollController.hasClients) return false;
    final maxScroll =
        context.reelsBloc.scrollController.position.maxScrollExtent;
    final currentScroll = context.reelsBloc.scrollController.offset;
    // Trigger loading more when user has scrolled past 90% of max scroll extent
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
            // Show loading spinner when reels are being fetched initially
            return const Center(child: LoadingIndicator());
          } else if (state is ReelsLoaded || state is ReelsLoadingMore) {
            // Display loaded reels list with pagination support
            final reels = state is ReelsLoaded
                ? state.reels
                : (state as ReelsLoadingMore).reels;
            final hasReachedMax = state is ReelsLoaded
                ? state.hasReachedMax
                : false;
            return RefreshIndicator(
              onRefresh: () async {
                // Trigger refresh event on pull-down
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
                  // Load more reels if user swipes to the loading indicator page
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
          } else if (state is ReelsError) {
            // Show error UI with retry option if fetching reels failed
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
                ] else ...[
                  const Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.white54,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading reels',
                    style: Theme.of(
                      context,
                    ).textTheme.headlineSmall?.copyWith(color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.message,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.white70),
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
          // Default fallback UI
          return const Center(child: LoadingIndicator());
        },
      ),
    );
  }
}
