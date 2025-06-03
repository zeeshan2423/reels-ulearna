import 'package:reels_ulearna/core/constants/imports.dart';

/// A reusable loading spinner widget used throughout the app to indicate
/// that a background process is ongoing (e.g., network request, data loading).
///
/// This widget is a simple wrapper around Flutter's [CircularProgressIndicator],
/// with optional parameters to customize its color and size.
///
/// Usage:
/// ```dart
/// LoadingIndicator(color: Colors.blue, size: 50);
/// ```
///
/// In the clean architecture structure, this widget belongs to the
/// presentation layer, specifically under widgets, because it deals with UI only.
class LoadingIndicator extends StatelessWidget {
  final Color? color;
  final double? size;

  const LoadingIndicator({super.key, this.color, this.size});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size ?? 40,
      height: size ?? 40,
      child: CircularProgressIndicator(
        strokeWidth: 3,
        valueColor: AlwaysStoppedAnimation<Color>(color ?? Colors.white),
      ),
    );
  }
}
