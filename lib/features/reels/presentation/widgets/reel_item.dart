import 'package:reels_ulearna/core/constants/imports.dart';

/// A widget representing a single Reel item in the feed.
///
/// This widget is stateful because it manages video playback state and UI updates.
/// It plays the video associated with the [Reel] entity, shows controls like
/// play/pause, handles errors during video loading, and displays relevant
/// metadata such as creator info, likes, views, and description.
///
/// The [isActive] flag is used to control playback — only the active reel plays.
///
/// Key responsibilities:
/// - Initialize and dispose a [VideoPlayerController] for the reel's video.
/// - Automatically play/pause video based on [isActive].
/// - Show play icon when video is paused.
/// - Handle video loading errors gracefully by showing a fallback UI.
/// - Display reel metadata overlays, such as creator name, title, description,
///   and engagement stats (likes, views).
///
/// This widget is part of the presentation layer under widgets,
/// adhering to clean architecture principles by separating UI concerns
/// from business logic and data layers.
///
/// Example usage:
/// ```dart
/// ReelItem(reel: reelEntity, isActive: true);
/// ```
class ReelItem extends StatefulWidget {
  final Reel reel;
  final bool isActive;

  const ReelItem({super.key, required this.reel, required this.isActive});

  @override
  State<ReelItem> createState() => _ReelItemState();
}

class _ReelItemState extends State<ReelItem>
    with AutomaticKeepAliveClientMixin {
  late VideoPlayerController _controller;
  final ValueNotifier<bool> _showPlayIcon = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _hasError = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    // Initialize video player with the reel's video URL
    _controller =
        VideoPlayerController.networkUrl(Uri.parse(widget.reel.videoUrl))
          ..setLooping(true) // loop the video indefinitely
          ..initialize()
              .then((_) {
                if (!mounted) return;
                setState(() {}); // refresh UI after initialization
                _showPlayIcon.value = false;
                _controller.play(); // auto-play on load
              })
              .catchError((error) {
                // Handle initialization errors by showing an error state
                _hasError.value = true;
              });
    // Listen for video player state changes
    _controller.addListener(_videoListener);
    _controller.addListener(_errorListener);
  }

  @override
  void didUpdateWidget(covariant ReelItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Control video playback based on whether this reel is active
    if (widget.isActive && !_controller.value.isPlaying && !_hasError.value) {
      _controller.play();
    } else if (!widget.isActive && _controller.value.isPlaying) {
      _controller.pause();
    }
  }

  /// Updates the play icon visibility depending on the video playing state.
  void _videoListener() {
    if (!mounted) return;
    _showPlayIcon.value = !_controller.value.isPlaying;
  }

  /// Listens for video playback errors and updates UI accordingly.
  void _errorListener() {
    if (!mounted) return;
    if (_controller.value.hasError) {
      _hasError.value = true;
    }
  }

  @override
  void dispose() {
    // Clean up listeners and controllers to prevent memory leaks
    _controller.removeListener(_videoListener);
    _controller.removeListener(_errorListener);
    _controller.dispose();
    _showPlayIcon.dispose();
    _hasError.dispose();
    super.dispose();
  }

  /// Toggles play/pause on video tap.
  void _onTapVideo() {
    if (_controller.value.isPlaying) {
      _controller.pause();
    } else {
      _controller.play();
    }
  }

  @override
  bool get wantKeepAlive => true; // Keep state alive for performance

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ValueListenableBuilder(
      valueListenable: _hasError,
      builder: (context, hasError, child) {
        if (hasError) {
          // Show fallback UI with thumbnail and error message if video fails to load
          return Stack(
            fit: StackFit.expand,
            children: [
              CachedNetworkImage(
                imageUrl: widget.reel.thumbnailUrl.isNotEmpty
                    ? widget.reel.thumbnailUrl
                    : 'https://via.placeholder.com/400x600/333333/FFFFFF?text=Video',
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: Colors.grey[900],
                  child: const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  color: Colors.grey[900],
                  child: const Center(
                    child: Icon(Icons.error, color: Colors.white),
                  ),
                ),
              ),
              const Center(
                child: Icon(Icons.error_outline, color: Colors.red, size: 60),
              ),
              const Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 80),
                  child: Text(
                    'Video failed to load',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
              _buildOverlays(), // metadata overlay even on error screen
            ],
          );
        } else {
          // Normal video player UI with tap-to-play/pause and overlays
          return GestureDetector(
            onTap: _onTapVideo,
            child: Stack(
              fit: StackFit.expand,
              children: [
                _controller.value.isInitialized
                    ? VideoPlayer(_controller)
                    : Container(color: Colors.black),
                ValueListenableBuilder<bool>(
                  valueListenable: _showPlayIcon,
                  builder: (context, showPlayIcon, child) {
                    return showPlayIcon
                        ? Center(
                            child: Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.3),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.play_arrow,
                                color: Colors.white,
                                size: 40,
                              ),
                            ),
                          )
                        : const SizedBox.shrink();
                  },
                ),
                _buildOverlays(),
              ],
            ),
          );
        }
      },
    );
  }

  /// Builds the bottom overlay showing creator info, title, description,
  /// and stats (likes, views, shares).
  Widget _buildOverlays() {
    return Stack(
      children: [
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [Colors.black.withOpacity(0.8), Colors.transparent],
              ),
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: Colors.grey[700],
                      backgroundImage:
                          widget.reel.creatorProfilePicture != null &&
                              widget.reel.creatorProfilePicture!.isNotEmpty
                          ? NetworkImage(widget.reel.creatorProfilePicture!)
                          : null,
                      child:
                          (widget.reel.creatorProfilePicture == null ||
                              widget.reel.creatorProfilePicture!.isEmpty)
                          ? Text(
                              widget.reel.creator.isNotEmpty
                                  ? widget.reel.creator[0].toUpperCase()
                                  : 'U',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          : null,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      widget.reel.creator,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'Follow',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                if (widget.reel.title.isNotEmpty) ...[
                  Text(
                    widget.reel.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                ],

                if (widget.reel.description.isNotEmpty) ...[
                  Text(
                    widget.reel.description,
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                ],

                Row(
                  children: [
                    _buildStatItem(Icons.favorite_border, widget.reel.likes),
                    const SizedBox(width: 24),
                    _buildStatItem(
                      Icons.visibility_outlined,
                      widget.reel.views,
                    ),
                    const SizedBox(width: 24),
                    _buildStatItem(Icons.share_outlined, 0),
                  ],
                ),
              ],
            ),
          ),
        ),
        Positioned(
          right: 12,
          bottom: 120,
          child: Column(
            children: [
              _buildActionButton(
                Icons.favorite_border,
                widget.reel.likes,
                Colors.white,
              ),
              const SizedBox(height: 24),
              _buildActionButton(Icons.chat_bubble_outline, 0, Colors.white),
              const SizedBox(height: 24),
              _buildActionButton(Icons.share, 0, Colors.white),
              const SizedBox(height: 24),
              _buildActionButton(Icons.more_vert, null, Colors.white),
            ],
          ),
        ),
      ],
    );
  }

  /// Helper widget to display an icon with a count (e.g., likes, views).
  Widget _buildStatItem(IconData icon, int count) {
    return Row(
      children: [
        Icon(icon, color: Colors.white70, size: 20),
        const SizedBox(width: 4),
        Text(
          _formatCount(count),
          style: const TextStyle(color: Colors.white70, fontSize: 14),
        ),
      ],
    );
  }

  /// Helper widget to create an action button with icon and optional count.
  Widget _buildActionButton(IconData icon, int? count, Color color) {
    return Column(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.black.withOpacity(0.3),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        if (count != null) ...[
          const SizedBox(height: 4),
          Text(
            _formatCount(count),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ],
    );
  }

  /// Formats large numbers to more readable strings with K and M suffixes.
  String _formatCount(int count) {
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}K';
    }
    return count.toString();
  }
}
